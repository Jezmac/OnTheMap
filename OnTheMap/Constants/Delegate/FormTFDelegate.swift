////
////  FormTFDelegate.swift
////  OnTheMap
////
////  Created by Jeremy MacLeod on 26/02/2021.
////
//
//import Foundation
//import UIKit
//
//class FormTFDelegate: NSObject, UITextFieldDelegate {
//    
//
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        switch textField.returnKeyType {
//        case .next:
//            inactiveTF.becomeFirstResponder()
//        case .go:
//            setGeocoding(true)
//            getLocationCoordinates(address: locationTF.text!, completion: self.handleGeocodeResponse(result:))
//        default:
//            inactiveTF.becomeFirstResponder()
//        }
//        return true
//    }
//    
//    // checks contents of the non-editing textField. If it is empty then text entry does not enable the location button. If it does contain text then the button is enabled.
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//        if inactiveTF.text == "" {
//            enableLocationButton(false)
//        } else {
//            if !text.isEmpty {
//                enableLocationButton(true)
//            } else {
//                enableLocationButton(false)
//            }
//        }
//        return true
//    }
//    
//    // Checks if both textfields are empty, if they are then the return key is set to next for the selected textfield. If the other textfield has text, then it is set to go instead.
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        inactiveTF = setInactiveTF(textField: textField)
//        if inactiveTF.text == "" {
//            textField.returnKeyType = .next
//        } else {
//            textField.returnKeyType = .go
//        }
//    }
//
//    // ensures button is disabled when cleartext button is used.
//    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        enableLocationButton(false)
//        return true
//    }
//    
//    // returns the textField not currently in use.
//    
//    func setInactiveTF(textField: UITextField) -> UITextField {
//        let inactiveTF: UITextField
//        if textField == locationTF {
//            inactiveTF = linkTF
//        } else {
//            inactiveTF = locationTF
//        }
//        return inactiveTF
//    }
//}
//
