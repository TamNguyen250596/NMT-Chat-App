//
//  Enums.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 11/01/2022.
//

import UIKit

enum ResuableColors {
    
    case thickBlue, lightBlue, white
    
    static func returnUIColor(color: ResuableColors) -> UIColor {
        switch color {
        case .thickBlue:
            return #colorLiteral(red: 0.1294117647, green: 0.07058823529, blue: 0.8, alpha: 1)
        case .lightBlue:
            return #colorLiteral(red: 0.4235397279, green: 0.687035203, blue: 0.834825933, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

enum ResuableTypeOfFonts: String {
    
    case chalkboardBold = "Chalkboard SE Bold"
    case chalkboardRegular = "Chalkboard SE Regular"
    case helvetica = "Helvetica"
    case helveticaBold = "Helvetica Neue Bold"
    case system = "System"
}

enum AvatarType {
    
    case dark, light
}
