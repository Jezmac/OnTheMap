//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation

class UdacityClient {
    
    private struct Auth {
        static var accountID = 0
        static var sessionID = ""
        static var key = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK:- Generic Request Functions
    
    //MARK: Post Request
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        print("\(body)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.connectionError))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let decodedResponse = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    print("\(String(describing: response))")
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    //MARK: Get Request
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, reponse: ResponseType.Type, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error  in
            guard let data = data else {
                completion(.failure(.connectionError))
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            guard let decodedResponse = try? JSONDecoder().decode(ResponseType.self, from: newData) else {
                completion(.failure(.decodingError))
                return
            }
            completion(.success(decodedResponse))
        }
        task.resume()
    }
    //MARK:- Requests by type
    
    //MARK: Login Fucntion
    
    class func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        taskForPOSTRequest(url: Endpoints.login.url, response: SessionResponse.self, body: LoginRequest(udacity: LoginDetails(username: username, password: password))) { result in
            switch result {
            case .success(let response):
                Auth.key = response.account.key
                print(Auth.key)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
