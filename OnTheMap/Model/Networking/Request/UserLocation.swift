//
//  UserLocation.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 19/02/2021.
//

import Foundation

struct UserLocation: Codable {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    
}
