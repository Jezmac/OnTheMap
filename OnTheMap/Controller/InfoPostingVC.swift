//
//  InfoPostingVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit
import MapKit

class InfoPostingVC: UIViewController {
    

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
        setGeocoding(true)
        getLocationCoordinates(address: address, completion: self.handleGeocodeResponse(result:))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation") {
            let LocationVC = segue.destination as! LocationVC
            let location = sender as! CLPlacemark
            LocationVC.placemark = location
            LocationVC.link = linkTextField.text ?? ""
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func handleGeocodeResponse(result: Result<CLPlacemark, NetworkError>) {
        switch result {
        case .failure(_):
            Alert.showCouldNotCompileUserLocation(on: self)
        case .success(let placemark):
            self.performSegue(withIdentifier: "findLocation", sender: placemark)
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

