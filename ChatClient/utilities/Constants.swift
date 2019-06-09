//
//  Constants.swift
//  ChatClient
//
//  Created by Роман Смоляков on 03/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import Foundation

struct Constants{
    
    struct URL {
        //        static let ETH_MAINNET = "https://mainnet.infura.io/oShbYdHLGQhi0rn1audL"
        //        static let ETH_MAINNET = "https://ropsten.infura.io/oShbYdHLGQhi0rn1audL "
        //        static let ETH_NETWORK = "https://etzrpc.org:443"
        static let ETH_NETWORK_ALT = "http://52.74.3.64:9646"
        static let COINGATE_URL = "http://vse100.info"
        static let HOST_BACKEND = "https://core.unicorngo.io/v1"
        static let RENDER_API = "http://54.72.13.174:3000"
        static let TRANSACTION_VIEWER = "http://explorer.etherzero.org/tx/"
        static let HOST_ETHERSCAN = "http://api.etherscan.io"
    }
    
    static var id = ""
    static var dateFormatter = DateFormatter()
    
}
