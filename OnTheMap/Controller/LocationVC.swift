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
    
    var pinData: UserPinData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomedMapView.delegate = self
        mapManager(mapView: zoomedMapView, pinData: pinData)
        print(link)
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
        NetworkClient.postUserLocation(userPin: pinData, completion: handlePostUserResponse(result:))
    }
}

extension LocationVC {
    
    func handlePostUserResponse(result: Result<POSTResponse, Error>) {
        switch result {
        case .failure(_):
            Alert.showCouldNotPostUserLocation(on: self)
        case .success(_):
            NetworkClient.putUserLocation(userPin: pinData, completion: self.handlePutUserResponse(result:))
        }
    }
    
    func handlePutUserResponse(result: Result<Bool, Error>) {
        switch result {
        case .failure(_):
            Alert.showCouldNotPostUserLocation(on: self)
        case .success(_):
            self.dismiss(animated: true, completion: nil)
        }
    }
}


func mapManager(mapView: MKMapView, pinData: UserPinData) {
    let coordinate = pinData.getCoordinate()
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = pinData.mapString
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
