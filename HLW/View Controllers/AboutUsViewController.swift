//
//  AboutUsViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 22/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet var imgViewAppIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        lblVersion.text = AppConstant.getAppVersion()
        imgViewAppIcon.layer.cornerRadius = imgViewAppIcon.frame.size.height/2
        imgViewAppIcon.clipsToBounds = true
    }
    
    //MARK: Button Action
    @IBAction func btnMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
