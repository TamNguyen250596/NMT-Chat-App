//
//  AvatarPickerModel.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 01/12/2021.
//

import UIKit

struct AvatarPickerModel {
    public private(set) var avatarType:AvatarType
    
    func createDarkIconArray() -> [UIImage] {
        var imageArray = [UIImage]()
        
        for i in 0...27 {
            guard let image = UIImage(named: "dark\(i)") else {return imageArray}
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    func createLightIconArray() -> [UIImage] {
        var imageArray = [UIImage]()
        
        for i in 0...27 {
            guard let image = UIImage(named: "light\(i)") else {return imageArray}
            imageArray.append(image)
        }
        
        return imageArray
    }
    
    func getDarkOrLightIconArray() -> [UIImage] {
        switch avatarType {
        case .dark:
            return createDarkIconArray()
        case .light:
            return createLightIconArray()
        }
    }
}
