//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 18/02/2021.
//

import Foundation
import UIKit


// Subclass for VCs in tab view, containing shared functions.
class BaseViewController: UIViewController {
    
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create navigation bar items
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshTapped))
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocationTapped))
        navigationItem.rightBarButtonItems = [addLocationButton, refreshButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped))
        
    }
    
    
    //MARK:- Actions
    
    // Refresh button calls network client to update student locations.
    @objc func refreshTapped(_ sender: UIBarButtonItem) {
        NetworkClient.getStudentLocations(completion: BaseViewController.handleGetStudentLocationsResponse(result:))
    }
    
    
    // Clear current StudentArray, replace with new array. Shows alert if download of new locations fails.
    class func handleGetStudentLocationsResponse(result: Result<[StudentLocation], Error>) {
        if case .success(let students) = result {
            StudentModel.studentArray.removeAll()
            StudentModel.studentArray = BaseViewController.cleanArray(elements: students)
        }
    }
    
    
    // Calls navigation stack for InfoPostingVC.
    @objc func addLocationTapped(_ sender: UIBarButtonItem) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = mainStoryboard.instantiateViewController(withIdentifier: "InfoPostingNVC")
        present(navigationVC, animated: true, completion: nil)
    }
    
    
    // Calls logout function in Newtwork client.
    @objc func logoutTapped(_ sender: UIBarButtonItem) {
        NetworkClient.logout { result in
            switch result {
            case .failure(_):
                Alert.showLogoutFailure(on: self)
            case .success(_):
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Method for cleaning the StudentLocations array.
    
    // Removes all duplicates from the StudentLocation struct and returns a new array containing only those with a valid url and full name.
    static func cleanArray(elements: [StudentLocation]) -> [StudentLocation] {
        var uniqueElements = [StudentLocation]()
        for element in elements {
            if !uniqueElements.contains(element) && element.mediaURL.isValidURL && element.firstName != "" {
                uniqueElements.append(element)
            }
        }
        return uniqueElements
    }
}
