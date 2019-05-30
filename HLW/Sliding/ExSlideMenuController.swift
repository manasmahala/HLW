//
//  ExSlideMenuController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/11/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ExSlideMenuController : SlideMenuController {
    
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            
            if vc is MenuController
            {
                return true
            }
            if vc is HomeScreenController
            {
                AppConstant.isSlideMenu = true
                NotificationCenter.default.post(name: Notification.Name("DisableMapFromDragNotification"), object: nil)
                return true
            }
            if vc is DriverInfoScreenController
            {
                AppConstant.isSlideMenu = true
                NotificationCenter.default.post(name: Notification.Name("DisableMapFromDragNotification"), object: nil)
                return true
            }
            if vc is MyProfileViewController
            {
                return true
            }
            if vc is YourTotalTripsViewController
            {
                return true
            }
            if vc is EmergencyContactsViewController
            {
                return true
            }
            if vc is AboutUsViewController
            {
                return true
            }
            
        }
        return false
    }
    
 override func track(_ trackAction: TrackAction) {
     switch trackAction {
     case .leftTapOpen:
     print("TrackAction: left tap open.")
     case .leftTapClose:
        AppConstant.isSlideMenu = false
        NotificationCenter.default.post(name: Notification.Name("DisableMapFromDragNotification"), object: nil)
     print("TrackAction: left tap close.")
     case .leftFlickOpen:
     print("TrackAction: left flick open.")
     case .leftFlickClose:
        AppConstant.isSlideMenu = false
        NotificationCenter.default.post(name: Notification.Name("DisableMapFromDragNotification"), object: nil)
     print("TrackAction: left flick close.")
     case .rightTapOpen:
     print("TrackAction: right tap open.")
     case .rightTapClose:
     print("TrackAction: right tap close.")
     case .rightFlickOpen:
     print("TrackAction: right flick open.")
     case .rightFlickClose:
     print("TrackAction: right flick close.")
     }
     }
}
