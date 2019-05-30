//
//  EmergencyContactTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 17/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class EmergencyContactTableViewCell: UITableViewCell {
    
    @IBOutlet var lblContactName: UILabel!
    @IBOutlet var lblContactNumber: UILabel!
    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var shareRideSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shareRideSwitch.onTintColor = AppConstant.colorThemeYellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
