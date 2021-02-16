//
//  MapVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet private var mapView: MKMapView!

    // LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMap()
    }
    
    // Actions
    
    @IBAction func refreshTapped(_ sender: Any) {
        updateMap()
    }
    
    // Generate MKPinViewAnnotations for each StudentLocation
    
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
    
    // Call client to request latest 100 student locations
    private func updateMap() {
        UdacityClient.getStudentLocations { [weak self] result in
            if case .success(let students) = result {
                StudentModel.student = students
                self?.addPins()
            }
        }
    }
    // Creates annotation array for MapView
    private func addPins() {
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
}


