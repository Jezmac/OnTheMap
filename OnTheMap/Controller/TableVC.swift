//
//  TableVC.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 11/02/2021.
//

import UIKit

class TableVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlets and properties
    
    // UITableViewController cannot be used as I have subclassed UIViewController. Therefore, a tableView reference iss required.
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = 0
    
    
    //MARK:- LifeCycle
    
    
    // Observer functions are set up as in mapVC.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        tableView.reloadData()
    }
    
    deinit {
        clearObserver()
    }
    
    //MARK:- Table view Delegate and DataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentArray.count
    }
    
    // Cells are created using the StudentViewCell class from the View group.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell", for: indexPath) as! StudentViewCell
        
        let student = StudentModel.studentArray[indexPath.row]
        cell.configure(with: student)
        return cell
    }
    
    
    // Opens mediaURL for cell selected by user.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.studentArray[indexPath.row]
        let urlString = student.mediaURL
        let myURLString: String
        if urlString.hasPrefix("https://") || urlString.hasPrefix("http://"){
                myURLString = urlString
            } else {
                myURLString = "http://\(urlString)"
            }
        if let url = URL(string: myURLString) {
            UIApplication.shared.open(url)
        }
    }
}

//MARK:- Observer pattern extension


extension TableVC {
    
    // Observer added as with MapVC
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
