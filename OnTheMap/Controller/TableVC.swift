//
//  TableVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit

class TableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentLocations() { result in
        if case .success(let students) = result {
            StudentModel.studentList = students
            self.tableView.reloadData()
            }
        }
    }
}
