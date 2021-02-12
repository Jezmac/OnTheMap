//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 12/02/2021.
//

import Foundation

struct Student: Codable {
    
    let createdAt: Date
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectID: String
    let uniqueKey: String
    let updatedAt: Date
}
