//
//  SwitchLanguagesModel.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 06/01/2022.
//

import UIKit
import Localize_Swift

struct SwitchLanguagesModel {
    public private(set) var flags: UIImage?
    public private(set) var languages: String!
    
    let availableLanguages = Localize.availableLanguages(true)
    
    func createArrayLanguages() -> [SwitchLanguagesModel] {
        var arraySum = [SwitchLanguagesModel]()
        
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let array = SwitchLanguagesModel(flags: UIImage(named: "\(language)_flag"), languages: displayName)
            arraySum.append(array)
            }
        
        return arraySum
        }
    
    func indexOfCurrentLanguage() -> Int {
        if let index = availableLanguages.firstIndex(of: Localize.currentLanguage()) {
            return index
        } else {
            return 0
        }
    }
    
}
