//
//  OTPController.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 05/02/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

class OTPController: UIViewController {

    @IBOutlet weak var otpTf1: UITextField!
    @IBOutlet weak var otpTf2: UITextField!
    @IBOutlet weak var otpTf3: UITextField!
    @IBOutlet weak var otpTf4: UITextField!
    @IBOutlet weak var otpVerifyBtn: UIButton!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    
    var mobile : String?
    var countryCode : String?
    var controllerName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
    }
    
    func initDesign(){
        //Manage for iPhone X
        if (AppConstant.screenSize.height >= 812) {
            navBarHeightConstraint.constant = 92
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
     //   otpTf1.becomeFirstResponder()
    }
    
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
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.dismissKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Button Action
    @IBAction func otpSubmitBtnAction(_ sender: Any) {
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
            if (controllerName == "SignUp") {
                self.serviceCallToVerifySignUpOTP(mobile: mobile!, otp: userEnteredOtp)
            }
            else if (controllerName == "MyProfile") {
                self.serviceCallToVerifyChangeMobileNoOTP(mobile: mobile!, otp: userEnteredOtp)
            }
            else if (controllerName == "ForgotPassword") {
                self.serviceCallToVerifyChangePasswordOTP(mobile: mobile!, otp: userEnteredOtp)
            }
        }
    }
    
    @IBAction func resendOtpBtnAction(_ sender: Any) {
        serviceCallToResendOTP()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Api Service call Method
    func serviceCallToVerifySignUpOTP(mobile: String, otp: String){
        AppConstant.showHUD()
        var params: Parameters!
        params = [
            "mobile": mobile,
            "otp": otp
        ]
        
        print("url===\(AppConstant.otpVerifyUrl)")
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
                        }
                        else  if(status == 1){//Success
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
                            
                            //Show registration success msg
                            if let msg = dict?["msg"] as? String{
                                AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                            }
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
    
    func serviceCallToVerifyChangeMobileNoOTP(mobile: String, otp: String){
        AppConstant.showHUD()
        var params: Parameters!
        params = [
            "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
            "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
            "mobile": mobile,
            "otp": otp
        ]
        
        print("url===\(AppConstant.otpVerifyChangeMobileNoUrl)")
        print("params===\(params!)")
        
        Alamofire.request( AppConstant.otpVerifyChangeMobileNoUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseString { response in
                AppConstant.hideHUD()
                debugPrint(response)
                switch(response.result) {
                case .success(_):
                    let dict = AppConstant.convertToDictionary(text: response.result.value!)
                    debugPrint(dict!)
                    
                    if let status = dict?["status"] as? Int{
                        if(status == 1){//Success
                            self.performSegue(withIdentifier: "change_mobile_number", sender: self)
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
    
    func serviceCallToVerifyChangePasswordOTP(mobile: String, otp: String){
        AppConstant.showHUD()
        var params: Parameters!
        params = [
            "mobile": mobile,
            "otp": otp
        ]
        
        print("url===\(AppConstant.otpVerifyChangePasswordUrl)")
        print("params===\(params!)")
        
        Alamofire.request( AppConstant.otpVerifyChangePasswordUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseString { response in
                AppConstant.hideHUD()
                debugPrint(response)
                switch(response.result) {
                case .success(_):
                    let dict = AppConstant.convertToDictionary(text: response.result.value!)
                    debugPrint(dict!)
                    
                    if let status = dict?["status"] as? Int{
                        if(status == 1){//Success
                            self.performSegue(withIdentifier: "forget_password_change", sender: self)
                        }
                    }
                    
                    break
                    
                case .failure(_):
                    AppConstant.showAlert(strTitle: response.result.error!.localizedDescription , strDescription: "", delegate: self)
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
                            if (status == 1) {//Success
                                if let msg = dict?["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
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
        if (segue.identifier == "home_screen"){
            let vc = segue.destination as! HomeScreenController
            
        }
        else if (segue.identifier == "forget_password_change"){
            let vc = segue.destination as! SetNewPasswordViewController
            vc.mobile = mobile
            vc.countryCode = countryCode
        }
    }

}
