//
//  UserDataService.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 29/11/2021.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id:String, color:String, avatarName: String, email:String, name:String) {
        
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName:String) {
        self.avatarName = avatarName
    }
    
    func updateUserName(name: String) {
        self.name = name
    }
    
    func logOutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        AuthorService.instance.isLoggedin = false
        AuthorService.instance.userEmail = ""
        AuthorService.instance.author = ""
        MessageService.instance.clearChannel()
        MessageService.instance.clearMessage()
    }
}
