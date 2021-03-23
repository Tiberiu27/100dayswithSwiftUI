//
//  MKPointAnnotation - ObservableObject.swift
//  BucketList
//
//  Created by Tiberiu on 24.02.2021.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
    
    
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }
        
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unkown value"
        }
        
        set {
            subtitle = newValue
        }
    }
}
