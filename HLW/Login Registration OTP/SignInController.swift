//
//  SignInController.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 02/02/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import EAIntroView
import NVActivityIndicatorView
import ADCountryPicker

class SignInController: UIViewController, UITextFieldDelegate, EAIntroDelegate, ADCountryPickerDelegate {
    
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var mobileNoView: UIView!
    @IBOutlet weak var imgViewCountryFlag: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var loginBtnBottomConstraint: NSLayoutConstraint!
    
    var userid : String!
    var mobile : String!
    var token : String!
    let limitLength = 10
    
    let countryCodePicker = ADCountryPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
    }
    
    func initDesign(){
        
        mobileNoTf.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        mobileNoView.layer.cornerRadius = 5
        mobileNoView.clipsToBounds = true
        
        //Get Country code from locale
        let bundle = "country_assets.bundle/"
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if let image = UIImage(named: bundle + countryCode.uppercased(), in: Bundle(for:SignInController.self), compatibleWith: nil){
                imgViewCountryFlag.image = image
            }
        }
        
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.dismissKeyboard()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == mobileNoTf){
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= limitLength
        }
        else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Button Action
    @IBAction func loginBtnAction(_ sender: Any) {
        var errMessage : String?
        let mobile = self.mobileNoTf?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let countryCode = self.lblCountryCode?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(mobile == ""){
            errMessage = StringConstant.mobile_blank_validation_msg
        }else if((mobile?.count)! < 10){
            errMessage = StringConstant.validate_mobile_msg
        }
        
        if(errMessage != nil){
            AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)
        }else {
            serviceCallToLogin(mobile: mobile!, countryCode: countryCode!)
        }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Api Service Call Method
    func serviceCallToLogin(mobile: String, countryCode: String){
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let params: Parameters = [
                "mobile": mobile,
                "con_code": countryCode
            ]
            print("params===\(params)")
            
            Alamofire.request( AppConstant.verifyMobileUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    
                    switch(response.result) {
                    case .success(_):
                        
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 0){
                                
                                let alert = UIAlertController(title: StringConstant.register_now_msg, message: "", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Yes", style: .cancel) { action in
                                    self.performSegue(withIdentifier: "sign_up", sender: self)
                                })
                                alert.addAction(UIAlertAction(title: "No", style: .default) { action in
                                    
                                })
                                self.present(alert, animated: true)
                                
                            }else  if(status == 1){//success
                                
                                self.performSegue(withIdentifier: "login_with_otp", sender: self)
                                
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
    
    //MARK: Keyboard Delegate
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            loginBtnBottomConstraint.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        loginBtnBottomConstraint.constant = 0
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
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mainController"){
            let vc = segue.destination as! HomeScreenController
            vc.userid = self.userid
            vc.token = self.token
        }
        else if (segue.identifier == "sign_up"){
            let vc = segue.destination as! SignUpController
            vc.mobile = mobileNoTf?.text
            vc.countryCode = lblCountryCode.text
        }else if (segue.identifier == "login_with_otp"){
            let vc = segue.destination as! LoginWithOTPViewController
            vc.mobile = mobileNoTf.text?.trim()
            vc.countryCode = lblCountryCode.text!
        }
    }
    
    
    
    
}
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
