//
//  CustomViewForPriceViewController.swift
//  Taxi Booking
//
//  Created by OdiTek Solutions on 15/03/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit

class CustomViewForPriceViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var lblFareDesc5: UILabel!
    @IBOutlet weak var CustomViewForPriceTableView: UITableView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var popUpViewHeightConstraint: NSLayoutConstraint!
    
    
    var fareInfoArray = [Dictionary<String, Any>]()
    var totalFare : String!
    var info : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomViewForPriceTableView.tableFooterView = UIView()
        okBtn.layer.cornerRadius = 3
        lblTotalCost.text = "Total Cost : ₹" + self.totalFare
        lblFareDesc5.text = self.info
        
        tableViewHeightConstraint.constant = CGFloat(self.fareInfoArray.count * 24)
        if self.fareInfoArray.count > 3 {
            popUpViewHeightConstraint.constant = popUpViewHeightConstraint.constant + (CGFloat(self.fareInfoArray.count * 24) - 72)
        }
        
        
    }
    
    @IBAction func btnOKAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParentViewController: nil)
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fareInfoArray.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:CustomViewForPriceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomViewForPriceTableViewCell") as! CustomViewForPriceTableViewCell!
        
        // set the text from the array
        let fareDetails = fareInfoArray[indexPath.row] as Dictionary
        cell.lblFareDesc?.text = fareDetails["key"] as? String
        if let fareValue = fareDetails["value"] as? Int {
            cell.lblFare?.text = "₹" + String(fareValue)
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    
    
}
