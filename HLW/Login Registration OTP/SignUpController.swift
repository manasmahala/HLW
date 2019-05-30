//
//  SignUpController.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 02/02/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import GoogleSignIn

class SignUpController: UIViewController , UITextFieldDelegate,  GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordBtn: UIButton!
    @IBOutlet weak var confirmPasswordBtn: UIButton!
    @IBOutlet var btnSignUpBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomHeightConstraint: NSLayoutConstraint!
    
    
    var userid : String!
    var countryCode : String!
    var mobile : String!
    var otpToken : String!
    var limitLength = 10
    var isMaleSelected = false
    var isFemaleSelected = false
    var isOthersSelected = false
    var dictUserData : [String : AnyObject]!
    var fname : String = ""
    var lname : String = ""
    var email : String = ""
    var socialAuthId : String = ""
    var provider : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        //Manage for iPhone X
        if (AppConstant.screenSize.height >= 812) {
            navBarHeightConstraint.constant = 92
        }
        
        mobileNoTf.delegate = self
        passwordTf.delegate = self
        confirmPasswordTf.delegate = self
        
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
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        mobileNoTf.text = countryCode + mobile
        mobileNoTf.isUserInteractionEnabled = false
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
        else{//passwordTf & confirmPasswordTf
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 100
        }
    }
    
    func updateUserData(){
        nameTf.text = fname + " " + lname
        emailTf.text = email
        
        btnSignUpBottomSpaceConstraint.constant = 20
        viewBottomHeightConstraint.constant = 85
    }
    
    //MARK: Button ACtion
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

    @IBAction func toggleConfirmPasswordBtnAction(_ sender: Any) {
        if (self.confirmPasswordTf.isSecureTextEntry == true) {
            self.confirmPasswordBtn.setImage( UIImage.init(named: "showpass"), for: .normal)
            self.confirmPasswordTf.isSecureTextEntry =  false
        }else{
            self.confirmPasswordBtn.setImage( UIImage.init(named: "hidepass"), for: .normal)
            self.confirmPasswordTf.isSecureTextEntry =  true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpBtnAction(_ sender: Any) {
        
        var errMessage : String?
        var name = self.nameTf?.text
        var email = self.emailTf?.text
        var mobile = self.mobileNoTf?.text
        var password = self.passwordTf?.text
        let confirmPassword = self.confirmPasswordTf?.text

        name = name?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        email = email?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        mobile = mobile?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        password = password?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if(name == ""){
            errMessage = StringConstant.name_blank_validation_msg
        }else if(email == ""){
            errMessage = StringConstant.email_blank_validation_msg
        }else if(!AppConstant.isValidEmail(emailId: email!)){
            errMessage = StringConstant.email_validation_msg
        }else if(mobile == ""){
            errMessage = StringConstant.mobile_blank_validation_msg
        }else if((mobile?.count)! < 10){
            errMessage = StringConstant.validate_mobile_msg
        }else if(password == ""){
            errMessage = StringConstant.password_blank_validation_msg
        }else if((password?.count)! < 8){
            errMessage = StringConstant.password_validation_msg
        }else if(!AppConstant.validatePassword(phrase: password!)){
            errMessage = StringConstant.password_validation_msg
        }else if(confirmPassword == ""){
            errMessage = StringConstant.cnf_password_blank_validation_msg
        }else if(password != confirmPassword){
            errMessage = StringConstant.password_mismatch_validation_msg
        }

        if(errMessage != nil){
            AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)

        }else {
            serviceCallToSignUp(name: name!, email: email!, mobile: mobile!, password: password!)
        }
        
    }
    
    @IBAction func FBsignUpBtnAction(_ sender: Any) {
        loginWithFacebook()
    }
    @IBAction func GooglesignUpBtnAction(_ sender: Any) {        
        loginWithGoogle()
    }
    
    // MARK: - Api Service Call Method
    func serviceCallToSignUp(name: String, email: String, mobile: String, password: String) {
        if AppConstant.hasConnectivity() {
            
            AppConstant.showHUD()
            var params: Parameters!
            
            params = [
                "name": name,
                "email": email,
                "password": password,
                "mobile": mobile,
                "con_code": countryCode!,
                "social_type": "",
                "oauth_provider": "",
                "oauth_uid": ""
                
            ]
            
            print("url===\(AppConstant.signUpUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.signUpUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        debugPrint(response.result.value!)
                        
                        if let status = dict?["status"] as? Int{
                            if(status == 0){
                                if let msg = dict?["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
                            }
                            else  if(status == 1){//Success
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
    
    
    //MARK:Facebook Login
    func loginWithFacebook() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                print("permissions: \(fbloginresult.grantedPermissions)")
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            //AppConstant.showHUD()
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dictUserData = result as! [String : AnyObject]
                    print(result!)
                    print(self.dictUserData)
                    self.fname = self.dictUserData["first_name"] as! String
                    self.lname = self.dictUserData["last_name"] as! String
                    self.email = self.dictUserData["email"] as! String
                    self.socialAuthId = self.dictUserData["id"] as! String
                    self.provider = StringConstant.facebook
                    
                    self.updateUserData()
                }else{
                    AppConstant.hideHUD()
                }
            })
        }else{
            print("FBSDKAccessToken is nil")
        }
    }
    
    //MARK: Google Login
    
    func loginWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            /*NotificationCenter.default.post(
             name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)*/
            // [END_EXCLUDE]
        } else {
            print("google")
            // Perform any operations on signed in user here.
            
            self.fname = user.profile.givenName
            self.lname = user.profile.familyName
            self.email = user.profile.email
            self.socialAuthId = user.userID
            self.provider = StringConstant.google
            
            self.updateUserData()
            
            /* NotificationCenter.default.post(
             name: Notification.Name(rawValue: "ToggleAuthUINotification"),
             object: nil,
             userInfo: ["statusText": "Signed in user:\n\(fullName)"])*/
            // [END_EXCLUDE]
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        /* NotificationCenter.default.post(
         name: Notification.Name(rawValue: "ToggleAuthUINotification"),
         object: nil,
         userInfo: ["statusText": "User has disconnected."])*/
        // [END_EXCLUDE]
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "otp"){
            let vc = segue.destination as! OTPController
            vc.controllerName = "SignUp"
            vc.mobile = self.mobileNoTf.text
            vc.countryCode = countryCode
        }
    }

    

}
