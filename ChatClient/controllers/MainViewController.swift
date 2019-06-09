//
//  MainViewController.swift
//  ChatClient
//
//  Created by Роман Смоляков on 31/05/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit
import SocketIO

class MainViewController: UIViewController {
//    , UITableViewDelegate, UITableViewDataSource
    @IBOutlet var tableView: UITableView!
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          return nil
//    }
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        SocketHelper.sharedInstance.socket.on(clientEvent: .connect, callback: { (data, ack) in
            print("--- onConnect ---")
            //            self.socket.emit("chatevent", ["userName": "Vasia", "message": "hello"])
            //            self.socket.emit("showRooms", with: [])
            //            SocketHelper.sharedInstance.showRooms()
        })
        SocketHelper.sharedInstance.socket.on(clientEvent: .disconnect, callback: { (data, ack) in
            print("--- onDisconnect ---")
            //            self.connected.value = false
        })
        
        SocketHelper.sharedInstance.socket.on("getrooms", callback: { (data, ack) in
            //            let s = data[0] as? [Room]
            print(data[0])
        })
        
        //        SocketHelper.sharedInstance.socket.on("showRooms", callback: { (data, ack) in
        //            //            let s = data[0] as? [Room]
        //            //            print(s)
        //            self.rooms.removeAll()
        //
        //            if let result = data[0] as? [[String: AnyObject]] {
        //
        //                for room in result {
        //                    //                    if let nameRoom = room["nameRoom"] as? String{
        //                    //                        print(nameRoom)
        //                    //                    }
        //
        //                    if let r = Room(json: room)  {
        //                        self.rooms.append(r)
        //                    }
        //                }
        //                self.tableView.reloadData()
        //            }
        //        })
        
        //        SocketHelper.sharedInstance.socket.on("joinRoom", callback: { (data, ack) in
        //            if let result = data[0] as? [String: AnyObject] {
        //                if let room = Room(json: result)  {
        //                    let game = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        //                    game.room = room
        //                    self.present(game, animated: true, completion: nil)
        //                }
        //            }
        //        })
        
    }
    
//    @IBAction func btnAddAction(_ sender: Any) {
//        SocketHelper.sharedInstance.addRoom(name: "Vasia", idRoom: "44")
//        SocketHelper.sharedInstance.addRoom(name: "Vasia", idRoom: "55")
//        SocketHelper.sharedInstance.addRoom(name: "Vasia", idRoom: "3")
//        SocketHelper.sharedInstance.addRoom(name: "Vasia", idRoom: "33")
//    }
//
//
//    @IBAction func btnGetAction(_ sender: Any) {
//        SocketHelper.sharedInstance.getRooms(name: "Vasia")
//    }
//
}
