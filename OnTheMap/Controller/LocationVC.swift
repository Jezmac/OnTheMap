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
    
    
    //MARK:- Outlets and Properties
    
    
    @IBOutlet weak var zoomedMapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var pinData: UserPinData!
    
    
    //MARK:- LifeCycle
    
    // Calls mapManager method to initialise zoomedMapView using the user location passed as a pinData object from InfoPostingVC.
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomedMapView.delegate = self
        mapManager(mapView: zoomedMapView, pinData: pinData)
        print(link)
    }
    
    //MARK:- MapView Delegate behaviour
    
    // Determines the appearance of the pinView for the zoomedMapView
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
    
    
    //MARK:- Actions
    
    //Calls NetworkClient to Post and then put the user data.
    @IBAction func finishButtonTapped(_ sender: Any) {
        NetworkClient.postUserLocation(userPin: pinData, completion: handlePostUserResponse(result:))
    }
}


// Extension containing functions for network calls and initialising the mapView
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
    
    
    
    func mapManager(mapView: MKMapView, pinData: UserPinData) {
        let coordinate = pinData.getCoordinate()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = pinData.mapString
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8))
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
        
    }
    
}
