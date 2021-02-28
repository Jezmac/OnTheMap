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
        NetworkClient.getStudentLocations { result in
            if case .success(let students) = result {
                for element in students {
                    if element.mediaURL.isValidURL {
                        StudentModel.student.append(element)
                    }
                }
            }
        }
    }
    
    @objc func addLocationTapped(_ sender: UIBarButtonItem) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = mainStoryboard.instantiateViewController(withIdentifier: "InfoPostingNVC")
        present(navigationVC, animated: true, completion: nil)
    }
    
    @objc func logoutTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
