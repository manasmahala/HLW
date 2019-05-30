//
//  FeedbackQuestionsTableViewCell.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/11/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class FeedbackQuestionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFeedbackQuestions: UILabel!
    @IBOutlet weak var selectQuestionsImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
