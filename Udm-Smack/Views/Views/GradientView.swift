//
//  GradientView.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 13/11/2021.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    //MARK: Properties
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.3631175756, green: 0.4045736194, blue: 0.877563715, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1730003655, green: 0.8569490314, blue: 0.8771733642, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    //MARK: View cycle
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
