//
//  TableVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit

class TableVC: UITableViewController {
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentLocations() { result in
            if case .success(let students) = result {
                StudentModel.studentList = students
                print(students)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StudentModel.studentList.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell")!
    
    let student = StudentModel.studentList[indexPath.row]
    cell.textLabel?.text = "\(student.firstName)" + " \(student.lastName)"
    cell.detailTextLabel?.text = student.mediaURL
    cell.imageView?.image = UIImage(named: "icon_pin")
    return cell
}

