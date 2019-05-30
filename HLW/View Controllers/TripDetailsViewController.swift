//
//  TripDetailsViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 14/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps

class TripDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblTripDetails: UITableView!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblPageTitle: UILabel!
    @IBOutlet var viewSeparator: UIView!
    @IBOutlet var btnInvoice: UIButton!
    
    var bookId: String = ""
    var tripDetailsBo = TripDetailsBO()
    var pickUpCoordinate : CLLocationCoordinate2D? = nil
    var dropCoordinate : CLLocationCoordinate2D? = nil
    var arrLocations = [CLLocationCoordinate2D]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            navBarHeightConstraint.constant = 92
        }
        
        tblTripDetails.isHidden = true
        btnInvoice.isHidden = true
        lblPageTitle.text = bookId
        
        serviceCallToGetTripDetails()
        
    }
    
    //MARK: Tableview Datasource & Delagates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return tripDetailsBo.arrFareDettails.count
        }else if section == 2{
            return (self.tripDetailsBo.bookStatus == "6" || self.tripDetailsBo.bookStatus == "8") ? 0 : 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:TripDetailsTableViewCell = self.tblTripDetails.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell") as! TripDetailsTableViewCell
            cell.selectionStyle = .none
            
            cell.lblDriverName.text = tripDetailsBo.driverBo.driver_name
            cell.lblDriverRating.text = tripDetailsBo.driverBo.driver_rating
            cell.imgViewDriverPic.sd_setImage(with: URL(string: tripDetailsBo.driverBo.driver_image), placeholderImage: UIImage(named: "driver"))
            cell.imgViewCab.sd_setImage(with: URL(string: tripDetailsBo.driverBo.vehicle_image), placeholderImage: UIImage(named: "car_sedan_blue"))
            cell.lblRideType.text = tripDetailsBo.tripBo.rideName + " - "
            cell.lblCabType.text = tripDetailsBo.tripBo.catName
            cell.lblcabName.text = tripDetailsBo.driverBo.vehcile_brand_name + " " + tripDetailsBo.driverBo.vehcile_model_name + "[\(tripDetailsBo.driverBo.vehcile_registration_number)]"
            cell.lblStartTime.text = tripDetailsBo.tripBo.bookStartDateTime
            cell.lblEndTime.text = self.tripDetailsBo.tripBo.bookEndDateTime
            cell.lblPickupAddress.text = self.tripDetailsBo.source
            cell.lblDropAddress.text = self.tripDetailsBo.destination
            cell.lblStatus.text = tripDetailsBo.bookStatusStr
            
            if (self.tripDetailsBo.bookStatus == "6" || self.tripDetailsBo.bookStatus == "8"){//cancel ride
                cell.lblStartTimeWidthConstraint.constant = 0
                cell.lblRideDetailsTitle.isHidden = true
            }else{
                cell.lblStartTimeWidthConstraint.constant = 110
                cell.lblRideDetailsTitle.isHidden = false
            }
            
            if (self.tripDetailsBo.sourceLat != "" && self.tripDetailsBo.sourceLat != "NA"){
                pickUpCoordinate = CLLocationCoordinate2D(latitude:Double(self.tripDetailsBo.sourceLat)!
                    , longitude: Double(self.tripDetailsBo.sourceLng)!)
            }
            if (self.tripDetailsBo.destinationLat != "" && self.tripDetailsBo.destinationLat != "NA"){
                dropCoordinate = CLLocationCoordinate2D(latitude:Double(self.tripDetailsBo.destinationLat)!
                    , longitude: Double(self.tripDetailsBo.destinationLng)!)
            }
                
                
            arrLocations.removeAll()
            if pickUpCoordinate != nil{
                arrLocations.append(pickUpCoordinate!)
            }
            if dropCoordinate != nil{
                arrLocations.append(dropCoordinate!)
            }
            cell.arrLocations = arrLocations
            cell.setBoundsForMap()
            
            
            return cell
        }else if indexPath.section == 1 {
            let cell:BillBreakDownTableViewCell = self.tblTripDetails.dequeueReusableCell(withIdentifier: "BillBreakDownTableViewCell") as! BillBreakDownTableViewCell
            cell.selectionStyle = .none
            
            let fareBo = tripDetailsBo.arrFareDettails[indexPath.row]
            
            cell.lblKey.text = fareBo.title
            cell.lblValue.text = fareBo.type == 1 ? "₹ \(fareBo.price)" : fareBo.price
            
            return cell
        }else{
            let cell:TotalBillTableViewCell = self.tblTripDetails.dequeueReusableCell(withIdentifier: "TotalBillTableViewCell") as! TotalBillTableViewCell
            cell.selectionStyle = .none
            
            cell.lblPaymentMode.text = self.tripDetailsBo.tripBo.payMode
            cell.lblPrice.text = "₹ \(self.tripDetailsBo.totalCost)"
            
            return cell
        }
        
    }
    
    // MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMailInvoiceAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MailInvoiceViewController") as! MailInvoiceViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Service Call
    func serviceCallToGetTripDetails() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
//                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "user_id" : "28",
                "book_id" : bookId
            ]
            
            print("url===\(AppConstant.tripDetailsUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.tripDetailsUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint("Trip Details : \(response)")
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? String {
                            if(status == "1"){//Success
                                self.tblTripDetails.isHidden = false
                                self.btnInvoice.isHidden = false
                                
                                if let book_status = dict?["book_status"] as? String{
                                    self.tripDetailsBo.bookStatus = book_status
                                }
                                if let book_status_str = dict?["book_status_str"] as? String{
                                    self.tripDetailsBo.bookStatusStr = book_status_str
                                }
                                if let dictBookInfo = dict?["book_info"] as? [String: Any]{
                                    if let book_date = dictBookInfo["book_date"] as? String{
                                        self.tripDetailsBo.tripBo.bookDate = book_date
                                    }
                                    if let book_time = dictBookInfo["book_time"] as? String{
                                        self.tripDetailsBo.tripBo.bookTime = book_time
                                    }
                                    if let start_date_time = dictBookInfo["start_date_time"] as? String{
                                        self.tripDetailsBo.tripBo.bookStartDateTime = start_date_time
                                    }
                                    if let end_date_time = dictBookInfo["end_date_time"] as? String{
                                        self.tripDetailsBo.tripBo.bookEndDateTime = end_date_time
                                    }
                                    if let ride_id = dictBookInfo["ride_id"] as? String{
                                        self.tripDetailsBo.tripBo.rideId = ride_id
                                    }
                                    if let cat_id = dictBookInfo["cat_id"] as? String{
                                        self.tripDetailsBo.tripBo.catId = cat_id
                                    }
                                    if let ride_name = dictBookInfo["ride_name"] as? String{
                                        self.tripDetailsBo.tripBo.rideName = ride_name
                                    }
                                    if let rental_name = dictBookInfo["rental_name"] as? String{
                                        self.tripDetailsBo.tripBo.rentalName = rental_name
                                    }
                                    if let cat_name = dictBookInfo["cat_name"] as? String{
                                        self.tripDetailsBo.tripBo.catName = cat_name
                                    }
                                    if let cat_image = dictBookInfo["cat_image"] as? String{
                                        self.tripDetailsBo.tripBo.imgPath = cat_image
                                    }
                                    if let pay_mode_str = dictBookInfo["pay_mode_str"] as? String{
                                        self.tripDetailsBo.tripBo.payMode = pay_mode_str
                                    }
                                }
                                if let dictLocation_info = dict?["location_info"] as? [String: Any]{
                                    if let pick_pnt = dictLocation_info["pick_pnt"] as? String{
                                        self.tripDetailsBo.source = pick_pnt
                                    }
                                    if let drop_pnt = dictLocation_info["drop_pnt"] as? String{
                                        self.tripDetailsBo.destination = drop_pnt
                                    }
                                    if let drop_pnt = dictLocation_info["src_lat"] as? String{
                                        self.tripDetailsBo.sourceLat = drop_pnt
                                    }
                                    if let drop_pnt = dictLocation_info["src_lon"] as? String{
                                        self.tripDetailsBo.sourceLng = drop_pnt
                                    }
                                    if let drop_pnt = dictLocation_info["des_lat"] as? String{
                                        self.tripDetailsBo.destinationLat = drop_pnt
                                    }
                                    if let drop_pnt = dictLocation_info["des_lon"] as? String{
                                        self.tripDetailsBo.destinationLng = drop_pnt
                                    }
                                }
                                if let dictDriver_info = dict?["driver_info"] as? [String: Any]{
                                    if let driver_id = dictDriver_info["driver_id"] as? String{
                                        self.tripDetailsBo.driverBo.driver_id = driver_id
                                    }
                                    if let driver_name = dictDriver_info["driver_name"] as? String{
                                        self.tripDetailsBo.driverBo.driver_name = driver_name
                                    }
                                    if let driver_mobile = dictDriver_info["driver_mobile"] as? String{
                                        self.tripDetailsBo.driverBo.driver_mobile = driver_mobile
                                    }
                                    if let driver_rating = dictDriver_info["driver_rating"] as? String{
                                        self.tripDetailsBo.driverBo.driver_rating = driver_rating
                                    }
                                    if let driver_image = dictDriver_info["driver_image"] as? String{
                                        self.tripDetailsBo.driverBo.driver_image = driver_image
                                    }
                                    if let vehcile_reg_no = dictDriver_info["vehcile_reg_no"] as? String{
                                        self.tripDetailsBo.driverBo.vehcile_registration_number = vehcile_reg_no
                                    }
                                    if let vehcile_brand_name = dictDriver_info["vehcile_brand_name"] as? String{
                                        self.tripDetailsBo.driverBo.vehcile_brand_name = vehcile_brand_name
                                    }
                                    if let vehcile_model_name = dictDriver_info["vehcile_model_name"] as? String{
                                        self.tripDetailsBo.driverBo.vehcile_model_name = vehcile_model_name
                                    }
                                    if let vehicle_image = dictDriver_info["vehicle_image"] as? String{
                                        self.tripDetailsBo.driverBo.vehicle_image = vehicle_image
                                    }
                                }
                                if let dictInvoice_info = dict?["invoice_info"] as? [String: Any]{
                                    if let total_cost = dictInvoice_info["total_cost"] as? Int {
                                        self.tripDetailsBo.totalCost = String(total_cost)
                                    }
                                    if let fareInfoArray = dictInvoice_info["fare_detail"] as? [[String: Any]]{
                                        debugPrint(fareInfoArray)
                                        for item in fareInfoArray {
                                            let fareDetailsBo = FareDetails()
                                            
                                            if let titleKey = item["key"] as? String {
                                                fareDetailsBo.title = titleKey
                                            }
                                            if let value = item["value"] as? Int {
                                                fareDetailsBo.price = String(value)
                                            }
                                            if let type = item["type"] as? Int {
                                                fareDetailsBo.type = type
                                            }
                                            self.tripDetailsBo.arrFareDettails.append(fareDetailsBo)
                                        }
                                    }
                                }
                                
                                self.btnInvoice.isHidden =  (self.tripDetailsBo.bookStatus != "6" || self.tripDetailsBo.bookStatus != "8") ? false : true
                                self.viewSeparator.isHidden =  (self.tripDetailsBo.bookStatus != "6" || self.tripDetailsBo.bookStatus != "8") ? false : true
                                self.tblTripDetails.reloadData()
                            }
                            else if (status == "3"){//Logout from the app
                                AppConstant.logout()
                            }else{
                                if let msg = dict?["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
