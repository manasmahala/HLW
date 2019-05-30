//
//  TotalBillTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 14/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class TotalBillTableViewCell: UITableViewCell {
    
    @IBOutlet var viewTotalPayable: UIView!
    @IBOutlet var lblPaymentMode: UILabel!
    @IBOutlet var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func layoutSubviews() {
        //viewTotalPayable.addshadow(top: false, left: false, bottom: true, right: false, shadowRadius: 2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
