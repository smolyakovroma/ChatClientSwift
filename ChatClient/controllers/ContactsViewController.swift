//
//  ContactsTableViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 02/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

class ContactsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var realm = try! Realm()
    var contacts: Results<Contact>!
    
    override func viewDidAppear(_ animated: Bool) {
//            print("viewDidAppear")
//             SocketHelper.sharedInstance.getContacts(userId: Constants.id)
    }
    
    @objc func message(n: NSNotification){
        print("message income")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(message(n:)), name: NSNotification.Name.init(rawValue: "Message"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self

        contacts = realm.objects(Contact.self)
        SocketHelper.sharedInstance.getContacts(userId: Constants.id)
        
        for contact in contacts {
               SocketHelper.sharedInstance.getLogo(id: contact.contactId)
        }
        
        SocketHelper.sharedInstance.socket.on("getcontacts", callback: { (data, ack) in
            
            print("getcontacts")
            if let result = data[0] as? [[String: AnyObject]] {
                for contact in result {
                    try! self.realm.write {
                        if let avatar = ((contact["fromUsers"]) as? [[String: AnyObject]]), let logo = (avatar[0])["avatar"] as? String  {
                            self.realm.add(Contact(value: [contact["_id"],contact["user_id"],contact["contact_id"],
                                                           contact["contact_name"], logo]), update: true)
                        }else{
                            self.realm.add(Contact(value: [contact["_id"],contact["user_id"],contact["contact_id"],
                                                           contact["contact_name"]]), update: true)
                        }
                        
                    }
                }
                self.contacts = self.realm.objects(Contact.self)
                self.tableView.reloadData()
            }
        })
        
//        SocketHelper.sharedInstance.socket.on("getlogo", callback: { (data, ack) in
//            if let avatar = data[0] as? String, let id = data[1] as? String {
//                let c = self.realm.objects(Contact.self).filter("contactId = '\(id)'").first
//                if (!avatar.isEmpty && avatar != c!.avatar){
//                    try! self.realm.write {
//                        c!.avatar = avatar
//
//                    }
//                }
//            }
//        })
        
        SocketHelper.sharedInstance.socket.on("sendmsg", callback: { (data, ack) in
         
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Message"), object: nil)
//
//            if let id = data[0] as? String, let chatId = data[1] as? String,let senderId = data[2] as? String, let msg = data[3] as? String, let timestamp = data[4] as? NSNumber {
//                try! self.realm.write {
//
//                    let newMsg = Message(value: [id, chatId, senderId, msg, timestamp.floatValue])
//                    self.realm.add(newMsg, update: true)
//
//                }
//            }
            
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell
        let contact = contacts[indexPath.row]
        cell.labelNameUser.text = contact.name
        cell.labelLastSeen.text = contact.id
        cell.imgLogoUser.image = Utility.getImageFromBase64(str: contact.avatar)
        
        return cell
    }
    
//    var chatId = ""
    var recipientId = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell
        //        cell.selectedBackgroundView?.backgroundColor = .red
        //        self.selectedContact = contacts[indexPath.row]
        self.recipientId = contacts[indexPath.row].contactId
        self.performSegue(withIdentifier: "ContactsToChatSegue", sender: self)
        
    }
    
    
    @IBAction func addContact(_ sender: Any) {
        self.performSegue(withIdentifier: "ContactsToAddContactSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ContactsToAddContactSegue") {
            //            let vc = segue.destination as! AddNetworkViewController
            //            vc.network = self.selectedNetwork
        } else if (segue.identifier == "ContactsToChatSegue"){
            
//            let nav = segue.destination as! UINavigationController
            let vc = segue.destination as! ChatViewController
//            vc.chatId = self.chatId
            vc.recipientId = self.recipientId
        }
    }
}
