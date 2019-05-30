//
//  PreviousBookedLocationsViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/22/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol ChoosePreviousBookedLocationDelegate: class {
    @objc optional func selectedObject(obj: PreviousBookedLocationBO)
}

class PreviousBookedLocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var previousBookedLocationsTableView: UITableView!
    @IBOutlet var previousBookedLocationsTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet var noRecordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noRecordTopConstraint: NSLayoutConstraint!
    
    var arrPreviousBookedLocation = [PreviousBookedLocationBO]()
    var filteredArrPreviousBookedLocation = [PreviousBookedLocationBO]()
    var isKeyboardShowing : Bool = false
    var keyboardHeight : CGFloat = 0
    weak var delegate: ChoosePreviousBookedLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesigns()
    }
    
    func initDesigns() {
        
        lblNoRecord.isHidden = true
        noRecordHeightConstraint.constant = 0
        noRecordTopConstraint.constant = 0
        
        filteredArrPreviousBookedLocation = arrPreviousBookedLocation
        
        mySearchBar.sizeToFit()
        mySearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        mySearchBar.delegate = self
        mySearchBar.placeholder = "Search"
        //mySearchBar.becomeFirstResponder()
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.serviceCallToGetPrevBookedTrips()
    }
    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArrPreviousBookedLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousBookedLocationTableViewCell", for: indexPath as IndexPath) as! PreviousBookedLocationTableViewCell
        
        cell.selectionStyle = .none
        
        let previousBookedLocationBO = filteredArrPreviousBookedLocation[indexPath.row]
        cell.lblAddressName?.text = previousBookedLocationBO.addressName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.selectedObject!(obj: filteredArrPreviousBookedLocation[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            filteredArrPreviousBookedLocation = arrPreviousBookedLocation
        }
        else {
            filteredArrPreviousBookedLocation = arrPreviousBookedLocation.filter {
                //                ($0.name?.range(of: searchText, options: .caseInsensitive) != nil)
                $0.addressName.lowercased().hasPrefix(searchText.lowercased())
                
            }
        }
        
        //Show No records found label
        if (filteredArrPreviousBookedLocation.count == 0) {
            lblNoRecord.isHidden = false
            noRecordHeightConstraint.constant = 40
            noRecordTopConstraint.constant = 100
        }else {
            lblNoRecord.isHidden = true
            noRecordHeightConstraint.constant = 0
            noRecordTopConstraint.constant = 0
        }
        
        previousBookedLocationsTableView.reloadData()
    }
    
    //MARK: Keyboard Delegates
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("Keyboard is showing")
            isKeyboardShowing = true
            previousBookedLocationsTableViewBottomConstraint.constant = keyboardSize.height
            keyboardHeight = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("Keyboard is not showing")
        isKeyboardShowing = false
        previousBookedLocationsTableViewBottomConstraint.constant = 0
    }
    
    //Service call Methods
    func serviceCallToGetPrevBookedTrips() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                //"user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "user_id" : "28"
            ]
            
            print("url===\(AppConstant.getPrevBookedDestinationListUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getPrevBookedDestinationListUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint("prev Destination Data : \(response)")
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        self.arrPreviousBookedLocation.removeAll()
                        self.filteredArrPreviousBookedLocation.removeAll()
                        
                        if let status = dict!["status"] as? String {
                            if(status == "0"){
                                let msg = dict!["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == "1"){
                                if let arrData = dict!["dest_data"] as? [[String: Any]]{
                                    for dictLoc in arrData{
                                        let prevLocBo = PreviousBookedLocationBO()
                                        if let loc = dictLoc["des_loc"] as? String{
                                            prevLocBo.addressName = loc
                                        }
                                        if let des_lat = dictLoc["des_lat"] as? String{
                                            if des_lat != ""{
                                                prevLocBo.latitude = Double(des_lat)!
                                            }
                                        }
                                        if let des_lon = dictLoc["des_lon"] as? String{
                                            if des_lon != ""{
                                                prevLocBo.longitude = Double(des_lon)!
                                            }
                                        }
                                        self.arrPreviousBookedLocation.append(prevLocBo)
                                }
                                        
                            }
                                
                                self.filteredArrPreviousBookedLocation = self.arrPreviousBookedLocation
                                if (self.filteredArrPreviousBookedLocation.count == 0) {
                                    self.lblNoRecord.isHidden = false
                                    self.noRecordHeightConstraint.constant = 40
                                    self.noRecordTopConstraint.constant = 100
                                }else {
                                    self.lblNoRecord.isHidden = true
                                    self.noRecordHeightConstraint.constant = 0
                                    self.noRecordTopConstraint.constant = 0
                                }
                                
                                self.previousBookedLocationsTableView.reloadData()
                            }else  if(status == "3"){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
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
