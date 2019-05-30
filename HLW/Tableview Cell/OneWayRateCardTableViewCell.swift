//
//  OneWayRateCardTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 3/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import iOSDropDown

class OneWayRateCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rentalCarView: UIView!
    @IBOutlet weak var lblfareDesc: UILabel!
    @IBOutlet weak var viewTotalFare: UIView!
    @IBOutlet weak var viewCabInfo: UIView!
    @IBOutlet weak var viewCharges: UIView!
    @IBOutlet weak var viewCabSelection: UIView!
    @IBOutlet weak var lblVehiclaName: UILabel!
    @IBOutlet weak var imgViewVehicle: UIImageView!
    @IBOutlet weak var lblSelectedVehiclaName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        rentalCarView.layer.cornerRadius = rentalCarView.frame.height / 2
        rentalCarView.clipsToBounds = true
        
        viewTotalFare.layer.cornerRadius = 3
        viewTotalFare.clipsToBounds = true
//        viewTotalFare.layer.borderWidth = 1.0
//        viewTotalFare.layer.borderColor = AppConstant.colorThemeSeparatorGray.cgColor
        
        viewCabInfo.layer.cornerRadius = 3
        viewCabInfo.clipsToBounds = true
//        viewCabInfo.layer.borderWidth = 1.0
//        viewCabInfo.layer.borderColor = AppConstant.colorThemeSeparatorGray.cgColor
        
        viewCharges.layer.cornerRadius = 3
        viewCharges.clipsToBounds = true
//        viewCharges.layer.borderWidth = 1.0
//        viewCharges.layer.borderColor = AppConstant.colorThemeSeparatorGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
