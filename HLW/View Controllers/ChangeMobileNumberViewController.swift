//
//  ChangeMobileNumberViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 19/02/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import ADCountryPicker

class ChangeMobileNumberViewController: UIViewController, UITextFieldDelegate, ADCountryPickerDelegate {
    
    @IBOutlet weak var txtFldMobile: UITextField!
    @IBOutlet weak var btnUpdateMobile: UIButton!
    @IBOutlet weak var imgViewCountryFlag: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var btnUpdateMobileBottomConstraint: NSLayoutConstraint!
    
    let limitLength = 10
    let countryCodePicker = ADCountryPicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //Get Country code from locale
        let bundle = "country_assets.bundle/"
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if let image = UIImage(named: bundle + countryCode.uppercased(), in: Bundle(for:ChangeMobileNumberViewController.self), compatibleWith: nil){
                imgViewCountryFlag.image = image
            }
        }
    }
    
    //MARK: Textfield Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtFldMobile){
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= limitLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Button Action
    @IBAction func updateMobileBtnAction(_ sender: Any) {
        var errMessage : String?
        let mobile = self.txtFldMobile?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(mobile == ""){
            errMessage = StringConstant.mobile_blank_validation_msg
        }else if((mobile?.count)! < 10){
            errMessage = StringConstant.validate_mobile_msg
        }
        
        if(errMessage != nil){
            AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)
        }else {
            serviceCallToUpdateMobileNo(mobile: mobile!)
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
    func serviceCallToUpdateMobileNo(mobile: String){
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let params: Parameters = [
                "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "new_mobile": mobile
            ]
            
            print("url===\(AppConstant.updateMobileNoUrl)")
            print("params===\(params)")
            
            Alamofire.request(AppConstant.updateMobileNoUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    
                    switch(response.result) {
                    case .success(_):
                        
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//success
                                if let msg = dict?["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
                                _ = self.navigationController?.popViewController(animated: true)
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
            btnUpdateMobileBottomConstraint.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        btnUpdateMobileBottomConstraint.constant = 0
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
    

}
