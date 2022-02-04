//
//  MessageService.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 08/12/2021.
//

import Foundation
import SwiftyJSON
import Alamofire

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var message = [Message]()
    var unreadChannels = [String]()
    var selectedChannel:Channel?
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        
        AF.request(URL_GET_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: .init(BEARER_HEADER), interceptor: nil, requestModifier: nil).responseJSON(completionHandler: {
            (response) in
            
            switch response.result {
                
            case .success(_):
                
                guard let data = response.data else {return}
                
                do {guard let json = try JSON(data: data).array else {return}
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    
                    completion(true)
                } catch {
                    debugPrint("The problem of trying to make JSON-data: \(error.localizedDescription)")
                }
                
            case .failure(_):
                
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
        })
    }
    
    func findAllMessageForChannel(channelID: String, completion: @escaping CompletionHandler) {
        
        AF.request("\(URL_GET_MESSAGE)\(channelID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: .init(BEARER_HEADER), interceptor: nil, requestModifier: nil).responseJSON(completionHandler: {
            (response) in
            
            switch response.result {
                
            case .success(_):
                
                self.clearMessage()
                
                guard let data = response.data else {return}
                
                do {guard let json = try JSON(data: data).array else {return}
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        
                        self.message.append(message)
                    }
                    completion(true)
                } catch {
                    debugPrint("The problem of trying to make JSON-data: \(error.localizedDescription)")
                }
                
            case .failure(_):
                
                completion(false)
                debugPrint(response.error?.errorDescription as Any)
            }
        })
    }
    
    func clearChannel() {
        
        channels.removeAll()
    }
    
    func clearMessage() {
        
        message.removeAll()
    }
}
