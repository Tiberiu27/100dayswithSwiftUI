//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Tiberiu on 08.03.2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var shuffleWrong: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Reshuffle the wrong card", isOn: $shuffleWrong)
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(shuffleWrong: .constant(true))
    }
}
