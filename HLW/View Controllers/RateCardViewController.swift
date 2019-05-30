//
//  RateCardViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 3/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class RateCardViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesigns()
    }
    
    func initDesigns() {
        
        // change selected bar color for XLPagerTabStrip
        settings.style.buttonBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemBackgroundColor = UIColor.white
        settings.style.selectedBarBackgroundColor = AppConstant.colorThemeYellow
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 16.0)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarItemLeftRightMargin = 5
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.gray
            newCell?.label.textColor = UIColor.black
        }
        
        super.viewDidLoad()
        
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OneWayRateCardViewController")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RentalsRateCardViewController")
        return [child_1, child_2]
    }
    
    //MARK: Button Action
    @IBAction func menuBtnAction (_ sender: UIButton) {
        slideMenuController()?.toggleLeft()
    }
    

}
