//
//  ViewController.swift
//  JSQMes
//
//  Created by Polina on 04.10.17.
//  Copyright © 2017 Polina. All rights reserved.
//

import UIKit
import PubNub
import JSQMessagesViewController

class ViewController: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initPubNub()
    }
    ///PubNub
    func initPubNub(){
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        
        appDel.client?.unsubscribeFromChannels([chan], withPresence: true)
        appDel.client?.removeListener(self as! PNObjectEventListener)
        
        let config = PNConfiguration( publishKey: "pub-c-8ecaf827-b81c-4d89-abf0-d669cf6da672", subscribeKey: "sub-c-a11d1bc0-ce50-11e5-bcee-0619f8945a4f")
        config.uuid = userName
        appDel.client = PubNub.clientWithConfiguration(config)
        
        //appDel.client?.addListener(self as! PNObjectEventListener)
        self.joinChannel(chan)
    }
    
    deinit {
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        
        appDel.client?.removeListener(self as! PNObjectEventListener)
    }
    func joinChannel(_ channel: String){
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        appDel.client?.subscribeToChannels([channel], withPresence: true)
        
        appDel.client?.hereNowForChannel(channel, withCompletion: { (result, status) in
            
            for ent in result?.data.uuids as! NSArray{
                let user = ((ent as! [String:String])["uuid"])!
                if !usersArray.contains(user){
                    usersArray.append(user)
                }
                
            }
            _ = result?.data.occupancy.stringValue
        })
        updateHistory()
        
        guard let deviceToken   = UserDefaults.standard.object(forKey: "deviceToken") as? Data
            else {
                return
        }
        print("**********deviceToken is **** \(deviceToken)")
    }
    
    func parseJson(_ anyObj:AnyObject) -> [MesJSQ]{
        
        var list:[MesJSQ] = []
        
        if  anyObj is [AnyObject] {
            
            for jsonMsg in anyObj as! [AnyObject] {
                let json = jsonMsg["message"] as? NSDictionary
                
                let usernameJson = (json?["senderName"] as AnyObject? as? String) ?? "" // to get rid of null
                let textJson   = (json?["text"]  as AnyObject? as? String) ?? ""
                let timeJson   = (json?["time"]  as AnyObject? as? String) ?? ""
                let imgJson    = (json?["image"] as AnyObject as? String) ?? ""
                let sendIdJ   = (json?["senderid"] as AnyObject? as? String) ?? ""
                //let imgStickerJ  = (json?["stickers"] as AnyObject? as? String) ?? ""
                
                list.append(MesJSQ(userN: usernameJson, textMes: textJson, time: timeJson, image: imgJson, senderId: sendIdJ))
            }
            collectionView.reloadData()
            
        }
        
        return list
        
    }
    func updateHistory(){
        
        let appDel = UIApplication.shared.delegate! as! AppDelegate
        
        appDel.client?.historyForChannel(chan, start: nil, end: nil, includeTimeToken: true, withCompletion: { (result, status) in
            print("!!!!!!!!!Status: \(result)")
            
            
            chatMesArray2 = self.parseJson(result!.data.messages as AnyObject)
            self.updateTableview()
            
        })
    }
    func updateTableview(){
        self.collectionView.reloadData()
        if self.collectionView.contentSize.height > self.collectionView.frame.size.height {
            collectionView.scrollToItem(at: IndexPath(row: chatMesArray2.count - 1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    }
    func updateChat(){
        collectionView.reloadData()
        
        let numberOfSections = collectionView.numberOfSections
        let numberOfRows = collectionView.numberOfItems(inSection: numberOfSections-1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row:numberOfRows - 1, section:numberOfSections - 1)

            collectionView.scrollToItem(at: indexPath, at: .bottom,
                                        animated: true)
        }
    }
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        print("******didReceiveMessage*****")
        print("from client!!!!!!!!!!!!!!!!!!!!!!!\(message.data)")
        print("*******UUID from message IS \(message.uuid)")
        
        let stringData  = message.data.message as? NSDictionary
        
        
        let stringName    = stringData?["senderName"] as? String ?? ""
        let stringText    = stringData?["message"] as? String ?? ""
        let stringTime    = stringData?["time"] as? String ?? ""
        let stringImg     = stringData?["image"] as? String ?? ""
        let strSendId     = stringData?["senderid"] as? String ?? ""
        //let stringSticker = stringData?["stickers"] as? String ?? ""
        
        
        let newMessage = MesJSQ(userN: stringName, textMes: stringText, time: stringTime, image: stringImg, senderId: strSendId)
        chatMesArray2.append(newMessage)
        updateChat()
    }
    func getTime() -> String{
        let currentDate = Date()  // -  get the current date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" //format style to look like 00:00 am/pm
        let dateString = dateFormatter.string(from: currentDate)
        
        
        return dateString
    }
    //////
    



}

