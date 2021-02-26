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
    
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTF.delegate = self
        linkTF.delegate = self
        findLocationButton.isEnabled = false
        findLocationButton.alpha = 0.5
    }
    
    //MARK:- Actions
    
    @IBAction func findLocationButtonTapped() {
        guard let address = locationTF.text else { return }
        setGeocoding(true)
        getLocationCoordinates(address: address, completion: self.handleGeocodeResponse(result:))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation") {
            let LocationVC = segue.destination as! LocationVC
            let pinData = sender as! UserPinData
            LocationVC.pinData = pinData
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
            if let coordinate = placemark.location?.coordinate {
                let city = placemark.locality ?? ""
                let country = placemark.isoCountryCode ?? ""
                let mapString = city + ", " + country
                let mediaURL = linkTF.text ?? ""
                let pinData = UserPinData(latitude: coordinate.latitude, longitude: coordinate.longitude, mapString: mapString, mediaURL: mediaURL)
            self.performSegue(withIdentifier: "findLocation", sender: pinData)
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
        linkTF.isEnabled = !geocoding
        locationTF.isEnabled = !geocoding
    }
}


//MARK:- TextFieldDelegate + Extension

extension InfoPostingVC: UITextFieldDelegate {
    
    
    // Since return key type is only .go when both fields contain characters this variable can be used to determine the behaviour of the key press. If it is .next then the other field is set to first responser, if it is .go then the geolocation function is called
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let otherTF = setOtherTF(textField: textField)
        switch textField.returnKeyType {
        case .next:
            otherTF.becomeFirstResponder()
        case .go:
            setGeocoding(true)
            getLocationCoordinates(address: locationTF.text ?? "", completion: self.handleGeocodeResponse(result:))
        default:
            otherTF.becomeFirstResponder()
        }
        return true
    }
    
    // checks contents of the non-editing textField. If it is empty then text entry does not enable the location button. If it does contain text then the button is enabled.
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let otherTF = setOtherTF(textField: textField)
        if otherTF.text == "" {
            findLocationButton.isEnabled = false
            findLocationButton.alpha = 0.5
        } else {
            if !text.isEmpty {
                findLocationButton.isEnabled = true
                findLocationButton.alpha = 1
            } else {
                findLocationButton.isEnabled = false
                findLocationButton.alpha = 0.5
            }
        }
        return true
    }
    
    // Checks if both textfields are empty, if they are then the return key is set to next for the selected textfield. If the other textfield has text, then it is set to go instead.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let otherTF = setOtherTF(textField: textField)
        if otherTF.text == "" {
            textField.returnKeyType = .next
        } else {
            textField.returnKeyType = .go
        }
    }

    // ensures button is disabled when cleartext button is used.
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        findLocationButton.isEnabled = false
        findLocationButton.alpha = 0.5
        return true
    }
    
    // returns the name of textField not currently in use.
    
    func setOtherTF(textField: UITextField) -> UITextField {
        let otherTF: UITextField
        if textField == locationTF {
            otherTF = linkTF
        } else {
            otherTF = locationTF
        }
        return otherTF
    }
}
