//
//  RentalCabTypeTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/7/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class RentalCabTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCabType: UILabel!
    @IBOutlet weak var lblCabName: UILabel!
    @IBOutlet weak var lblCabAvailableTime: UILabel!
    @IBOutlet weak var lblCabPrice: UILabel!
    @IBOutlet weak var cabImage: UIImageView!
    @IBOutlet weak var radioImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
