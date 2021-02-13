//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 12/02/2021.
//

import Foundation

struct StudentLocation: Codable {
    
//    let createdAt: Date
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
//    let updatedAt: Date
}
