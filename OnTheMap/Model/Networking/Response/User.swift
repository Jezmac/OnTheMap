//
//  User.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 19/02/2021.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
