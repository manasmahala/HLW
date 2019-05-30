//
//  BookRideForViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/30/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import ContactsUI

@objc protocol ChooseDelegate: class {
    @objc optional func selectedObject(obj: BookRideForContactBO,type: String)
}

class BookRideForViewController: UIViewController, CNContactPickerDelegate {
    
    @IBOutlet weak var viewMyself: UIView!
    @IBOutlet weak var viewOthers: UIView!
    @IBOutlet weak var viewChooseContact: UIView!
    @IBOutlet weak var lblMyselfMobileNo: UILabel!
    @IBOutlet weak var lblOthersName: UILabel!
    @IBOutlet weak var lblOthersMobileNo: UILabel!
    @IBOutlet weak var lblUnderline: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var myselfRadioImage: UIImageView!
    @IBOutlet weak var othersRadioImage: UIImageView!
    @IBOutlet var viewOthersHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblUnderlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewBookRideForHeightConstraint: NSLayoutConstraint!
    
    var bookRideForContactsBo = BookRideForContactBO()
    var type: String = ""
    weak var delegate: ChooseDelegate?
    var currentSelectedStatus: String = "1"

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesigns()
    }
    
    func initDesigns() {
        if (AppConstant.bookRideForContactName == "") {
            myselfRadioImage?.image = UIImage.init(named: "radio_checked")
            othersRadioImage?.image = UIImage.init(named: "radio_unchecked")
            viewOthers.isHidden = true
            lblUnderline.isHidden = true
            viewOthersHeightConstraint.constant = 0
            lblUnderlineHeightConstraint.constant = 0
            viewBookRideForHeightConstraint.constant = 289
        }
        else {
            if (AppConstant.bookRideForContactSelectedStatus == "1") {
                myselfRadioImage?.image = UIImage.init(named: "radio_checked")
                othersRadioImage?.image = UIImage.init(named: "radio_unchecked")
                viewOthers.isHidden = false
                lblUnderline.isHidden = false
                viewOthersHeightConstraint.constant = 50
                lblUnderlineHeightConstraint.constant = 1
                viewBookRideForHeightConstraint.constant = 340
                lblOthersName?.text = AppConstant.bookRideForContactName
                lblOthersMobileNo?.text = AppConstant.bookRideForContactNumber
                AppConstant.bookRideForContactSelectedStatus = "2"
            }
            else {
                myselfRadioImage?.image = UIImage.init(named: "radio_unchecked")
                othersRadioImage?.image = UIImage.init(named: "radio_checked")
                viewOthers.isHidden = false
                lblUnderline.isHidden = false
                viewOthersHeightConstraint.constant = 50
                lblUnderlineHeightConstraint.constant = 1
                viewBookRideForHeightConstraint.constant = 340
                lblOthersName?.text = AppConstant.bookRideForContactName
                lblOthersMobileNo?.text = AppConstant.bookRideForContactNumber
                AppConstant.bookRideForContactSelectedStatus = "1"
            }
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.viewChooseContactAction(_:)))
        viewChooseContact.addGestureRecognizer(tap1)
        viewChooseContact.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.viewChooseExistsContactAction(_:)))
        viewMyself.addGestureRecognizer(tap2)
        viewMyself.tag = 0
        viewMyself.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.viewChooseExistsContactAction(_:)))
        viewOthers.addGestureRecognizer(tap3)
        viewOthers.tag = 1
        viewOthers.isUserInteractionEnabled = true
    }
    
    //MARK: - Button Action
    @IBAction func btnDoneAction(_ sender: Any) {
        if (currentSelectedStatus == "1") {
            self.delegate?.selectedObject!(obj: bookRideForContactsBo, type: "Myself")
        }
        else {
            self.delegate?.selectedObject!(obj: bookRideForContactsBo, type: type)
        }
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func viewChooseContactAction(_ sender: UITapGestureRecognizer) {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    @objc func viewChooseExistsContactAction(_ sender: UITapGestureRecognizer) {
        if (sender.view?.tag == 0) {
            if (AppConstant.bookRideForContactSelectedStatus == "1") {
                myselfRadioImage?.image = UIImage.init(named: "radio_checked")
                othersRadioImage?.image = UIImage.init(named: "radio_unchecked")
            }
            currentSelectedStatus = "1"
            AppConstant.bookRideForContactSelectedStatus = "2"
        }
        else {
            if (AppConstant.bookRideForContactSelectedStatus == "2") {
                myselfRadioImage?.image = UIImage.init(named: "radio_unchecked")
                othersRadioImage?.image = UIImage.init(named: "radio_checked")
            }
            currentSelectedStatus = "2"
            AppConstant.bookRideForContactSelectedStatus = "1"
        }
        
    }
    
    // MARK: Delegate method CNContectPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        bookRideForContactsBo.name = "\(contact.givenName) \(contact.familyName)"
        lblOthersName?.text = bookRideForContactsBo.name
        AppConstant.bookRideForContactName = bookRideForContactsBo.name!
        let numbers = contact.phoneNumbers.first
        bookRideForContactsBo.number = (numbers?.value)?.stringValue
        lblOthersMobileNo?.text = bookRideForContactsBo.number
        AppConstant.bookRideForContactNumber = bookRideForContactsBo.number!
        viewOthers.isHidden = false
        lblUnderline.isHidden = false
        viewOthersHeightConstraint.constant = 50
        lblUnderlineHeightConstraint.constant = 1
        viewBookRideForHeightConstraint.constant = 340
        myselfRadioImage?.image = UIImage.init(named: "radio_unchecked")
        othersRadioImage?.image = UIImage.init(named: "radio_checked")
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
