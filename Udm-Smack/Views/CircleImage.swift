//
//  CircleImage.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 04/12/2021.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
