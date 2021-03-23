//
//  PhoneNavigationView.swift
//  SnowSeeker
//
//  Created by Tiberiu on 22.03.2021.
//

import SwiftUI

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
