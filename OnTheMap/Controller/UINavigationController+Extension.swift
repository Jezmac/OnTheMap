//
//  UINavigationController+Extension.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 19/02/2021.
//

import Foundation
import UIKit

extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
