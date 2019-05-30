//
//  RentalDisplaySelectedOptionsTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/7/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class RentalDisplaySelectedOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet var viewSelectedRentalCar: UIView!
    @IBOutlet var innerViewSelectedRentalCar: UIView!
    @IBOutlet weak var selectedCarImgView: UIImageView!
    @IBOutlet weak var lblSelectedCar: UILabel!
    @IBOutlet weak var bookRideForView: UIView!
    @IBOutlet weak var paymentModeView: UIView!
    @IBOutlet weak var applyCouponView: UIView!
    @IBOutlet weak var totalFareView: UIView!
    @IBOutlet weak var viewPickupTime: UIView!
    @IBOutlet weak var lblBookRideFor: UILabel!
    @IBOutlet weak var lblBookRideForContact: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblApplyCoupon: UILabel!
    @IBOutlet weak var lblAppliedCouponCode: UILabel!
    @IBOutlet weak var imgViewCoupon: UIImageView!
    @IBOutlet weak var lblTotalFare: UILabel!
    @IBOutlet weak var lblPaymentModeOption: UILabel!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet var viewRentalDisplayHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewPickupTimeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewPickupTimeTopConstraint: NSLayoutConstraint!
    
    var isForBooklater: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        lblPaymentModeOption.text = AppConstant.selectedPaymentMode
        
        viewSelectedRentalCar.layer.cornerRadius = viewSelectedRentalCar.frame.size.width / 2
        viewSelectedRentalCar.clipsToBounds = true
        
        innerViewSelectedRentalCar.layer.cornerRadius = innerViewSelectedRentalCar.frame.size.width / 2
        innerViewSelectedRentalCar.clipsToBounds = true
        
        bookRideForView.layer.cornerRadius = 5
        bookRideForView.clipsToBounds = true
        
        paymentModeView.layer.cornerRadius = 5
        paymentModeView.clipsToBounds = true
        
        applyCouponView.layer.cornerRadius = 5
        applyCouponView.clipsToBounds = true
        
        totalFareView.layer.cornerRadius = 5
        totalFareView.clipsToBounds = true
        
        viewPickupTime.layer.cornerRadius = 5
        viewPickupTime.clipsToBounds = true
        
        if (AppConstant.screenSize.height <= 568) {
            lblBookRideFor.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
            lblPaymentMode.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
            lblApplyCoupon.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
            lblTotalFare.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
        }
        
//        if isForBooklater == false{
//            viewConfirmBookingTopSpaceConstraint.constant = 51
//            viewContainerHeightConstraint.constant = 131
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
