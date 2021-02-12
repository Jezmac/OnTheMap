//
//  ErrorTypes.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation

// A ErrorType enum that allows for access to the .localisedDescription property of the errors contained.

// Adding an associated value allows for the passing in of externally generated error messages from APIs etc

public enum NetworkError: Error {
    case domainError
    case networkError(String)
    case decodingError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .domainError: return NSLocalizedString("There was a problem with the domain", comment: "It happens")
        case .networkError(let message): return NSLocalizedString("\(message)", comment: "from API")
        case .decodingError: return NSLocalizedString("There was a problem with decoding the data", comment: "Bad data")
        }
    }
}

