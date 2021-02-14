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
    
    // LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMap()
    }
    
    // Actions
    
    @IBAction func refreshTapped(_ sender: Any) {
        updateMap()
    }
}


extension MapVC {
    
    // Call client to request latest 100 student locations
    private func updateMap() {
        UdacityClient.getStudentLocations { result in
            if case .success(let students) = result {
                StudentModel.student = students
                self.addPins()
            }
        }
    }
    // Creates annotation array for MapView
    private func addPins() {
        var annotations = [MKAnnotation]()
        
        // Iterate over the array to call annotation array for each index
        for location in StudentModel.student {
            let annotation = location.getlocationPin()
            
            // Each result is added to the annotations array
            annotations.append(annotation)
            // Then the updated array is added to the map
            self.mapView.addAnnotations(annotations)
        }
    }
}


