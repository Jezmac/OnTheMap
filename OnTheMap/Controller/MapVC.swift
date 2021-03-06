//
//  MapVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import MapKit

class MapVC: BaseViewController, MKMapViewDelegate {
    
    //MARK:- Outlets
    
    
    @IBOutlet private weak var mapView: MKMapView!
    
    //MARK:-  LifeCycle
    
    // Manages observer for datamodel updates
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
    }
    
    deinit {
        clearObserver()
        print("MapView has been Cleared from memory for reuse")
    }
    
    
    // Manages the appearance of the pins in the mapView.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // adds and removes a gesture recognizer when the pin is tapped
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let tapRecognizer = UITapGestureRecognizer(target: self,  action:#selector(calloutTapped(sender:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.removeGestureRecognizer(view.gestureRecognizers!.first!)
    }
    
    
    // Opens mediaURL link for pin upon selection by the user
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        let view = sender.view as! MKAnnotationView
        if let urlString = view.annotation?.subtitle as? String {
            let myURLString: String
            if urlString.hasPrefix("https://") || urlString.hasPrefix("http://"){
                myURLString = urlString
            } else {
                myURLString = "http://\(urlString)"
            }
            if let url = URL(string: myURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
}


extension MapVC {
    
    
    // Clears current annotations then creates new annotation array for MapView
    @objc func addPins(_ sender: Notification) {
        self.mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKAnnotation]()
        // Iterate over the array to call annotation array for each index
        for location in StudentModel.studentArray {
            let annotation = location.getlocationPin()
            
            // Each result is added to the annotations array
            annotations.append(annotation)
            // Then the updated array is added to the map
            mapView.addAnnotations(annotations)
        }
    }
    
    // Obsever functions. Toggles mapView to respond when a call to getStudentLocations is succesful.
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(addPins(_:)), name: .newLocationsReceived, object: nil)
    }
    
    func clearObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
