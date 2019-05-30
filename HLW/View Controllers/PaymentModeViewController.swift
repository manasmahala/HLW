//
//  PaymentModeViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/5/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

@objc protocol ChoosePaymentModeDelegate: class {
    @objc func selectedPaymentMode(pMode: String)
}

class PaymentModeViewController: UIViewController {
    
    @IBOutlet weak var cashPaymentRadioImage: UIImageView!
    @IBOutlet weak var cardPaymentRadioImage: UIImageView!
    
    weak var delegate: ChoosePaymentModeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDesigns()
    }
    
    func initDesigns() {
        if (AppConstant.selectedPaymentModeStatus == "1") {
            cashPaymentRadioImage?.image = UIImage.init(named: "radio_checked")
            cardPaymentRadioImage?.image = UIImage.init(named: "radio_unchecked")
        }
        else {
            cashPaymentRadioImage?.image = UIImage.init(named: "radio_unchecked")
            cardPaymentRadioImage?.image = UIImage.init(named: "radio_checked")
        }
    }
    
    //MARK: - Button Action
    @IBAction func btnDoneAction(_ sender: Any) {
        if (AppConstant.selectedPaymentModeStatus == "1") {
            self.delegate?.selectedPaymentMode(pMode: "Cash")
        }
        else {
            self.delegate?.selectedPaymentMode(pMode: "Card")
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnPaymentModeAction(_ sender: UIButton) {
        if (sender.tag == 1) {
            cashPaymentRadioImage?.image = UIImage.init(named: "radio_checked")
            cardPaymentRadioImage?.image = UIImage.init(named: "radio_unchecked")
            AppConstant.selectedPaymentModeStatus = "1"
        }
        else if (sender.tag == 2) {
            cashPaymentRadioImage?.image = UIImage.init(named: "radio_unchecked")
            cardPaymentRadioImage?.image = UIImage.init(named: "radio_checked")
            AppConstant.selectedPaymentModeStatus = "2"
        }
    }
    
}

