//
//  Chat.swift
//  ChatClient
//
//  Created by Роман Смоляков on 05/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import Foundation
import RealmSwift

class Chat: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var senderId = ""
    @objc dynamic var recipientId = ""
    @objc dynamic var group = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
