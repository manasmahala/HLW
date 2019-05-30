//
//  RouteScreenController.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 27/01/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import SwiftyJSON
import GooglePlaces
import DSGradientProgressView
import Windless
import SkeletonView

class RouteScreenController: UIViewController , GMSMapViewDelegate , CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate, ChooseDelegate, ChooseSeatsDelegate, ChoosePaymentModeDelegate, ApplyCouponDelegate {

    @IBOutlet weak var selectedCarView: UIView!
    @IBOutlet weak var selectedCarImgView: UIImageView!
    @IBOutlet weak var lblSelectedCar: UILabel!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var pickUpLocationTf: UITextField!
    @IBOutlet weak var dropLocationTf: UITextField!
    @IBOutlet var btnConfirmBooking: UIButton!
    @IBOutlet var viewPickUpLocation: UIView!
    @IBOutlet var viewDropLocation: UIView!
    @IBOutlet var webViewGoogleMap: UIWebView!
    @IBOutlet var viewFindingDriver: UIView!
    @IBOutlet var viewConfirmBooking: UIView!
    @IBOutlet var progressBar: DSGradientProgressView!
    @IBOutlet var btnCancelRequest: UIButton!
    @IBOutlet weak var totalFareView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bookRideForView: UIView!
    @IBOutlet weak var paymentModeView: UIView!
    @IBOutlet weak var applyCouponView: UIView!
    @IBOutlet weak var viewPickupTime: UIView!
    @IBOutlet weak var lblPickupTime: UILabel!
    @IBOutlet weak var lblPickupTimeTitle: UILabel!
    @IBOutlet var viewContainerBottom: NSLayoutConstraint!
    @IBOutlet var viewBottomHeight: NSLayoutConstraint!
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet var viewDatePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var dateTimePicker: UIDatePicker!
    @IBOutlet var viewbackground: UIView!
    @IBOutlet weak var lblBookRideFor: UILabel!
    @IBOutlet weak var lblBookRideForContact: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblApplyCoupon: UILabel!
    @IBOutlet weak var lblAppliedCoupon: UILabel!
    @IBOutlet weak var lblTotalFare: UILabel!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var viewDriverInfo: UIView!
    
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblVehicleName: UILabel!
    @IBOutlet var lblVehicleNumber: UILabel!
   // @IBOutlet var lblOTP: UILabel!
    @IBOutlet weak var cancelRideBtn: UIButton!
    @IBOutlet weak var imgViewPickupTime: UIImageView!
    @IBOutlet weak var imgViewCoupon: UIImageView!
    @IBOutlet weak var lblPaymentModeOption: UILabel!
    @IBOutlet weak var lblPageTitle: UILabel!
    
    var currentCity : String!
    var vehicleType : String!
    var arrFareDettails = [FareDetails]()
    var info : String = ""
    var taxValue : String = ""
    var cityId : String = ""
    var vehicleTypeId : String = ""
    var totalFare : String = "0"
    var pickUpCoordinate : CLLocationCoordinate2D? = nil
    var dropCoordinate : CLLocationCoordinate2D? = nil
    var pickUpAddress : String!
    var dropAddress : String!
    var locationManager = CLLocationManager()
    var arrLocations = [CLLocationCoordinate2D]()
    //var driverProfileBo = DriverProfileBO()
    var bokingStatusBo = BookingStatusBO()
    var isAddressChanged : Bool = false
    var isForBookLater : Bool = false
    var isForBookShareRide : Bool = false
    var isCouponApplied: Bool = false
    var pickupTime: String = ""
    var waitingTime: String = ""
    var promoCode = CouponBO()
    
    //Draw animated path
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        googleMapView.clear()
        
        //Draw route between two locations
        if self.dropCoordinate != nil{//Manas
            self.drawPath(startLocation: self.pickUpCoordinate!, endLocation: self.dropCoordinate!)
        }
        
        setBoundsForMap()
        
//        DispatchQueue.main.async {
//            self.viewFindingDriver.isHidden = false
//            self.progressBar.wait()
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
//        topView.layer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 5)
//        topView.clipsToBounds = true
        
        topView.setShadowWithCornerRadius(corners: 20.0)
        
        
        bookRideForView.layer.cornerRadius = 5
        bookRideForView.clipsToBounds = true
        paymentModeView.layer.cornerRadius = 5
        paymentModeView.clipsToBounds = true
        applyCouponView.layer.cornerRadius = 5
        applyCouponView.clipsToBounds = true
        totalFareView.layer.cornerRadius = 5
        totalFareView.clipsToBounds = true
        viewPickupTime.layer.cornerRadius = 5
        viewPickupTime.clipsToBounds = true
    }
    
    func initDesign(){
        lblPaymentModeOption.text = AppConstant.selectedPaymentMode
        lblTotalFare.text = ""
        
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            navBarHeightConstraint.constant = 92
            viewBottomBottomSpaceConstraint.constant = 34
        }
        
        //Hide PickupTime view
        if (isForBookLater == false) && (isForBookShareRide == false){
            viewContainerBottom.constant = 8
            viewPickupTime.isHidden = true
            viewBottomHeight.constant = viewBottomHeight.constant - 49
        }
        
        if isForBookLater{
            lblPickupTime.text = pickupTime
        }else if isForBookShareRide{
            lblPickupTimeTitle.text = "No of seats"
            lblPickupTime.text = "1 Seat"
        }
        
        lblPageTitle.text = "\(vehicleType!), \(waitingTime) away"
        
        self.serviceCallToGetFareDetails()
        
        //Hide date Picker initially
        viewDatePicker.isHidden = true
        viewDatePickerBottomConstraint.constant = -190
        
        googleMapView.delegate = self
        dropLocationTf.delegate = self
        
        self.pickUpLocationTf.text = self.pickUpAddress
        self.dropLocationTf.text = self.dropAddress
        
        selectedCarView.layer.cornerRadius = selectedCarView.frame.size.width / 2
        selectedCarView.clipsToBounds = true
        
        btnConfirmBooking.layer.cornerRadius = 3
        btnConfirmBooking.clipsToBounds = true
        
        viewPickUpLocation.layer.cornerRadius = 3
        viewPickUpLocation.clipsToBounds = true
        viewDropLocation.layer.cornerRadius = 3
        viewDropLocation.clipsToBounds = true
        
        googleMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.googleMapView.settings.myLocationButton = false
        
        arrLocations.append(pickUpCoordinate!)
        arrLocations.append(dropCoordinate!)
        
        lblSelectedCar?.text = vehicleType
        
        if (vehicleType == "Share") {
            self.selectedCarImgView.image = UIImage(named:"car_share_blue")!
        }else if (vehicleType == "Micro") {
            self.selectedCarImgView.image = UIImage(named:"car_micro_blue")!
        }else if (vehicleType == "Mini") {
            self.selectedCarImgView.image = UIImage(named:"car_mini_blue")!
        }else{
            self.selectedCarImgView.image = UIImage(named:"car_sedan_blue")!
        }
        
        if (AppConstant.currentBookRideForSelectedType == "") {
            lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
            lblBookRideForContact?.text = "Myself"
        }
        else {
            if (AppConstant.currentBookRideForSelectedType == "book_ride_for") {
                lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 14.0)
                lblBookRideForContact?.text = AppConstant.bookRideForContactName
            }
            else {
                lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
                lblBookRideForContact?.text = "Myself"
            }
        }
        
        print(totalFare)
        self.lblTotalFare.text = String(format: "Rs %@/-", totalFare)
        lblPickupTime.text = pickupTime
        
        if (AppConstant.screenSize.height <= 568) {
            lblApplyCoupon.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
            lblPaymentMode.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
            lblBookRideFor.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
            lblTotalFare.font = UIFont.init(name: "Poppins-Regular", size: 9.0)
        }
        
        //Show Traffic Data
        // self.googleMapView.isTrafficEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(RouteScreenController.getBookingConfirmation(notification:)), name: Notification.Name("reloadNotification"), object: nil)
        
        var tap1 = UITapGestureRecognizer(target: self, action: #selector(self.setPickupTime))
        if isForBookShareRide {
            tap1 = UITapGestureRecognizer(target: self, action: #selector(self.chooseSeats))
        }
        self.viewPickupTime?.isUserInteractionEnabled = true
        self.viewPickupTime?.addGestureRecognizer(tap1)
        
        // Adding webView content
        do {
            guard let filePath = Bundle.main.path(forResource: "googleMapTrafficDirection", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webViewGoogleMap.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
        
        
    }

    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == dropLocationTf {
            showGooglePlacesAutoCompleteViewController()
        }
        
    }
    func showGooglePlacesAutoCompleteViewController() {
        let placeholderAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        let attributedPlaceholder = NSAttributedString(string: "Enter drop location", attributes: placeholderAttributes)
        if let aClass = [UISearchBar.self] as? [UIAppearanceContainer.Type] {
            if #available(iOS 9.0, *) {
                UITextField.appearance(whenContainedInInstancesOf: aClass).attributedPlaceholder = attributedPlaceholder
            } else {
                // Fallback on earlier versions
            }
        }
        
        let acController = GMSAutocompleteViewController()
        let bounds: GMSCoordinateBounds = getCoordinateBounds(latitude: (pickUpCoordinate?.latitude)!, longitude: (pickUpCoordinate?.longitude)!)
        acController.autocompleteBounds = GMSCoordinateBounds(coordinate: bounds.northEast, coordinate: bounds.southWest)
        
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    /* Returns Bounds */
    func getCoordinateBounds(latitude:CLLocationDegrees ,
                             longitude:CLLocationDegrees,
                             distance:Double = 0.01)->GMSCoordinateBounds{
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + distance, longitude: center.longitude + distance)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - distance, longitude: center.longitude - distance)
        
        return GMSCoordinateBounds(coordinate: northEast,
                                   coordinate: southWest)
        
    }
    
    // MARK: - AutocompleteViewController Delegate
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place latitude: \(String(describing: place.coordinate.latitude))")
        print("Place longitude: \(String(describing: place.coordinate.longitude))")
        self.dropLocationTf.text = place.formattedAddress
        self.dropCoordinate = place.coordinate
        
        //Update the location array
        arrLocations.removeLast()
        arrLocations.append(dropCoordinate!)
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude ,longitude: place.coordinate.longitude , zoom: 13)
        self.googleMapView.animate(to: camera)
        
        self.isAddressChanged = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // handle the error.
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Google Map Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        //googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
        
//        showMultipleRoute(startLocation: pickUpCoordinate!, endLocation: dropCoordinate!)
        
       // If User Changes Destination
//        drawPath(startLocation: pickUpCoordinate!, endLocation: dropCoordinate!)
//
//        setBoundsForMap()
        
        locationManager.stopUpdatingLocation()
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                print(location)
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks!.count) > 0 {
                    let pm = placemarks?[0]
                    print("you are in city ->",String(describing: pm!.locality))
                    self.currentCity = pm!.locality
                    
                    if (self.isAddressChanged == true) {
                        self.isAddressChanged = false
                        self.serviceCallToGetFareDetails()
                    }
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func handleUserCurrentLocationTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let lat = self.googleMapView.myLocation?.coordinate.latitude,
            let lng = self.googleMapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 13)
        self.googleMapView.animate(to: camera)
        
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = UIImage.init(named: "map_pin")
        marker.map = googleMapView
    }
    
    // MARK: Set bounds for Map
    func setBoundsForMap() {
        var bounds = GMSCoordinateBounds()
        for var i in (0..<arrLocations.count)
        {
            let location = arrLocations[i]
            
            let latitude = location.latitude
            let longitude = location.longitude
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
            marker.map = self.googleMapView
            if i == 1 {
                marker.icon = UIImage.init(named: "map_pin")
            }else{
                marker.icon = UIImage.init(named: "map_pin_green")
            }
            
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 70)
        self.googleMapView.animate(with: update)
    }
    
    //MARK: - Draw direction path, from start location to desination location
    func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D)
    {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(AppConstant.GoogleMapApiKey)"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            if let json = try? JSON(data: response.data!) {
                let routes = json["routes"].arrayValue
                print("Direction Response \(json)")
                
                // print route using Polyline
                for route in routes
                {
                    let arrlegs = route["legs"].arrayValue
                    let dict = arrlegs[0]
                    let distanceDict = dict["distance"].dictionary
                    let distance = distanceDict!["text"]?.string
                    print(distance as Any)
                    let durationDict = dict["duration"].dictionary
                    let duration = durationDict!["text"]?.string
                    print(duration as Any)
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    self.path = GMSPath.init(fromEncodedPath: points!)!
                    self.polyline = GMSPolyline.init(path: self.path)
                    self.polyline.strokeWidth = 3
                    self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    
                    self.polyline.map = self.googleMapView
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
                }
            }
            
        }
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.googleMapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    /*
    func showMultipleRoute(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D)
    {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(AppConstant.GoogleMapApiKey)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    self.googleMapView.clear()
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.googleMapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.googleMapView
                            
                        }
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }*/
    
    //MARK: - Button Action
    
    @IBAction func btnConfirmBookingAction(_ sender: Any) {
        //Move to DriverInfo Screen
        
        self.selectedCarView.isHidden = true
        self.viewConfirmBooking.isHidden = true
        self.viewFindingDriver.isHidden = false
        self.viewBottomHeight.constant = 0
        self.progressBar.wait()

        
        viewDriverInfo.showAnimatedGradientSkeleton()
        lblDriverName.showAnimatedGradientSkeleton()
        lblVehicleName.showAnimatedGradientSkeleton()
        lblVehicleNumber.showAnimatedGradientSkeleton()
        //lblOTP.showAnimatedGradientSkeleton()
        lblRating.showAnimatedGradientSkeleton()
        cancelRideBtn.showAnimatedGradientSkeleton()
        
        self.serviceCallToConfirmBooking()
        
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0, execute: {
            self.viewFindingDriver.isHidden = true
            self.progressBar.signal()
//            self.performSegue(withIdentifier: "driverinfo", sender: self)
            self.serviceCallToConfirmBooking()
            
            AppConstant.isTokenVerified(completion: { (Bool) in
                if Bool{
                    self.serviceCallToConfirmBooking()
                }
            })
        })*/
        
    }
    
    @IBAction func btnDropLocationSearchAction(_ sender: Any) {
        showGooglePlacesAutoCompleteViewController()
    }
    
    
    @IBAction func btnCancelRequestAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelRidePopupViewController") as! CancelRidePopupViewController
//        vc.fareInfoArray = self.fareInfoArray
//        vc.totalFare = self.totalFare
//        vc.info = self.info
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        vc.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        vc.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            vc.view.alpha = 1.0
            vc.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        //AppConstant.showAlertForCancelBooking()
//        AppConstant.isTokenVerified(completion: { (Bool) in
//            if Bool{
//                self.serviceCallToCancelBooking()
//            }
//        })
    }

    @IBAction func btnBackAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func totalFareViewAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FareDetailsViewController") as! FareDetailsViewController
        vc.arrFareDettails = self.arrFareDettails
        vc.totalFare = self.totalFare
        vc.info = self.info
        vc.taxValue = self.taxValue
        vc.vehicleType = self.vehicleType
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        vc.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        vc.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            vc.view.alpha = 1.0
            vc.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
    }
    
    @IBAction func viewBookRideForAction(_ sender: Any) {
        viewbackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewbackground.isHidden = false
        self.performSegue(withIdentifier: "book_ride_for", sender: self)
    }
    
    @IBAction func viewPaymentModeAction(_ sender: Any) {
        viewbackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewbackground.isHidden = false
        self.performSegue(withIdentifier: "payment_mode", sender: self)
    }
    
    @IBAction func viewApplyCouponAction(_ sender: Any) {
        self.performSegue(withIdentifier: "apply_coupon", sender: self)
    }
    
    @objc func chooseSeats() {
        viewbackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewbackground.isHidden = false
        self.performSegue(withIdentifier: "choose_seats", sender: self)
    } 
    
    @objc func setPickupTime() {
        dateTimePicker.minimumDate = Date()
        dateTimePicker.maximumDate = Date().add(days: 2)//User can book a cab before 2 days only
        viewDatePicker.animShow()
        
        viewbackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewbackground.isHidden = false
    }
    
    @IBAction func datePickerCancelBtnAction(_ sender: Any) {
        viewDatePicker.animHide()
        viewbackground.isHidden = true
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: Any) {
        viewDatePicker.animHide()
        viewbackground.isHidden = true
        isForBookLater = true
        
        pickupTime = AppConstant.formattedDate(date: dateTimePicker.date, withFormat: StringConstant.dateFormatter1, ToFormat: StringConstant.dateFormatter3)!
        lblPickupTime.text = pickupTime
    }
    
    //MARK: Choose Contact Protocol Delegates
    func selectedObject(obj: BookRideForContactBO, type: String) {
        viewbackground.isHidden = true
        AppConstant.currentBookRideForSelectedType = type
        if (type == "book_ride_for") {
            if (obj.name == nil) {
                if (AppConstant.bookRideForContactName == "") {
                    lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
                    lblBookRideForContact?.text = "Myself"
                    AppConstant.bookRideForContactSelectedStatus = "1"
                }
                else {
                    lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 14.0)
                    lblBookRideForContact?.text = AppConstant.bookRideForContactName
                    AppConstant.bookRideForContactSelectedStatus = "2"
                }
            }
            else {
                lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 14.0)
                lblBookRideForContact?.text = obj.name!
                AppConstant.bookRideForContactSelectedStatus = "2"
            }
        }
        else if (type == "Myself") {
            lblBookRideForContact?.font = UIFont.init(name: "Poppins-Semibold", size: 15.0)
            lblBookRideForContact?.text = "Myself"
            AppConstant.bookRideForContactSelectedStatus = "1"
        }
    }
    
    //MARK: Choose Seats Protocol Delegates
    func selectedSeats(seats: Int) {
        viewbackground.isHidden = true
        lblPickupTime.text = String(seats)
    }
    
    //MARK: Applied Coupon Protocol Delegates
    func appliedCoupon(couponBo: CouponBO) {
        promoCode = couponBo
        isCouponApplied = true
        lblAppliedCoupon.text = couponBo.title
        imgViewCoupon.isHidden = true
        lblAppliedCoupon.isHidden = false
        lblApplyCoupon.text = "Coupon Applied"
        self.serviceCallToGetFareDetails()
        
    }
    
    //MARK: Choose Payment Mode Protocol Delegates
    func selectedPaymentMode(pMode: String) {
        viewbackground.isHidden = true
        
        AppConstant.selectedPaymentMode = pMode
        lblPaymentModeOption?.text = pMode
    }
    
    // MARK: - Animation Method
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    // MARK: - Service Call Method
    func serviceCallToConfirmBooking() {
        if AppConstant.hasConnectivity() {
           // AppConstant.showHUD()
            DispatchQueue.main.async {
                self.viewFindingDriver.isHidden = false
                self.progressBar.wait()
            }
            
            let pickUPAddress = self.pickUpLocationTf.text!
            let pickLat : NSNumber = NSNumber(value: (pickUpCoordinate?.latitude)!)
            let pickLng : NSNumber = NSNumber(value: (pickUpCoordinate?.longitude)!)
            let dropAddress = self.dropLocationTf.text!
            let dropLat : NSNumber = NSNumber(value: (dropCoordinate?.latitude)!)
            let dropLng : NSNumber = NSNumber(value: (dropCoordinate?.longitude)!)
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "book_now" : "1",
                "book_for" : "1",
                "pay_mode" : "1",
                "ride_id" : "0",
                "cat_id" : vehicleTypeId,
                "city" : self.currentCity!,
                "src_lat" : String(describing: pickLat),
                "src_lon" : String(describing: pickLng),
                "des_lat" : String(describing: dropLat),
                "des_lon" : String(describing: dropLng),
                "src_loc" : String(describing: pickUPAddress),
                "des_loc" : String(describing: dropAddress),
                "promo_code" : isCouponApplied ? promoCode.title : ""
            ]
            
            print("Url===\(AppConstant.confirmBookingUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.confirmBookingUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                   // AppConstant.hideHUD()
                    
                    DispatchQueue.main.async {
                        self.viewFindingDriver.isHidden = false
                        self.progressBar.signal()
                    }
                    
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        debugPrint(dict!)
                        
                        if let status = dict?["status"] as? String {
                            if(status == "0"){
                                let msg = dict?["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                                
                            }else  if(status == "1"){
                                if let bookingId = dict?["book_id"] as? String {
                                    AppConstant.saveInDefaults(key: StringConstant.book_id, value: bookingId)
                                }
                                if let waitTime = dict?["wait_time"] as? Int {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 190) { // change 30 to desired number of seconds
                                        if(!AppConstant.isBookingConfirm){
                                            //Call api to confirm your booking
                                            self.serviceCallToGetBookingDetails()
                                            //                                        AppConstant.isBookingConfirm = false
                                            //                                        self.performSegue(withIdentifier: "driverinfo", sender: self)
                                        }
                                        
                                    }
                                }
                                
                            }else  if(status == "2"){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    /*
    func serviceCallToConfirmBooking() {
        if AppConstant.hasConnectivity() {
            // AppConstant.showHUD()
            DispatchQueue.main.async {
                self.viewFindingDriver.isHidden = false
                self.progressBar.wait()
            }
            
            let pickUPAddress = self.pickUpLocationTf.text
            let pickLat : NSNumber = NSNumber(value: (pickUpCoordinate?.latitude)!)
            let pickLng : NSNumber = NSNumber(value: (pickUpCoordinate?.longitude)!)
            let dropAddress = self.dropLocationTf.text
            let dropLat : NSNumber = NSNumber(value: (dropCoordinate?.latitude)!)
            let dropLng : NSNumber = NSNumber(value: (dropCoordinate?.longitude)!)
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id"),
                "pickup_latitude" : String(describing: pickLat),
                "pickup_longitude" : String(describing: pickLng),
                "drop_latitude" : String(describing: dropLat),
                "drop_longitude" : String(describing: dropLng),
                "pickup_address" : String(describing: pickUPAddress),
                "drop_address" : String(describing: dropAddress),
                "category_id" : vehicleTypeId,
                "city_id" : self.cityId
            ]
            
            
            print("params===\(params)")
            
            Alamofire.request( AppConstant.confirmBookingUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    // AppConstant.hideHUD()
                    DispatchQueue.main.async {
                        self.viewFindingDriver.isHidden = true
                        self.progressBar.signal()
                    }
                    
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let arrData = AppConstant.convertToArray(text: response.result.value!)
                        let dict = arrData![0] as Dictionary
                        
                        if let status = dict["status"] as? Int {
                            if(status == 0){
                                let msg = dict["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, delegate: self)
                            }else  if(status == 1){
                                
                                if let driver_name = dict["driver_name"] as? String {
                                    self.driverProfileBo.driver_name = driver_name
                                }
                                if let image = dict["image"] as? String {
                                    self.driverProfileBo.image = image
                                }
                                if let driver_mobile = dict["driver_mobile"] as? String {
                                    self.driverProfileBo.driver_mobile = driver_mobile
                                }
                                if let driver_latitude = dict["driver_latitude"] as? String {
                                    self.driverProfileBo.driver_latitude = driver_latitude
                                }
                                if let driver_longitude = dict["driver_longitude"] as? String {
                                    self.driverProfileBo.driver_longitude = driver_longitude
                                }
                                if let driver_address = dict["driver_address"] as? String {
                                    self.driverProfileBo.driver_address = driver_address
                                }
                                if let driver_id = dict["driver_id"] as? String {
                                    self.driverProfileBo.driver_id = driver_id
                                }
                                if let imagepath = dict["imagepath"] as? String {
                                    self.driverProfileBo.imagepath = imagepath
                                }
                                //Move to DriverInfo Screen
                                self.performSegue(withIdentifier: "driverinfo", sender: self)
                                
                            }else  if(status == 2){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: response.result.error! as! String, delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }*/
    
    func serviceCallToCancelBooking() {
        AppConstant.isBookingConfirm = false
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id")
            ]
            
            
            print("params===\(params)")
            
            Alamofire.request( AppConstant.cancelBookingUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    DispatchQueue.main.async {
                        self.viewFindingDriver.isHidden = true
                        self.progressBar.signal()
                    }
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let arrData = AppConstant.convertToArray(text: response.result.value!)
                        let dict = arrData![0] as Dictionary
                        if let status = dict["status"] as? Int {
                            if(status == 0){
                                let msg = dict["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == 1){
//                                AppConstant.showAlert(strTitle: "Your Booking has cancelled", delegate: self)
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.goToMainScreen()
                                AppConstant.showAlertForCancelBooking()
                                
                            }else  if(status == 2){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        let error = response.result.error!
                        AppConstant.showAlert(strTitle: error.localizedDescription, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    func serviceCallToGetBookingDetails() {
//        AppConstant.isBookingConfirm = false
        if AppConstant.hasConnectivity() {
            DispatchQueue.main.async {
                self.viewFindingDriver.isHidden = false
                self.progressBar.wait()
            }
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "book_id" : AppConstant.retrievFromDefaults(key: StringConstant.book_id)
            ]
            
            print("params===\(params!)")
            print("Api===\(AppConstant.getBookingDetails)")
            
            Alamofire.request( AppConstant.getBookingDetails, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    DispatchQueue.main.async {
                        self.viewFindingDriver.isHidden = true
                        self.progressBar.signal()
                    }
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? String {
                            if(status == "1"){//Success
                                
                                if let dictDriverInfo = dict!["driver_info"] as? [String: Any]{
                                    if let driver_id = dictDriverInfo["driver_id"] as? String {
                                        self.bokingStatusBo.driverBo.driver_id = driver_id
                                    }
                                    if let driver_name = dictDriverInfo["driver_name"] as? String {
                                        self.bokingStatusBo.driverBo.driver_name = driver_name
                                    }
                                    if let driver_mobile = dictDriverInfo["driver_mobile"] as? String {
                                        self.bokingStatusBo.driverBo.driver_mobile = driver_mobile
                                    }
                                    if let driver_rating = dictDriverInfo["driver_rating"] as? String {
                                        self.bokingStatusBo.driverBo.driver_rating = driver_rating
                                    }
                                    if let driver_image = dictDriverInfo["driver_image"] as? String {
                                        self.bokingStatusBo.driverBo.driver_image = driver_image
                                    }
                                    if let vehcile_reg_no = dictDriverInfo["vehcile_reg_no"] as? String {
                                        self.bokingStatusBo.driverBo.vehcile_registration_number = vehcile_reg_no
                                    }
                                    if let vehcile_brand_name = dictDriverInfo["vehcile_brand_name"] as? String {
                                        self.bokingStatusBo.driverBo.vehcile_brand_name = vehcile_brand_name
                                    }
                                    if let vehcile_model_name = dictDriverInfo["vehcile_model_name"] as? String {
                                        self.bokingStatusBo.driverBo.vehcile_model_name = vehcile_model_name
                                    }
                                    if let vehicle_image = dictDriverInfo["vehicle_image"] as? String {
                                        self.bokingStatusBo.driverBo.vehicle_image = vehicle_image
                                    }
                                }
                                
                                //Move to DriverInfo Screen
                                self.performSegue(withIdentifier: "driverinfo", sender: self)
                                
                            }else if(status == "3"){//Logout
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    func serviceCallToVerifyToken() {
        if AppConstant.hasConnectivity() {
            //AppConstant.showHUD()
            var params: Parameters!
            params = [
                "token" : AppConstant.retrievFromDefaults(key: "token"),
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id")
            ]
            print("params===\(params)")
            
            Alamofire.request( AppConstant.tokenVarificationUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToArray(text: response.result.value!)
                        //debugPrit(dict)
                        let dataArray = dict![0] as Dictionary
                        
                        if let status = dataArray["status"] as? Int {
                            if(status == 0){
                                let msg = dataArray["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == 1){
                               // self.serviceCallToGetFairDetails()
                                
                            }else  if(status == 2){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        let error = response.result.error!
                        AppConstant.showAlert(strTitle: error.localizedDescription, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
    }
    
    func serviceCallToGetDriverLocation() {
        if AppConstant.hasConnectivity() {
            //  AppConstant.showHUD()
            let address = self.pickUpLocationTf.text
            let lat : NSNumber = NSNumber(value: (pickUpCoordinate?.latitude)!)
            let lng : NSNumber = NSNumber(value: (pickUpCoordinate?.longitude)!)
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id"),
                "latitude" : String(describing: lat),
                "longitude" : String(describing: lng),
                "address" : address!,
                "device_id" : AppConstant.retrievFromDefaults(key: "APNID"),
                "device_type" : "iOS"
                
            ]
            print("params===\(params)")
            
            Alamofire.request( AppConstant.cabLocationInfoUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        //debugPrint(dict)
                        
                        if let status = dict!["status"] as? Int {
                            if(status == 0){
                                let msg = dict!["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == 1){
                                
                               
                                
                            }else  if(status == 2){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    func serviceCallToGetFareDetails() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let pickUPAddress = self.pickUpLocationTf.text!
            let pickLat : NSNumber = NSNumber(value: (pickUpCoordinate?.latitude)!)
            let pickLng : NSNumber = NSNumber(value: (pickUpCoordinate?.longitude)!)
            let dropAddress = self.dropLocationTf.text!
            let dropLat : NSNumber = NSNumber(value: (dropCoordinate?.latitude)!)
            let dropLng : NSNumber = NSNumber(value: (dropCoordinate?.longitude)!)
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "src_lat" : String(describing: pickLat),
                "src_lon" : String(describing: pickLng),
                "des_lat" : String(describing: dropLat),
                "des_lon" : String(describing: dropLng),
                "ride_id" : "0",
                "cat_id" : vehicleTypeId,
                "city" : self.currentCity!,
                "promo_code" : isCouponApplied ? promoCode.title : ""
            ]
            print("url===\(AppConstant.getFareDetailsUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getFareDetailsUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        debugPrint(dict!)
                        //                        let dict = dataArray![0] as Dictionary
                        self.arrFareDettails.removeAll()
                        if let status = dict?["status"] as? String {
                            if(status == "0"){
                                let msg = dict?["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == "1"){
                                if let totalFare = dict?["cost"] as? Int {
                                    self.totalFare = "\(totalFare)"
                                    self.lblTotalFare.text = String(format: "Rs %@/-", self.totalFare)
                                    debugPrint(self.totalFare)
                                }
                                if let taxValue = dict?["tax"] as? Int {
                                    self.taxValue = "\(taxValue)"
                                    debugPrint(self.taxValue)
                                }
                                if let info = dict?["info_str"] as? String {
                                    self.info = info
                                    debugPrint(self.info)
                                }
                                if let fareInfoArray = dict?["info_arry"] as? [[String: Any]]{
                                    debugPrint(fareInfoArray)
                                    for item in fareInfoArray {
                                        let fareDetailsBo = FareDetails()
                                        
                                        if let titleKey = item["key"] as? String {
                                            fareDetailsBo.title = titleKey.replacingOccurrences(of: "&#x20b9;", with: "₹ ")
                                        }
                                        if let value = item["value"] as? String {
                                            fareDetailsBo.price = value
                                        }
                                        else if let value = item["value"] as? Int {
                                            fareDetailsBo.price = "\(value)"
                                        }
                                        self.arrFareDettails.append(fareDetailsBo)
                                    }
                                }
                                
                            }else  if(status == "2"){
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToLandingScreen()
                            }
                        }
                        
                        break
                        
                    case .failure(_):
                        AppConstant.showAlert(strTitle: (response.result.error?.localizedDescription)!, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
        
    }
    
    @objc func getBookingConfirmation(notification: Notification){
        self.serviceCallToGetBookingDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "driverinfo"{
            let vc = segue.destination as! DriverInfoScreenController
            vc.pickUpCoordinate = self.pickUpCoordinate
            vc.dropCoordinate = self.dropCoordinate
            vc.pickUpAddress = self.pickUpLocationTf.text
            vc.dropAddress = self.dropLocationTf.text
            vc.driverProfileBo = self.bokingStatusBo.driverBo
        }
        else if (segue.identifier == "book_ride_for"){
            let vc = segue.destination as! BookRideForViewController
            vc.delegate = self
            vc.type = segue.identifier!
        }
        else if (segue.identifier == "choose_seats"){
            let vc = segue.destination as! ChooseSeatsViewController
            vc.delegate = self
        }
        else if (segue.identifier == "payment_mode"){
            let vc = segue.destination as! PaymentModeViewController
            vc.delegate = self
        }
        else if (segue.identifier == "apply_coupon"){
            let vc = segue.destination as! ApplyCouponViewController
            vc.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
}

extension UIView {
    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
