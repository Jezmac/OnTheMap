//
//  InfoPostingVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class InfoPostingVC: UIViewController, MKMapViewDelegate {
    

    //MARK:- Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: LoginButton!
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
                print(location)
                self.performSegue(withIdentifier: "findLocation", sender: nil)
            }
        }
        setGeocoding(true)
    }
    
}

extension InfoPostingVC {

    func getLocationCoordinates(address: String, completion: @escaping (Result<CLLocationCoordinate2D, NetworkError>) -> Void) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            self.setGeocoding(false)
            if error != nil {
                completion(.failure(.geocodeError))
            } else {
                var location: CLLocation?
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                if let location = location {
                completion(.success(location.coordinate))
                } else {
                    completion(.failure(.geocodeError))
                }
            }
        }
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

