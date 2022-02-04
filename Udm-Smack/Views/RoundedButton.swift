//
//  RoundedButton.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 29/11/2021.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    //MARK: Properties
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    //MARK: View cycle
    override func awakeFromNib() {
        
        self.layer.cornerRadius = cornerRadius
    }

    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        self.layer.cornerRadius = cornerRadius
    }
}
