//
//  LoginWithOTPViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 25/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

class LoginWithOTPViewController: UIViewController {

    @IBOutlet weak var otpTf1: UITextField!
    @IBOutlet weak var otpTf2: UITextField!
    @IBOutlet weak var otpTf3: UITextField!
    @IBOutlet weak var otpTf4: UITextField!
    @IBOutlet weak var lblInfo: UILabel!
    
    var mobile: String?
    var countryCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesigns()
    }
    
    func initDesigns() {
        otpTf1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTf2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTf3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTf4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        otpTf1.layer.borderColor = UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0).cgColor
        otpTf1.layer.borderWidth = 1
        otpTf1.layer.cornerRadius = 5
        otpTf1.clipsToBounds = true
        
        otpTf2.layer.borderColor = UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0).cgColor
        otpTf2.layer.borderWidth = 1
        otpTf2.layer.cornerRadius = 5
        otpTf2.clipsToBounds = true
        
        otpTf3.layer.borderColor = UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0).cgColor
        otpTf3.layer.borderWidth = 1
        otpTf3.layer.cornerRadius = 5
        otpTf3.clipsToBounds = true
        
        otpTf4.layer.borderColor = UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0).cgColor
        otpTf4.layer.borderWidth = 1
        otpTf4.layer.cornerRadius = 5
        otpTf4.clipsToBounds = true
        
        let attrStrOtp1 : NSMutableAttributedString = NSMutableAttributedString(string: "Enter OTP sent to ", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 16.0)!])
        attrStrOtp1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0), range: NSRange(location: 0,length: attrStrOtp1.length))
        let attrStrOtp2 : NSMutableAttributedString = NSMutableAttributedString(string: mobile!, attributes: [NSAttributedStringKey.font: UIFont(name: "Poppins-Bold", size: 17.0)!])
        attrStrOtp1.append(attrStrOtp2)
        // set label Attribute
        lblInfo.attributedText = attrStrOtp1
        
    }
    
    //MARK: - OtpTextfield Action
    @objc func textFieldDidChange(textField : UITextField) {
        let text = textField.text
        if ((text?.utf16.count)! == 1) {
            switch textField {
            case otpTf1:
                otpTf1.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf1.layer.borderWidth = 3
                otpTf2.becomeFirstResponder()
            case otpTf2:
                otpTf2.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf2.layer.borderWidth = 3
                otpTf3.becomeFirstResponder()
            case otpTf3:
                otpTf3.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf3.layer.borderWidth = 3
                otpTf4.becomeFirstResponder()
            case otpTf4:
                otpTf4.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf4.layer.borderWidth = 3
                otpTf4.resignFirstResponder()
                
            default:
                break
            }
        }
        else if ((text?.utf16.count)! == 0) {
            switch textField {
            case otpTf1:
                let value = otpTf1.text
                otpTf1.text = String((value?.dropFirst())!)
                otpTf1.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf1.layer.borderWidth = 3
                otpTf1.becomeFirstResponder()
            case otpTf2:
                let value = otpTf2.text
                otpTf2.text = String((value?.dropFirst())!)
                otpTf2.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf2.layer.borderWidth = 3
                otpTf1.becomeFirstResponder()
            case otpTf3:
                let value = otpTf3.text
                otpTf3.text = String((value?.dropFirst())!)
                otpTf3.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf3.layer.borderWidth = 3
                otpTf2.becomeFirstResponder()
            case otpTf4:
                let value = otpTf4.text
                otpTf4.text = String((value?.dropFirst())!)
                otpTf4.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf4.layer.borderWidth = 3
                otpTf3.becomeFirstResponder()
                
            default:
                break
            }
        }
        else{
            switch textField {
            case otpTf1:
                let value = otpTf1.text
                otpTf1.text = String((value?.dropFirst())!)
                otpTf1.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf1.layer.borderWidth = 3
                otpTf2.becomeFirstResponder()
            case otpTf2:
                let value = otpTf2.text
                otpTf2.text = String((value?.dropFirst())!)
                otpTf2.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf2.layer.borderWidth = 3
                otpTf3.becomeFirstResponder()
            case otpTf3:
                let value = otpTf3.text
                otpTf3.text = String((value?.dropFirst())!)
                otpTf3.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf3.layer.borderWidth = 3
                otpTf4.becomeFirstResponder()
            case otpTf4:
                let value = otpTf4.text
                otpTf4.text = String((value?.dropFirst())!)
                otpTf4.layer.borderColor = AppConstant.colorThemeBlue.cgColor
                otpTf4.layer.borderWidth = 3
                otpTf4.resignFirstResponder()
                
            default:
                break
            }
            
        }
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func LoginWithPasswordBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "login_with_password", sender: self)
    }
    
    @IBAction func btnResendOTPAction(_ sender: Any) {
        serviceCallToResendOTP()
    }
    
    @IBAction func LoginBtnAction(_ sender: Any) {
        var errMessage : String?
        let otp1 = self.otpTf1?.text
        let otp2 = self.otpTf2?.text
        let otp3 = self.otpTf3?.text
        let otp4 = self.otpTf4?.text
        let userEnteredOtp = otp1! + otp2! + otp3! + otp4!
        debugPrint(userEnteredOtp)
        
        if(userEnteredOtp == ""){
            errMessage = StringConstant.otp_blank_validation_msg
        }
        if(errMessage != nil){
            AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)
        }else {
            self.serviceCallToVerifyOTP(mobile: mobile!, otp: userEnteredOtp)
        }
    }
    
    //MARK: Api Service call Method
    func serviceCallToVerifyOTP(mobile: String, otp: String){
        AppConstant.showHUD()
        var params: Parameters!
        params = [
            "mobile": mobile,
            "otp": otp
        ]
        print("params===\(params!)")
        
        Alamofire.request( AppConstant.otpVerifyUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseString { response in
                AppConstant.hideHUD()
                debugPrint(response)
                switch(response.result) {
                case .success(_):
                    let dict = AppConstant.convertToDictionary(text: response.result.value!)
                    debugPrint(dict!)
                    
                    if let status = dict?["status"] as? Int{
                        if(status == 0){
                            if let msg = dict?["msg"] as? String{
                                AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                            }
                        }else  if(status == 1){//Success
                            if let name = dict?["name"] as? String{
                                AppConstant.saveInDefaults(key: StringConstant.name, value: name)
                            }
                            if let uId = dict?["user_id"] as? String{
                                AppConstant.saveInDefaults(key: StringConstant.user_id, value: uId)
                            }
                            if let mobile = dict?["mobile"] as? String{
                                AppConstant.saveInDefaults(key: StringConstant.mobile, value: mobile)
                            }
                            if let email = dict?["email"] as? String{
                                AppConstant.saveInDefaults(key: StringConstant.email, value: email)
                            }
                            if let accessToken = dict?["access_token"] as? String{
                                AppConstant.saveInDefaults(key: StringConstant.accessToken, value: accessToken)
                            }
                            if let profileImgUrl = dict?["image"] as? String{
                                AppConstant.saveInDefaults(key: StringConstant.profile_image, value: profileImgUrl)
                            }
                            
                            AppConstant.saveInDefaults(key: StringConstant.isLoggedIn, value: "1")
                            
                            self.performSegue(withIdentifier: "home_screen", sender: self)
                        }
                    }
                    
                    break
                    
                case .failure(_):
                    let error = response.result.error!
                    AppConstant.showAlert(strTitle: error.localizedDescription, strDescription: "", delegate: self)
                    break
                    
                }
        }
    }
    
    func serviceCallToResendOTP(){
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            var params: Parameters!
            params = [
                "con_code": countryCode!,
                "mobile": mobile!
            ]
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.resendOtpUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        debugPrint(dict!)
                        
                        if let status = dict?["status"] as? Int{
                            if let msg = dict?["msg"] as? String{
                                AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
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
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login_with_password"{
            let vc = segue.destination as! SignInWithPaaswordViewController
            vc.mobileNumber = self.mobile!
        }
    }
}
