//
//  MenuTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/16/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var menuImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
