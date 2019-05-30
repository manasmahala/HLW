//
//  AppDelegate.swift
//  HLW
//
//  Created by OdiTek Solutions on 22/12/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navController: UINavigationController!
    
    
    // AIzaSyDIqKyViDTwa9GISngfxvyZsUU-rZfQqqo
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        self.registerAPN(application)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
        
        GMSServices.provideAPIKey(AppConstant.GoogleMapApiKey)
        GMSPlacesClient.provideAPIKey(AppConstant.GoogleMapApiKey)
        
        GIDSignIn.sharedInstance().clientID = AppConstant.GIDSignInClientKey
        
        let isLoggedIn = AppConstant.retrievFromDefaults(key: StringConstant.isLoggedIn)
        if(isLoggedIn == "1"){
            self.goToMainScreen()
        }else{
            self.goToLandingScreen()
        }
        
        FirebaseApp.configure()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0;
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func goToMainScreen(){
        //        navController = UINavigationController()
        //        navController.setNavigationBarHidden(true, animated: true)
        //        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let initialViewControlleripad : HomeScreenController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeScreenController") as! HomeScreenController
        //        navController.viewControllers = [initialViewControlleripad]
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //        self.window?.rootViewController = navController
        //        self.window?.makeKeyAndVisible()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeScreenController") as! HomeScreenController
        self.navController = UINavigationController(rootViewController: mainViewController)
        self.navController?.isNavigationBarHidden = true
        let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        leftViewController.homeViewController = self.navController
        let slideMenuController = ExSlideMenuController(mainViewController:self.navController!, leftMenuViewController: leftViewController)
        slideMenuController.addLeftGestures()
        slideMenuController.delegate = mainViewController
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    
    func goToLandingScreen(){
        //        navController = UINavigationController()
        //
        //        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let initialViewControlleripad : SignInController = mainStoryboardIpad.instantiateViewController(withIdentifier: "SignInController") as! SignInController
        //        navController.viewControllers = [initialViewControlleripad]
        //        self.window = UIWindow(frame: UIScreen.main.bounds)
        //        self.window?.rootViewController = navController
        //        self.window?.makeKeyAndVisible()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "LandingScreenViewController") as! LandingScreenViewController
        self.navController = UINavigationController(rootViewController: mainViewController)
        self.navController?.isNavigationBarHidden = true
        let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        leftViewController.homeViewController = self.navController
        let slideMenuController = ExSlideMenuController(mainViewController:self.navController!, leftMenuViewController: leftViewController)
        slideMenuController.addLeftGestures()
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    
    func logoutAction(){
        AppConstant.saveInDefaults(key: "isLoggedIn", value: "0")
        self.goToLandingScreen();
    }
    
    func registerAPN(_ application: UIApplication){
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        // iOS 9 support
        if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let str = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        //print("str : \(str)")
        AppConstant.saveInDefaults(key: StringConstant.deviceToken, value: str)
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        AppConstant.isBookingConfirm = true
        
        guard
            let aps = data[AnyHashable("aps")] as? NSDictionary,
            let alert = aps["alert"] as? NSDictionary,
            let body = alert["body"] as? String,
            let title = alert["title"] as? String
            else {
                // handle any error here
                return
        }
        
        let isLoggedIn = AppConstant.retrievFromDefaults(key: "isLoggedIn")
        if(isLoggedIn == "1"){
            
            if(application.applicationState == .active) {
                AppConstant.isBookingConfirm = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadNotification"), object: nil)
                
                //app is currently active, can update badges count here
                
            } else if(application.applicationState == .background){
                
                //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
                
            } else if(application.applicationState == .inactive){
                
                //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
                
            }
            
        }
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        
        if FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil){
            return true
        }else if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: nil){
            return true
        }
        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        AppConstant.isBookingConfirm = true
        print(notification.description)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadNotification"), object: nil)
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Action First Tapped")
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
}

