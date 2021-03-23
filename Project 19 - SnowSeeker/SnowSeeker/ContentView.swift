//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Tiberiu on 22.03.2021.
//

import SwiftUI

enum SortType {
    case none, name, country
}

enum FilterType {
    case none, country, size, price
}

struct ContentView: View {
    @ObservedObject var favorites = Favorites()
    //challenge 3
    @State private var sorted = SortType.none
    @State private var sortButtonName = "name"
    
    @State private var showingFilterView = false
    @State private var filtered = FilterType.none
    
    @ObservedObject var settings = Settings()
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    //challenge 3
    var sortedList: [Resort] {
        switch sorted {
        case .none:
            return resorts
        case .name:
            return resorts.sorted { $0.name < $1.name }
        default:
            return resorts.sorted { $0.country < $1.country }
        }
    }
    
    var filteredList: [Resort] {
        let list  = sortedList
        switch filtered {
        case .none:
            return list
        case .country:
            return list.filter { $0.country == settings.country }
        case .size:
            return list.filter { $0.size == settings.size }
        default:
            return list.filter { $0.price == settings.price }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredList) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width:40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                }
                
                if favorites.contains(resort) {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Resorts")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Filter") {
                        //do shit
                        showingFilterView = true
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sort by \(sortButtonName)") {
                        //sort
                        print(settings.country)
                        if sorted == SortType.none {
                            sorted = SortType.name
                            sortButtonName = "country"
                        } else if sorted == SortType.name {
                            sorted = SortType.country
                            sortButtonName = "none"
                        } else {
                            sorted = SortType.none
                            sortButtonName = "name"
                        }
                    }
                }
            }
            
            WelcomeView()
        }
        .environmentObject(favorites)
        .phoneOnlyStackNavigationView()
        
        //challenge 3
        .sheet(isPresented: $showingFilterView) {
            FilterView(filtered: $filtered, settings: settings)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
