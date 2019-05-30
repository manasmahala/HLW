//
//  ChangePasswordViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/18/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTf: UITextField!
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdatePasswordAction(_ sender: Any) {
        var errMessage : String?
        let oldPassword = self.oldPasswordTf?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let newPassword = self.newPasswordTf?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = self.confirmPasswordTf?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(oldPassword == ""){
            errMessage = StringConstant.old_password_blank_validation_msg
        }else if(newPassword == ""){
            errMessage = StringConstant.password_blank_validation_msg
        }else if((newPassword?.count)! < 8){
            errMessage = StringConstant.password_validation_msg
        }else if(!AppConstant.validatePassword(phrase: newPassword!)){
            errMessage = StringConstant.password_validation_msg
        }else if(confirmPassword == ""){
            errMessage = StringConstant.cnf_password_blank_validation_msg
        }else if(newPassword != confirmPassword){
            errMessage = StringConstant.password_mismatch_validation_msg
        }
        
        if(errMessage != nil){
            AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)
        }else {
            serviceCallToUpdatePassword(oldPassword: oldPassword!, newPassword: newPassword!)
        }
    }
    
    // MARK: - Api Service Call Method
    func serviceCallToUpdatePassword(oldPassword: String, newPassword: String){
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let params: Parameters = [
                "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "old_password": oldPassword,
                "new_password": newPassword
            ]
            
            print("url===\(AppConstant.changePasswordUrl)")
            print("params===\(params)")
            
            Alamofire.request(AppConstant.changePasswordUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
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

}
