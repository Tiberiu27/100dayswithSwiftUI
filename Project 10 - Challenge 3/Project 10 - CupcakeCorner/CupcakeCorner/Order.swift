//
//  Order.swift
//  CupcakeCorner
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI

enum CodingKeys: CodingKey {
    case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
}
//challenge 3
class ObservableOrder: ObservableObject {
    @Published var order: Order
    
    init(order: Order) {
        self.order = order
    }

}

struct Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        //challenge 1
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        //2$ per cake
        var cost = Double(quantity) * 2
        
        //complicated cakes cost more
        cost += (Double(type) / 2)
        
        //1$ / cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        //0.50$ / cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
}
