//
//  CouponTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 22/05/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnApplyCoupon: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
