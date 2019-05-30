//
//  BillViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 09/02/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Cosmos

class BillViewController: UIViewController {

    @IBOutlet weak var imgViewDriverProfile: UIImageView!
    @IBOutlet weak var viewVehicle: UIView!
    @IBOutlet weak var viewVehicleContainer: UIView!
    @IBOutlet weak var viewRatings: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        viewVehicle.layer.cornerRadius = viewVehicle.frame.size.width / 2
        viewVehicle.clipsToBounds = true
        viewVehicleContainer.layer.cornerRadius = viewVehicleContainer.frame.size.width / 2
        viewVehicleContainer.clipsToBounds = true
        
        imgViewDriverProfile.layer.cornerRadius = imgViewDriverProfile.frame.size.width / 2
        imgViewDriverProfile.clipsToBounds = true
        
        viewRatings.settings.fillMode = .full
        
        viewRatings.didFinishTouchingCosmos = { rating in
            self.viewRatings.rating = rating
        }
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRateUsAction(_ sender: Any) {
        self.performSegue(withIdentifier: "feedback", sender: self)
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedback"{
            let vc = segue.destination as! FeedbackViewController
            vc.ratings = Int(self.viewRatings.rating)
        }
    }
    
}
