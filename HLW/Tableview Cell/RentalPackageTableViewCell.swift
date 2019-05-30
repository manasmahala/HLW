//
//  RentalPackageTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/7/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class RentalPackageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblRentalBookingPackages: UILabel!
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet var viewContainerBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var viewContainerTopSpaceConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        viewContainer.layer.cornerRadius = 5
//        viewContainer.clipsToBounds = true
//        viewInner.layer.cornerRadius = 5
//        viewInner.clipsToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
