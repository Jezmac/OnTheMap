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
    

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: LoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func findLocationButtonTapped() {
        performSegue(withIdentifier: "findLocation", sender: nil)
    }
}

