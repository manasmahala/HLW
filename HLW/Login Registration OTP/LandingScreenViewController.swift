//
//  LandingScreenViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/25/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import EAIntroView

class LandingScreenViewController: UIViewController, EAIntroDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var viewYourMobileNumber: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesigns()
    }
    
    func initDesigns() {
        if (AppConstant.retrieveBoolFromDefaults(key: StringConstant.isIntroduceScreenShown) == false) {
            //Show Indroduction
            self.showIntro()
        }
        
        logoImage.layer.cornerRadius = logoImage.frame.width / 2
        logoImage.clipsToBounds = true
        
        viewYourMobileNumber.layer.borderWidth = 2
        viewYourMobileNumber.layer.borderColor = AppConstant.colorThemeBlue.cgColor
        viewYourMobileNumber.clipsToBounds = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.viewYourMobileNumberAction(_:)))
        viewYourMobileNumber.addGestureRecognizer(tap1)
        viewYourMobileNumber.isUserInteractionEnabled = true
    }
    
    //MARK: - Button Action
    @objc func viewYourMobileNumberAction(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    //MARK: Introdution View
    func showIntro() {
        let page1 = EAIntroPage.init(customViewFromNibNamed: "Introduction1")
        let page2 = EAIntroPage.init(customViewFromNibNamed: "Introduction2")
        let page3 = EAIntroPage.init(customViewFromNibNamed: "Introduction3")
        let page4 = EAIntroPage.init(customViewFromNibNamed: "Introduction4")
        let page5 = EAIntroPage.init(customViewFromNibNamed: "Introduction5")
        
        let introView = EAIntroView.init(frame: self.view.bounds, andPages: [page1!,page2!,page3!,page4!,page5!])
        introView?.delegate = self
        introView?.skipButton.alpha = 1.0
        introView?.skipButton.setTitle("Skip", for: .normal)
        introView?.skipButton.isEnabled = true
        
        //        page5!.onPageDidAppear = {
        //            introView?.skipButton.isEnabled = true
        //            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
        //                introView?.skipButton.alpha = 1.0
        //            }, completion: nil)
        //        }
        //
        //        page5!.onPageDidDisappear = {
        //            introView?.skipButton.isEnabled = false
        //            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
        //                introView?.skipButton.alpha = 0.0
        //            }, completion: nil)
        //        }
        introView?.show(in: self.view)
        
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        AppConstant.saveBoolInDefaults(key: StringConstant.isIntroduceScreenShown, value: true)
        if(wasSkipped) {
            
            print("Intro skipped")
            
        } else {
            
            print("Intro not skipped")
        }
    }

}
