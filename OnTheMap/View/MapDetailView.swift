//
//  MapDetailView.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 15/02/2021.
//

import MapKit

class MapPinAnnotationView: MKAnnotationView {
    
    let reuseId = "pin"
    
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
         = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.pinTintColor = .red
        pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    else {
        pinView!.annotation = annotation
    }
    
    return pinView
}
    
}
