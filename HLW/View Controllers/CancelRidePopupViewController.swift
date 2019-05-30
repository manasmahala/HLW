//
//  CancelRidePopupViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 18/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class CancelRidePopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblCancelRide: UITableView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var btnDontCancel: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var popUpViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewTrailingConstraint: NSLayoutConstraint!
    
    var selectedIndex: Int = -1
    var arrCancelRideDesc = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        viewPopup.layer.cornerRadius = 10
        viewPopup.clipsToBounds = true
        
//        btnDontCancel.layer.cornerRadius = 5
//        btnDontCancel.clipsToBounds = true
//
//        btnCancel.layer.cornerRadius = 5
//        btnCancel.clipsToBounds = true
        
        popUpViewLeadingConstraint.constant = (AppConstant.screenSize.width * 10)/100
        popUpViewTrailingConstraint.constant = (AppConstant.screenSize.width * 10)/100
        
        tblCancelRide.tableFooterView = UIView()
        
        self.arrCancelRideDesc = ["Driver denied to go to destination","Driver denied to come to pickup","Expected a shorter wait time","Unable to contact driver","My reason is not listed"]
        btnCancel.isEnabled = false
    }
    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCancelRideDesc.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelRideTableViewCell", for: indexPath as IndexPath) as! CancelRideTableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row == self.arrCancelRideDesc.count - 1{
            cell.viewSeparator.isHidden = true
        }
        
        let strReason = self.arrCancelRideDesc[indexPath.row]
        cell.lblCancelRideDesc.text = strReason
        cell.imgViewRadio.image = (indexPath.row == selectedIndex) ? UIImage.init(named: "radio_checked") : UIImage.init(named: "radio_unchecked")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        btnCancel.isEnabled = true
        tableView.reloadData()
        
    }
    
    //MARK: Button Action
    @IBAction func btnDontCancelRideAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
            }
        })
        
    }
    @IBAction func btnCancelRideAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.goToMainScreen()
            }
        })
    }

}
