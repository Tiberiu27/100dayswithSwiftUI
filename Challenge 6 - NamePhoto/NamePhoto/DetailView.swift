//
//  DetailView.swift
//  NamePhoto
//
//  Created by Tiberiu on 28.02.2021.
//

import SwiftUI
import MapKit

struct DetailView: View {
    let friend: Friend
    
    var body: some View {
        VStack {
            if loadImage() != nil {
                loadImage()!
                    .resizable()
                    .scaledToFit()
            } else {
                Rectangle()
            }
            MapView(annotation: getAnnotation())
        }
        .navigationBarTitle(friend.name)
        
        .onAppear(perform: {
            print(friend.latitude)
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() -> Data? {
        let data = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent(friend.photo))
        return data
    }
    
    func loadImage() -> Image? {
        if let data = loadData() {
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        }
        
        return nil
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
        
        return annotation
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(friend: Friend(name: "Tst", photo: "Test"))
    }
}
