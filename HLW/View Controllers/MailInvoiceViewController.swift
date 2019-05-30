//
//  MakeYourSelectionViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 28/05/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class MailInvoiceViewController: UIViewController {
  
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtFldMail: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesign()
    }
    
    func initDesign(){
        txtFldMail.text = AppConstant.retrievFromDefaults(key: StringConstant.email)
        
        self.btnCancel.layer.cornerRadius = 5
        self.btnCancel.clipsToBounds = true
        
        self.btnSend.layer.cornerRadius = 5
        self.btnSend.clipsToBounds = true
        
        self.viewPopup.layer.cornerRadius = 5
        self.viewPopup.clipsToBounds = true
    }
    
    //MARK: Button Action
    
    @IBAction func btnCancelAction(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
