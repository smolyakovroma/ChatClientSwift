//
//  RoomsTableViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 02/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

class RoomsViewController:  UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var realm = try! Realm()
    
    var rooms: Array<Chat>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        rooms = Array(realm.objects(Chat.self))
        
        SocketHelper.sharedInstance.getChats(userId: Constants.id)
        
        SocketHelper.sharedInstance.socket.on("getchats", callback: { (data, ack) in
            if let result = data[0] as? [[String: AnyObject]] {
                for chat in result {
                
                    try! self.realm.write {
                        let sender = (chat["members"] as! [String])[0]
                        let recipient = (chat["members"] as! [String])[1]
                        if sender == Constants.id {
                            self.realm.add(Chat(value: [chat["_id"]!, sender, recipient]), update: true)
                        }else{
                            self.realm.add(Chat(value: [chat["_id"]!, recipient, sender]), update: true)
                        }
                        
                    }
                }
                self.rooms = Array(self.realm.objects(Chat.self))
                self.tableView.reloadData()
            }
        })
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RoomTableViewCell
        let room = rooms[indexPath.row]
        let contact = realm.objects(Contact.self).filter("contactId = '\(room.recipientId)'").first
        
//        SocketHelper.sharedInstance.getLogo(id: room.recipientId);
//
//        SocketHelper.sharedInstance.socket.on("getlogo", callback: { (data, ack) in
//            if let avatar = data[0] as? String {
//                print("1")
//         if (!avatar.isEmpty && avatar != contact!.avatar){
//            print("2")
//                    try! self.realm.write {
//                        contact!.avatar = avatar
////                         cell.imgLogoUser.image = Utility.getImageFromBase64(str: contact!.avatar)
//                    }
//                }
//            }
//        })
        
        if contact == nil{
             cell.labelNameUser.text = "empty name"
//                cell.imgLogoUser.image =
        }else{
            cell.labelNameUser.text = contact!.name
            cell.imgLogoUser.image = Utility.getImageFromBase64(str: contact!.avatar)
//            print(contact!.avatar)
//            print("==================")
        }
       
        let messages = realm.objects(Message.self).filter("chatId = '\(room.id)'")
        let message = messages.last
        if let message = message {
            cell.labelTextMsg.text = message.msg
            cell.labelDateMsg.text = Constants.dateFormatter.string(from: Date(timeIntervalSince1970: message.timestamp))
            cell.labelCountMsg.text = String(messages.count)
        }else{
            cell.labelTextMsg.text = "empty"
            cell.labelDateMsg.text = "00/00"
            cell.labelCountMsg.text = "00"
        }
        
        
        cell.labelCountMsg.backgroundColor = .blue
        return cell
    }
    
    var recipientId = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recipientId = rooms[indexPath.row].recipientId
        self.performSegue(withIdentifier: "RoomsToChatSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RoomsToChatSegue") {
            let vc = segue.destination as! ChatViewController
            vc.recipientId = self.recipientId
        }
    }
}
