//
//  global.swift
//  JSQMes
//
//  Created by Polina on 04.10.17.
//  Copyright © 2017 Polina. All rights reserved.
//

import Foundation
import  JSQMessagesViewController

var userName    = "P"
var nameChanged = false
var chan        = "antichat_hackathon"
var imgName     = ""
var imgSticker  = ""
var textGlobal  = ""

var usersArray   :[String]       = []

func chatMessageToDictionary(_ chatmessage: MesJSQ) -> [String: AnyObject]{
    return [
        "username": NSString(string: chatmessage.username),
        "text"    : NSString(string: chatmessage.textMes),
        "time"    : NSString(string: chatmessage.time),
        "image"   : NSString(string: chatmessage.image),
        
    ]
}

var chatMesArray2 : [MesJSQ]  = []

class MesJSQ {
    
//    enum position {
//        case LEFT
//        case RIGHT
//    }
    var username: String
    var textMes    : String
    var time    : String
    var image   : String
    var senderId: String

    
    var messages: [JSQMessage] = []
    
    init(userN: String, textMes: String, time: String, image: String, senderId: String ) {
            self.username = userN
            self.textMes  = textMes
            self.time     = time
            self.image    = image
            self.senderId = senderId
        }
}



