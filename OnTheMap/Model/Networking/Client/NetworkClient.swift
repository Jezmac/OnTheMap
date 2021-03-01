//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation

class NetworkClient {
    
    //MARK:- Struct for storing a variety of authorisation and user data
    private struct Auth {
        static var accountID = ""
        static var sessionID = ""
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectID = ""
    }
    
    //MARK:- Enum for creation of endpoints for various Network tasks
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getUserData(String)
        case getStudentLocations
        case postStudentLocation
        case putStudentLocation(String)

        
        var stringValue: String {
            switch self {
            case .login: return "\(Endpoints.base)/session"
            case .getUserData(let key): return "\(Endpoints.base)/users/\(key)"
            case .getStudentLocations: return "\(Endpoints.base)/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return "\(Endpoints.base)/StudentLocation"
            case .putStudentLocation(let objectId): return "\(Endpoints.base)/StudentLocation/\(objectId)"

            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    //MARK:- Generic Request Functions
    
    //MARK: POST Request
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, range: Int, response: ResponseType.Type, body: RequestType, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.connectionError))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = range..<data.count
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
        }.resume()
    }
    
    //MARK: GET Request
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, range: Int, response: ResponseType.Type, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error  in
            guard let data = data else {
                DispatchQueue.main.async {
                completion(.failure(.connectionError))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = range..<data.count
                let newData = data.subdata(in: range)
                let decodedResponse = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    //MARK: PUT Request
    
    class func taskForPUTRequest<RequestType: Encodable>(url: URL, body: RequestType, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    completion(.failure(.connectionError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }.resume()
    }
    
    
    //MARK: DELETE Request
    
    
    //MARK:- Requests by type
    
    //MARK: Login Function, stores student ID as "key" in Auth struct
    
    class func login(username: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        taskForPOSTRequest(url: Endpoints.login.url, range: 5, response: SessionResponse.self, body: LoginRequest(udacity: LoginDetails(username: username, password: password))) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                Auth.key = response.account.key
                completion(.success(true))
            }
        }
    }
    
    //MARK: Fetch User Data function, stores first and last name in Auth Struct
    
    class func getUserData(completion: @escaping (Result<User, Error>) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData(Auth.key).url, range: 5, response: User.self) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                print(response)
            }
        }
    }
    
    //MARK: Fetch Student Locations, fetches most recent 100 entries on the API and sends a notification to map and table views.
    
    class func getStudentLocations(completion: @escaping (Result<[StudentLocation], Error>) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, range: 0, response: LocationResults.self) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response.results))
                NotificationCenter.default.post(name: .newLocationsReceived, object: nil)
            }
        }
    }

    //MARK: 
    
    class func postUserLocation(userPin: UserPinData, completion: @escaping (Result<POSTResponse, Error>) -> Void) {
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, range: 0, response: POSTResponse.self, body: UserLocation(firstName: Auth.firstName, lastName: Auth.lastName, latitude: userPin.latitude, longitude: userPin.longitude, mapString: userPin.mapString, mediaURL: userPin.mediaURL, uniqueKey: Auth.key)) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                completion(.success(response))
                Auth.objectID = response.objectId
                print(response.objectId)
            }
        }
    }
    
    class func putUserLocation(userPin: UserPinData, completion: @escaping (Result<Bool, Error>) -> Void) {
        taskForPUTRequest(url: Endpoints.putStudentLocation(Auth.objectID).url, body: UserLocation(firstName: Auth.firstName, lastName: Auth.lastName, latitude: userPin.latitude, longitude: userPin.longitude, mapString: userPin.mapString, mediaURL: userPin.mediaURL, uniqueKey: Auth.key)) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(true))
                getStudentLocations { result in
                    if case .success(let students) = result {
                        StudentModel.student = students
                    }
                }
            }
        }
    }
}


extension Notification.Name {
    static let newLocationsReceived = Notification.Name("NewLocationsReceived")
}
