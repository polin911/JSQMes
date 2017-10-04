//
//  global.swift
//  JSQMes
//
//  Created by Polina on 04.10.17.
//  Copyright © 2017 Polina. All rights reserved.
//

import Foundation
import  JSQMessagesViewController

func getTime() -> String{
    let currentDate = Date()  // -  get the current date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a" //format style to look like 00:00 am/pm
    let dateString = dateFormatter.string(from: currentDate)
    
    
    return dateString
}

var userName    = "P"
var nameChanged = false
var chan        = "antichat_hackathon"
var imgName     = ""
var imgSticker  = ""
var textGlobal  = ""
var glsenderId = ""

var usersArray   :[String]       = []



//////////////////////////////////////
class MesJSQ: NSObject ,JSQMessageData {
    var username: String
    var textMes    : String
    var time    : String
    var image   : String
    //var imgSticker: Strin
    
    init(userN: String, textMes: String, time: String, image: String ) {
        self.username = userN
        self.textMes  = textMes
        self.time     = time
        self.image    = image
    }
    
    func senderId() -> String! {
        let appDel = UIApplication.shared.delegate as! AppDelegate!
        let str = appDel?.client?.uuid()
        return str
    }
    func senderDisplayName() -> String! {
        return username
    }
    func date() -> Date! {
        let currentDate = Date()  // -  get the current dateb
        return currentDate
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    func messageHash() -> UInt {
        return 0
    }
    
    
}

//когда отправляется на сохранение
//for publick Btn
// let pubChat = MesJSQ(username: userName, text: messageTxtField.text!, time: getTime(), image: imgName)

//let newDict = chatMessageToDictionary(pubChat)
//appDel.client?.publish(newDict, toChannel: chan, compressed: true, withCompletion: nil)
func chatMessageToDictionary(_ chatmessage: MesJSQ) -> [String: AnyObject]{
    return [
        "username": NSString(string: chatmessage.username),
        "text"    : NSString(string: chatmessage.textMes),
        "time"    : NSString(string: chatmessage.time),
        "image"   : NSString(string: chatmessage.image),
        
    ]
}




//там где храниться!
var chatMesArray2 : [MesJSQ]  = []
//cell.chatNameLbl.text = chatMesArray[indexPath.row].username
//cell.chatTxtLbl.text  = chatMesArray[indexPath.row].text


