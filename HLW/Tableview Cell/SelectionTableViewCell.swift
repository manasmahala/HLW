//
//  SelectionTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 21/05/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
