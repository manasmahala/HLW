//
//  OneWayRateCardViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 3/15/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import iOSDropDown

class OneWayRateCardViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate , UITableViewDataSource, selectionDelegate {

    @IBOutlet weak var oneWayTableView: UITableView!
    
    var isFareDetailsShowing = true
    
    var itemInfo: IndicatorInfo = "ONE WAY"
//    var arrVehicleType = [VehicleTypeBO]()
    var vehicleInfo = VehicleTypeBO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesign()
    }
    
    func initDesign(){
        if AppConstant.arrVehicleType.count > 0{
            vehicleInfo = AppConstant.arrVehicleType[0]
        }
        
        self.oneWayTableView.reloadData()
    }
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    //MARK: Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OneWayRateCardTableViewCell", for: indexPath as IndexPath) as! OneWayRateCardTableViewCell
        
        cell.selectionStyle = .none
        
        cell.lblfareDesc.text = isFareDetailsShowing == true ? StringConstant.fareDesc : ""
        cell.lblVehiclaName.text = vehicleInfo.name
        cell.lblSelectedVehiclaName.text = vehicleInfo.name
        cell.imgViewVehicle.sd_setImage(with: URL(string: vehicleInfo.unselectedImage), placeholderImage: UIImage(named: ""))
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.viewTotalTapAction(_:)))
        cell.viewTotalFare.isUserInteractionEnabled = true
        cell.viewTotalFare.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.selectCabAction(_:)))
        cell.viewCabSelection.isUserInteractionEnabled = true
        cell.viewCabSelection.addGestureRecognizer(tap2)

        
        return cell
    }
    //MARK: Selection Delegate
    
    func selectedOption(customBo: CustomObject, at: Int){
        vehicleInfo = AppConstant.arrVehicleType[at]
        
        self.oneWayTableView.reloadData()
    }
    
    //MARK: Button Action
    @objc func viewTotalTapAction(_ sender: UITapGestureRecognizer) {
        isFareDetailsShowing = !isFareDetailsShowing
        
        oneWayTableView.reloadData()
    }
    
    @objc func selectCabAction(_ sender: UITapGestureRecognizer) {
        AppConstant.arrSelection.removeAll()
        
        for item in AppConstant.arrVehicleType{
            let customBo = CustomObject()
            customBo.id = item.vehicleId
            customBo.name = item.name!
            
            AppConstant.arrSelection.append(customBo)
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeYourSelectionViewController") as! MakeYourSelectionViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }

}
