//
//  RentalsRateCardViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 3/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class RentalsRateCardViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate , UITableViewDataSource, selectionDelegate {

    @IBOutlet weak var rentalsTableView: UITableView!
    
    var itemInfo: IndicatorInfo = "RENTAL"
    var cells = SwiftyAccordionCells()
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    var arrRentalBookingCabTypes = [RentalBookingCabTypes]()
    var selectedTrip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
    }
    
    func initDesign(){
        self.rentalsTableView.tableFooterView = UIView()
        //self.tblViewRewards.estimatedRowHeight = 45
        self.rentalsTableView.rowHeight = UITableViewAutomaticDimension
        self.rentalsTableView.allowsMultipleSelection = true
        
        
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    //MARK: Tableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else if (section == 1) {
            return arrRentalBookingCabTypes.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalDetailsRateCardTableViewCell", for: indexPath as IndexPath) as! RentalDetailsRateCardTableViewCell
            
            cell.selectionStyle = .none
            
            cell.lblSelection.text = selectedTrip
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectTripAction(_:)))
            cell.viewTripSelection.isUserInteractionEnabled = true
            cell.viewTripSelection.addGestureRecognizer(tap)
            
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalCabFareDetailsTableViewCell", for: indexPath as IndexPath) as! RentalCabFareDetailsTableViewCell
            cell.selectionStyle = .none
            
            let cabBo = self.arrRentalBookingCabTypes[indexPath.row]
            
            cell.lblBaseFare.text = "₹ \(cabBo.baseFare)"
            cell.lblAddKmFare.text = "₹ \(cabBo.addKmFare)"
            cell.lblAddTimeFare.text = "₹ \(cabBo.addTimeFare)"
            cell.lblMinFare.text = "₹ \(cabBo.minFare)"
            cell.lblCabName.text = cabBo.cabName
            
            cell.viewContainerHeightConstraint.constant = cabBo.isShowing ? 188.0 : 0
            cell.viewContainer.isHidden = cabBo.isShowing ? false : true
            cell.viewCab.tag = indexPath.row
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectCabFare(_:)))
            cell.viewCab.isUserInteractionEnabled = true
            cell.viewCab.addGestureRecognizer(tap)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RentalExtraChargesRateCardTableViewCell", for: indexPath as IndexPath) as! RentalExtraChargesRateCardTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Selection Delegate
    func selectedOption(customBo: CustomObject, at: Int){
        selectedTrip = customBo.name
        self.serviceCallToGetRentalTarif(rentalId: customBo.id)
    }
    
    //MARK: Button Action
    @objc func selectTripAction(_ sender: UITapGestureRecognizer) {
        serviceCallToGetSelectTripOptions()
        
    }
    @objc func selectCabFare(_ sender: UITapGestureRecognizer) {
        let cabBo = self.arrRentalBookingCabTypes[(sender.view?.tag)!]
        cabBo.isShowing = !cabBo.isShowing
        
        self.rentalsTableView.reloadData()
        
    }
    
    func showSelection(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeYourSelectionViewController") as! MakeYourSelectionViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Service Call
    func serviceCallToGetSelectTripOptions() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "city_name" : AppConstant.cityName,
                "ride_type" : "1"
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
                                AppConstant.arrSelection.removeAll()
                                if let dictRateCard = dict?["rateCard"] as? [String: Any] {
                                    if let arrCategory = dictRateCard["category"] as? [[String: Any]] {
                                        for dict in arrCategory{
                                            let customBo = CustomObject()
                                            if let rental_id = dict["rental_id"] as? String {
                                                customBo.id = rental_id
                                            }
                                            if let rental_type = dict["rental_type"] as? String {
                                                customBo.name = rental_type
                                            }
                                            
                                            AppConstant.arrSelection.append(customBo)
                                        }
                                    }
                                }
                                self.showSelection()
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
                                            if let add_km_fare = dict["add_km_fare"] as? String {
                                                cabBo.addKmFare = add_km_fare
                                            }
                                            if let add_time_fare = dict["add_time_fare"] as? String {
                                                cabBo.addTimeFare = add_time_fare
                                            }
                                            if let base_fare = dict["base_fare"] as? String {
                                                cabBo.baseFare = base_fare
                                            }
                                            if let min_fare = dict["min_fare"] as? Int {
                                                cabBo.minFare = String(min_fare)
                                            }
                                            
                                            self.arrRentalBookingCabTypes.append(cabBo)
                                        }
                                    }
                                }
                                
                                if self.arrRentalBookingCabTypes.count > 0{
                                    let cabBo = self.arrRentalBookingCabTypes[0]
                                    cabBo.isShowing = true
                                }
                                
                                self.rentalsTableView.reloadData()
                                
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
    

}
