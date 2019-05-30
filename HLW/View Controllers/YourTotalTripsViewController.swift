//
//  YourTotalTripsViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class YourTotalTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblViewTrip: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var arrTrips = [TripBO]()
    var selectedBookId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        lblNoDataFound.isHidden = true
        self.serviceCallToGetTripList()
    }
    
    //MARK: Button Action
    @IBAction func btnMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourTotalTripsTableViewCell", for: indexPath as IndexPath) as! YourTotalTripsTableViewCell
        cell.selectionStyle = .none
        
        let tripBo = self.arrTrips[indexPath.row]
        
        cell.lblCRN.text = tripBo.bookId
        
        if tripBo.bookStatus == "6"{//Canceled
            cell.tripCancelImage.isHidden = false
            cell.lblPrice.text = ""
        }else{
            cell.tripCancelImage.isHidden = true
            cell.lblPrice.text = "₹\(tripBo.totalfare)"
        }
        cell.lblTripStatus.text = tripBo.bookStatusStr
        cell.lblRideType.text = tripBo.rideName + " - "
        cell.lblVehicleType.text = tripBo.catName
        cell.lblRideDate.text = tripBo.bookDate + " " + tripBo.bookTime
        cell.imgViewCab.sd_setImage(with: URL(string: tripBo.imgPath), placeholderImage: UIImage(named: ""))
        
        if tripBo.rideId == "0"{//One Way
            cell.lblPickUpAddress.text = tripBo.source
            cell.lblDropAddress.text = tripBo.destination
        }else{//Rental
            cell.lblPickUpAddress.text = tripBo.bookStartDateTime
            cell.lblDropAddress.text = tripBo.bookEndDateTime
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tripBo = self.arrTrips[indexPath.row]
        selectedBookId = tripBo.bookId
        self.performSegue(withIdentifier: "trip_details", sender: self)
    }
    
    //MARK: Service Call Method
    func serviceCallToGetTripList() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                //"user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id)
                "user_id" : "28"
            ]
            
            print("url===\(AppConstant.tripHistoryUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.tripHistoryUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint("Ride History : \(response)")
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        self.arrTrips.removeAll()
                        if let status = dict!["status"] as? String {
                            if(status == "1"){
                                if let arrData = dict!["book_data"] as? [[String: Any]]{
                                    for dictData in arrData{
                                        let tripBo = TripBO()
                                        if let book_id = dictData["book_id"] as? String{
                                            tripBo.bookId = book_id
                                        }
                                        if let book_status = dictData["book_status"] as? String{
                                            tripBo.bookStatus = book_status
                                        }
                                        if let book_status_str = dictData["book_status_str"] as? String{
                                            tripBo.bookStatusStr = book_status_str
                                        }
                                        if let start_date_time = dictData["start_date_time"] as? String{
                                            tripBo.bookStartDateTime = start_date_time
                                        }
                                        if let end_date_time = dictData["end_date_time"] as? String{
                                            tripBo.bookEndDateTime = end_date_time
                                        }
                                        if let ride_id = dictData["ride_id"] as? String{
                                            tripBo.rideId = ride_id
                                        }
                                        if let ride_name = dictData["ride_name"] as? String{
                                            tripBo.rideName = ride_name
                                        }
                                        if let rental_name = dictData["rental_name"] as? String{
                                            tripBo.rentalName = rental_name
                                        }
                                        if let cat_id = dictData["cat_id"] as? String{
                                            tripBo.catId = cat_id
                                        }
                                        if let cat_name = dictData["cat_name"] as? String{
                                            tripBo.catName = cat_name
                                        }
                                        if let cat_image = dictData["cat_image"] as? String{
                                            tripBo.imgPath = cat_image
                                        }
                                        if let book_date = dictData["book_date"] as? String{
                                            tripBo.bookDate = book_date
                                        }
                                        if let book_time = dictData["book_time"] as? String{
                                            tripBo.bookTime = book_time
                                        }
                                        if let src_loc = dictData["src_loc"] as? String{
                                            tripBo.source = src_loc
                                        }
                                        if let des_loc = dictData["des_loc"] as? String{
                                            tripBo.destination = des_loc
                                        }
                                        if let total_fare = dictData["total_fare"] as? Int{
                                            tripBo.totalfare = String(total_fare)
                                        }
                                        
                                        self.arrTrips.append(tripBo)
                                    }
                                }
                                self.lblNoDataFound.isHidden = self.arrTrips.count > 0 ? true : false
                                
                                
                                self.tblViewTrip.reloadData()
                            }else  if(status == "3"){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }else{
                                if let msg = dict!["msg"] as? String{
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
    
    //MARK: Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trip_details"{
            let vc  =  segue.destination as! TripDetailsViewController
            vc.bookId = selectedBookId
        }
    }

}
