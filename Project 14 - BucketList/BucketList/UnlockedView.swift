//
//  UnlockedView.swift
//  BucketList
//
//  Created by Tiberiu on 25.02.2021.
//

import SwiftUI
import MapKit

//challenge 2
struct UnlockedView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @Binding var locations: [CodableMKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    @Binding var showEditingScreen: Bool
    
    var body: some View {
        MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
            .edgesIgnoringSafeArea(.all)
        Circle()
            .fill(Color.blue)
            .opacity(0.3)
            .frame(width: 32, height: 32)
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    let newLocation = CodableMKPointAnnotation()
                    newLocation.title = "Example location"
                    newLocation.coordinate = self.centerCoordinate
                    self.locations.append(newLocation)
                    
                    selectedPlace = newLocation
                    showEditingScreen = true
                }) {
                    //challenge 1
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
            }
    }
 }
}

