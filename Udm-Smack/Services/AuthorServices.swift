//
//  AuthorServices.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 26/11/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthorService {
    
    static let instance = AuthorService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedin: Bool {
        get {
            return defaults.bool(forKey: LOGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGED_IN_KEY)
        }
    }
    
    var author: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser(email:String, password:String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        AF.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: .init(HEADER), interceptor: nil, requestModifier: nil).responseString {(response) in
            if response.error == nil {
                completion(true)
            } else{
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
        }
    }
    
    func loginUser(email:String, password:String, completion: @escaping CompletionHandler){
        let lowerCaseEmail = email.lowercased()
        
        let body = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        AF.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: .init(HEADER), interceptor: nil, requestModifier: nil).responseJSON{
            response in
            switch response.result {
            case .success(_):
                guard let data = response.data else {return}
                do { let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.author = json["token"].stringValue
                    
                    self.isLoggedin = true
                    completion(true)
                } catch {
                    debugPrint("The problem of trying to make JSON-data: \(error.localizedDescription)")
                }
            case .failure(_):
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
            
        }
    }
    
    func createUser(name:String, email:String, avatarName:String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName":avatarName,
            "avatarColor":avatarColor
        ]
        
        let header = [
            "Authorization":"Bearer \(AuthorService.instance.author)",
            "Content-Type":"application/json; charset=utf-8"
        ]
        
        AF.request(USL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: .init(header), interceptor: nil, requestModifier: nil).responseJSON{
            response in
            switch response.result {
                
            case .success(_):
                guard let data = response.data else {return}
                do { let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                    
                    completion(true)
                } catch {
                    debugPrint("The problem of trying to make JSON-data: \(error.localizedDescription)")
                }
            case .failure(_):
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        AF.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: .init(BEARER_HEADER), interceptor: nil, requestModifier: nil).responseJSON{
            response in
            switch response.result {
                
            case .success(_):
                guard let data = response.data else {return}
                do { let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                    
                    completion(true)
                } catch {
                    debugPrint("The problem of trying to make JSON-data: \(error.localizedDescription)")
                }
            case .failure(_):
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
        }
    }
    
    func updateUser(name: String, completion: @escaping CompletionHandler) {
        let body = [
            "name": name,
            "email": UserDataService.instance.email,
            "avatarName": UserDataService.instance.avatarName,
            "avatarColor": UserDataService.instance.avatarColor
        ]

        AF.request("\(URL_USE_UPDATE)\(UserDataService.instance.id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: .init(BEARER_HEADER), interceptor: nil, requestModifier: nil).responseJSON(completionHandler: {
            (response) in
            switch response.result {
                
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
        })

    }

}


