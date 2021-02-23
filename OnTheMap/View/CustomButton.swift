//
//  LoginButton.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 10/02/2021.
//

import UIKit


//MARK:- Custom view for UIButtons used in app

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super .awakeFromNib()
    
    layer.cornerRadius = 5
    layer.borderWidth = 1
    layer.borderColor = ColorPalette.udacityBlue.cgColor
        
    }
}

