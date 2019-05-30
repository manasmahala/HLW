//
//  CancelRideTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 18/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class CancelRideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgViewRadio: UIImageView!
    @IBOutlet weak var lblCancelRideDesc: UILabel!
    @IBOutlet weak var viewSeparator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if AppConstant.screenSize.height <= 736{
            lblCancelRideDesc.font = UIFont.init(name: "Poppins-Regular", size: 13.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
