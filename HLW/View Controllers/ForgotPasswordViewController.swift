//
//  ForgotPasswordViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/21/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import BetterSegmentedControl
import ADCountryPicker

class ForgotPasswordViewController: UIViewController, ADCountryPickerDelegate {
    
    @IBOutlet weak var viewSegment: BetterSegmentedControl!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textTf: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgViewCountryFlag: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var viewCountryCode: UIView!
    @IBOutlet var lblSeparator: UILabel!
    @IBOutlet var viewCountryCodeWidthConstraint: NSLayoutConstraint!
    @IBOutlet var lblSeparatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet var textTfLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var lblSeparatorLeadingConstraint: NSLayoutConstraint!
    
    let countryCodePicker = ADCountryPicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesigns()
    }
    
    func initDesigns() {
        viewSegment.segments = LabelSegment.segments(withTitles: ["Mobile No","Email Id"], normalFont: UIFont(name: "Poppins-Medium", size: 16.0)!, normalTextColor: UIColor.white, selectedFont: UIFont(name: "Poppins-Semibold", size: 16.0)!, selectedTextColor: AppConstant.colorThemeBlue)
        
        
        //Get Country code from locale
        let bundle = "country_assets.bundle/"
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if let image = UIImage(named: bundle + countryCode.uppercased(), in: Bundle(for:SignInController.self), compatibleWith: nil){
                imgViewCountryFlag.image = image
            }
        }
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewSegmentValueChanged(_ sender: BetterSegmentedControl) {
        btnSubmit.tag = Int(sender.index)
        self.view.endEditing(true)
        
        if (sender.index == 0) {
            viewCountryCode.isHidden = false
            viewCountryCodeWidthConstraint.constant = 86
            lblSeparator.isHidden = false
            lblSeparatorWidthConstraint.constant = 2
            textTfLeadingConstraint.constant = 8
            lblSeparatorLeadingConstraint.constant = 8
            lblInfo?.text = "An OTP will be sent to your mobile number to reset your password."
            lblTitle?.text = "Mobile Number"
            textTf?.placeholder = "Enter Your Mobile No"
            textTf?.keyboardType = .phonePad
        }
        else if (sender.index == 1) {
            viewCountryCode.isHidden = true
            viewCountryCodeWidthConstraint.constant = 0
            lblSeparator.isHidden = true
            lblSeparatorWidthConstraint.constant = 0
            textTfLeadingConstraint.constant = 0
            lblSeparatorLeadingConstraint.constant = 0
            lblInfo?.text = "A link will auto sent to the email id from server to reset the password."
            lblTitle?.text = "Email Id"
            textTf?.placeholder = "Enter Your Email Id"
            textTf?.keyboardType = .emailAddress
        }
    }
    
    @IBAction func btnCountryCodeAction(_ sender: Any) {
//        countryCodePicker.delegate = self
//        countryCodePicker.showCallingCodes = true
//        let pickerNavigationController = UINavigationController(rootViewController: countryCodePicker)
//        pickerNavigationController.navigationBar.barTintColor = AppConstant.colorThemeBlue
//        pickerNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        pickerNavigationController.navigationBar.isTranslucent = false
//        countryCodePicker.closeButtonTintColor = UIColor.white
//        countryCodePicker.font = UIFont(name: "Poppins-Regular", size: 15)
//        self.present(pickerNavigationController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        if (btnSubmit.tag == 0) {
            var errMessage : String?
            let mobile = self.textTf?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let countryCode = self.lblCountryCode?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if(mobile == ""){
                errMessage = StringConstant.mobile_blank_validation_msg
            }else if((mobile?.count)! < 10){
                errMessage = StringConstant.validate_mobile_msg
            }
            
            if(errMessage != nil){
                AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)
            }else {
                serviceCallToForgotPasswordWithMobile(mobile: mobile!, countryCode: countryCode!)
            }
        }
        else if (btnSubmit.tag == 1) {
            print("A link is auto sent to the email id from server to reset the password.")
        }
    }
    
    // MARK: - Api Service Call Method
    func serviceCallToForgotPasswordWithMobile(mobile: String, countryCode: String){
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let params: Parameters = [
                "mobile": mobile,
                "con_code": countryCode
            ]
            
            print("url===\(AppConstant.forgotPasswordWithMobileUrl)")
            print("params===\(params)")
            
            Alamofire.request(AppConstant.forgotPasswordWithMobileUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    
                    switch(response.result) {
                    case .success(_):
                        
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//success
                                self.performSegue(withIdentifier: "otp", sender: self)
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
            AppConstant.showSnackbarMessage(msg: StringConstant.noInternetConnectionMsg)
        }
    }
    
    //MARK:Country Picker Delegate
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        self.lblCountryCode.text = dialCode
        let bundle = "country_assets.bundle/"
        if let image = UIImage(named: bundle + code.uppercased(), in: Bundle(for:SignInController.self), compatibleWith: nil){
            self.imgViewCountryFlag.image = image
        }
        countryCodePicker.dismiss(animated: true) {
            
        }
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "otp"){
            let vc = segue.destination as! OTPController
            vc.controllerName = "ForgotPassword"
            vc.mobile = self.textTf?.text
            vc.countryCode = self.lblCountryCode?.text
        }
    }

}
