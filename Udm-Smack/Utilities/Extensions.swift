//
//  Extensions.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 03/12/2021.
//

import UIKit
import Localize_Swift

extension UIViewController {
    func hideNavigationBar(animated: Bool){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

extension String {
    func returnColor(components: String) -> UIColor {
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 20 }
    
    var boldFont:UIFont { return UIFont(name: "Helvetica-Neue-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    
    var normalFont:UIFont { return UIFont(name: "Helvetica-Neue-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

extension UIButton {
    
    func switchLanguagesForButton(titleBtn: String, color: ResuableColors, fontType: ResuableTypeOfFonts, fontsize: CGFloat) {
    
        let colorDidChoose = ResuableColors.returnUIColor(color: color)
        
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorDidChoose,
            .font: UIFont(name: fontType.rawValue, size: fontsize) ??
                   UIFont.systemFont(ofSize: fontsize)
        ]
        
        let attributedTitle = NSMutableAttributedString(
            string: titleBtn.localized(using: Strings_ButtonTitle),
            attributes: atts)
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UILabel {
    
    func switchLanguagesForLabel(titleBtn: String, color: ResuableColors, fontType: ResuableTypeOfFonts, fontsize: CGFloat) {
    
        let colorDidChoose = ResuableColors.returnUIColor(color: color)
        
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorDidChoose,
            .font: UIFont(name: fontType.rawValue, size: fontsize) ??
                   UIFont.systemFont(ofSize: fontsize)
        ]
        
        let attributedTitle = NSMutableAttributedString(
            string: titleBtn.localized(using: Strings_LabelStrings),
            attributes: atts)
        
        attributedText = attributedTitle
    }
}

extension UITextField {
    func switchLanguges(localizedPlaceholder: String) {
        attributedPlaceholder = NSAttributedString (
            string: localizedPlaceholder.localized(using: Strings_Placehodlder),
            attributes: [.foregroundColor: textPuprlePlaceholder])
    }
}



