//
//  FareDetailsTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 27/12/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit

class FareDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFareTitle: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var viewSeparator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Manage for iPhone 5 and Below
        if AppConstant.screenSize.height <= 568{
            lblFareTitle.font = UIFont.init(name: "Poppins-Regular", size: 13.0)
            lblFareTitle.font = UIFont.init(name: "Poppins-Regular", size: 13.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
