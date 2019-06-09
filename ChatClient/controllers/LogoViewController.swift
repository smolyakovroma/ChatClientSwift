//
//  LogoViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 03/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import RealmSwift

class LogoViewController: UIViewController {

    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
           
            let user = self.realm.objects(User.self)
            if user.count == 0 {
                self.performSegue(withIdentifier: "LogoToLoginSegue", sender: self)
            }else{
                Constants.id = user[0].id
                SocketHelper.sharedInstance.subscribe(id: Constants.id)
                self.performSegue(withIdentifier: "LogoToMainSegue", sender: self)
            }
        })
    }

}
