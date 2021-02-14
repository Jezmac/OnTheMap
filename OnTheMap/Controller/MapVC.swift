//
//  MapVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityClient.getStudentLocations { result in
            if case .success(let students) = result {
                StudentModel.student = students
                self.addPins()
            }
        }
    }
    
    private func addPins() {
        var annotations = [MKAnnotation]()
        
        for location in StudentModel.student {
            let annotation = location.getlocationPin()
            annotations.append(annotation)
            self.mapView.addAnnotations(annotations)
        }
    }
}


