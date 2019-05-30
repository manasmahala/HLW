//
//  FeedbackRatingsTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/11/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Cosmos

class FeedbackRatingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFeedbackMsg: UILabel!
    @IBOutlet weak var lblFeedbackQuestionTitle: UILabel!
    @IBOutlet weak var viewRatings: CosmosView!
    @IBOutlet weak var ratingsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingsImage.layer.cornerRadius = ratingsImage.frame.width / 2
        ratingsImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
