//
//  LoaderView.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/18/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {

    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.startAnimating()
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
