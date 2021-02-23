//
//  UserPinData.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 23/02/2021.
//

import MapKit

struct UserPinData {
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
}

extension UserPinData {

    func getCoordinate() -> CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return coordinate
    }
}
