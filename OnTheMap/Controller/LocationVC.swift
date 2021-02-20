//
//  locationVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 18/02/2021.
//

import Foundation
import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var zoomedMapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var placemark: CLPlacemark!
    var link = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomedMapView.delegate = self
        mapManager(mapView: zoomedMapView, placemark: placemark)
        print(link)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        if let coordinate = placemark.location?.coordinate {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
            let mapString = placemark.locality ?? ""
            NetworkClient.postUserLocation(latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: link) { result in
                switch result {
                case .failure(_):
                    Alert.showCouldNotPostUserLocation(on: self)
                case .success(_):
                    NetworkClient.putUserLocation(latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: self.link) { result in
                        switch result {
                        case .failure(_):
                            Alert.showCouldNotPostUserLocation(on: self)
                        case .success(_):
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }

    func mapManager(mapView: MKMapView, placemark: CLPlacemark) {
        let location = placemark.location
        guard let coordinate = location?.coordinate else { return }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = placemark.locality
        mapView.addAnnotation(annotation)
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pinView.canShowCallout = true
        pinView.pinTintColor = .red
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pinView.rightCalloutAccessoryView?.isHidden = true
        mapView.setCenter(coordinate, animated: true)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8))
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
}
