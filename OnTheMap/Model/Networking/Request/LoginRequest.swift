//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: LoginDetails
}

struct LoginDetails: Codable {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
