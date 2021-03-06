//
//  Alert.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 12/02/2021.
//

import UIKit


//MARK:- Custom alert handler that both allows for specific messages and calls Alert view from outside of ViewControllers

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete Form", message: "Please complete all fields in the form")
    }
    
    static func showInvalidIDAlert(on vc: UIViewController)  {
        showBasicAlert(on: vc, with: "Invalid Email address and/or password", message: "Please check your details and try again")
    }
    
    static func showNoUserDataAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Could not find data for this user ID on the server", message: "Please check your Udacity account")
    }
    
    static func showCouldNotGetStudentLocations(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Could not download data from the server", message: "Please check network connection and try again")
    }
    
    static func showCouldNotGetUserLocation(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "No matching location found", message:  "Please check location field for mistakes")
    }
    
    static func showCouldNotPostUserLocation(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Could not post data to server", message:  "Please check all fields have been completed")
    }
    
    static func showInvalidURLEntered(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "The link you have entered is not a valid URL", message: "Please check and try again")
    }
    
    static func showLogoutFailure(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Could Not Logout", message: "Please log this error")
    }
    
    static func showFBLoginSuccess(on vc: UIViewController, user: String) {
        showBasicAlert(on: vc, with: "Hello \(user)!", message: "Your login was succesful but due to API limitations we cannot provide access to the functionality of this app. You will now be logged out again.")
    }
}
