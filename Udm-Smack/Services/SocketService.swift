//
//  SocketService.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 10/12/2021.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    let manager = SocketManager(socketURL: URL(string: URL_BASE)!, config: [.log(true), .compress])
    var socket:SocketIOClient!

    override init() {
        super.init()
    socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", with: [channelName, channelDescription])
        completion(true)
        
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated", callback: {
            (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
            
            MessageService.instance.channels.append(newChannel)
            completion(true)
        })
    }
    
    func addMessage(messageBody: String, userId: String, channelId:String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", with: [messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor])
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated", callback: {
            (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                MessageService.instance.message.append(newMessage)
            completion(newMessage)
        })
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate", callback: {
            (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        })
    }
    
}
