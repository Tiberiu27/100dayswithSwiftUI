//
//  FilterSettings.swift
//  SnowSeeker
//
//  Created by Tiberiu on 23.03.2021.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var country = "All"
    @Published var size = 1
    @Published var price = 1
}
