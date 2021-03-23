//
//  AddView.swift
//  NamePhoto
//
//  Created by Tiberiu on 28.02.2021.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    @ObservedObject var friendList: FriendList
    
    @Environment(\.presentationMode) var presentationMode
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter the name", text: $name)
                Button("Done") {
                    //save
                    if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
                        let filename = UUID().uuidString
                        let path = getDocumentsDirectory().appendingPathComponent(filename)
                        try? jpegData.write(to: path)
                        
                        var friend = Friend(name: name, photo: filename)
                        
                        if let location = locationFetcher.lastKnownLocation {
                            friend.latitude = location.latitude
                            friend.longitude = location.longitude
                        }

                        
                        friendList.friends.append(friend)
                    } else {
                        print("failed to save photo")
                    }
                                        
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(image == nil)
            }
            .padding()
            
            if image != nil {
                image?
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.secondary)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    .padding([.horizontal, .vertical])
            }
            
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
        
        .onAppear(perform: {
            locationFetcher.start()
        })
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadImage() {
        guard  inputImage != nil else { return }
        image = Image(uiImage: inputImage!)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(friendList: FriendList())
    }
}
