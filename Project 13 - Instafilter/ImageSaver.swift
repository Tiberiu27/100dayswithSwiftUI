//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Tiberiu on 21.02.2021.
//

import UIKit

class ImageSaver: NSObject {
    var succesHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        //save complete
        if let error = error {
            errorHandler?(error)
        } else {
            succesHandler?()
        }
    }
}
