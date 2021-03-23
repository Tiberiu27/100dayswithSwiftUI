//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var obsOrder = ObservableOrder(order: Order())
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $obsOrder.order.type) {
                        ForEach(0 ..< Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $obsOrder.order.quantity, in: 3 ... 20) {
                        Text("Number of cakes: \(obsOrder.order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $obsOrder.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }
                    
                    if obsOrder.order.specialRequestEnabled {
                        Toggle(isOn: $obsOrder.order.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $obsOrder.order.addSprinkles) {
                            Text("Add sprinklesa")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(obsOrder: self.obsOrder)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

