//
//  InfoPostingVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit
import MapKit

class InfoPostingVC: UIViewController, MKMapViewDelegate {
    

    //MARK:- Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK:- Actions
    
    @IBAction func findLocationButtonTapped() {
        guard let address = locationTextField.text else { return }
        getLocationCoordinates(address: address) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let location):
                self.performSegue(withIdentifier: "findLocation", sender: location)
            }
        }
        setGeocoding(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation") {
            let LocationVC = segue.destination as! LocationVC
            let location = sender as! CLPlacemark
            LocationVC.placemark = location
        }
    }
}

extension InfoPostingVC {

    func getLocationCoordinates(address: String, completion: @escaping (Result<CLPlacemark, NetworkError>) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            self.setGeocoding(false)
            if error != nil {
                completion(.failure(.geocodeError))
            } else {
                var location: CLPlacemark?
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first
                }
                if let location = location {
                completion(.success(location))
                } else {
                    completion(.failure(.geocodeError))
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
        mapView.setCenter(coordinate, animated: true)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func setGeocoding(_ geocoding: Bool) {
        if geocoding {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        findLocationButton.isEnabled = !geocoding
        linkTextField.isEnabled = !geocoding
        locationTextField.isEnabled = !geocoding
    }
}

