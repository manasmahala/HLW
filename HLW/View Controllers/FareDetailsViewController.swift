//
//  FareDetailsViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 27/12/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit

class FareDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblTaxCost: UILabel!
    @IBOutlet weak var lblFareInfo: UILabel!
    @IBOutlet weak var lblFareDetails: UILabel!
    @IBOutlet weak var tblFare: UITableView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet var viewSelectedCar: UIView!
    @IBOutlet var innerViewSelectedCar: UIView!
    @IBOutlet weak var lblSelectedCar: UILabel!
    @IBOutlet weak var selectedCarImgView: UIImageView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTotalCostHeightConstraint: NSLayoutConstraint!
    
    
    var arrFareDettails = [FareDetails]()
    var totalFare : String = "0"
    var info : String = ""
    var taxValue : String = "0"
    var vehicleType : String = ""
    var package : String = ""
    var isForRental: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
    }
    
    func initDesign(){
        tblFare.tableFooterView = UIView()
        okBtn.layer.cornerRadius = 5
        viewPopup.layer.cornerRadius = 10
        viewPopup.clipsToBounds = true
        
        popUpViewLeadingConstraint.constant = (AppConstant.screenSize.width * 11)/100
        popUpViewTrailingConstraint.constant = (AppConstant.screenSize.width * 11)/100
        
        tableViewHeightConstraint.constant = CGFloat((arrFareDettails.count) * 35)
        popUpViewHeightConstraint.constant = ((CGFloat((arrFareDettails.count) * 35)) + 372)
        
        lblTotalCost?.text = "Total Fare  ₹ " + totalFare
        lblTaxCost?.text = isForRental == true ? "package: \(package)" : "( Includes ₹ " + taxValue + " Taxes )"
        lblFareInfo?.text = info
        lblSelectedCar?.text = vehicleType
        if (vehicleType == "Share") {
            self.selectedCarImgView.image = UIImage(named:"car_share_blue")!
        }else if (vehicleType == "Micro") {
            self.selectedCarImgView.image = UIImage(named:"car_micro_blue")!
        }else if (vehicleType == "Mini") {
            self.selectedCarImgView.image = UIImage(named:"car_mini_blue")!
        }else{
            self.selectedCarImgView.image = UIImage(named:"car_sedan_blue")!
        }
        
        viewSelectedCar.layer.cornerRadius = viewSelectedCar.frame.size.width / 2
        viewSelectedCar.clipsToBounds = true
        
        innerViewSelectedCar.layer.cornerRadius = innerViewSelectedCar.frame.size.width / 2
        innerViewSelectedCar.clipsToBounds = true
        
        //Manage for iPhone 5 and Below
        if AppConstant.screenSize.height <= 568{
            lblTotalCostHeightConstraint.constant = 40
        }
        
        //        if self.fareInfoArray.count > 3 {
        //            popUpViewHeightConstraint.constant = popUpViewHeightConstraint.constant + (CGFloat(self.fareInfoArray.count * 30) - 72)
        //        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Action
    @IBAction func btnOKAction(_ sender: UIButton) {
        
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
    
    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFareDettails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FareDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FareDetailsTableViewCell") as! FareDetailsTableViewCell
        cell.selectionStyle = .none
        
        // set the text from the array
//        let fareDetails = fareInfoArray[indexPath.row] as Dictionary
//        cell.lblFareDesc?.text = fareDetails["key"] as? String
//        if let fareValue = fareDetails["value"] as? Int {
//            cell.lblFare?.text = "₹" + String(fareValue)
//        }
        if (indexPath.row < arrFareDettails.count) {
            let fareDetailsBo = arrFareDettails[indexPath.row]
            cell.lblFareTitle?.text = fareDetailsBo.title
            cell.lblFare?.text = "₹ " + fareDetailsBo.price
        }
        
//        if (indexPath.row == self.arrFareDettails.count) {
//            cell.viewSeparator.isHidden = true
//            cell.lblFareTitle?.text = self.info
//            cell.lblFare?.text = ""
//        }
        
        return cell
    }
    

}
