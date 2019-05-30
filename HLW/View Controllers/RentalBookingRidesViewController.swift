//
//  RentalBookingRidesViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/7/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class RentalBookingRidesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChooseDelegate, ChoosePaymentModeDelegate, ApplyCouponDelegate {
    @IBOutlet weak var rentalBookingRidesTableView: UITableView!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dateTimePicker: UIDatePicker!
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet var viewDatePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var viewBackground: UIView!
    
    var arrRentalBookingPackages = [RentalBookingPackages]()
    var arrRentalBookingCabTypes = [RentalBookingCabTypes]()
    var pickUpLocation : String = ""
    var selectedPackageIndex = -1
    var selectedCabIndex = -1
    var isForBooklater: Bool = false
    var pickupTime: String = ""
    var pickUpCoordinate : CLLocationCoordinate2D? = nil
    var selectedPackageId = ""
    var arrFareDettails = [FareDetails]()
    var info : String = ""
    var taxValue : String = ""
    var cityId : String = ""
    var totalFare : String = "--"
    var vehicleType: String = ""
    var selectedPackage: String = ""
    var isCouponApplied: Bool = false
    var promoCode = CouponBO()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesigns()
    }
    
    func initDesigns() {
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            navBarHeightConstraint.constant = 92
        }

        viewBackground.isHidden = true
        viewDatePicker.isHidden = true
        viewDatePickerBottomConstraint.constant = -190
        
        //loadRentalBookingPackages()
        
        serviceCallToGetRateCard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load Static Rental Datas
    func loadRentalBookingPackages() {
        var rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "1 hrs 10 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "BBSR_CUTTACK 1 hr 30 km 2019"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "2 hrs 20 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "3 hrs 30 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "BBSR_NANDANKANAN 5 hrs 30 km 2019"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "BBSR_CUTTACK 5 hrs 60 km 2019"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "6 hrs 60 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "8 hrs 80 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "10 hrs 100 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "BBSR_DARSHAN 10 hrs 101 km 2019"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
        
        rentalBookingPackagesBo = RentalBookingPackages()
        rentalBookingPackagesBo.packageName = "12 hrs 120 km"
        arrRentalBookingPackages.append(rentalBookingPackagesBo)
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func totalFareViewAction(_ sender: Any) {
        if self.totalFare != "--"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FareDetailsViewController") as! FareDetailsViewController
            vc.arrFareDettails = self.arrFareDettails
            vc.totalFare = self.totalFare
            vc.info = self.info
            vc.taxValue = self.taxValue
            vc.vehicleType = self.vehicleType
            vc.isForRental = true
            vc.package = self.selectedPackage
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
    }
    
    @objc func viewBookRideForAction(_ sender: UITapGestureRecognizer) {
        viewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewBackground.isHidden = false
        self.performSegue(withIdentifier: "book_ride_for", sender: self)
    }
    
    @objc func viewPaymentModeAction(_ sender: UITapGestureRecognizer) {
        viewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewBackground.isHidden = false
        self.performSegue(withIdentifier: "payment_mode", sender: self)
    }
    
    @objc func viewApplyCouponAction(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "apply_coupon", sender: self)
    }
    
    @objc func setPickupTime() {
        dateTimePicker.minimumDate = Date()
        dateTimePicker.maximumDate = Date().add(days: 2)//User can book a cab before 2 days only
        viewDatePicker.animShow()
        
        viewDatePicker.isHidden = false
        viewDatePickerBottomConstraint.constant = 0
    
        viewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewBackground.isHidden = false
    }
    
    @IBAction func datePickerCancelBtnAction(_ sender: Any) {
        viewDatePicker.animHide()
        viewBackground.isHidden = true
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: Any) {
        viewDatePicker.animHide()
        viewBackground.isHidden = true
        
        pickupTime = AppConstant.formattedDate(date: dateTimePicker.date, withFormat: StringConstant.dateFormatter1, ToFormat: StringConstant.dateFormatter3)!
        rentalBookingRidesTableView.reloadData()
    }
    
    //MARK: Choose Contact Protocol Delegates
    func selectedObject(obj: BookRideForContactBO, type: String) {
        viewBackground.isHidden = true
        let indexPath = IndexPath(row: 0, section: 3)
        let cell = self.rentalBookingRidesTableView.cellForRow(at: indexPath) as! RentalDisplaySelectedOptionsTableViewCell
        AppConstant.currentBookRideForSelectedType = type
        if (type == "book_ride_for") {
            if (obj.name == nil) {
                if (AppConstant.bookRideForContactName == "") {
                    cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
                    cell.lblBookRideForContact?.text = "Myself"
                    AppConstant.bookRideForContactSelectedStatus = "1"
                }
                else {
                    cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 14.0)
                    cell.lblBookRideForContact?.text = AppConstant.bookRideForContactName
                    AppConstant.bookRideForContactSelectedStatus = "2"
                }
            }
            else {
                cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 14.0)
                cell.lblBookRideForContact?.text = obj.name!
                AppConstant.bookRideForContactSelectedStatus = "2"
            }
        }
        else if (type == "Myself") {
            cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
            cell.lblBookRideForContact?.text = "Myself"
            AppConstant.bookRideForContactSelectedStatus = "1"
        }
    }
    
    //MARK: Applied Coupon Protocol Delegates
    func appliedCoupon(couponBo: CouponBO) {
        promoCode = couponBo
        isCouponApplied = true
//        lblAppliedCoupon.text = couponBo.title
//        imgViewCoupon.isHidden = true
//        lblAppliedCoupon.isHidden = false
//        lblApplyCoupon.text = "Coupon Applied"

        let cabBo = self.arrRentalBookingCabTypes[selectedCabIndex]
        self.serviceCallToGetFareDetails(vehicleTypeId: cabBo.cabId)
    }
    
    //MARK: Choose Payment Mode Protocol Delegates
    func selectedPaymentMode(pMode: String) {
        viewBackground.isHidden = true
        let indexPath = IndexPath(row: 0, section: 3)
        let cell = self.rentalBookingRidesTableView.cellForRow(at: indexPath) as! RentalDisplaySelectedOptionsTableViewCell
        AppConstant.selectedPaymentMode = pMode
        cell.lblPaymentModeOption?.text = pMode
    }
    
    //MARK: Tableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else if (section == 1) {
            return arrRentalBookingPackages.count + 1
        }
        else if (section == 2) {
            return selectedPackageIndex == -1 ? 1 :  arrRentalBookingCabTypes.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalPickUpLocationTableViewCell", for: indexPath as IndexPath) as! RentalPickUpLocationTableViewCell
            
            cell.selectionStyle = .none
            cell.lblPickUpLocation?.text = self.pickUpLocation
            
            return cell
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RentalTitleTableViewCell", for: indexPath as IndexPath) as! RentalTitleTableViewCell
                
                cell.selectionStyle = .none
                cell.lblRentalBookingTitle?.text = "SELECT  PACKAGE"
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RentalPackageTableViewCell", for: indexPath as IndexPath) as! RentalPackageTableViewCell
                
                cell.selectionStyle = .none
                let rentalBookingPackagesBo = arrRentalBookingPackages[indexPath.row - 1]
                cell.lblRentalBookingPackages?.text = rentalBookingPackagesBo.packageName
                cell.radioImage?.image = selectedPackageIndex == indexPath.row - 1 ? UIImage.init(named: "radio_checked") : UIImage.init(named: "radio_unchecked")
                
//                if indexPath.row == 1{
//                    cell.viewContainer.roundCorners([.topLeft, .topRight], radius: 5)
//                    cell.viewInner.roundCorners([.topLeft, .topRight], radius: 5)
//                }
//                if indexPath.row == arrRentalBookingPackages.count + 1{
//                    cell.viewContainer.roundCorners([.bottomLeft, .bottomRight], radius: 5)
//                    cell.viewInner.roundCorners([.topLeft, .topRight], radius: 5)
//                }
//
//                cell.viewContainerTopSpaceConstraint.constant = indexPath.row == 1 ? 1 : 0
//                cell.viewContainerBottomSpaceConstraint.constant = indexPath.row == arrRentalBookingPackages.count + 1 ? 1 : 0
                
                return cell
            }
        }
        else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RentalTitleTableViewCell", for: indexPath as IndexPath) as! RentalTitleTableViewCell
                
                cell.selectionStyle = .none
                cell.lblRentalBookingTitle?.text = "CHOOSE  A  CAB  TYPE"
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RentalCabTypeTableViewCell", for: indexPath as IndexPath) as! RentalCabTypeTableViewCell
                
                cell.selectionStyle = .none
                let rentalBookingCabTypesBo = arrRentalBookingCabTypes[indexPath.row - 1]
                cell.lblCabType?.text = rentalBookingCabTypesBo.cabName
                //cell.lblCabName?.text = rentalBookingCabTypesBo.cabName
                cell.lblCabAvailableTime?.text = rentalBookingCabTypesBo.cabAvailableTime
                cell.lblCabPrice?.text = "₹ \(rentalBookingCabTypesBo.cabPrice)"
                cell.cabImage?.sd_setImage(with: URL(string: rentalBookingCabTypesBo.cabBlue), placeholderImage: UIImage(named: ""))
                cell.radioImage?.image = selectedCabIndex == indexPath.row - 1 ? UIImage.init(named: "radio_checked") : UIImage.init(named: "radio_unchecked")
                
                
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalDisplaySelectedOptionsTableViewCell", for: indexPath as IndexPath) as! RentalDisplaySelectedOptionsTableViewCell
            
            cell.selectionStyle = .none
            cell.isForBooklater = isForBooklater
            cell.lblPickupTime.text = pickupTime
            cell.lblTotalFare.text = self.totalFare == "--" ? "--" : "₹ \(self.totalFare)/-"
            
            if (isForBooklater == false) {
                cell.viewPickupTime.isHidden = true
                cell.viewPickupTimeHeightConstraint.constant = 0
                cell.viewPickupTimeTopConstraint.constant = 0
                cell.viewRentalDisplayHeightConstraint.constant = 174
            }
            else {}
            
            if selectedCabIndex >= 0{
                cell.viewSelectedRentalCar.isHidden = false
            }else{
                cell.viewSelectedRentalCar.isHidden = true
            }
            
            if selectedCabIndex >= 0{
                let rentalBookingCabTypesBo = arrRentalBookingCabTypes[selectedCabIndex]
                
                cell.lblSelectedCar?.text = rentalBookingCabTypesBo.cabName
                cell.selectedCarImgView?.sd_setImage(with: URL(string: rentalBookingCabTypesBo.cabBlue), placeholderImage: UIImage(named: ""))
            }
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.viewBookRideForAction(_:)))
            cell.bookRideForView.addGestureRecognizer(tap1)
            cell.bookRideForView.isUserInteractionEnabled = true
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.viewPaymentModeAction(_:)))
            cell.paymentModeView.addGestureRecognizer(tap2)
            cell.paymentModeView.isUserInteractionEnabled = true
            
            let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.viewApplyCouponAction(_:)))
            cell.applyCouponView.addGestureRecognizer(tap3)
            cell.applyCouponView.isUserInteractionEnabled = true
            
            let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.setPickupTime))
            cell.viewPickupTime?.isUserInteractionEnabled = true
            cell.viewPickupTime?.addGestureRecognizer(tap4)
            
            if (AppConstant.currentBookRideForSelectedType == "") {
                cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
                cell.lblBookRideForContact?.text = "Myself"
            }
            else {
                if (AppConstant.currentBookRideForSelectedType == "book_ride_for") {
                    cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 14.0)
                    cell.lblBookRideForContact?.text = AppConstant.bookRideForContactName
                }
                else {
                    cell.lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
                    cell.lblBookRideForContact?.text = "Myself"
                }
            }
            
            cell.imgViewCoupon.isHidden = isCouponApplied ? true : false
            cell.lblAppliedCouponCode.isHidden = isCouponApplied ? false : true
            cell.lblAppliedCouponCode.text = isCouponApplied ? promoCode.title : ""
            cell.lblApplyCoupon.text = isCouponApplied ? "Coupon Applied" : "Apply Coupon"

            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat.leastNonzeroMagnitude
        }
        else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {//Select Package
            selectedPackageIndex = indexPath.row - 1
            let packageBo = self.arrRentalBookingPackages[indexPath.row - 1]
            self.selectedPackage = packageBo.packageName
            self.serviceCallToGetRentalTarif(rentalId: packageBo.packageId)
            //tableView.reloadData()
        }else if (indexPath.section == 2) {//Choose a  cab
            selectedCabIndex = indexPath.row - 1
            
            let cabBo = self.arrRentalBookingCabTypes[indexPath.row - 1]
            self.vehicleType = cabBo.cabName
            self.serviceCallToGetFareDetails(vehicleTypeId: cabBo.cabId)
            
            //tableView.reloadData()
        }
        
    }
    
    //MARK: Service Call
    func serviceCallToGetRateCard() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "city_name" : AppConstant.cityName,
                "ride_type" : 1
            ]
            
            print("url===\(AppConstant.getRateCardUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getRateCardUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint("Rate Card : \(response)")
                    switch(response.result) {
                    case .success(_):
                        
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//Success
                                self.arrRentalBookingPackages.removeAll()
                                if let dictRateCard = dict?["rateCard"] as? [String: Any] {
                                    if let arrCategory = dictRateCard["category"] as? [[String: Any]] {
                                        for dict in arrCategory{
                                            let packageBo = RentalBookingPackages()
                                            if let rental_id = dict["rental_id"] as? String {
                                                packageBo.packageId = rental_id
                                            }
                                            if let rental_type = dict["rental_type"] as? String {
                                                packageBo.packageName = rental_type
                                            }
                                            
                                            self.arrRentalBookingPackages.append(packageBo)
                                        }
                                    }
                                }
                                
                                self.rentalBookingRidesTableView.reloadData()
                                    
                            }
                            else if (status == 3){//Logout from the app
                                AppConstant.logout()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    func serviceCallToGetRentalTarif(rentalId : String) {
        if AppConstant.hasConnectivity() {
            self.selectedPackageId = rentalId
            self.totalFare = "--"
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "city_name" : AppConstant.cityName,
                "ride_type" : 1,
                "rental_id" : rentalId
            ]
            
            print("url===\(AppConstant.getRentalTarifUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getRentalTarifUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint("Tarif : \(response)")
                    switch(response.result) {
                    case .success(_):
                        
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//Success
                                self.arrRentalBookingCabTypes.removeAll()
                                if let dictRateCard = dict?["rateCard"] as? [String: Any] {
                                    if let arrCategory = dictRateCard["category"] as? [[String: Any]] {
                                        for dict in arrCategory{
                                            let cabBo = RentalBookingCabTypes()
                                            if let cat_id = dict["cat_id"] as? String {
                                                cabBo.cabId = cat_id
                                            }
                                            if let category_name = dict["category_name"] as? String {
                                                cabBo.cabName = category_name
                                            }
                                            if let cabBlue = dict["image_blue"] as? String {
                                                cabBo.cabBlue = cabBlue
                                            }
                                            if let cabWhite = dict["image_white"] as? String {
                                                cabBo.cabWhite = cabWhite
                                            }
                                            if let min_fare = dict["min_fare"] as? Int {
                                                cabBo.cabPrice = String(min_fare)
                                            }
                                            
                                            self.arrRentalBookingCabTypes.append(cabBo)
                                        }
                                    }
                                }
                                
                                self.rentalBookingRidesTableView.reloadData()
                                
                            }
                            else if (status == 3){//Logout from the app
                                AppConstant.logout()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    func serviceCallToGetFareDetails(vehicleTypeId: String) {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            let pickLat : NSNumber = NSNumber(value: (pickUpCoordinate?.latitude)!)
            let pickLng : NSNumber = NSNumber(value: (pickUpCoordinate?.longitude)!)
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "src_lat" : String(describing: pickLat),
                "src_lon" : String(describing: pickLng),
                "des_lat" : "",
                "des_lon" : "",
                "ride_id" : "1",
                "rental_id": selectedPackageId,
                "cat_id" : vehicleTypeId,
                "city" : AppConstant.cityName,
                "promo_code" : isCouponApplied ? promoCode.title : ""
            ]
            print("url===\(AppConstant.getFareDetailsUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getFareDetailsUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        debugPrint(dict!)
                        //                        let dict = dataArray![0] as Dictionary
                        self.arrFareDettails.removeAll()
                        if let status = dict?["status"] as? String {
                            if(status == "0"){
                                let msg = dict?["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == "1"){
                                if let totalFare = dict?["cost"] as? Int {
                                    self.totalFare = "\(totalFare)"
                                    debugPrint(self.totalFare)
                                }
                                if let taxValue = dict?["tax"] as? Int {
                                    self.taxValue = "\(taxValue)"
                                    debugPrint(self.taxValue)
                                }
                                if let info = dict?["info_str"] as? String {
                                    self.info = info
                                    debugPrint(self.info)
                                }
                                if let fareInfoArray = dict?["info_arry"] as? [[String: Any]]{
                                    debugPrint(fareInfoArray)
                                    for item in fareInfoArray {
                                        let fareDetailsBo = FareDetails()
                                        
                                        if let titleKey = item["key"] as? String {
                                            fareDetailsBo.title = titleKey.replacingOccurrences(of: "&#x20b9;", with: "₹ ")
                                        }
                                        if let value = item["value"] as? String {
                                            fareDetailsBo.price = value
                                        }
                                        self.arrFareDettails.append(fareDetailsBo)
                                    }
                                }
                                
                            }else  if(status == "2"){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
//                        let indexPath = IndexPath(item: 0, section: 3)
//                        self.rentalBookingRidesTableView.reloadRows(at: [indexPath], with: .none)
                        self.rentalBookingRidesTableView.reloadData()
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.view.endEditing(true)
        if (segue.identifier == "book_ride_for"){
            let vc = segue.destination as! BookRideForViewController
            vc.delegate = self
            vc.type = segue.identifier!
        }else if (segue.identifier == "payment_mode"){
            let vc = segue.destination as! PaymentModeViewController
            vc.delegate = self
        }else if (segue.identifier == "apply_coupon"){
            let vc = segue.destination as! ApplyCouponViewController
            vc.delegate = self
        }
    }
    

}
