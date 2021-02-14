//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 12/02/2021.
//

import MapKit

struct StudentLocation: Codable {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    
}


extension StudentLocation {
    // Get full name string
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    // Convert name and coordinates into annotation onjects for MapView
    func getlocationPin() -> MKPointAnnotation {
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = fullName()
        annotation.subtitle = mediaURL
        return annotation
    }
}
