//
//  FeedbackViewController.swift
//  HLW
//
//  Created by Chinmaya Sahu on 2/11/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var feedbackTableView: UITableView!
    
    var arrFeedbackQuestionsForNormalRides = [FeedbackQuestionsForNormalRides]()
    var arrFeedbackQuestionsForBestRides = [FeedbackQuestionsForBestRides]()
    
    var ratings: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedbackQuestionsForNormalRides()
        loadFeedbackQuestionsForBestRides()
    }
    
    //MARK: - Load Static Feedback Questions
    func loadFeedbackQuestionsForNormalRides() {
        var feedbackQuestionsForNormalRidesBo = FeedbackQuestionsForNormalRides()
        feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions = "Charged extra"
        arrFeedbackQuestionsForNormalRides.append(feedbackQuestionsForNormalRidesBo)
        
        feedbackQuestionsForNormalRidesBo = FeedbackQuestionsForNormalRides()
        feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions = "Delayed Pickup"
        arrFeedbackQuestionsForNormalRides.append(feedbackQuestionsForNormalRidesBo)
        
        feedbackQuestionsForNormalRidesBo = FeedbackQuestionsForNormalRides()
        feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions = "Driver Unprofessional"
        arrFeedbackQuestionsForNormalRides.append(feedbackQuestionsForNormalRidesBo)
        
        feedbackQuestionsForNormalRidesBo = FeedbackQuestionsForNormalRides()
        feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions = "Long/incorrect route"
        arrFeedbackQuestionsForNormalRides.append(feedbackQuestionsForNormalRidesBo)
        
        feedbackQuestionsForNormalRidesBo = FeedbackQuestionsForNormalRides()
        feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions = "Did not take this ride"
        arrFeedbackQuestionsForNormalRides.append(feedbackQuestionsForNormalRidesBo)
        
        feedbackQuestionsForNormalRidesBo = FeedbackQuestionsForNormalRides()
        feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions = "My reason is not listed"
        arrFeedbackQuestionsForNormalRides.append(feedbackQuestionsForNormalRidesBo)
    }
    
    func loadFeedbackQuestionsForBestRides() {
        var feedbackQuestionsForBestRidesBo = FeedbackQuestionsForBestRides()
        feedbackQuestionsForBestRidesBo.bestFeedbackQuestions = "Polite and professional driver"
        arrFeedbackQuestionsForBestRides.append(feedbackQuestionsForBestRidesBo)
        
        feedbackQuestionsForBestRidesBo = FeedbackQuestionsForBestRides()
        feedbackQuestionsForBestRidesBo.bestFeedbackQuestions = "On-time pickup"
        arrFeedbackQuestionsForBestRides.append(feedbackQuestionsForBestRidesBo)
        
        feedbackQuestionsForBestRidesBo = FeedbackQuestionsForBestRides()
        feedbackQuestionsForBestRidesBo.bestFeedbackQuestions = "Comfortable ride"
        arrFeedbackQuestionsForBestRides.append(feedbackQuestionsForBestRidesBo)
        
        feedbackQuestionsForBestRidesBo = FeedbackQuestionsForBestRides()
        feedbackQuestionsForBestRidesBo.bestFeedbackQuestions = "Driver familiar with the route"
        arrFeedbackQuestionsForBestRides.append(feedbackQuestionsForBestRidesBo)
        
        feedbackQuestionsForBestRidesBo = FeedbackQuestionsForBestRides()
        feedbackQuestionsForBestRidesBo.bestFeedbackQuestions = "Value for money"
        arrFeedbackQuestionsForBestRides.append(feedbackQuestionsForBestRidesBo)
        
        feedbackQuestionsForBestRidesBo = FeedbackQuestionsForBestRides()
        feedbackQuestionsForBestRidesBo.bestFeedbackQuestions = "My reason is not listed"
        arrFeedbackQuestionsForBestRides.append(feedbackQuestionsForBestRidesBo)
    }
    
    //MARK: - Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Tableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else if (section == 1) {
            if (ratings == 5) {
                return arrFeedbackQuestionsForBestRides.count
            }
            else {
                return arrFeedbackQuestionsForNormalRides.count
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackRatingsTableViewCell", for: indexPath as IndexPath) as! FeedbackRatingsTableViewCell
            
            cell.selectionStyle = .none
            cell.viewRatings.rating = Double(ratings)
            
            if (ratings == 1) {
                cell.lblFeedbackMsg?.text = "Very bad!"
                cell.lblFeedbackQuestionTitle?.text = "Tell us what went wrong"
                cell.ratingsImage?.image = UIImage(named: "ride_very_bad")
            }
            else if (ratings == 2) {
                cell.lblFeedbackMsg?.text = "A bad one!"
                cell.lblFeedbackQuestionTitle?.text = "Tell us what went wrong"
                cell.ratingsImage?.image = UIImage(named: "ride_bad")
            }
            else if (ratings == 3) {
                cell.lblFeedbackMsg?.text = "An ok ok ride!"
                cell.lblFeedbackQuestionTitle?.text = "Tell us what went wrong"
                cell.ratingsImage?.image = UIImage(named: "ride_ok")
            }
            else if (ratings == 4) {
                cell.lblFeedbackMsg?.text = "A good ride!"
                cell.lblFeedbackQuestionTitle?.text = "Why wasn't this a great ride?"
                cell.ratingsImage?.image = UIImage(named: "ride_good")
            }
            else if (ratings == 5) {
                cell.lblFeedbackMsg?.text = "A great ride!"
                cell.lblFeedbackQuestionTitle?.text = "What went perfect for you?"
                cell.ratingsImage?.image = UIImage(named: "ride_great")
            }
            
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackQuestionsTableViewCell", for: indexPath as IndexPath) as! FeedbackQuestionsTableViewCell
            
            cell.selectionStyle = .none
            
            if (ratings == 5) {
                let feedbackQuestionsForBestRidesBo = arrFeedbackQuestionsForBestRides[indexPath.row]
                cell.lblFeedbackQuestions?.text = feedbackQuestionsForBestRidesBo.bestFeedbackQuestions
                cell.selectQuestionsImage?.image = feedbackQuestionsForBestRidesBo.selectedQuestionsStatus == 1 ? UIImage(named: "check_box_checked") : UIImage(named: "check_box_unchecked")
            }
            else {
                let feedbackQuestionsForNormalRidesBo = arrFeedbackQuestionsForNormalRides[indexPath.row]
                cell.lblFeedbackQuestions?.text = feedbackQuestionsForNormalRidesBo.normalFeedbackQuestions
                cell.selectQuestionsImage?.image = feedbackQuestionsForNormalRidesBo.selectedQuestionsStatus == 1 ? UIImage(named: "check_box_checked") : UIImage(named: "check_box_unchecked")
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCommentsTableViewCell", for: indexPath as IndexPath) as! FeedbackCommentsTableViewCell
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 1) {
            if (ratings == 5) {
                let feedbackQuestionsForBestRidesBo = arrFeedbackQuestionsForBestRides[indexPath.row]
                if (feedbackQuestionsForBestRidesBo.selectedQuestionsStatus == 1) {
                    feedbackQuestionsForBestRidesBo.selectedQuestionsStatus = 0
                }else {
                    feedbackQuestionsForBestRidesBo.selectedQuestionsStatus = 1
                }
            }
            else {
                let feedbackQuestionsForNormalRidesBo = arrFeedbackQuestionsForNormalRides[indexPath.row]
                if (feedbackQuestionsForNormalRidesBo.selectedQuestionsStatus == 1) {
                    feedbackQuestionsForNormalRidesBo.selectedQuestionsStatus = 0
                }else {
                    feedbackQuestionsForNormalRidesBo.selectedQuestionsStatus = 1
                }
            }
            feedbackTableView.reloadData()
        }
    }
    

}
