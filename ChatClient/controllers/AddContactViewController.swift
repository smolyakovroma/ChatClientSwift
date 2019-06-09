//
//  AddContactViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 04/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet weak var etPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketHelper.sharedInstance.socket.on("findcontact", callback: { (data, ack) in
           
                SocketHelper.sharedInstance.getContacts(userId: Constants.id)
                 self.dismiss(animated: true, completion: nil)

        })
    }
    

    @IBAction func btnCloseAction(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddAction(_ sender: Any) {
        if !etPhone.text!.isEmpty {
            SocketHelper.sharedInstance.findContact(userId: Constants.id, name: "xxx", phone: etPhone.text!)
        }
    }
}
