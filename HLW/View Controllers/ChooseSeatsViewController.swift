//
//  ChooseSeatsViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 05/02/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

@objc protocol ChooseSeatsDelegate: class {
    @objc func selectedSeats(seats: Int)
}

class ChooseSeatsViewController: UIViewController {
    
    @IBOutlet var imgViewSeat1: UIImageView!
    @IBOutlet var imgViewSeat2: UIImageView!
    weak var delegate: ChooseSeatsDelegate?
    
    var selectedSeats: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Button Action
    @IBAction func btnSeatAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://Seat1
            imgViewSeat1.image = UIImage.init(named: "radio_checked")
            imgViewSeat2.image = UIImage.init(named: "radio_unchecked")
            break
        case 2://Seat2
            imgViewSeat1.image = UIImage.init(named: "radio_unchecked")
            imgViewSeat2.image = UIImage.init(named: "radio_checked")
            break
        default:
            break
        }
        selectedSeats = sender.tag
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.delegate?.selectedSeats(seats: selectedSeats)
        self.dismiss(animated: true, completion: nil)
    }

}
