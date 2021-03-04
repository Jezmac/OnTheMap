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
    @IBOutlet weak var findLocationButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    //MARK: Properties
    
    weak var activeTF: UITextField!
    weak var inactiveTF: UITextField!
    var keyboardHeight: CGFloat!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTF.delegate = self
        linkTF.delegate = self
        findLocationButton.isEnabled(false)
        addTapRecognizer()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableUnoccludedTextField()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disableUnoccludedTextField()
    }
    
    
    //MARK:- Actions
    
    // Checks if link text is a valid URL. If URL is valid then forward geocode is initiated.  Force unwrap is safe as the button is disabled while fields are empty
    @IBAction func findLocationButtonTapped() {
        if !linkTF.text!.isValidURL {
            Alert.showInvalidURLEntered(on: self)
        } else {
            setGeocoding(true)
        getLocationCoordinates(address: locationTF.text!, completion: self.handleGeocodeResponse(result:))
        }
    }
    
    
    // Segue is prepared with the user's pinData passed over as a variable.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "findLocation") {
            let LocationVC = segue.destination as! LocationVC
            let pinData = sender as! UserPinData
            LocationVC.pinData = pinData
        }
    }
    
    
    // Cancel button simply dismisses the modal view.
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- Extension for networking tasks and observer setup


extension InfoPostingVC {
    
    // Passes error if geocode fails. If succesful passes the first location received to the completion handler.
    func getLocationCoordinates(address: String, completion: @escaping (Result<CLPlacemark, NetworkError>) -> Void) {
        CLGeocoder().geocodeAddressString(address) { [weak self] placemarks, error in
            self?.setGeocoding(false)
            if error != nil {
                DispatchQueue.main.async {
                completion(.failure(.geocodeError))
                }
            } else {
                var location: CLPlacemark?
                // Selects first result from geocode if there are more than one.
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first
                }
                if let location = location {
                    DispatchQueue.main.async {
                        completion(.success(location))
                    }
                }
            }
        }
    }
    
    //Show alert if geocode fails, if successful, generate a pinData instance containing information to be used by the network calls in the location view, which is then called and this data passed on. As this function cannot be called if the linkTF is empty I have force unwrapped it.
    func handleGeocodeResponse(result: Result<CLPlacemark, NetworkError>) {
        switch result {
        case .failure(_):
            Alert.showCouldNotGetUserLocation(on: self)
        case .success(let placemark):
            if let coordinate = placemark.location?.coordinate {
                let pinData = UserPinData(latitude: coordinate.latitude, longitude: coordinate.longitude, mapString: makeMapString(placemark: placemark), mediaURL: linkTF.text!)
                self.performSegue(withIdentifier: "findLocation", sender: pinData)
            }
        }
    }
    
    // Takes placemark and generates a reasonably legible mapstring depending on the contents
    func makeMapString(placemark: CLPlacemark) -> String {
        let mapString: String
        var city = placemark.locality ?? ""
        if city == "" {
            city = placemark.name ?? ""
        }
        let county = placemark.administrativeArea ?? ""
        let country = placemark.country ?? ""
        if county != country {
            mapString = city + ", " + county + ", " + country
        } else {
            mapString = city + ", " + country
        }
        return mapString
    }
    
    
    // Disable/enable controls and show/hide activity indicator
    func setGeocoding(_ geocoding: Bool) {
        if geocoding {
            activityIndicator.startAnimating()
            view.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            view.alpha = 1
        }
        findLocationButton.isEnabled(!geocoding)
        linkTF.isEnabled = !geocoding
        locationTF.isEnabled = !geocoding
    }
    
    // Toggle keyboard observations on/off
    func enableUnoccludedTextField() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func disableUnoccludedTextField() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.viewTapped))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
}

//MARK:- TextFieldDelegate + Extension

extension InfoPostingVC: UITextFieldDelegate {
    
    
    // Since return key type is only .go when both fields contain characters this variable can be used to determine the behaviour of the key press. If it is .next then the other field is set to first responser, if it is .go then the geolocation function is called
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            inactiveTF.becomeFirstResponder()
        case .go:
            setGeocoding(true)
            getLocationCoordinates(address: locationTF.text!, completion: self.handleGeocodeResponse(result:))
        default:
            inactiveTF.becomeFirstResponder()
        }
        return true
    }
    
    
    // checks contents of the non-editing textField. If it is empty then text entry does not enable the location button. If it does contain text then the button is enabled.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if inactiveTF.text == "" {
            findLocationButton.isEnabled(false)
        } else {
            if !text.isEmpty {
                findLocationButton.isEnabled(true)
            } else {
                findLocationButton.isEnabled(false)
            }
        }
        return true
    }
    
    
    // Checks if both textfields are empty, if they are then the return key is set to next for the selected textfield. If the other textfield has text, then it is set to go instead.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
        inactiveTF = setInactiveTF(textField: textField)
        if inactiveTF.text == "" {
            textField.returnKeyType = .next
        } else {
            textField.returnKeyType = .go
        }
    }
    
    
    // ensures button is disabled when cleartext button is used.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        findLocationButton.isEnabled(false)
        return true
    }
    
    
    // returns the textField not currently in use.
    func setInactiveTF(textField: UITextField) -> UITextField {
        let inactiveTF: UITextField
        if textField == locationTF {
            inactiveTF = linkTF
        } else {
            inactiveTF = locationTF
        }
        return inactiveTF
    }
    
    
    //MARK:- Keyboard occlusion handler methods
    
    @objc func keyboardWillShow(notification: Notification) {
        checkForOcclusion()
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y = 0.0
        }
        self.keyboardHeight = 0.0
    }
    
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.keyboardHeight = keyboardFrame.height
    }
    
    
    func checkForOcclusion() {
        let bottomOfTextField = self.view.convert(CGPoint(x: 0, y: self.activeTF!.frame.height), from: activeTF!).y
        let topOfKeyboard = self.view.frame.height - self.keyboardHeight!
        
        if bottomOfTextField > topOfKeyboard {
            var offset = bottomOfTextField - topOfKeyboard
            if self.view.frame.origin.y < 0 {
                offset += 20.0
            }
            self.view.frame.origin.y = -1 * offset
        } else {
            self.view.frame.origin.y = 0
        }
    }
}
