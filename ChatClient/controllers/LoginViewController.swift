//
//  LoginViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 03/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var etName: UITextField!
    @IBOutlet weak var etPhone: UITextField!
    
    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketHelper.sharedInstance.socket.on("adduser", callback: { (data, ack) in
            if let id = data[0] as? String {
                try! self.realm.write {
                    self.realm.add(User(value: [id, self.etName.text!, self.etPhone.text!, "mail@mail.com"]), update: true)
                    Constants.id = id;
                    SocketHelper.sharedInstance.subscribe(id: Constants.id)
                    self.performSegue(withIdentifier: "LoginToMainSegue", sender: self)
                }
            }
            //            print(data[0])
        })
        
    }
    
    
    @IBAction func btnLoginAction(_ sender: Any) {
        if !etName.text!.isEmpty && !etPhone.text!.isEmpty {
            SocketHelper.sharedInstance.addUser(name: etName.text!, phone: etPhone.text!, email: "mail@mail.com")
        }
    }
    
    
    
}
