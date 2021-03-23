//
//  FilterView.swift
//  SnowSeeker
//
//  Created by Tiberiu on 23.03.2021.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    let countries = ["France", "Austria", "United States", "Canada", "All"]
    @State private var countrySelected = 4
    let sizes = ["Small", "Average", "Large", "All"]
    @State private var sizeSelected = 3
    let prices = ["Affordable", "Premium", "Delux", "All"]
    @State private var priceSelected = 3
    @Binding var filtered: FilterType
    @ObservedObject var settings: Settings
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Country")
            Picker("Country", selection: $countrySelected) {
                ForEach(0 ..< countries.count) {
                    Text(countries[$0])
                }
            }
            Text("Size")
            Picker("Size", selection: $sizeSelected) {
                ForEach(0 ..< sizes.count) {
                    Text(sizes[$0])
                }
            }
            Text("Price")
            Picker("Price", selection: $priceSelected) {
                ForEach(0 ..< prices.count) {
                    Text(prices[$0])
                }
            }
            HStack {
                Spacer()
                Button("Done") {
                    updateSettings()
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            .padding(.vertical)
            
            Spacer()
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()

    }
    
    func updateSettings() {
        if countrySelected != 4 {
            settings.country = countries[countrySelected]
            filtered = .country
        } else if priceSelected != 3 {
            settings.price = priceSelected + 1
            filtered = .price
        } else if sizeSelected != 3 {
            settings.size = sizeSelected + 1
                filtered = .size
        }
        
        if countrySelected == 4 && priceSelected == 3 && sizeSelected == 3 {
            filtered = .none
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(filtered: .constant(.none), settings: Settings())
    }
}

