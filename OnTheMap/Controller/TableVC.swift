//
//  TableVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import Foundation
import UIKit

class TableVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
        addObserver()
        tableView.reloadData()
    }
    
    deinit {
        clearObserver()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell") as! StudentViewCell
        
        let student = StudentModel.student[indexPath.row]
        cell.configure(with: student)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.student[indexPath.row]
        let url = student.mediaURL
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

extension TableVC {
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable(_:)), name: .newLocationsReceived, object: nil)
    }
    
    func clearObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateTable(_ sender: Notification) {
        tableView.reloadData()
        
    }
}
