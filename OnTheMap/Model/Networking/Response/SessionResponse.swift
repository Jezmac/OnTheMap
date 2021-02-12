//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}
