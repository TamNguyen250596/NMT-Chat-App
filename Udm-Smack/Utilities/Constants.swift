//
//  Constants.swift
//  Udm-Smack
//
//  Created by Nguyen Minh Tam on 13/11/2021.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//URL Constant
let URL_BASE = "http://localhost:3005/v1"
let URL_REGISTER =  "http://localhost:3005/v1/account/register"
let URL_LOGIN = "http://localhost:3005/v1/account/login"
let USL_USER_ADD = "http://localhost:3005/v1/user/add"
let URL_USE_UPDATE = "http://localhost:3005/v1/user/"
let URL_USER_BY_EMAIL = "http://localhost:3005/v1//user/byEmail/"
let URL_GET_CHANNEL = "http://localhost:3005/v1/channel"
let URL_GET_MESSAGE = "http://localhost:3005/v1/message/byChannel/"

// Colors
let textPuprlePlaceholder = #colorLiteral(red: 0.3976411819, green: 0.5083162189, blue: 0.8185178041, alpha: 0.5)

//Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = NSNotification.Name("notificationOfUserDataDidChange")
let NOTIF_CHANNELS_LOADED = NSNotification.Name("channelIsLoaded")
let NOTIF_CHANNEL_SELECTED = NSNotification.Name("channelSelected")
let NOTIF_USER_NAME_UPDATE = NSNotification.Name("notoficationOfUserUpdate")

//Cell-ID
let CELL_AVARTA_ICON = "AvatarIcon"
let CELL_CHANNEL_REUSABLE_ID = "channelCell"
let CELL_CHAT_REUSABLE_ID = "chatCell"

//Nib names
let NIB_NAME_CELL_AVARTA_ICON =  UINib(nibName: "AvatarDarkAndLightCell", bundle: nil)
let NIB_NAME_CELL_CHAT = UINib(nibName: "ChatCell", bundle: nil)
let NIB_NAME_CELL_CHANNEL = UINib(nibName: "ChannelCellViewController", bundle: nil)

//User defaults
let TOKEN_KEY = "token"
let LOGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//Header
let HEADER = ["Content-Type":"application/json; charset=utf-8"]

let BEARER_HEADER = [
    "Authorization":"Bearer \(AuthorService.instance.author)",
    "Content-Type":"application/json; charset=utf-8"
]

//Groups of strings
let Strings_Placehodlder = "PlaceholderStrings"
let Strings_ButtonTitle = "ButtonTitleStrings"
let Strings_LabelStrings = "LabelStrings"

