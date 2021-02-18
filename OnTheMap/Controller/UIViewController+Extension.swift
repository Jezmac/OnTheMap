//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 18/02/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    @IBAction func postInfoButtonTapped(_ sender: UIBarButtonItem) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc = mainStoryboard.instantiateViewController(withIdentifier: "InfoPostingNVC")
        //nvc.modalPresentationStyle = .fullScreen
        present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
