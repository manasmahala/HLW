//
//  SignInWithPaaswordViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/24/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

class SignInWithPaaswordViewController: UIViewController {
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var btnLoginWithOtp: UIButton!
    
    var mobileNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesigns()
    }
    
    func initDesigns() {
        
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
        
        let attrStrPassword1 : NSMutableAttributedString = NSMutableAttributedString(string: "Enter your password for ", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 16.0)!])
        attrStrPassword1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0), range: NSRange(location: 0,length: attrStrPassword1.length))
        let attrStrPassword2 : NSMutableAttributedString = NSMutableAttributedString(string: mobileNumber, attributes: [NSAttributedStringKey.font: UIFont(name: "Poppins-Bold", size: 17.0)!])
        attrStrPassword1.append(attrStrPassword2)
        // set label Attribute
        lblInfo.attributedText = attrStrPassword1
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func togglePasswordBtnAction(_ sender: Any) {
        if (self.passwordTf.isSecureTextEntry == true) {
            self.passwordBtn.setImage( UIImage.init(named: "showpass"), for: .normal)
            self.passwordTf.isSecureTextEntry =  false
        }else{
            self.passwordBtn.setImage( UIImage.init(named: "hidepass"), for: .normal)
            self.passwordTf.isSecureTextEntry =  true
        }
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.dismissKeyboard()
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "forgot_password", sender: self)
    }
    
    @IBAction func LoginWithOtpBtnAction(_ sender: Any) {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logInBtnAction(_ sender: Any) {
        if (passwordTf.text!.trim() == "") {
            AppConstant.showAlert(strTitle: StringConstant.password_blank_validation_msg, strDescription: "", delegate: nil)
        }else{
            serviceCallToLogin()
        }
    }
    
    //MARK: Api Service call Method
    func serviceCallToLogin(){
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            var params: Parameters!
            params = [
                "mobile": mobileNumber,
                "password": passwordTf.text!.trim()
            ]
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.loginWithPasswordUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
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
                            }else  if(status == 1){ //Success
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
        }else{
            AppConstant.showSnackbarMessage(msg: StringConstant.noInternetConnectionMsg)
        }
    }

}
