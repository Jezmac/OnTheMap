//
//  Alert.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 12/02/2021.
//

import Foundation
import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
