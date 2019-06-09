//
//  ChatViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 02/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

class ChatViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var tfMsg: UITextField!
    
    lazy var realm = try! Realm()
    var messages: Array<Message>!
    var chatId: String!
    var recipientId: String!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navBar.title = "Test"
        tfMsg.becomeFirstResponder()
        btnSend.isEnabled = false
        
        let chat = realm.objects(Chat.self).filter("recipientId = '\(recipientId!)'")
        if(chat.count == 0){
            chatId = ""
        }else{
           chatId = chat[0].id
        }
     
        
        messages = Array(realm.objects(Message.self).filter("chatId = '\(chatId!)'").sorted(byKeyPath: "timestamp"))
        

        
          SocketHelper.sharedInstance.socket.on("addchat", callback: { (data, ack) in
            SocketHelper.sharedInstance.getChats(userId: Constants.id)
            if let id = data[0] as? String, let senderId = data[1] as? String, let recipientId = data[2] as? String {
                try! self.realm.write {
                    self.realm.add(Chat(value: [id, senderId, recipientId, false]), update: true)
                    self.chatId = id
                    if(!self.tfMsg.text!.isEmpty){
                        SocketHelper.sharedInstance.sendMsg(userId: Constants.id, recipientId: self.recipientId, chatId: self.chatId!, msg: self.tfMsg.text!)
                        self.tfMsg.text = ""
                    }
                }
            }
          })
        
        SocketHelper.sharedInstance.socket.on("sendmsg", callback: { (data, ack) in
            
            if let id = data[0] as? String, let chatId = data[1] as? String,let senderId = data[2] as? String, let msg = data[3] as? String, let timestamp = data[4] as? NSNumber {
                try! self.realm.write {
                    
                    let newMsg = Message(value: [id, chatId, senderId, msg, timestamp.floatValue])
                    self.realm.add(newMsg, update: true)
                    if(newMsg.chatId == chatId){
                        self.messages.append(newMsg)
                        self.tableView.reloadData()
                    }
                }
            }
           
        })
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //        tableView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
        
        if(chatId==""){
            SocketHelper.sharedInstance.addChat(userId: Constants.id, recipientId: recipientId)
        }else{
            if(!self.tfMsg.text!.isEmpty){
                SocketHelper.sharedInstance.sendMsg(userId: Constants.id, recipientId: recipientId, chatId: chatId, msg: self.tfMsg.text!)
                self.tfMsg.text = ""}
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        let message = messages[indexPath.row]
        cell.labelMsg.text = message.msg
         cell.labelDate.text = Constants.dateFormatter.string(from: Date(timeIntervalSince1970: message.timestamp))
 
        //        cell.leftMargin.constant = UIScreen.main.bounds.width / 10
        cell.selectionStyle = .none
        
        if message.senderId == Constants.id {
            cell.leftMargin.constant = UIScreen.main.bounds.width / 12
            cell.rightMargin.constant = 5
            cell.viewMsg.backgroundColor = UIColor(red: 200.0/255.0, green:
                240.0/255.0, blue: 200.0/255.0, alpha: 1.0)
            //               cell.viewMsg.backgroundColor = .init(red: 200, green: 240, blue: 200, alpha: 1)
        }else{
            cell.leftMargin.constant = 5
            cell.rightMargin.constant = UIScreen.main.bounds.width / 12
            cell.viewMsg.backgroundColor = .white
        }
        return cell
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        tfMsg.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let a = indexPath.row
        print("click")
        self.dismissKeyboard()
    }
    
    @IBAction func backPressedAction(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        var keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomHeight.constant = keyboardSize - bottomLayoutGuide.length
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomHeight.constant = 0
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    
    @IBAction func tfMessageAction(_ sender: Any) {
        if self.tfMsg.text?.count == 0 {
            btnSend.isEnabled = false
        }else{
            btnSend.isEnabled = true
        }
    }
}
