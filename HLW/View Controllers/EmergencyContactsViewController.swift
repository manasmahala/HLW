//
//  EmergencyContactsViewController.swift
//  HLW
//
//  Created by OdiTek Solutions on 15/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import ContactsUI

class EmergencyContactsViewController: UIViewController, SlideMenuControllerDelegate, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblViewContacts: UITableView!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblEmergencyDesc: UILabel!
    
    var arrContacts = [EmergencyContactBO]()

    override func viewDidLoad() {
        super.viewDidLoad()

        initDesign()
    }
    
    func initDesign(){
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            navBarHeightConstraint.constant = 92
        }
        
        if arrContacts.count < 1{
            lblEmergencyDesc.isHidden = false
            tblViewContacts.isHidden = true
        }else{
            lblEmergencyDesc.isHidden = true
            tblViewContacts.isHidden = false
        }
        
        lblEmergencyDesc.text = StringConstant.empty_emergency_contact_msg
    }

    @IBAction func btnSlideMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    @IBAction func btnAddContactAction(_ sender: Any) {
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    @objc func btnRemoveContactAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Remove", message: StringConstant.remove_contact_from_emergency_msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { action in
            self.arrContacts.remove(at: sender.tag)
            self.tblViewContacts.reloadData()
            
            if self.arrContacts.count < 1{
                self.lblEmergencyDesc.isHidden = false
                self.tblViewContacts.isHidden = true
            }else{
                self.lblEmergencyDesc.isHidden = true
                self.tblViewContacts.isHidden = false
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            
        })
        self.present(alert, animated: true)
    }
    
    // MARK: Delegate method CNContectPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contactsBo = EmergencyContactBO()
        contactsBo.name = "\(contact.givenName) \(contact.familyName)"
        let numbers = contact.phoneNumbers.first
        contactsBo.number = (numbers?.value)?.stringValue
        
        if self.checkIfContactNumberAlreadyExist(num: contactsBo.number!) == false{
            self.arrContacts.append(contactsBo)
            if arrContacts.count < 1{
                lblEmergencyDesc.isHidden = false
                tblViewContacts.isHidden = true
            }else{
                lblEmergencyDesc.isHidden = true
                tblViewContacts.isHidden = false
            }
            self.tblViewContacts.reloadData()
        }else{
            AppConstant.showAlert(strTitle: StringConstant.contact_already_exist_emergency_list_msg, strDescription: "", delegate: nil)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview Delegates & Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrContacts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:EmergencyContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmergencyContactTableViewCell") as! EmergencyContactTableViewCell
        cell.selectionStyle = .none
        
        let contactBo = self.arrContacts[indexPath.section]
        cell.lblContactName.text = contactBo.name
        cell.lblContactNumber.text = contactBo.number
        cell.btnRemove.tag = indexPath.section
        cell.btnRemove.addTarget(self, action: #selector(btnRemoveContactAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat.leastNonzeroMagnitude
        }
        else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func checkIfContactNumberAlreadyExist(num: String)-> Bool{
        var isExist = false
        for contact in self.arrContacts {
            if (num == contact.number) && (isExist == false){
                isExist = true
            }
        }
        return isExist
    }

}
