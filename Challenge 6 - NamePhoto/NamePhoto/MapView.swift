//
//  MapView.swift
//  NamePhoto
//
//  Created by Tiberiu on 03.03.2021.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var annotation: MKPointAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if let annotation = annotation {
            mapView.setCenter(annotation.coordinate, animated: false)
        }
        return mapView
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = annotation {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "location"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
