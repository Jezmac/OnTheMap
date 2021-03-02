//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 12/02/2021.
//

import MapKit

struct StudentLocation: Codable, Equatable {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    
    
    // Allows for comparison of StudentLocation structs. If full name and mapstring are the same then the comparison  returns a true.
    static func == (lhs: StudentLocation, rhs: StudentLocation) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.mapString == rhs.mapString
    }
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
