//
//  RentalPickUpLocationTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/7/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class RentalPickUpLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewPickUpLocation: UIView!
    @IBOutlet weak var lblPickUpLocation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        viewPickUpLocation.layer.cornerRadius = 5
        viewPickUpLocation.clipsToBounds = true
        viewPickUpLocation.layer.borderWidth = 1.0
        viewPickUpLocation.layer.borderColor = AppConstant.colorThemeSeparatorGray.cgColor
    }

}
