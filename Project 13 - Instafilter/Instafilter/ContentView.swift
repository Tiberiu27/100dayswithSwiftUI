//
//  ContentView.swift
//  Instafilter
//
//  Created by Tiberiu on 17.02.2021.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var showingFilterList = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    //challenge 1
    @State private var showingError = false
    @State private var errorMessage = ""
    
    //challenge 2
    @State private var changeFilterButton = "Change Filter"
    
    var body: some View {
        let intensity = Binding<Double> (
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    //select an image
                    self.showingImagePicker = true
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button(changeFilterButton) {
                        //change filter
                        showingFilterList = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        //save the picture
                        guard let processedImage = processedImage else { return }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.succesHandler = {
                            print("Succes")
                        }
                        
                        imageSaver.errorHandler = { error in
                            print("Oops!: \(error.localizedDescription)")
                            //challenge 1
                            errorMessage = "\(error.localizedDescription)"
                            showingError = true
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .vertical])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .actionSheet(isPresented: $showingFilterList) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystalize")) { setFilter(CIFilter.crystallize())
                        changeFilterButton = "Crystalize"
                    },
                    .default(Text("Edges")) { setFilter(CIFilter.edges())
                        changeFilterButton = "Edges"
                    },
                    .default(Text("Gaussian Blur")) { setFilter(CIFilter.gaussianBlur())
                        changeFilterButton = "Gaussian Blur"
                    },
                    .default(Text("Pixellate")) { setFilter(CIFilter.pixellate())
                        changeFilterButton = "Pixellate"
                    },
                    .default(Text("Sepia Tone")) { setFilter(CIFilter.sepiaTone())
                        changeFilterButton = "Sepia Tone"
                    },
                    .default(Text("Unsharp Mask")) { setFilter(CIFilter.unsharpMask())
                        changeFilterButton = "Unsharp Mask"
                    },
                    .default(Text("Vignette")) { setFilter(CIFilter.vignette())
                        changeFilterButton = "Vignette"
                    },
                    .cancel()
                ])
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text("Oops!"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        //check if a filter has that unit of mesurement (ie: intensity)
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

