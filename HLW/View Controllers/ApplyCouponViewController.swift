//
//  ApplyCouponViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/5/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

protocol ApplyCouponDelegate: class {
    func appliedCoupon(couponBo: CouponBO)
}

class ApplyCouponViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    weak var delegate: ApplyCouponDelegate?
    @IBOutlet weak var txtFldCoupon: UITextField!
    @IBOutlet weak var tblViewCoupon: UITableView!
    
    var selectedCouponBo = CouponBO()
    
    var arrCouponList = [CouponBO]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        tblViewCoupon.tableFooterView = nil
        self.serviceCallToGetCouponLists(coupon: "")
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnApplyCouponAction(_ sender: Any) {
        if txtFldCoupon.text?.trim() == ""{
            AppConstant.showAlert(strTitle: StringConstant.coupon_validation_msg, strDescription: "", delegate: nil)
        }else{
            serviceCallToGetCouponLists(coupon: (txtFldCoupon.text?.trim())!)
        }
        
        
    }
    
    @objc func applyCouponFromListing(_ sender: UIButton){
        let couponBo = self.arrCouponList[sender.tag]
        txtFldCoupon.text = couponBo.title
        selectedCouponBo = couponBo
    }
    
    //MARK: Tableview Degates & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCouponList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath as IndexPath) as! CouponTableViewCell
        cell.selectionStyle = .none
        
        let couponBo = arrCouponList[indexPath.row]
        cell.lblTitle.text = couponBo.title
        cell.lblDesc.text = couponBo.desc
        cell.btnApplyCoupon.tag = indexPath.row
        cell.btnApplyCoupon.addTarget(self, action: #selector(self.applyCouponFromListing(_:)), for: .touchUpInside)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Service Call
    func serviceCallToGetCouponLists(coupon : String) {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "city" : AppConstant.cityName,
                "coupon_code" : coupon
            ]
            
            print("url===\(AppConstant.promoCodeUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.promoCodeUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint("Promo Code : \(response)")
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//Success
                                if coupon == ""{
                                    self.arrCouponList.removeAll()
                                    if let arrPromo = dict?["promo_data"] as? [[String: Any]] {
                                        for dict in arrPromo{
                                            let promoBo = CouponBO()
                                            if let promo_code = dict["promo_code"] as? String {
                                                promoBo.title = promo_code
                                            }
                                            if let promo_msg = dict["promo_msg"] as? String {
                                                promoBo.desc = promo_msg
                                            }
                                            if let promo_id = dict["promo_id"] as? String {
                                                promoBo.id = promo_id
                                            }
                                            
                                            self.arrCouponList.append(promoBo)
                                        }
                                    }
                                    self.tblViewCoupon.reloadData()
                                }else{
                                    self.delegate?.appliedCoupon(couponBo: self.selectedCouponBo)
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                            else if (status == 3){//Logout from the app
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

}
