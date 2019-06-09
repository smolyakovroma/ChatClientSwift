//
//  RoomTableViewCell.swift
//  ChatClient
//
//  Created by Роман Смоляков on 02/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgLogoUser: UIImageView!
    @IBOutlet weak var labelNameUser: UILabel!
    @IBOutlet weak var labelDateMsg: UILabel!
    @IBOutlet weak var labelTextMsg: UILabel!
    @IBOutlet weak var labelCountMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
