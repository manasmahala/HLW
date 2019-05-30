//
//  BillBreakDownTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 14/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class BillBreakDownTableViewCell: UITableViewCell {
    
    @IBOutlet var lblKey: UILabel!
    @IBOutlet var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
