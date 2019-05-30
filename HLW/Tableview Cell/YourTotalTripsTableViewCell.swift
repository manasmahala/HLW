//
//  YourTotalTripsTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class YourTotalTripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPickUpCircle: UILabel!
    @IBOutlet weak var lblDropCircle: UILabel!
    @IBOutlet weak var lblTripStatus: UILabel!
    @IBOutlet weak var lblRideType: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tripCancelImage: UIImageView!
    @IBOutlet weak var imgViewCab: UIImageView!
    @IBOutlet weak var lblRideDate: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblCRN: UILabel!
    @IBOutlet weak var lblPickUpAddress: UILabel!
    @IBOutlet weak var lblDropAddress: UILabel!
    @IBOutlet weak var viewContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblPickUpCircle.layer.cornerRadius = lblPickUpCircle.frame.width / 2
        lblPickUpCircle.clipsToBounds = true
        
        lblDropCircle.layer.cornerRadius = lblDropCircle.frame.width / 2
        lblDropCircle.clipsToBounds = true
        
        viewContainer.layer.cornerRadius = 5
        viewContainer.clipsToBounds = true
        viewContainer.layer.borderColor = AppConstant.colorThemeSeparatorGray.cgColor
        viewContainer.layer.borderWidth = 0.5
        
        
        if AppConstant.screenSize.height <= 568{
            lblRideDate.font = UIFont.init(name: "Poppins-SemiBold", size: 13.0)
            lblVehicleType.font = UIFont.init(name: "Poppins-Medium", size: 12.0)
            lblCRN.font = UIFont.init(name: "Poppins-Medium", size: 12.0)
            lblPickUpAddress.font = UIFont.init(name: "Poppins-Regular", size: 12.0)
            lblDropAddress.font = UIFont.init(name: "Poppins-Regular", size: 12.0)
            lblTripStatus.font = UIFont.init(name: "Poppins-SemiBold", size: 12.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
