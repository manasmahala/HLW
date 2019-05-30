//
//  RentalCabFareDetailsTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 21/05/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class RentalCabFareDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblAddKmFare: UILabel!
    @IBOutlet weak var lblAddTimeFare: UILabel!
    @IBOutlet weak var lblMinFare: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCab: UIView!
    @IBOutlet weak var lblCabName: UILabel!
    @IBOutlet var viewContainerHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
