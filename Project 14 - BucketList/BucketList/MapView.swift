//
//  MapView.swift
//  BucketList
//
//  Created by Tiberiu on 23.02.2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    

    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //this is our unique identifier for view reuse
            let identifier = "Placemark"
            
            //attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                //we didn't find one, make a new one
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                //allow this to pop up information
                annotationView?.canShowCallout = true
                
                //attach an information button to the view
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                //we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            
            //send it back
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }
            
            parent.selectedPlace = placemark
            parent.showingPlaceDetails = true
        }
        
        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

