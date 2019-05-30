//
//  DriverToReachPickUpPointViewController.swift
//  Taxi Booking
//
//  Created by OdiTek Solutions on 19/02/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class DriverToReachPickUpPointViewController: UIViewController {
    
    
    @IBOutlet var imgViewDriverProfile: UIImageView!
    @IBOutlet var viewDriverProfile: UIView!
    @IBOutlet var btnCancelYourRide: UIButton!
    @IBOutlet var btnDown: UIButton!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblVehicleName: UILabel!
    @IBOutlet var lblVehicleNumber: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblOTP: UILabel!
    
    @IBOutlet var viewStartPoint: UIView!
    @IBOutlet var viewPickpoint: UIView!
    @IBOutlet var btnCallPolice: UIButton!
    @IBOutlet var btnSendAlert: UIButton!
    @IBOutlet var lblNotificationCount: UILabel!
    @IBOutlet var lblDriverNearYou: UILabel!
    @IBOutlet var viewDriverinfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imgViewProfileWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imgViewProfileHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblRideOnWayTopConstraint: NSLayoutConstraint!
    @IBOutlet var btnCancelRideBottomConstraint: NSLayoutConstraint!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblRideOnTheWayBottomConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomBottomSpaceConstraint: NSLayoutConstraint!
    
    var timer = Timer()
    var count = AppConstant.count
    var driverProfileBo = DriverProfileBO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designAfterStoryBoard()
        //setValuesToView()
        //runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Design Methods
    func designAfterStoryBoard() {
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            navBarHeightConstraint.constant = 92
            
            viewDriverinfoHeightConstraint.constant = 310
            imgViewProfileHeightConstraint.constant = 140
            imgViewProfileWidthConstraint.constant = 140
            lblRideOnWayTopConstraint.constant = 55
            lblRideOnTheWayBottomConstraint.constant = 50
            viewBottomBottomSpaceConstraint.constant = 37
        }else if AppConstant.screenSize.height <= 568 {
            viewDriverinfoHeightConstraint.constant = 225
            imgViewProfileWidthConstraint.constant = 75
            imgViewProfileHeightConstraint.constant = 75
            lblRideOnWayTopConstraint.constant = 15
            btnCancelRideBottomConstraint.constant = 20
            
            lblDriverName.font = UIFont.init(name: "Poppins-Bold", size: 13.0)
            lblVehicleName.font = UIFont.init(name: "Poppins-Regular", size: 13.0)
            lblVehicleNumber.font = UIFont.init(name: "Poppins-Regular", size: 13.0)
            lblRating.font = UIFont.init(name: "Poppins-Bold", size: 14.0)
            lblOTP.font = UIFont.init(name: "Poppins-Bold", size: 14.0)
        }
        
        btnCancelYourRide.layer.cornerRadius = 3
        btnCancelYourRide.clipsToBounds = true
        btnCancelYourRide.layer.borderWidth = 2.0
        btnCancelYourRide.layer.borderColor = UIColor.white.cgColor
        
//        btnDown.layer.borderColor = UIColor.init(red:108/255.0, green:163/255.0, blue:38/255.0, alpha: 1.0).cgColor Manas
//        btnDown.layer.borderWidth = 2
//        btnDown.layer.cornerRadius = btnDown.frame.size.width / 2
//        btnDown.clipsToBounds = true
        
//        viewDriverProfile.layer.borderColor = UIColor.white.cgColor
//        viewDriverProfile.layer.borderWidth = 1
//        viewDriverProfile.layer.cornerRadius = viewImageHeightConstraint.constant / 2
//        viewDriverProfile.clipsToBounds = true
        
        imgViewDriverProfile.layer.borderColor = UIColor.white.cgColor
        imgViewDriverProfile.layer.borderWidth = 2
        imgViewDriverProfile.layer.cornerRadius = imgViewProfileWidthConstraint.constant / 2
        imgViewDriverProfile.clipsToBounds = true
        
//        viewStartPoint.layer.cornerRadius = viewStartPoint.frame.size.width / 2
//        viewStartPoint.clipsToBounds = true
//
//        viewPickpoint.layer.cornerRadius = viewPickpoint.frame.size.width / 2
//        viewPickpoint.clipsToBounds = true
        
//        btnCallPolice.layer.borderColor = UIColor.init(red:108/255.0, green:163/255.0, blue:38/255.0, alpha: 1.0).cgColor
//        btnCallPolice.layer.borderWidth = 2
//        btnCallPolice.layer.cornerRadius = btnCallPolice.frame.size.height / 2
//        btnCallPolice.clipsToBounds = true
//        
//        btnSendAlert.layer.borderColor = UIColor.init(red:108/255.0, green:163/255.0, blue:38/255.0, alpha: 1.0).cgColor
//        btnSendAlert.layer.borderWidth = 2
//        btnSendAlert.layer.cornerRadius = btnSendAlert.frame.size.height / 2
//        btnSendAlert.clipsToBounds = true
//        
//        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.size.width / 2
//        lblNotificationCount.clipsToBounds = true
        
        let attrs1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize:11 ), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 11), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:"Vehicle No. ", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:driverProfileBo.vehcile_registration_number, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        //self.lblVehicleNumber.attributedText = attributedString1 Manas
        
        //Set progress of the progress bar
        progressBar.progress = 1.0
        
    }
    
    func setValuesToView() {
        lblDriverName.text = driverProfileBo.driver_name
        lblVehicleName.text = String(format : "%@ %@", driverProfileBo.vehcile_brand_name, driverProfileBo.vehcile_model_name)
        
        imgViewDriverProfile.sd_setImage(with: URL(string: driverProfileBo.imagepath), placeholderImage: UIImage(named: "driverProfile"))
    }
    
    // MARK: - Button Action
    @IBAction func btnDownAction(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//        _ = self.navigationController?.popViewController(animated: true)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCancelYourBookingAction(_ sender: Any) {
//        AppConstant.isTokenVerified(completion: { (Bool) in
//            if Bool{
//                self.serviceCallToCancelBooking()
//            }
//        })
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelRidePopupViewController") as! CancelRidePopupViewController
        //        vc.fareInfoArray = self.fareInfoArray
        //        vc.totalFare = self.totalFare
        //        vc.info = self.info
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        vc.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        vc.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            vc.view.alpha = 1.0
            vc.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
    }
    
    @IBAction func btnBackActon(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
//        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnCallDriverAction(_ sender: Any) {
        let phoneNumber: String = driverProfileBo.driver_mobile
        // UIApplication.shared.openURL(URL(string: phoneNumber)!)
        
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(phoneCallURL as URL)
                }
                
            }
        }
    }
    
    @IBAction func btnShareDetailsAction(_ sender: Any) {
        let message = "Riding in HLW cab driven by John Catar (+912345678876). OTP: 1234 is needed to start the ride after booking the cab. Final bill amount will be shown on driver device."
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDriverProfleAction(_ sender: Any) { //As per now dis function works to show bill
        self.performSegue(withIdentifier: "show_bill", sender: self)
    }
    
    @IBAction func btnHelpDeskAction(_ sender: Any) {
        
    }
    
    func runTimer() {
        if(count > 0){
            let hours = Int(count) / 3600
            let minutes = Int(count) / 60 % 60
            let seconds = Int(count) % 60
            
            self.lblTimer.text = String(format:"%02i : %02i : %02i", hours, minutes, seconds)
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(DriverToReachPickUpPointViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
       //Show count down timer hh : mm : ss
        if(count > 0){
            let hours = Int(count) / 3600
            let minutes = Int(count) / 60 % 60
            let seconds = Int(count) % 60
            
            self.lblTimer.text = String(format:"%02i : %02i : %02i", hours, minutes, seconds)
            count = count - 1
            AppConstant.count = count
        }
    }
    
    // MARK: - Service Call Method
    
    func serviceCallToCancelBooking() {
        AppConstant.isBookingConfirm = false
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id"),
                "driver_id" : driverProfileBo.driver_id,
                "booking_id" : AppConstant.retrievFromDefaults(key: "booking_id")
            ]
            
            
            print("params===\(params)")
            
            Alamofire.request( AppConstant.cancelBookingUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let arrData = AppConstant.convertToArray(text: response.result.value!)
                        let dict = arrData![0] as Dictionary
                        if let status = dict["status"] as? Int {
                            if(status == 0){
                                let msg = dict["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == 1){
                                //Show alert for booking cancelled
                                AppConstant.showAlertForCancelBooking()
                                let driverVC = DriverInfoScreenController()
                                driverVC.stopTimer()
                                
                            }else  if(status == 2){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        let error = response.result.error!
                        AppConstant.showAlert(strTitle: error.localizedDescription, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
