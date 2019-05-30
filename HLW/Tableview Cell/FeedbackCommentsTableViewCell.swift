//
//  FeedbackCommentsTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/11/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class FeedbackCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentsTv: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentsTv.layer.borderWidth = 2
        commentsTv.layer.borderColor = AppConstant.colorThemeBlue.cgColor
        commentsTv.layer.cornerRadius = 5
        commentsTv.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
