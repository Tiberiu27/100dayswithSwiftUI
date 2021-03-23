//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Tiberiu on 23.03.2021.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort
    @State private var selectedFacility: Facility?
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var favorites: Favorites
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    //challenge 1
                    Text("Credit: \(resort.imageCredit)")
                        .font(.caption)
                        .padding(8)
                        .background(Color.black)
                        .opacity(0.75)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
        
                Group {
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            VStack { ResortDetailView(resort: resort) }
                            VStack { SkiDetailView(resort: resort) }
                            Spacer()
                        } else {
                            ResortDetailView(resort: resort)
                            Spacer().frame(height: 0)
                            SkiDetailView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                    
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    selectedFacility = facility
                                }
                        }
                    }
                        .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                if favorites.contains(resort) {
                    favorites.remove(resort)
                } else {
                    favorites.add(resort)
                }
            }
            .padding()
        }
        .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        
        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
