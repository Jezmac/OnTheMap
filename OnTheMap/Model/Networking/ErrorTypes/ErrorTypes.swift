//
//  ErrorTypes.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit

// A ErrorType enum that allows for access to the .localisedDescription property of the errors contained.

// Adding an associated value allows for the passing in of externally generated error messages from APIs etc

public enum NetworkError: Error {
    case connectionError
    case networkError(String)
    case domainError
    case decodingError
    case geocodeError
}

let statusCode = 0

extension NetworkError: LocalizedError {
    public var statusCode: String? {
        switch self {
        case .connectionError: return NSLocalizedString("Could not connect with the domain.", comment: "Establish Internet Connection")
        case .domainError: return NSLocalizedString("There was a problem with the domain", comment: "It happens")
        case .networkError(let message): return NSLocalizedString("\(message)", comment: "from API")
        case .decodingError: return NSLocalizedString("There was a problem with decoding the data", comment: "Bad data")
        case .geocodeError: return NSLocalizedString("No matching location found", comment: "Please check for mistakes")
        }
    }
}


