//
//  AppConstant.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 02/02/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire

class AppConstant: NSObject , UIAlertViewDelegate {

//    static var baseUrl : String = "http://oditek.in/cab/service/api/v1/"
//    static var baseUrl : String = "http://10.25.25.100/cab/service/api/v1/"
//    static var baseUrl1 : String = "http://10.25.25.100/cab/service/api/test1/v1/"
    static var baseUrl : String = "http://172.104.60.124/cab/service/api/v1/"
    
    
    static var verifyMobileUrl : String = baseUrl + "user/user_mobileverification.php?action=mobileverify"
    static var signInUrl : String = baseUrl + "usersignin.php?action=signin"
    static var signUpUrl : String = baseUrl + "user/user_signup.php?action=signup"
    static var otpVerifyUrl : String = baseUrl + "user/user_verifyOtp.php?action=verifyOtp"
    static var loginWithPasswordUrl : String = baseUrl + "user/user_loginWithPassword.php?action=loginwithpass"
    static var resendOtpUrl : String = baseUrl + "/user/user_sendOTP.php?action=sendOTP"
    static var registerDeviceInfoUrl : String = baseUrl + "user/user_register_deviceinfo.php?action=deviceinfo"
    static var cabLocationInfoUrl : String = baseUrl + "user/user_getCabLocation.php?action=cablocation"
    static var getVehicleCategoryUrl : String = baseUrl + "user/user_getVehicleCategory.php?action=vehiclecategory"
    static var uploadProfilePicUrl : String = baseUrl + "user/user_updateProfileImage.php?action=userimage"
    static var getUserProfileUrl : String = baseUrl + "user/user_getProfileData.php?action=getProfile"
    static var updateuserProfileUrl : String = baseUrl + "user/user_updateProfileDetails.php?action=updateProfile"
    static var changeMobileNoUrl : String = baseUrl + "user/user_mobileChangeVerification.php?action=mobileChange"
    static var otpVerifyChangeMobileNoUrl : String = baseUrl + "user/user_changeMobileOtpVerify.php?action=mobileChangeOTP"
    static var updateMobileNoUrl : String = baseUrl + "user/user_updateMobileno.php?action=updateMobile"
    static var changePasswordUrl : String = baseUrl + "user/user_passwordChange.php?action=chnagePassword"
    static var forgotPasswordWithMobileUrl : String = baseUrl + "user/user_sendOTPForgetPassword.php?action=sendotpforgetpass"
    static var otpVerifyChangePasswordUrl : String = baseUrl + "user/user_otpVerifyForForgetPassword.php?action=forgetpassOTP"
    static var updatePasswordUrl : String = baseUrl + "user/user_updatePassword.php?action=updatePassword"
    static var getFareDetailsUrl : String = baseUrl + "user/user_estimated_cost.php?action=estimatecost"
    static var confirmBookingUrl : String = baseUrl + "user/user_booking_v1.php?action=custbooking"
    static var getPrevBookedDestinationListUrl : String = baseUrl + "user/user_destination_list.php?action=destinationlist"
    
    
    static var tokenVarificationUrl : String = baseUrl + "tokenverification.php?action=tokenverify"
    static var cancelBookingUrl : String = baseUrl + "usercancelbooking.php?action=usercancelbooking"
    static var getBookingDetails : String = baseUrl + "user/user_booking_status.php?action=custbookingstatus"
    static var bookingVarificationUrl : String = baseUrl + "userBookingverification.php?action=userBookingverification"
    static var driverLocationTrackingUrl : String = baseUrl + "driverLocationTracking.php?action=driverLocationTracking"
    static var getRateCardUrl : String = baseUrl + "user/user_ratecard.php?action=ratecard"
    static var getRentalTarifUrl : String = baseUrl + "user/user_getRentalTariff.php?action=rentaltariff"
    static var promoCodeUrl : String = baseUrl + "user/user_get_promocode.php?action=promocode"
    static var tripHistoryUrl : String = baseUrl + "user/user_getmyride.php?action=myridelist"
    static var tripDetailsUrl : String = baseUrl + "user/user_getmyridedetails.php?action=myridedetail"

    
    
    //Keys
//    static var GoogleMapApiKey: String = "AIzaSyAW7R2k-PTE_iyUR_UoiIxgeohaF1RJZ50"
    static var GoogleMapApiKey: String = "AIzaSyBYm_JbaHbjE7DAj9aAMC23MMvj5oF1pOI" // Chinmay Sir
//    static var GoogleMapApiKey: String = "AIzaSyD-OnWu5FUavXVh19wGJDJTWCzpG1SnxWk"  // Komal
//    static var GoogleMapApiKey: String = "AIzaSyAbl4N-6kxi3YhCwK8w5G0DFtZIaSV0vbg"
//    static var GoogleMapApiKey: String = "AIzaSyA-3TM8CpTR7SqC2FbXhRBXeqDPn5Dv404" // Manas
    //static var GoogleMapApiKey: String = "AIzaSyBW-XuHvnx-h_PMST5kTunifqfF5WIcbh0"  // added bundle key
//    static var GoogleMapApiKey: String = "AIzaSyDIqKyViDTwa9GISngfxvyZsUU-rZfQqqo"//Easytrip

    //    static var GoogleMapApiKey: String = "AIzaSyAfUH5VcCcpe4RZJIBbTeZGYMeD_QMxXJk"
    static var GIDSignInClientKey: String = "330388056582-5u3a2p01oqgskslj1tg1c9fm2cjchpas.apps.googleusercontent.com"
    
    //Color
    static var colorThemeGreen : UIColor = UIColor.init(red: 158.0/255.0, green: 178.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    static var colorThemeRed : UIColor = UIColor.init(red: 231.0/255.0, green: 56.0/255.0, blue: 71.0/255.0, alpha: 1.0)
    static var colorThemeGray : UIColor = UIColor.init(red: 198.0/255.0, green: 202.0/255.0, blue: 213.0/255.0, alpha: 1)
    static var colorThemeLightGray : UIColor = UIColor.init(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1)
    static var colorThemeBlue : UIColor = UIColor.init(hexString: "1565C0")
    static var colorThemeYellow : UIColor = UIColor.init(hexString: "FFC107")
    static var colorThemeBlack : UIColor = UIColor.init(hexString: "0D0D0D")
    static var colorThemeSeparatorGray : UIColor = UIColor.init(hexString: "AAAAAA")
    static var screenSize: CGRect = UIScreen.main.bounds
    static var count: Int = 0
    
    static var timerValue : String = ""
    static var isSlideMenu : Bool = false
    static var isBookingConfirm : Bool = false
    static var selectedVehicleImgName : String = ""
    static var booking_id : Int  = 0
    static var bookRideForContactName : String = ""
    static var bookRideForContactNumber : String = ""
    static var bookRideForContactSelectedStatus : String = "1"
    static var currentBookRideForSelectedType : String = ""
    static var selectedPaymentMode : String = "Cash"
    static var selectedPaymentModeStatus : String = "1"
    static var arrVehicleType = [VehicleTypeBO]()
    static var slideMenuSelectedIndex = 0
    static var cityName = ""
    static var arrSelection = [CustomObject]()
    
    
    class func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    class func showAlert(strTitle: String,strDescription: String,delegate: AnyObject?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: strTitle, message: strDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.view.tintColor = colorThemeBlue
            
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    class func showAlertForCancelBooking() {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert = UIAlertController(title: "Booking Cancelled", message: "Your booking has been calcelled successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "confirm"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            // continue your work
            // important to hide the window after work completed.
            // this also keeps a reference to the window until the action is invoked.
            topWindow.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.goToMainScreen()
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
    class func isValidEmail(emailId:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailId)
    }
    class func validatePassword(phrase:String) -> Bool{
        let letters = NSCharacterSet.letters
        let range = phrase.rangeOfCharacter(from: letters, options: String.CompareOptions.caseInsensitive)
        if(range == nil){
            return false
        }
        /* if let test = range {
         print("letters found")
         }*/
        let digits = NSCharacterSet.decimalDigits
        let range1 = phrase.rangeOfCharacter(from: digits, options: String.CompareOptions.caseInsensitive)
        if(range1 == nil){
            return false
        }
        
        if((phrase.count) < 8){
            return false
        }
        return true
        
    }
    class func showHUD() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.window != nil){
            let loadingView: UIView? = Bundle.main.loadNibNamed("loadingView",
                                                                owner: nil,
                                                                options: nil)?.first as? UIView
            loadingView?.frame = CGRect(x: 0 , y: 0, width: 100, height: 100)
            loadingView?.layer.cornerRadius = 10.0
            loadingView?.layer.masksToBounds = true
            let hud = MBProgressHUD.showAdded(to: appDelegate.window, animated: true)
            hud?.mode = MBProgressHUDMode.customView
            hud?.customView = loadingView
            hud?.backgroundColor = UIColor.clear
            hud?.color = UIColor.clear
            hud?.dimBackground = true
        }
        
    }
    class func hideHUD() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //let window :UIWindow = UIApplication.shared.keyWindow!
        
        //MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        MBProgressHUD.hide(for: appDelegate.window, animated:true)
    }
    class func showSnackbarMessage(msg : String) {
//        let snackbar = TTGSnackbar(message: msg, duration: .short)
//        snackbar.show()
    }
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
                return ["parseError":error.localizedDescription]
            }
        }
        return nil
    }
    class func convertToArray(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    class func saveBoolInDefaults(key: String,value: Bool){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func retrieveBoolFromDefaults(key: String) -> Bool {
        if let returnValue = UserDefaults.standard.object(forKey: key) as? Bool{
            return returnValue
        }
        return false
        
    }
    class func saveInDefaults(key: String,value: String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func retrievFromDefaults(key: String) -> String {
        if let returnValue = UserDefaults.standard.object(forKey: key) as? String{
            return returnValue
        }
        return ""
        
    }
    class func removeFromDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func formattedDateFromString(dateString: String, withFormat format: String, ToFormat newFormat: String) -> String? {
        //yyyy-MM-dd'T'HH:mm:ss
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = newFormat
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    class func formattedDate(date: Date, withFormat format: String, ToFormat newFormat: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = inputFormatter.string(from: date)
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.dateFormat = newFormat
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    class func convertStringToDate(dateString: String, withFormat format: String) -> Date? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        
        if let date = inputFormatter.date(from: dateString) {
            
            return date
        }
        
        return nil
    }
    
    class func getAppVersion() -> String{
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Version - \(version).\(build)"
    }
    
    class func showAlertToEnableLocation() {
        let topWindow = UIWindow(frame: UIScreen.main.bounds)
        topWindow.rootViewController = UIViewController()
        topWindow.windowLevel = UIWindowLevelAlert + 1
        let alert = UIAlertController(title: "Your Location services are Disabled", message: "Turn on your location from the Settings to help us locate you.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            // Move to Settings page
            
            topWindow.isHidden = true
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        }))
        topWindow.makeKeyAndVisible()
        topWindow.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
    
    class func logout(){
        AppConstant.removeFromDefaults(key: StringConstant.isLoggedIn)
        AppConstant.removeFromDefaults(key: StringConstant.name)
        AppConstant.removeFromDefaults(key: StringConstant.user_id)
        AppConstant.removeFromDefaults(key: StringConstant.accessToken)
        AppConstant.removeFromDefaults(key: StringConstant.mobile)
        AppConstant.removeFromDefaults(key: StringConstant.email)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.goToLandingScreen()
    }
    
    class func fileName()  -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        // print("hours = \(hour):\(minutes):\(seconds)")
        let timeNowStr = "\(hour)\(minutes)\(seconds).png"
        return timeNowStr
    }
    
    
}

