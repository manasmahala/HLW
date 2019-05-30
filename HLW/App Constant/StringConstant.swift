//
//  StringConstant.swift
//  HLW
//
//  Created by OdiTek Solutions on 22/12/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import Foundation

class StringConstant: NSObject {
    
    //User Default
    static var isLoggedIn: String = "isLoggedIn"
    static var isIntroduceScreenShown: String = "isIntroduceScreenShown"
    static var name: String = "name"
    static var user_id: String = "user_id"
    static var accessToken: String = "access_token"
    static var current_address: String = "current_address"
    static var deviceToken: String = "APNID"
    static var mobile: String = "mobile"
    static var email: String = "email"
    static var profile_image: String = "profile_image"
    static var book_id: String = "book_id"
    
    //Messages
    static var logout_msg: String = "Are you sure you want to log out?"
    static var remove_contact_from_emergency_msg: String = "Are you sure you want to remove this from your emergency contact list?"
    static var contact_already_exist_emergency_list_msg: String = "Contact already exist in your Emergency contact list"
    static var empty_emergency_contact_msg: String = "Alert your family and friends \n in  case of an emergency. \nAdd them to your emergency contacts."
    static var internetToAddPhotoMsg : String = "Internet connectivity is required to add photo"
    static var noInternetConnectionMsg : String = "Please check your internet connection."
    static var changeMobileMsg : String = "Do you want to change your mobile number?"
    
    //DateFormatter
    static var dateFormatter1 : String = "yyyy-MM-dd HH:mm:ss ZZZ"
    static var dateFormatter2 : String = "dd-MM-yyyy"
    static var dateFormatter3 : String = "dd MMM yyyy, h:mm a"
    
    //Social Login Type
    static var facebook : String = "facebook"
    static var google : String = "google"
    
    //Validation Msg
    static var mobile_blank_validation_msg : String = "Please enter your mobile number"
    static var register_now_msg : String = "Mobile number doesn't exist in our record. Do you want to Register Now?"
    static var validate_mobile_msg : String = "The mobile number is not correct."
    static var otp_blank_validation_msg : String = "Please enter OTP sent to your mobile number."
    static var password_blank_validation_msg : String = "Please enter your password"
    static var old_password_blank_validation_msg : String = "Please enter your old password"
    static var name_blank_validation_msg : String = "Please enter your name."
    static var email_blank_validation_msg : String = "Please enter your email."
    static var email_validation_msg : String = "The email ID is not correct."
    static var password_validation_msg : String = "Password should contain at least one alphabet,one number and 8 characters."
    static var cnf_password_blank_validation_msg : String = "Please enter your confirm password."
    static var password_mismatch_validation_msg : String = "Password & confirm password doesn't match."
    static var coupon_validation_msg : String = "Please enter Coupon code"
    
    //Others
    static var iOS : String = "iOS"
    static var poppinsRegular : String = "Poppins-Regular"
    static var poppinsMedium : String = "Poppins-Medium"
    static var poppinsSemibold : String = "Poppins-Semibold"
    static var poppinsBold : String = "Poppins-Bold"
    static var fareDesc : String = "When booking this ride in the city, you ‘ll see a total fare before confirming you booking. This is what you ‘ll repaying at the end of your trip. Just enter your drop location to know the total fare.\n\nTotal fare includes applicable taxes, Tool/Parkinh/Hub fee and any fare increases due to demand wherever applicable"
}

