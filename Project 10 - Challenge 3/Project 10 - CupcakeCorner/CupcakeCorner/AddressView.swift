//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var obsOrder: ObservableOrder
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $obsOrder.order.name)
                TextField("Street Address", text: $obsOrder.order.streetAddress)
                TextField("City", text: $obsOrder.order.city)
                TextField("Zip", text: $obsOrder.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(obsOrder: self.obsOrder)) {
                    Text("Checkout")
                }
            }
            .disabled(obsOrder.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(obsOrder: ObservableOrder(order: Order()))
    }
}
