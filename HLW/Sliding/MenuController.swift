//
//  MenuController.swift
//  TheSpesh
//
//  Created by Chinmaya Sahu on 13/10/17.
//  Copyright © 2017 Rajendra. All rights reserved.
//

import UIKit
class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imgViewProfile: UIImageView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblVersion: UILabel!
    @IBOutlet weak var menuTabelView: UITableView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet var viewProfileHeight: NSLayoutConstraint!
    @IBOutlet var imgViewProfileBottomSpaceConstraint: NSLayoutConstraint!
    
    var allMenues:[String]! = []
    var allMenuesImages:[String]!
    var className : String?
    var myProfileViewController: UIViewController!
    var homeViewController: UIViewController!
    var yourTotalTripsViewController: UIViewController!
    var emergenctContactController: UIViewController!
    var aboutUsController: UIViewController!
    var rateCardController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateValues()
    }
    
    func loadAllMenu(){
//        self.allMenues = ["Book Your Trip","Your Total Trips","Type of bookings","Check Price list","Payments","Emergency Contact","Helpdesk","About Us","Log out"]
//        self.allMenuesImages = ["book_your_trip","your_total_trip","type_of_booking","check_price_list","payment","emergency_contact","help_desk_menu","about_us","sign_out"]
        
        self.allMenues = ["Book Your Trip","Your Total Trips","Type of bookings","Emergency Contact","Rate Card","Help Desk","About Us","Log Out"]
        self.allMenuesImages = ["book_your_trip","your_total_trip","type_of_booking","emergency_contact","emergency_contact","help_desk_menu","about_us","sign_out"]
        self.menuTabelView.reloadData()
        
    }
    
    func initDesign(){
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.size.height/2
        imgViewProfile.layer.masksToBounds = true
        
        self.loadAllMenu()
        
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            viewProfileHeight.constant = 200
        }else if AppConstant.screenSize.height <= 568{
            viewProfileHeight.constant = 140
            imgViewProfileBottomSpaceConstraint.constant = 25
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.btnEditProfileAction(_:)))
        self.viewProfile.addGestureRecognizer(tap1)
        self.viewProfile.isUserInteractionEnabled = true
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let myProfileViewController = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        let navController1 =  UINavigationController(rootViewController: myProfileViewController)
        navController1.isNavigationBarHidden = true
        self.myProfileViewController = navController1
        
        let homeScreenController = storyboard.instantiateViewController(withIdentifier: "HomeScreenController" ) as! HomeScreenController
        let navController2 =  UINavigationController(rootViewController: homeScreenController)
        navController2.isNavigationBarHidden = true
        self.homeViewController = navController2
        
        let yourTotalTripsViewController = storyboard.instantiateViewController(withIdentifier: "YourTotalTripsViewController") as! YourTotalTripsViewController
        let navController3 =  UINavigationController(rootViewController: yourTotalTripsViewController)
        navController3.isNavigationBarHidden = true
        self.yourTotalTripsViewController = navController3
        
        let emergencyContactsController = storyboard.instantiateViewController(withIdentifier: "EmergencyContactsViewController") as! EmergencyContactsViewController
        let navController4 =  UINavigationController(rootViewController: emergencyContactsController)
        navController4.isNavigationBarHidden = true
        self.emergenctContactController = navController4
        
        let aboutController = storyboard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
        let navController5 =  UINavigationController(rootViewController: aboutController)
        navController5.isNavigationBarHidden = true
        self.aboutUsController = navController5
        
        let rateCardController = storyboard.instantiateViewController(withIdentifier: "RateCardViewController") as! RateCardViewController
        let navController6 =  UINavigationController(rootViewController: rateCardController)
        navController6.isNavigationBarHidden = true
        self.rateCardController = navController6
    }
    
    func updateValues(){
        self.lblVersion?.text = AppConstant.getAppVersion()
        self.lblUserName.text = AppConstant.retrievFromDefaults(key: StringConstant.name)
        self.lblAddress.text = AppConstant.retrievFromDefaults(key: StringConstant.current_address)
        self.imgViewProfile.sd_setImage(with: URL(string: AppConstant.retrievFromDefaults(key: StringConstant.profile_image)), placeholderImage: UIImage(named: "user"))
        
        self.menuTabelView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (newImage?.withRenderingMode(.alwaysTemplate))!
    }
    
    func showAlertForLogout() {
        let alert = UIAlertController(title: "Log out", message: StringConstant.logout_msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .cancel) { action in
            AppConstant.logout()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            
        })
        self.present(alert, animated: true)
    }
    
    //MARK: Button Action
    @IBAction func btnEditProfileAction(_ sender: Any) {
    self.slideMenuController()?.changeMainViewController(self.myProfileViewController, close: true)
    }
    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = self.allMenues[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath as IndexPath) as! MenuTableViewCell
        //cell.selectionStyle = .none
        
        cell.contentView.backgroundColor = AppConstant.slideMenuSelectedIndex == indexPath.row ? UIColor.blue: UIColor.clear
        
        cell.lblMenu?.text = menu
        if (AppConstant.screenSize.height <= 568) {
            cell.lblMenu?.font = UIFont.init(name: "Poppins-Medium", size: 13.0)
        }
        cell.menuImage?.image = UIImage(named:self.allMenuesImages[indexPath.row])
        
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.menuTabelView.deselectRow(at: indexPath, animated: true)
        
        AppConstant.slideMenuSelectedIndex = indexPath.row
        
        let menu = self.allMenues[indexPath.row]
        if(menu == "Log Out"){
            // let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            //fbLoginManager.logOut()
            //            self.logoutInstagram()
            //            FBSDKAccessToken.setCurrent(nil)
            self.showAlertForLogout()
        }else if(menu == "Sign In"){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.goToLandingScreen()
        }else if(menu == "Book Your Trip"){
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.goToMainScreen()
        }else if(menu == "Your Total Trips"){
            self.slideMenuController()?.changeMainViewController(self.yourTotalTripsViewController, close: true)
        }else if(menu == "Emergency Contact"){
            self.slideMenuController()?.changeMainViewController(self.emergenctContactController, close: true)
        }else if(menu == "Rate Card"){
            self.slideMenuController()?.changeMainViewController(self.rateCardController, close: true)
        }else if(menu == "About Us"){
            self.slideMenuController()?.changeMainViewController(self.aboutUsController, close: true)
        }
    }
    
    func changeViewController(index: Int) {
        switch index {
        case 0:
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
            break
        case 1:
            self.slideMenuController()?.changeMainViewController(self.yourTotalTripsViewController, close: true)
            break
        default:
            break
            
        }
    }
    
}
