//
//  ChatTableViewCell.swift
//  ChatClient
//
//  Created by Роман Смоляков on 02/06/2019.
//  Copyright © 2019 Роман Смоляков. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMsg: CardView!
    @IBOutlet weak var labelMsg: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
