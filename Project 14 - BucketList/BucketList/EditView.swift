//
//  EditView.swift
//  BucketList
//
//  Created by Tiberiu on 25.02.2021.
//

import SwiftUI
import MapKit

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place a name", text: $placemark.wrappedTitle)
                    TextField("Description", text: $placemark.wrappedSubtitle)
                }
                
                Section(header: Text("Nearby...")) {
                    if loadingState == .loaded {
                        List(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    } else if loadingState == .loading {
                        ProgressView()
                    } else {
                        Text("Please try again later")
                    }
                }
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            .onAppear(perform: fetchNearbyPlaces)
        }
    }
    
    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad url String")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //we got some data back
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data) {
                    //succes - convert the array values to our pages array
                    pages = Array(items.query.pages.values).sorted()
                    loadingState = .loaded
                    return
                }
            }
            
            //if we're here we failed somehow
            loadingState = .failed
            
        }.resume()
        
    }
    
    enum LoadingState {
        case loading, loaded, failed
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(placemark: MKPointAnnotation.example)
    }
}
