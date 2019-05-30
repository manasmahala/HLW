//
//  MyProfileViewController.swift
//  Taxi Booking
//
//  Created by OdiTek Solutions on 01/03/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import RSKImageCropperSwift

class MyProfileViewController: UIViewController, SlideMenuControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var lblUnderlineName: UILabel!
    @IBOutlet weak var lblUnderlineMobileNo: UILabel!
    @IBOutlet weak var lblUnderlineEmail: UILabel!
    @IBOutlet weak var lblUnderlinePassword: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnProfileDetailsEdit: UIButton!
    
    
    var userProfileBo = MyProfileBO()
    var picker:UIImagePickerController? = UIImagePickerController()
    var uploadImage : UIImage?
    var profileImageUrl: String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesigns()
    }
    
    func initDesigns() {
        
        nameTf.isUserInteractionEnabled = false
        mobileNoTf.isUserInteractionEnabled = false
        emailTf.isUserInteractionEnabled = false
        passwordTf.isUserInteractionEnabled = false
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        
        serviceCallToGetUserProfileInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Action
    @IBAction func btnMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnChangePasswordAction(_ sender: Any) {
        self.performSegue(withIdentifier: "change_password", sender: self)
    }
    
    @IBAction func btnChangeMobileAction(_ sender: Any) {
        let alert = UIAlertController(title: StringConstant.changeMobileMsg, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel) { action in
            //Service call to change Mobile
            self.serviceCallToChangeMobileNo()
        })
        alert.addAction(UIAlertAction(title: "No", style: .default) { action in
            
        })
        self.present(alert, animated: true)
    }
    
    @IBAction func btnProfileDetailsEditAction(_ sender: Any) {
        let btnTitle = btnProfileDetailsEdit?.currentTitle
        if (btnTitle == "EDIT") {
            nameTf.isUserInteractionEnabled = true
            emailTf.isUserInteractionEnabled = true
            nameTf.becomeFirstResponder()
            lblUnderlineName?.backgroundColor = AppConstant.colorThemeBlue
            lblUnderlineEmail?.backgroundColor = AppConstant.colorThemeBlue
            btnProfileDetailsEdit?.setTitle("SAVE", for: .normal)
        }
        else if (btnTitle == "SAVE") {
            nameTf.isUserInteractionEnabled = false
            emailTf.isUserInteractionEnabled = false
            lblUnderlineName?.backgroundColor = UIColor.lightGray
            lblUnderlineEmail?.backgroundColor = UIColor.lightGray
            btnProfileDetailsEdit?.setTitle("EDIT", for: .normal)
            
            //Validation
            var errMessage : String?
            
            if nameTf.text?.trim() == ""{
                errMessage = StringConstant.name_blank_validation_msg
            }else if emailTf.text?.trim() == ""{
                errMessage = StringConstant.email_blank_validation_msg
            }else if(!AppConstant.isValidEmail(emailId: (emailTf.text?.trim())!)){
                errMessage = StringConstant.email_validation_msg
            }
            
            if(errMessage != nil){
                AppConstant.showAlert(strTitle: errMessage!, strDescription: "", delegate: self)
                
            }else{
                //Api call to update profile
                self.serviceCallToUpdateUserProfileInfo()
            }
        }
    }
    
    @IBAction func changeProfilePicBtnAction(_ sender: UIButton) {
        
        if (AppConstant.hasConnectivity())  {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let deleteButton = UIAlertAction(title: "Delete Photo", style: .destructive, handler: { (action) -> Void in
                //Api call to delete photo
                //self.serviceCallToRemoveProfilePic()
            })
            
            let galleryButton = UIAlertAction(title: "Choose Photo", style: .default, handler: { (action) -> Void in
                self.picker!.allowsEditing = false
                self.picker!.delegate = self
                self.picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(self.picker!, animated: true, completion: nil)
            })
            let cameraButton = UIAlertAction(title: "Take Photo", style: .default, handler: { (action) -> Void in
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                    self.picker!.allowsEditing = false
                    self.picker!.sourceType = UIImagePickerControllerSourceType.camera
                    self.picker!.cameraCaptureMode = .photo
                    self.present(self.picker!, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                    alert.addAction(ok)
                    self.present(self.picker!, animated: true, completion: nil)
                    
                }
            })
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            if(self.profileImageUrl! != ""){
                alertController.addAction(deleteButton)
            }
            //alertController.addAction(deleteButton)
            alertController.addAction(cameraButton)
            alertController.addAction(galleryButton)
            alertController.addAction(cancelButton)
            
            //        self.navigationController!.present(alertController, animated: true, completion: nil)
            
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = sender.bounds
            }
            self.navigationController!.present(alertController, animated: true, completion: nil)
        }else{
            AppConstant.showAlert(strTitle: StringConstant.internetToAddPhotoMsg, strDescription: "", delegate: nil)
        }
        
        
    }
    
    //ImagePicker Delegate Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Continue with Image
        self.dismiss(animated: true) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                var myImage : UIImage!
                if (picker.sourceType == UIImagePickerControllerSourceType.photoLibrary) {
                    
                    if let imageData = UIImageJPEGRepresentation(image, 1) {
                        let imageSize: Int = imageData.count
                        let imgSizeInKB = Double(imageSize) / 1024.0
                        let imgSizeInMB = Double(imgSizeInKB) / 1024.0
                        print("size of image in MB: %f ", imgSizeInKB / 1024.0)
                        
                        myImage = self.fixOrientation(img: image)
                        
                    }
                    
                }else{
                    if picker.cameraDevice == .front
                    {
                        myImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
                    }else{
                        myImage = self.fixOrientation(img: image)
                    }
                }
                let initialViewController : RSKImageCropViewController = RSKImageCropViewController.init(image: myImage, cropMode: RSKImageCropMode.circle)
                initialViewController.delegate = self
                self.navigationController?.pushViewController(initialViewController, animated: true)
            }
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // Continue with Image
        self.dismiss(animated: true) {
            //self.continueWithImage(self.imageViewProfilePicture.image)
            var myImage : UIImage!
            if (picker.sourceType == UIImagePickerControllerSourceType.photoLibrary) {
                
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    let imageSize: Int = imageData.count
                    let imgSizeInKB = Double(imageSize) / 1024.0
                    let imgSizeInMB = Double(imgSizeInKB) / 1024.0
                    print("size of image in MB: %f ", imgSizeInKB / 1024.0)
                    
                    myImage = self.fixOrientation(img: image)
                    
                }
                
            }else{
                if picker.cameraDevice == .front
                {
                    myImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
                }else{
                    myImage = self.fixOrientation(img: image)
                }
            }
            let initialViewController : RSKImageCropViewController = RSKImageCropViewController.init(image: myImage, cropMode: RSKImageCropMode.circle)
            initialViewController.delegate = self
            self.navigationController?.pushViewController(initialViewController, animated: true)
            
            
        }
    }
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    func calculateImageSize(image : UIImage) -> Double {
        var imgSizeInMB : Double = 0
        if let imageData = UIImageJPEGRepresentation(image, 1) {
            let imageSize: Int = imageData.count
            let imgSizeInKB = Double(imageSize) / 1024.0
            imgSizeInMB = Double(imgSizeInKB) / 1024.0
            print("size of image in MB: %f ", imgSizeInKB / 1024.0)
        }
        return imgSizeInMB
    }
    
    func degradeOrientationOfImage(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    //RSKImageCropViewControllerDelegate
    func didCancelCrop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func didCropImage(_ croppedImage: UIImage, usingCropRect cropRect: CGRect){
        
    }
    
    func willCropImage(_ originalImage: UIImage){
    }
    
    func didCropImage(_ croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat){
        self.navigationController?.popViewController(animated: true)
        //profileImageView?.contentMode = .scaleToFill
        //  profileImageView?.image = croppedImage
        self.uploadImage = croppedImage
        let imgSize = self.calculateImageSize(image: self.uploadImage!)
        
        if(imgSize > 1.5){
            let compressData = UIImageJPEGRepresentation(self.uploadImage!, 0.5)
            self.uploadImage = UIImage(data: compressData!)
        }
        
        self.serviceCallToUploadProfilePic()
    }
    
    // MARK: - Api Service Call Method
    func serviceCallToUploadProfilePic(){
        if AppConstant.hasConnectivity(){
            AppConstant.showHUD()
            
            let parameters = [
                "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken)
            ]
            print("param: \(parameters)")
            print("Api: \(AppConstant.uploadProfilePicUrl)")
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                if(self.uploadImage != nil){
                    let picSize = self.calculateImageSize(image:self.uploadImage!)
                    print("pic size \(picSize)")
                    var compressVal = 1.0
                    if((picSize < 1.0) && (picSize > 0.5)){
                        compressVal = 0.7
                    }else if(picSize > 1.0){
                        compressVal = 0.5
                    }
                    if let imageData = UIImageJPEGRepresentation(self.uploadImage!, CGFloat(compressVal)) {
                        let imageSize: Int = imageData.count
                        let imgSizeInKB = Double(imageSize) / 1024.0
                        let imgSizeInMB = Double(imgSizeInKB) / 1024.0
                        print("size of image in MB: %f ", imgSizeInKB / 1024.0)
                        multipartFormData.append(imageData, withName: "file", fileName:  AppConstant.fileName(), mimeType: "image/png")
                    }
                    
                }
                for (key, value) in parameters {
                    multipartFormData.append(((value as String).data(using: .utf8))!, withName: key)
                }}, to: AppConstant.uploadProfilePicUrl, method: .post, headers: nil,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseString { response in
                                AppConstant.hideHUD()
                                debugPrint(response)
                                let dict = AppConstant.convertToDictionary(text: response.result.value!)
                                
                                if let status = dict?["status"] as? Int {
                                    if(status == 1){
                                        if let imagePath = dict!["image"] as? String{
                                            AppConstant.saveInDefaults(key: StringConstant.profile_image, value: imagePath)
                                            //Update Profile pic
                                            self.profileImage.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "user"))
                                        }
                                        if let msg = dict!["msg"] as? String{
                                            AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                        }
                                    }else  if(status == 3){
                                        AppConstant.logout()
                                    }else{
                                        if let msg = dict!["msg"] as? String{
                                            AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                        }
                                    }
                                }
                            }
                        case .failure(let encodingError):
                            AppConstant.hideHUD()
                            AppConstant.showAlert(strTitle: encodingError.localizedDescription, strDescription: "", delegate: self)
                        }
            })
        }else{
            AppConstant.showAlert(strTitle: StringConstant.noInternetConnectionMsg, strDescription: "", delegate: self)
        }
        
    }
    
    func serviceCallToGetUserProfileInfo() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken)
            ]
            
            
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getUserProfileUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 0){
                                if let msg = dict?["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
                            }else  if(status == 1){
                                if let arrData = dict?["data"] as? [[String:Any]] {
                                    if arrData.count > 0{
                                        if let dictProfile = arrData[0] as? [String:Any]{
                                            if let name = dictProfile["name"] as? String {
                                                self.nameTf.text = name
                                            }
                                            if let email = dictProfile["email"] as? String {
                                                self.emailTf.text = email
                                            }
                                            if let mobile = dictProfile["mobile"] as? String {
                                                self.mobileNoTf.text = mobile
                                            }
                                            if let imagePath = dictProfile["image"] as? String {
                                                AppConstant.saveInDefaults(key: StringConstant.profile_image, value: imagePath)
                                                //Update Profile pic
                                                self.profileImage.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "user"))
                                            }
                                        }
                                    }
                                }
                                
                            }else if(status == 3){
                                AppConstant.logout()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: response.result.error!.localizedDescription, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showAlert(strTitle: StringConstant.noInternetConnectionMsg, strDescription: "", delegate: nil)
        }
        
    }
    
    func serviceCallToUpdateUserProfileInfo() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "name" : (nameTf.text?.trim())!,
                "email" : (emailTf.text?.trim())!
               
            ]
            
            
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.updateuserProfileUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){
                                AppConstant.saveInDefaults(key: StringConstant.name, value: (self.nameTf.text?.trim())!)
                                AppConstant.saveInDefaults(key: StringConstant.email, value: (self.emailTf.text?.trim())!)
                                
                                //Show response message
                                if let msg = dict?["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
                                
                            }else if(status == 3){
                                AppConstant.logout()
                            }else{
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
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    func serviceCallToChangeMobileNo() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let params: Parameters = [
                "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "mobile": (mobileNoTf.text?.trim())!,
                "con_code": "+91"
            ]
            
            print("url===\(AppConstant.changeMobileNoUrl)")
            print("params===\(params)")
            
            Alamofire.request(AppConstant.changeMobileNoUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
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
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "otp"){
            let vc = segue.destination as! OTPController
            vc.controllerName = "MyProfile"
            vc.mobile = self.mobileNoTf?.text
            vc.countryCode = "+91"
        }
    }
    

}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}
