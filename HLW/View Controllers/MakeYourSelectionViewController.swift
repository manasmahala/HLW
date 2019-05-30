//
//  MakeYourSelectionViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 21/05/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

protocol selectionDelegate: class{
    func selectedOption(customBo: CustomObject, at: Int)
}

class MakeYourSelectionViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tblViewSelection: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewContainerHeight: NSLayoutConstraint!
    
    weak var delegate: selectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initDesign()
    }
    
    func initDesign(){
        viewContainerHeight.constant = CGFloat((Double(AppConstant.arrSelection.count) * 49.5) + 48)
        tblViewHeightConstraint.constant = CGFloat((Double(AppConstant.arrSelection.count) * 49.5))
        
        self.viewContainer.layer.cornerRadius = 5
        self.viewContainer.clipsToBounds = true
    }
    
    //MARK: Tableview Degates & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppConstant.arrSelection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath as IndexPath) as! SelectionTableViewCell
        //cell.selectionStyle = .none
        
        let customBo = AppConstant.arrSelection[indexPath.row]
        cell.lblTitle.text = customBo.name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.selectedOption(customBo: AppConstant.arrSelection[indexPath.row], at: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    func touchesBegan(_ touches: Set<AnyHashable>, with event: UIEvent) {
        let touch: UITouch? = touches.first as! UITouch
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != viewContainer {
            self.dismiss(animated: true, completion: nil)
        }
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
