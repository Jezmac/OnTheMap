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
        UdacityClient.getStudentLocations() { [weak self] result in
            if case .success(let students) = result {
                StudentModel.student = students
                print(students)
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.student.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell") as! StudentViewCell
        
        let student = StudentModel.student[indexPath.row]
        cell.configure(with: student)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.student[indexPath.row]
        let url = student.mediaURL
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
