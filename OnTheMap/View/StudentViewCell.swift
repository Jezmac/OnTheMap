//
//  StudentViewCell.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 13/02/2021.
//

import UIKit

class StudentViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with student: StudentLocation?) {
        if let student = student {
            nameLabel?.text = student.fullName()
            urlLabel?.text = student.mediaURL
            pinImage.image = UIImage(named: "icon_pin")
        } else {
            nameLabel?.text = "Problem with the data"
        }
    }
}
