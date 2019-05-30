//
//  CustomViewForPriceTableViewCell.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 3/16/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit

class CustomViewForPriceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblFareDesc: UILabel!
    @IBOutlet weak var lblFare: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
