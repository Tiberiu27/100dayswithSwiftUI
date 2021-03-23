//
//  ContentView.swift
//  BucketList
//
//  Created by Tiberiu on 23.02.2021.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var showingEditScreen = false
    @State private var showingPlaceDetails = false
    @State private var selectedPlace: MKPointAnnotation?
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var showingAuthAlert = false
    
    //challenge 3
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    var body: some View {
        ZStack {
            if isUnlocked {
                UnlockedView(locations: $locations, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, showEditingScreen: $showingEditScreen)
                    //challenge 3
                    .alert(isPresented: $showingPlaceDetails) {
                        Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information"), primaryButton:.default(Text("Ok")), secondaryButton: .default(Text("Edit")) {
                            //edit this place
                            showingEditScreen = true
                        })
                    }
            } else {
                Button("Unlock places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                //challenge 3
                .alert(isPresented: $showingAuthAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }

        }
        

        
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if selectedPlace != nil {
                EditView(placemark: selectedPlace!)
            }
        }
        
        .onAppear(perform: loadData)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
            print(error.localizedDescription)
        }
    }
    
    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
            print(error.localizedDescription)
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { succes, authenticationError in
                
                DispatchQueue.main.async {
                    if succes {
                        isUnlocked = true
                    } else {
                        //error
                        alertTitle = "Locked"
                        alertMessage = "Could not read your biometrics"
                        showingAuthAlert = true
                    }
                }
            }
        } else {
            //no biometrics
            alertTitle = "No biometrics"
            alertMessage = "Please register your biometrics"
            showingAuthAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension FileManager {
   static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
