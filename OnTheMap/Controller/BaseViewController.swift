//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 18/02/2021.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshTapped))
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addLocationTapped))
        navigationItem.rightBarButtonItems = [addLocationButton, refreshButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped))
        
    }
    
    @objc func refreshTapped(_ sender: UIBarButtonItem) {
        NetworkClient.getStudentLocations(completion: BaseViewController.handleGetStudentLocationsResponse(result:))
    }
    
    
    // Clear current StudentArray, then remove all duplicates from the StudentLocation struct from API. Then only add those with a valid url and full name to the StudentModel.
    class func handleGetStudentLocationsResponse(result: Result<[StudentLocation], Error>) {
        if case .success(let students) = result {
            StudentModel.studentArray.removeAll()
            let uniqueStudents = unique(elements: students)
            for element in uniqueStudents {
                if element.mediaURL.isValidURL && element.firstName != "" {
                    StudentModel.studentArray.append(element)
                }
            }
        }
    }
    
    class func unique(elements: [StudentLocation]) -> [StudentLocation] {
        var uniqueElements = [StudentLocation]()
        for StudentLocation in elements {
            if !uniqueElements.contains(StudentLocation) {
                uniqueElements.append(StudentLocation)
            }
        }
        return uniqueElements
    }
    
    @objc func addLocationTapped(_ sender: UIBarButtonItem) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = mainStoryboard.instantiateViewController(withIdentifier: "InfoPostingNVC")
        present(navigationVC, animated: true, completion: nil)
    }
    
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
}
