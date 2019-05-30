//
//  RentalDetailsRateCardTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 3/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class RentalDetailsRateCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rentalCarView: UIView!
    @IBOutlet weak var viewTripSelection: UIView!
    @IBOutlet weak var lblSelection: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        rentalCarView.layer.cornerRadius = rentalCarView.frame.height / 2
        rentalCarView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
