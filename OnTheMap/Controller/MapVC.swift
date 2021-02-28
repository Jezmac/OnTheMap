//
//  MapVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import MapKit

class MapVC: BaseViewController, MKMapViewDelegate {
    
    
    @IBOutlet private weak var mapView: MKMapView!

    // LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
    }
    
    deinit {
        clearObserver()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView?.isHidden = true
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let subtitle = (view.annotation?.subtitle ?? "") as String?
            if let url = URL(string: subtitle!) {
            UIApplication.shared.open(url)
            }
        }
    }
}


extension MapVC {
    

    // Creates annotation array for MapView
    @objc func addPins(_ sender: Notification) {
        var annotations = [MKAnnotation]()
        // Iterate over the array to call annotation array for each index
        for location in StudentModel.student {
            let annotation = location.getlocationPin()

            // Each result is added to the annotations array
            annotations.append(annotation)
            // Then the updated array is added to the map
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addPins(_:)), name: .newLocationsReceived, object: nil)
        
    }
    
    func clearObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}


