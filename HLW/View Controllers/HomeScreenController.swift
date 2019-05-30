//
//  HomeScreenController.swift
//  Taxi Booking
//
//  Created by OdiTek Solutions on 26/12/17.
//  Copyright © 2017 OdiTek Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacesSearchController
import Alamofire
import SDWebImage

class HomeScreenController: UIViewController , CLLocationManagerDelegate , GMSMapViewDelegate , UITextFieldDelegate , GMSAutocompleteViewControllerDelegate , SlideMenuControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChoosePreviousBookedLocationDelegate {
    
    @IBOutlet weak var oneWayBtn: UIButton!
    @IBOutlet weak var rentalsBtn: UIButton!
    @IBOutlet weak var bookLaterBtn: UIButton!
    @IBOutlet weak var bookNowBtn: UIButton!
    @IBOutlet weak var myLocationView: UIView!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var pickUpLocationTf: UITextField!
    @IBOutlet weak var dropLocationTf: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var mapPinView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var viewNavBar: UIView!
    @IBOutlet var dropLocationView: UIView!
    @IBOutlet var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var dropLocationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet var viewDatePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var dateTimePicker: UIDatePicker!
    @IBOutlet var viewbackground: UIView!
    @IBOutlet var imgViewMyCurrentLocation: UIImageView!
    @IBOutlet var btnBookNowWidthConstraint: NSLayoutConstraint!
    @IBOutlet var lblBookLaterInfo: UILabel!
    @IBOutlet var viewRentalCar: UIView!
    @IBOutlet var viewRentalCarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewRentals: UIView!
    @IBOutlet var viewRentalsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rentalBookLaterBtn: UIButton!
    @IBOutlet weak var rentalBookNowBtn: UIButton!
    @IBOutlet var viewHourlyPackages: UIView!
    @IBOutlet var viewMultipleStops: UIView!
    @IBOutlet var viewAlwaysAvailable: UIView!
    @IBOutlet var myLocationViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var lblHourlyPackages: UILabel!
    @IBOutlet var lblMultipleStops: UILabel!
    @IBOutlet var lblAlwaysAvailable: UILabel!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewRentalsBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var vehicleTypeCollectionView: UICollectionView!
    @IBOutlet var lblNoOfActiveBookings: UILabel!
    @IBOutlet var viewActiveBookings: UIView!
    @IBOutlet var viewServiceUnavailable: UIView!
    @IBOutlet var viewServiceUnavailableVehicle: UIView!
    @IBOutlet var lblServiceUnavailableMsg: UILabel!
    
    var currentCity : String = ""
    var vehicleType : String = ""
    var vehicleTypeId : String = ""
    var totalFare : String = ""
    var info : String = ""
    var fareInfoArray = [Dictionary<String, Any>]()
    var cityId : String = ""
    var userid : String = ""
    var token : String = ""
    var locationManager = CLLocationManager()
    var selectedTf : String!
    var isPinShowPickUp : Bool = true
    var isPinShowDrop : Bool = false
    var hasGotDriverLocations : Bool = false
    var isFromAutoCompleteViewController : Bool = false
    var pickUpCoordinate : CLLocationCoordinate2D? = nil
    var dropCoordinate : CLLocationCoordinate2D? = nil
    var currentCoordinate : CLLocationCoordinate2D? = nil
    var arrCabInfo : [CabLocationBO] = []
    var driverProfileBo = DriverProfileBO()
//    var arrVehicleType = [VehicleTypeBO]()
    var arrTime = [Int]()
    var myCurrentLocation: CLLocation? = nil
    var isForBookLater : Bool = false
    var isForBookShareRide : Bool = false
    var isForOneWay : Bool = true
    var pickupTime: String = ""
    var lastZoom: CGFloat = 15
    var currentAddress: String = ""
    var selectedVehicleTypeIndex: Int! = 1
    var waitingTime: String = ""
    var isFromPrevBookLoc : Bool = false
    var activeBookingCount = "0"
    var isServiceAvailable : Bool = true
    
    var movingcar: UIImage = UIImage.init(named: "sedan_car")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDesign()
        
        let image = UIImage.init(named: "sedan_car")
        movingcar = (image?.rotate(radians: .pi/2))!
    }
    
    override func viewDidLayoutSubviews() {
        
        bottomView.addshadow(top: true, left: false, bottom: false, right: false, shadowRadius: 1.0)
        //        topView.addshadow(top: false, left: true, bottom: true, right: true, shadowRadius: 2.0)
        //        topView.layer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 7)
        //        topView.clipsToBounds = true
        
        
        topView.setShadowWithCornerRadius(corners: 20.0)
        
        
        //        topView.layer.addBorder(edge: .left, color: AppConstant.colorThemeLightGray, thickness: 2.0)
        //        topView.layer.addBorder(edge: .bottom, color: AppConstant.colorThemeLightGray, thickness: 2.0)
        //        topView.layer.addBorder(edge: .right, color: AppConstant.colorThemeLightGray, thickness: 2.0)
        
        //        bottomView.layer.addBorder(edge: .top, color: AppConstant.colorThemeLightGray, thickness: 0.5)
        
        //        topView.layer.shadowColor = UIColor.black.cgColor
        //        topView.layer.shadowOpacity = 1
        //        topView.layer.shadowOffset = CGSize.zero
        //        topView.layer.shadowRadius = 5.0
        //        topView.layer.shadowPath = UIBezierPath(roundedRect: topView.bounds, cornerRadius: 5.0).cgPath
        //        topView.layer.shouldRasterize = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and Add MapView to our main view
        // createMapView()
        //        let car1Location = CLLocationCoordinate2D(latitude: 20.2981806657416, longitude: 85.8576580882072)
        //        let car2Location = CLLocationCoordinate2D(latitude: 20.2949769603599, longitude: 85.8567551895976)
        //        animateVehiceLocation(oldCoodinate: car1Location, newCoodinate: car2Location)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initDesign(){
        self.vehicleTypeCollectionView.isHidden = true
        self.addressLabel.text = "Getting address..."
        
        //Manage for iPhone X
        if (AppConstant.screenSize.height >= 812) {
            navBarHeightConstraint.constant = 92
            viewRentalsBottomSpaceConstraint.constant = 34
            viewBottomBottomSpaceConstraint.constant = 34
        }
        
        //Hide Book Later
//        btnBookNowWidthConstraint.constant = -AppConstant.screenSize.width
//        lblBookLaterInfo.isHidden = true
        
        
        //Service call to verify Booking Status
//        serviceCallToVerifyBookingStatus()
        //self.googleMapView.addObserver(self, forKeyPath: "camera.zoom", options: [], context: nil)
        
//        createMarker(titleMarker: "", iconMarker: UIImage.init(named: "car_map")!, latitude:"20.295811" , longitude: "85.857744")
//
//        createMarker(titleMarker: "", iconMarker: UIImage.init(named: "car_map")!, latitude:"20.293795" , longitude: "85.859535")
        
        self.bookNowBtn.isEnabled = false
        self.viewServiceUnavailable.isHidden = true
        self.viewActiveBookings.isHidden = true
        
        googleMapView.delegate = self
        pickUpLocationTf.delegate = self
        dropLocationTf.delegate = self
        
        oneWayBtn.layer.cornerRadius = 3
        oneWayBtn.layer.borderColor = UIColor.white.cgColor
        oneWayBtn.layer.borderWidth = 1
        oneWayBtn.clipsToBounds = true
        
        rentalsBtn.layer.cornerRadius = 3
        rentalsBtn.layer.borderColor = UIColor.white.cgColor
        rentalsBtn.layer.borderWidth = 1
        rentalsBtn.clipsToBounds = true
        
        viewRentalCar.layer.cornerRadius = viewRentalCar.frame.size.width / 2
        viewRentalCar.clipsToBounds = true
        
        viewHourlyPackages.layer.cornerRadius = 5
        viewHourlyPackages.clipsToBounds = true
        
        viewMultipleStops.layer.cornerRadius = 5
        viewMultipleStops.clipsToBounds = true
        
        viewAlwaysAvailable.layer.cornerRadius = 5
        viewAlwaysAvailable.clipsToBounds = true
        
        lblNoOfActiveBookings.layer.cornerRadius = lblNoOfActiveBookings.frame.size.width / 2
        lblNoOfActiveBookings.clipsToBounds = true
        
        viewActiveBookings.layer.cornerRadius = 5
        viewActiveBookings.clipsToBounds = true
        viewActiveBookings.layer.borderColor = AppConstant.colorThemeSeparatorGray.cgColor
        viewActiveBookings.layer.borderWidth = 0.5
        
        viewServiceUnavailableVehicle.layer.cornerRadius = viewServiceUnavailableVehicle.frame.size.width / 2
        viewServiceUnavailableVehicle.clipsToBounds = true
        
        viewRentalCar.isHidden = true
        viewRentalCarHeightConstraint.constant = 0
        viewRentals.isHidden = true
        viewRentalsHeightConstraint.constant = 0
        
        myLocationView.layer.borderColor = UIColor.lightGray.cgColor
        myLocationView.layer.borderWidth = 1
        myLocationView.layer.cornerRadius = myLocationView.frame.size.width / 2
        myLocationView.clipsToBounds = true
        
        if (AppConstant.screenSize.height <= 568) {
            lblHourlyPackages.font = UIFont.init(name: "Poppins-Medium", size: 9.0)
            lblMultipleStops.font = UIFont.init(name: "Poppins-Medium", size: 9.0)
            lblAlwaysAvailable.font = UIFont.init(name: "Poppins-Medium", size: 9.0)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        selectedTf = "Pickup"
        
        let userCurrentLocation = UITapGestureRecognizer(target: self, action: #selector(self.handleUserCurrentLocationTap(_:)))
        self.myLocationView?.isUserInteractionEnabled = true
        self.myLocationView?.addGestureRecognizer(userCurrentLocation)
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        
        vehicleType = "Micro"
        vehicleTypeId = "1"
        AppConstant.selectedVehicleImgName = "auto_pin"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableDragFromNotification(notification:)), name: Notification.Name("DisableMapFromDragNotification"), object: nil)
        
        viewDatePicker.isHidden = true
        viewDatePickerBottomConstraint.constant = -190
        
//        loadVehicleType()
        selectedVehicleTypeIndex = 1
        
        
        //set Micro auto select
        //self.btnVehicleActiob(btnMicro)
        
        //        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        //        let statusBarColor = UIColor(red: 108/255, green: 163/255, blue: 38/255, alpha: 1.0)
        //        statusBarView.backgroundColor = statusBarColor
        //        view.addSubview(statusBarView)
        
        //        let myLocationButton: UIButton? = googleMapView.
        //        if myLocationButton != nil {
        //            myLocationButton?.setImage(UIImage(named: "map_options_button_mylocation_default"), for: .normal)
        //        }
    }
    
    
    // MARK: - Button Action
    @IBAction func btnOneWayAction(_ sender: UIButton) {
        isForOneWay = true
        topViewHeightConstraint.constant = 101
        dropLocationViewHeightConstraint.constant = 50
        rentalsBtn.backgroundColor = UIColor.clear
        rentalsBtn.setTitleColor(UIColor.white, for: .normal)
        oneWayBtn.backgroundColor = UIColor.white
        oneWayBtn.setTitleColor(AppConstant.colorThemeBlue, for: .normal)
        dropLocationView.isHidden = false
        viewRentalCar.isHidden = true
        viewRentalCarHeightConstraint.constant = 0
        viewRentals.isHidden = true
        viewRentalsHeightConstraint.constant = 0
        myLocationViewBottomConstraint.constant = 13
        
        if isServiceAvailable{
            self.viewActiveBookings.isHidden = activeBookingCount == "0" ? true : false
        }
        
        //Hide Book Later
//        btnBookNowWidthConstraint.constant = -AppConstant.screenSize.width
//        lblBookLaterInfo.isHidden = true
    }
    
    @IBAction func btnRentalAction(_ sender: UIButton) {
        isForOneWay = false
        topViewHeightConstraint.constant = 50
        dropLocationViewHeightConstraint.constant = 0
        oneWayBtn.backgroundColor = UIColor.clear
        oneWayBtn.setTitleColor(UIColor.white, for: .normal)
        rentalsBtn.backgroundColor = UIColor.white
        rentalsBtn.setTitleColor(AppConstant.colorThemeBlue, for: .normal)
        dropLocationView.isHidden = true
        viewRentalCar.isHidden = false
        viewRentalCarHeightConstraint.constant = 75
        viewRentals.isHidden = false
        viewRentalsHeightConstraint.constant = 175
        myLocationViewBottomConstraint.constant = 70
        
        if isServiceAvailable{
            self.viewActiveBookings.isHidden = true
        }
        
        //Show Book Later
        btnBookNowWidthConstraint.constant = 0
        lblBookLaterInfo.isHidden = false
    }
    
    @IBAction func bookNowBtnAction(_ sender: Any) {
        isForBookLater = false
        
        if (self.dropLocationTf.text == ""){
            selectedTf = "Drop"
            let placeholderAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let attributedPlaceholder = NSAttributedString(string: "Enter drop location", attributes: placeholderAttributes)
            if let aClass = [UISearchBar.self] as? [UIAppearanceContainer.Type] {
                if #available(iOS 9.0, *) {
                    UITextField.appearance(whenContainedInInstancesOf: aClass).attributedPlaceholder = attributedPlaceholder
                } else {
                    // Fallback on earlier versions
                }
            }
            presentGSMAutocompleteViewController()
        }else{
            self.performSegue(withIdentifier: "route", sender: self)
//            self.serviceCallToGetFareDetails()
        }
    }
    
    
    @IBAction func btnSearchLocationAction(_ sender: UIButton) {
        if (sender.tag == 201){
            selectedTf = "Pickup"
        }
        else {
            selectedTf = "Drop"
        }
        self.presentGSMAutocompleteViewController()
    }
    
    @IBAction func btnSlideMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnBookForLaterAction(_ sender: Any) {
        //        let phoneNumber: String = "tel://3124235234"
        //        UIApplication.shared.openURL(URL(string: phoneNumber)!)
        
        
        
        dateTimePicker.minimumDate = Date()
        dateTimePicker.maximumDate = Date().add(days: 2)//User can book a cab before 2 days only
        viewDatePicker.animShow()
        
        viewbackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewbackground.isHidden = false
        
    }
    
    @IBAction func btnPreviousBookedLocation(_ sender: Any) {
        self.performSegue(withIdentifier: "previous_booked_locations", sender: self)
    }
    
    
    @IBAction func datePickerCancelBtnAction(_ sender: Any) {
        viewDatePicker.animHide()
        viewbackground.isHidden = true
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: Any) {
        viewDatePicker.animHide()
        viewbackground.isHidden = true
        isForBookLater = true
        if isForOneWay == true {
            pickupTime = AppConstant.formattedDate(date: dateTimePicker.date, withFormat: StringConstant.dateFormatter1, ToFormat: StringConstant.dateFormatter3)!
            self.performSegue(withIdentifier: "route", sender: self)
        }else{//Rental
            pickupTime = AppConstant.formattedDate(date: dateTimePicker.date, withFormat: StringConstant.dateFormatter1, ToFormat: StringConstant.dateFormatter3)!
            self.performSegue(withIdentifier: "rental_booking_rides", sender: self)
        }
        
    }
    
    @IBAction func rentalBookNowBtnAction(_ sender: Any) {
        isForBookLater = false
        self.performSegue(withIdentifier: "rental_booking_rides", sender: self)
    }
    @IBAction func rentalBookLaterBtnAction(_ sender: Any) {
        dateTimePicker.minimumDate = Date()
        dateTimePicker.maximumDate = Date().add(days: 2)//User can book a cab before 2 days only
        viewDatePicker.animShow()
        
        viewbackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewbackground.isHidden = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "camera.zoom" {
            // this static variable will hold the last value between invocations.
            let currentZoom: CGFloat = CGFloat(googleMapView.camera.zoom)
            
            if lastZoom != currentZoom {
                //Zoom level has actually changed!
                print("Zoom level has actually changed")
                if let zoom = googleMapView?.camera.zoom {
                    self.lastZoom = CGFloat(zoom)
                }
            }
        }
    }
    
    @IBAction func activeBookingsBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "total_trips", sender: self)
    }
    
    // MARK: - Choose Previous Booked Location Delegate
    func selectedObject(obj: PreviousBookedLocationBO) {
        dropLocationTf?.text = obj.addressName
        addressLabel?.text = obj.addressName
        selectedTf = "Drop"
        isPinShowDrop = true
        isFromPrevBookLoc = true
        self.pickUpLocationTf.textColor = AppConstant.colorThemeLightGray
        self.dropLocationTf.textColor = AppConstant.colorThemeBlack
        
        dropCoordinate = CLLocationCoordinate2D(latitude: (obj.latitude) , longitude: (obj.longitude) )
        let camera = GMSCameraPosition.camera(withLatitude: (dropCoordinate?.latitude)! ,longitude: (dropCoordinate?.longitude)! , zoom: 15)
        self.googleMapView.animate(to: camera)
        
    }
    
    // MARK: - Google Map Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            googleMapView.isMyLocationEnabled = true
            googleMapView.settings.myLocationButton = true
            break
        case .denied:
            AppConstant.showAlertToEnableLocation()
            break
        default:
            break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print("My current location \(location)")
        myCurrentLocation = location
        
        googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        //        let car1Location = CLLocation(latitude: 20.2981806657416, longitude: 85.8576580882072)
        //        let car2Location = CLLocation(latitude: 20.2949769603599, longitude: 85.8567551895976)
        //        let car3Location = CLLocation(latitude: 20.2930948940639, longitude: 85.8573117479682)
        //
        //
        //        //Show static cars
        //        createMarker(titleMarker: "", iconMarker:  UIImage.init(named: "car_icon")!, latitude: (car1Location.coordinate.latitude), longitude: (car1Location.coordinate.longitude))
        //        createMarker(titleMarker: "", iconMarker: UIImage.init(named: "car_icon")! , latitude: (car2Location.coordinate.latitude), longitude: (car2Location.coordinate.longitude))
        //        createMarker(titleMarker: "", iconMarker: UIImage.init(named: "car_icon")! , latitude: (car3Location.coordinate.latitude), longitude: (car3Location.coordinate.longitude))
        
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (AppConstant.isSlideMenu == false){
            googleMapView.isMyLocationEnabled = true
            
            DispatchQueue.main.async {
                if (gesture) {
                    self.addressLabel.text = "Getting address..."
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {() -> Void in
                        self.view.layoutIfNeeded()
        
                        //Hide Active Booking View
                        self.viewActiveBookings.isHidden = true
                        
                        var topViewFrame = self.topView.frame
                        topViewFrame.origin.y = topViewFrame.origin.y - 250
                        self.topView.frame = topViewFrame
                        
                        var bottomViewFrame = self.bottomView.frame
                        bottomViewFrame.origin.y = bottomViewFrame.origin.y + bottomViewFrame.size.height + 250
                        self.bottomView.frame = bottomViewFrame
                        
                        var bottomRentalViewFrame = self.viewRentals.frame
                        bottomRentalViewFrame.origin.y = bottomRentalViewFrame.origin.y + (bottomRentalViewFrame.size.height + self.viewRentalCar.frame.size.height)
                        self.viewRentals.frame = bottomRentalViewFrame
                        
                        self.googleMapView.settings.myLocationButton = false
                    }, completion: {(_ finished: Bool) -> Void in
                    })
                    self.myLocationView.isHidden = true
                }
            }
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        guard let currCoordinate = self.googleMapView.myLocation?.coordinate else {
            return
        }
        
        self.currentCoordinate = self.googleMapView.myLocation?.coordinate
        
        //print("current coordinate: \(self.currentCoordinate!)")
        print("pickup coordinate: \(coordinate)")
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            if(self.selectedTf == "Pickup"){
                self.pickUpCoordinate = coordinate
                self.pickUpLocationTf.text = lines.joined(separator: "\n")
                self.addressLabel.text = lines.joined(separator: "\n")
                
                print("pickup Loc = \(self.addressLabel.text!)")
                
                //Service call to show velicle listing
//                self.serviceCallToGetVehicleCategory()
                //Set current address
                if self.currentAddress == ""{
                    self.currentAddress = self.addressLabel.text!
                    self.serviceCallToGetVehicleCategory()
                    self.serviceCallToRegisterDeviceInfo()
                }else{
                    //Api call to get cab location
                    self.serviceCallToGetCabLocation()
                }
                
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                print("-------------------")
                print(self.myCurrentLocation)
                print(location)
                //                if self.myCurrentLocation == location{
                //                    self.imgViewMyCurrentLocation.image = UIImage.init(named: "my_location")
                //                }else{
                //                    self.imgViewMyCurrentLocation.image = UIImage.init(named: "my_location_gray")
                //                }
                
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    print(location)
                    
                    if error != nil {
                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                        return
                    }
                    
                    if (placemarks!.count) > 0 {
                        let pm = placemarks?[0]
                        print("you are in city ->",String(describing: pm!.locality))
                        self.currentCity = pm!.locality!
                        AppConstant.cityName = self.currentCity
                        
                        if (pm?.locality) != nil{
                            //Save in UserDefaults
                            var address: String = ""
                            // City
                            if let city = pm?.locality as NSString? {
                                address = city as String
                            }
                            // Country
                            if let country = pm?.country as NSString? {
                                address = address + ", " + (country as String)
                            }
                            AppConstant.saveInDefaults(key: StringConstant.current_address, value: address)
                        }
                        
                    }
                    else {
                        print("Problem with the data received from geocoder")
                    }
                })
            }
            else {
                if self.isFromPrevBookLoc == false{
                    DispatchQueue.main.async {
                        self.dropCoordinate = coordinate
                        self.dropLocationTf.text = lines.joined(separator: "\n")
                        self.addressLabel.text = lines.joined(separator: "\n")
                    }
                }
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {() -> Void in
                self.view.layoutIfNeeded()
                if(self.bottomView.frame.origin.y == (self.bottomView.frame.origin.y + self.bottomView.frame.size.height)){
                    //                    var navViewFrame = self.viewNavBar.frame
                    //                    navViewFrame.origin.y = navViewFrame.origin.y + 80
                    //                    self.viewNavBar.frame = navViewFrame
                    
                    //Show Active Booking View
                    if self.isServiceAvailable{
                        self.viewActiveBookings.isHidden = self.activeBookingCount == "0" ? true : false
                    }
                    
                    var topViewFrame = self.topView.frame
                    topViewFrame.origin.y = topViewFrame.origin.y + 250
                    self.topView.frame = topViewFrame
                    
                    var bottomViewFrame = self.bottomView.frame
                    bottomViewFrame.origin.y = bottomViewFrame.origin.y - bottomViewFrame.size.height
                    self.bottomView.frame = bottomViewFrame
                    
                    var bottomRentalViewFrame = self.viewRentals.frame
                    bottomRentalViewFrame.origin.y = bottomRentalViewFrame.origin.y - (bottomRentalViewFrame.size.height + self.viewRentalCar.frame.size.height)
                    self.viewRentals.frame = bottomRentalViewFrame
                }
                self.myLocationView.isHidden = false
            }, completion: {(_ finished: Bool) -> Void in
            })
        }
    }
    // Touch drag and lift
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if !isFromAutoCompleteViewController {
            reverseGeocodeCoordinate(position.target)
        }
        isFromAutoCompleteViewController = false
        //self.imgViewMyCurrentLocation.image = UIImage.init(named: "my_location_gray")
        print("Touch drag and lift")
    }
    // Tap
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    @objc func handleUserCurrentLocationTap(_ sender: UITapGestureRecognizer? = nil) {
        
        guard let lat = self.googleMapView.myLocation?.coordinate.latitude,
            let lng = self.googleMapView.myLocation?.coordinate.longitude else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 15)
        self.googleMapView.animate(to: camera)
        
    }
    
    func selectVehicleType(index: Int){
        googleMapView.clear()
//        btnBookNowWidthConstraint.constant = 0
//        lblBookLaterInfo.isHidden = false
        isForBookShareRide = false
        
        let vehicleTypeBo = AppConstant.arrVehicleType[index]
        if (vehicleTypeBo.name == "Share") {
            
//            btnBookNowWidthConstraint.constant = -AppConstant.screenSize.width
//            lblBookLaterInfo.isHidden = true
            isForBookShareRide = true
            movingcar = UIImage.init(named: "share_car")!
            
            for cabInfoBo in self.arrCabInfo {
                createMarker(titleMarker: "", iconMarker: movingcar, latitude: cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
            }
        }
        else if (vehicleTypeBo.name == "Micro") {
            
            movingcar = UIImage.init(named: "micro_car")!
            
            for cabInfoBo in self.arrCabInfo {
                createMarker(titleMarker: "", iconMarker: movingcar, latitude:cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
                //                if(cabInfoBo.category_id == "2"){
                //                    createMarker(titleMarker: "", iconMarker: movingcar, latitude:cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
                //                }
            }
        }
        else if (vehicleTypeBo.name == "Mini") {
            
            movingcar = UIImage.init(named: "mini_car")!
            
            for cabInfoBo in self.arrCabInfo {
                createMarker(titleMarker: "", iconMarker: movingcar, latitude:cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
                //                if(cabInfoBo.category_id == "3"){
                //                    createMarker(titleMarker: "", iconMarker: movingcar, latitude:cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
                //                }
            }
        }
        else if (vehicleTypeBo.name == "Sedan") {
            
            movingcar = UIImage.init(named: "sedan_car")!
            
            for cabInfoBo in self.arrCabInfo {
                createMarker(titleMarker: "", iconMarker: movingcar, latitude:cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
                //                if(cabInfoBo.category_id == "4"){
                //                    createMarker(titleMarker: "", iconMarker: movingcar, latitude:cabInfoBo.latitide! , longitude: cabInfoBo.longitude!)
                //                }
            }
        }
        
        selectedVehicleTypeIndex = index
        self.vehicleTypeCollectionView.reloadData()
    }
    
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: String, longitude: String) {
        let lat = Double(latitude)
        let lon = Double(longitude)
        
        let coordinates = CLLocationCoordinate2D(latitude:lat!
            , longitude:lon!)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        marker.title = titleMarker
        marker.icon = self.image(with: iconMarker, scaledTo: CGSize(width: 30.0, height: 14.0))
        marker.map = googleMapView
    }
    
    @objc func disableDragFromNotification(notification: Notification){
        //Take Action on Notification
        if (AppConstant.isSlideMenu) {
            googleMapView.settings.scrollGestures = false
        }else{
            googleMapView.settings.scrollGestures = true
        }
        
    }
    
    func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.isFromPrevBookLoc = false
        if (textField == self.pickUpLocationTf){
            
            self.dropLocationTf.textColor = AppConstant.colorThemeLightGray
            self.pickUpLocationTf.textColor = AppConstant.colorThemeBlack
            
            selectedTf = "Pickup"
            let placeholderAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let attributedPlaceholder = NSAttributedString(string: "Enter pickup location", attributes: placeholderAttributes)
            if let aClass = [UISearchBar.self] as? [UIAppearanceContainer.Type] {
                if #available(iOS 9.0, *) {
                    UITextField.appearance(whenContainedInInstancesOf: aClass).attributedPlaceholder = attributedPlaceholder
                } else {
                    // Fallback on earlier versions
                }
            }
            if ((self.dropLocationTf.text == "") || (self.pickUpLocationTf.text == "")){
                presentGSMAutocompleteViewController()
            }
            else {
                
                if !isPinShowPickUp {
                    presentGSMAutocompleteViewController()
                }else{
                    self.addressLabel.text = self.pickUpLocationTf.text
                    let camera = GMSCameraPosition.camera(withLatitude: (pickUpCoordinate?.latitude)! ,longitude: (pickUpCoordinate?.longitude)! , zoom: 15)
                    self.googleMapView.animate(to: camera)
                    isPinShowPickUp = false
                    if !isPinShowDrop {
                        isPinShowDrop = true
                    }
                }
                
            }
            
        }
        else {//Drop Location
            
            self.pickUpLocationTf.textColor = AppConstant.colorThemeLightGray
            self.dropLocationTf.textColor = AppConstant.colorThemeBlack

            
            selectedTf = "Drop"
            let placeholderAttributes = [NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let attributedPlaceholder = NSAttributedString(string: "Enter drop location", attributes: placeholderAttributes)
            if let aClass = [UISearchBar.self] as? [UIAppearanceContainer.Type] {
                if #available(iOS 9.0, *) {
                    UITextField.appearance(whenContainedInInstancesOf: aClass).attributedPlaceholder = attributedPlaceholder
                } else {
                    // Fallback on earlier versions
                }
            }
            if (self.dropLocationTf.text == ""){
                presentGSMAutocompleteViewController()
            }
            else {
                if !isPinShowDrop {
                    presentGSMAutocompleteViewController()
                }else{
                    self.addressLabel.text = self.dropLocationTf.text
                    let camera = GMSCameraPosition.camera(withLatitude: (dropCoordinate?.latitude)! ,longitude: (dropCoordinate?.longitude)! , zoom: 15)
                    self.googleMapView.animate(to: camera)
                    isPinShowDrop = false
                    if !isPinShowPickUp {
                        isPinShowPickUp = true
                    }
                }
                
            }
            
        }
        
    }
    
    // MARK: - AutocompleteViewController Delegate
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place latitude: \(String(describing: place.coordinate.latitude))")
        print("Place longitude: \(String(describing: place.coordinate.longitude))")
        
        isFromAutoCompleteViewController = true
        
        if (selectedTf == "Pickup"){
            self.pickUpLocationTf.text = String(format: "%@, %@", place.name!, place.formattedAddress!)
            self.addressLabel.text = String(format: "%@, %@", place.name!, place.formattedAddress!)
            
            self.dropLocationTf.textColor = AppConstant.colorThemeLightGray
            self.pickUpLocationTf.textColor = AppConstant.colorThemeBlack
            
            self.pickUpCoordinate = place.coordinate
            isPinShowPickUp = true
            
            //Service call to show velicle listing
            self.serviceCallToGetVehicleCategory()
        }
        else {
            self.dropLocationTf.text = String(format: "%@, %@", place.name!, place.formattedAddress!)
            self.addressLabel.text = String(format: "%@, %@", place.name!, place.formattedAddress!)
            self.dropCoordinate = place.coordinate
            isPinShowDrop = true
            
            self.pickUpLocationTf.textColor = AppConstant.colorThemeLightGray
            self.dropLocationTf.textColor = AppConstant.colorThemeBlack
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude ,longitude: place.coordinate.longitude , zoom: 15)
        self.googleMapView.animate(to: camera)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        if (selectedTf == "Pickup"){
            isPinShowPickUp = true
        }
        else {
            isPinShowDrop = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Collectionview Delegates and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppConstant.arrVehicleType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vehicleTypeCollectionView.dequeueReusableCell(withReuseIdentifier: "VehicleTypeCollectionViewCell", for: indexPath as IndexPath) as! VehicleTypeCollectionViewCell
        
        let vehicleTypeBo = AppConstant.arrVehicleType[indexPath.row]
        cell.lblVehicleTypeName.text = vehicleTypeBo.name
        cell.lblVehicleTypeTime.text = vehicleTypeBo.minTime
        if (vehicleTypeBo.isSelected == false) {
            cell.lblVehicleTypeName?.font = UIFont.init(name: StringConstant.poppinsMedium, size: 12.0)
            cell.imgViewVehicleType?.sd_setImage(with: URL(string: vehicleTypeBo.unselectedImage), placeholderImage: UIImage(named: vehicleTypeBo.unselectedImage))
            cell.lblVehicleTypeTime?.font = UIFont.init(name: StringConstant.poppinsRegular, size: 10.0)
        }else{
            cell.lblVehicleTypeName?.font = UIFont.init(name: StringConstant.poppinsBold, size: 12.0)
            cell.imgViewVehicleType?.sd_setImage(with: URL(string: vehicleTypeBo.selectedImage), placeholderImage: UIImage(named: vehicleTypeBo.selectedImage))
            cell.lblVehicleTypeTime?.font = UIFont.init(name: StringConstant.poppinsSemibold, size: 10.0)
            vehicleType = vehicleTypeBo.name!
            vehicleTypeId = vehicleTypeBo.vehicleId
            waitingTime = vehicleTypeBo.minTime
        }
        
        if (cell.lblVehicleTypeTime?.text == "Not Aval") {
            bookNowBtn.isEnabled = false
        }else{
            bookNowBtn.isEnabled = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (selectedVehicleTypeIndex != indexPath.row) {
            //Set selected Vehicle index
            selectedVehicleTypeIndex = indexPath.row
            //clear vehicles pin from map
            googleMapView.clear()
            
            for var vehicleTypeBo in AppConstant.arrVehicleType {
                vehicleTypeBo.isSelected = false
            }
            
            let vehicleTypeBo = AppConstant.arrVehicleType[indexPath.row]
            if (vehicleTypeBo.rowIndex == indexPath.row) {
                vehicleTypeBo.isSelected = true
                vehicleType = vehicleTypeBo.name!
                vehicleTypeId = vehicleTypeBo.vehicleId
                self.vehicleTypeCollectionView.reloadData()
            }
            //service call to get vehicle location according to cab type
            serviceCallToGetCabLocation()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellHeight = 75
        var cellWidth = 94
        
        if AppConstant.arrVehicleType.count <= 4 {
            cellHeight = 75
            cellWidth = Int(AppConstant.screenSize.width) / AppConstant.arrVehicleType.count
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Api Service Call Method
    func serviceCallToRegisterDeviceInfo(){
        if AppConstant.hasConnectivity() {
            //AppConstant.showHUD()
            let params: Parameters = [
                "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "mobile": AppConstant.retrievFromDefaults(key: StringConstant.mobile),
                "device_id": AppConstant.retrievFromDefaults(key: StringConstant.deviceToken),
                "device_type": StringConstant.iOS,
                "latitude": NSNumber(value: (self.currentCoordinate?.latitude)!),
                "longitude": NSNumber(value: (self.currentCoordinate?.longitude)!),
                "location": self.currentAddress
            ]
            print("params===\(params)")
            
            Alamofire.request( AppConstant.registerDeviceInfoUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    //AppConstant.hideHUD()
                    print("Url: \(AppConstant.registerDeviceInfoUrl)")
                    debugPrint(response)
                    
                    switch(response.result) {
                    case .success(_):
                        
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//Success
                            }else if (status == 3){//Logout from the app
                                AppConstant.logout()
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
            AppConstant.showSnackbarMessage(msg: StringConstant.noInternetConnectionMsg)
        }
    }
    
    func serviceCallToGetCabLocation() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let address = self.pickUpLocationTf.text
            let lat : NSNumber = NSNumber(value: (pickUpCoordinate?.latitude)!)
            let lng : NSNumber = NSNumber(value: (pickUpCoordinate?.longitude)!)
            
            let vehicleTypeBo = AppConstant.arrVehicleType[selectedVehicleTypeIndex]
            
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token" : AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "ride_type" : "0",
                "cat_id" : vehicleTypeBo.vehicleId,
                "latitude" : NSNumber(value: (pickUpCoordinate?.latitude)!),
                "longitude" : NSNumber(value: (pickUpCoordinate?.longitude)!)
            ]
            
            print("url===\(AppConstant.cabLocationInfoUrl)")
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.cabLocationInfoUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    AppConstant.hideHUD()
                    debugPrint("Cab Location : \(response)")
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        print(AppConstant.cabLocationInfoUrl)
                        debugPrint(dict!)
                        
                        if let status = dict!["status"] as? Int {
                            self.viewServiceUnavailable.isHidden = true
                            if(status == 1){
                                if let active_booking =  dict?["active_booking"] as? String{
                                    if active_booking != "0"{
                                        self.activeBookingCount = active_booking
                                        self.lblNoOfActiveBookings.text = active_booking
                                        self.viewActiveBookings.isHidden = false
                                    }else{
                                        self.viewActiveBookings.isHidden = true
                                    }
                                }
                                self.arrCabInfo.removeAll()
                                if let arrCabLocationInfo = dict?["data"] as? [[String: Any]]{
                                    if(arrCabLocationInfo.count > 0){
                                        for dictInfo in arrCabLocationInfo{
                                            
                                            let cabInfoBo = CabLocationBO()
                                            
                                            if let latitude = dictInfo["latitude"] as? String {
                                                cabInfoBo.latitide = latitude
                                            }
                                            if let longitude = dictInfo["longitude"] as? String {
                                                cabInfoBo.longitude = longitude
                                            }
                                            self.arrCabInfo.append(cabInfoBo)
                                            
                                            //Set default Vehicle Type
                                            
                                            if (self.arrCabInfo.count > 1){
                                                self.selectVehicleType(index: self.selectedVehicleTypeIndex)
                                                
                                            }
                                        }
                                    }
                                }
                                /*
                                //parse cab Category
                                AppConstant.arrVehicleType.removeAll()
                                if let arrVehicleCategoryInfo = dict?["cab_list"] as? [[String: Any]] {
                                    var index: Int = -1
                                    if (arrVehicleCategoryInfo.count > 0) {
                                        for dictInfo in arrVehicleCategoryInfo {
                                            index = index + 1
                                            let vehicleTypeBo = VehicleTypeBO()
                                            
                                            if let vehicleId = dictInfo["cat_id"] as? String {
                                                vehicleTypeBo.vehicleId = vehicleId
                                            }
                                            if let vehicleName = dictInfo["cat_name"] as? String {
                                                vehicleTypeBo.name = vehicleName
                                            }
                                            if let vehicleSelectedImage = dictInfo["image_blue"] as? String {
                                                vehicleTypeBo.selectedImage = vehicleSelectedImage
                                            }
                                            if let vehicleUnselectedImage = dictInfo["image_white"] as? String {
                                                vehicleTypeBo.unselectedImage = vehicleUnselectedImage
                                            }
                                            if let minTime = dictInfo["min_time"] as? String {
                                                vehicleTypeBo.minTime = minTime
                                            }
                                            vehicleTypeBo.rowIndex = index
                                            if (vehicleTypeBo.rowIndex == self.selectedVehicleTypeIndex) {
                                                vehicleTypeBo.isSelected = true
                                            }else {
                                                vehicleTypeBo.isSelected = false
                                            }
                                            AppConstant.arrVehicleType.append(vehicleTypeBo)
                                        }
                                        //Reload minimum pickup time
                                        self.vehicleTypeCollectionView.reloadData()
                                    }
                                }*/
                                
                            }else  if(status == 3){
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.goToLandingScreen()
                                
                                //Show Service Unavailable View
                                
                                self.viewServiceUnavailable.isHidden = false
                                self.viewActiveBookings.isHidden = true
                                self.isServiceAvailable = false
                                if let msg = dict!["msg"] as? String{
                                    self.lblServiceUnavailableMsg.text = msg
                                }
                            }else{
                                if let msg = dict!["msg"] as? String{
                                    AppConstant.showAlert(strTitle: msg, strDescription: "", delegate: self)
                                }
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
    
    func serviceCallToGetVehicleCategory() {
        if AppConstant.hasConnectivity() {
            AppConstant.showHUD()
            let params: Parameters = [
                "user_id": AppConstant.retrievFromDefaults(key: StringConstant.user_id),
                "access_token": AppConstant.retrievFromDefaults(key: StringConstant.accessToken),
                "latitude" : NSNumber(value: (pickUpCoordinate?.latitude)!),
                "longitude" : NSNumber(value: (pickUpCoordinate?.longitude)!)
            ]
            
            print("url===\(AppConstant.getVehicleCategoryUrl)")
            print("params===\(params)")
            
            Alamofire.request(AppConstant.getVehicleCategoryUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    //AppConstant.hideHUD()
                    print("url===\(AppConstant.getVehicleCategoryUrl)")
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        self.vehicleTypeCollectionView.isHidden = false
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        
                        if let status = dict?["status"] as? Int {
                            if(status == 1){//Success
                                AppConstant.arrVehicleType.removeAll()
                                if let arrVehicleCategoryInfo = dict?["data"] as? [[String: Any]] {
                                    var index: Int = -1
                                    if (arrVehicleCategoryInfo.count > 0) {
                                        for dictInfo in arrVehicleCategoryInfo {
                                            index = index + 1
                                            let vehicleTypeBo = VehicleTypeBO()
                                            
                                            if let vehicleId = dictInfo["cat_id"] as? String {
                                                vehicleTypeBo.vehicleId = vehicleId
                                            }
                                            if let vehicleName = dictInfo["cat_name"] as? String {
                                                vehicleTypeBo.name = vehicleName
                                            }
                                            if let vehicleSelectedImage = dictInfo["image_blue"] as? String {
                                                vehicleTypeBo.selectedImage = vehicleSelectedImage
                                            }
                                            if let vehicleUnselectedImage = dictInfo["image_white"] as? String {
                                                vehicleTypeBo.unselectedImage = vehicleUnselectedImage
                                            }
                                            if let minTime = dictInfo["min_time"] as? String {
                                                vehicleTypeBo.minTime = minTime
                                            }
                                            vehicleTypeBo.rowIndex = index
                                            if (vehicleTypeBo.rowIndex == 1) {
                                                vehicleTypeBo.isSelected = true
                                            }else {
                                                vehicleTypeBo.isSelected = false
                                            }
                                            AppConstant.arrVehicleType.append(vehicleTypeBo)
                                        }
                                        self.vehicleTypeCollectionView.reloadData()
                                    }
                                }
                                AppConstant.hideHUD()
                               //Service call to get Vehicle location
                                self.serviceCallToGetCabLocation()
                            }else if (status == 3){//Logout from the app
                                AppConstant.hideHUD()
                                AppConstant.logout()
                            }
                        }
                        
                        
                        break
                        
                    case .failure(_):
                        AppConstant.hideHUD()
                        let error = response.result.error!
                        AppConstant.showAlert(strTitle: error.localizedDescription, strDescription: "", delegate: self)
                        break
                        
                    }
            }
        }else{
            AppConstant.showSnackbarMessage(msg: StringConstant.noInternetConnectionMsg)
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
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id"),
                "pickup_latitude" : String(describing: pickLat),
                "pickup_longitude" : String(describing: pickLng),
                "drop_latitude" : String(describing: dropLat),
                "drop_longitude" : String(describing: dropLng),
                "pickup_address" : String(describing: pickUPAddress),
                "drop_address" : String(describing: dropAddress),
                "category_id" : vehicleTypeId,
                "book_city" : self.currentCity
            ]
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.getFareDetailsUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    AppConstant.hideHUD()
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let dict = AppConstant.convertToDictionary(text: response.result.value!)
                        //debugPrit(dict)
                        //                        let dict = dataArray![0] as Dictionary
                        
                        if let status = dict?["status"] as? String {
                            if(status == "0"){
                                let msg = dict?["msg"] as? String
                                AppConstant.showAlert(strTitle: msg!, strDescription: "", delegate: self)
                            }else  if(status == "1"){
                                if let fare = dict?["total_cost"] as? Int {
                                    self.totalFare = "\(fare)"
                                    debugPrint(self.totalFare)
                                }
                                if let city_id = dict?["city_id"] as? String {
                                    self.cityId = String(city_id)
                                }else{
                                    self.cityId = "1"
                                }
                                if let info = dict?["info_str"] as? String {
                                    self.info = info
                                    debugPrint(self.info)
                                }
                                if let info_arry = dict?["info_arry"] as? [[String: Any]]{
                                    debugPrint(info_arry)
                                    self.fareInfoArray = info_arry
                                }
                                self.performSegue(withIdentifier: "route", sender: self)
                                
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
    
    func serviceCallToVerifyBookingStatus() {
        if AppConstant.hasConnectivity() {
            // AppConstant.showHUD()
            
            var params: Parameters!
            params = [
                "user_id" : AppConstant.retrievFromDefaults(key: "user_id"),
            ]
            print("params===\(params!)")
            
            Alamofire.request( AppConstant.bookingVarificationUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let arrData = AppConstant.convertToArray(text: response.result.value!)
                        let dict = arrData![0] as Dictionary
                        if let status = dict["status"] as? Int {
                            if(status == 0){
                                
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
    
    func calculateMinimumTime(vehicleTypeId : String) -> String {
        //        var minTime = 0
        //        for cabInfoBo in self.arrCabInfo {
        //            if(cabInfoBo.category_id == vehicleTypeId){
        //                let replaced : NSString = cabInfoBo.time?.replacingOccurrences(of: " min", with: "") as! NSString
        //                print("time string", replaced)
        //                minTime = (replaced as NSString).integerValue
        //                print("time int", minTime)
        //            }
        //        }
        arrTime.removeAll()
        for cabInfoBo in self.arrCabInfo {
            if(cabInfoBo.category_id == vehicleTypeId){
                let replaced = cabInfoBo.time?.replacingOccurrences(of: " min", with: "")
                let timeVal = (replaced! as NSString).integerValue
                print(timeVal)
                arrTime.append(timeVal)
            }
        }
        if (arrTime.count > 0){
            let minValue = arrTime.min()
            print("array count = ", arrTime.count)
            return "\(String(describing: minValue!)) min"
            
        }else{
            
            return "Not Aval"
        }
        
        
    }
    
    func presentGSMAutocompleteViewController() {
        if AppConstant.hasConnectivity(){
//            let placesSearchController: GooglePlacesSearchController = {
//                let controller = GooglePlacesSearchController(delegate: self,
//                                                              apiKey: AppConstant.GoogleMapApiKey,
//                                                              placeType: .address,
//                                                              coordinate: CLLocationCoordinate2D(latitude: (pickUpCoordinate?.latitude)!, longitude: (pickUpCoordinate?.longitude)!),
//                                                              radius: 100
////                                                              strictBounds: true
//                    //                Optional: searchBarPlaceholder: "Start typing..."
//                )
////                coordinate: CLLocationCoordinate2D(latitude: (pickUpCoordinate?.latitude)!, longitude: (pickUpCoordinate?.longitude)!)
//                //        controller.searchBar.isTranslucent = false
//                //        controller.searchBar.barStyle = .black
//                //        controller.searchBar.tintColor = .white
//                //        controller.searchBar.barTintColor = .black
//                controller.view.backgroundColor = UIColor.white
//                return controller
//            }()
            
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            //Show near by places first
            let bounds: GMSCoordinateBounds = getCoordinateBounds(latitude: (pickUpCoordinate?.latitude)!, longitude: (pickUpCoordinate?.longitude)!)
            acController.autocompleteBounds = GMSCoordinateBounds(coordinate: bounds.northEast, coordinate: bounds.southWest)
            present(acController, animated: true, completion: nil)
        }else{
            AppConstant.showSnackbarMessage(msg: "Please check your internet connection.")
        }
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
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "route") {
            let vc = segue.destination as! RouteScreenController
            vc.pickUpCoordinate = self.pickUpCoordinate
            vc.dropCoordinate = self.dropCoordinate
            vc.pickUpAddress = self.pickUpLocationTf.text
            vc.dropAddress = self.dropLocationTf.text
            vc.vehicleType = self.vehicleType
            vc.totalFare = self.totalFare
            vc.vehicleTypeId = self.vehicleTypeId
            vc.cityId = self.cityId
            vc.currentCity = self.currentCity
//            vc.fareInfoArray = self.fareInfoArray
            vc.info = self.info
            vc.isForBookLater = isForBookLater
            vc.isForBookShareRide = isForBookShareRide
            vc.pickupTime = pickupTime
            vc.waitingTime = waitingTime
        }
        else if (segue.identifier == "driverinfo") {
            let vc = segue.destination as! DriverInfoScreenController
            vc.pickUpCoordinate = self.pickUpCoordinate
            vc.dropCoordinate = self.dropCoordinate
            vc.pickUpAddress = self.pickUpLocationTf.text
            vc.dropAddress = self.dropLocationTf.text
            vc.driverProfileBo = self.driverProfileBo
        }
        else if (segue.identifier == "rental_booking_rides") {
            let vc = segue.destination as! RentalBookingRidesViewController
            vc.pickUpLocation = self.pickUpLocationTf.text!
            vc.isForBooklater = self.isForBookLater
            vc.pickupTime = pickupTime
            vc.pickUpCoordinate = self.pickUpCoordinate
        }
        else if (segue.identifier == "previous_booked_locations") {
            let vc = segue.destination as! PreviousBookedLocationsViewController
            vc.delegate = self
        }
    }
    
    // MARK: - Animation Method
    func animateVehiceLocation(oldCoodinate: CLLocationCoordinate2D , newCoodinate: CLLocationCoordinate2D, image: UIImage) {
        let driverMarker = GMSMarker()
        driverMarker.icon = image
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
        //found bearing value by calculation when marker add
        driverMarker.position = oldCoodinate
        //this can be old position to make car movement to new position
        driverMarker.map = self.googleMapView
        //marker movement animation
        CATransaction.begin()
        CATransaction.setValue(Int(15.0), forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({() -> Void in
            driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            //            driverMarker.rotation = CDouble(data.value(forKey: "bearing"))
            //driverMarker.rotation = 90
            //New bearing value from backend after car movement is done
            driverMarker.map = nil
            let oldCoordinates = newCoodinate
            let newCoordinates = CLLocationCoordinate2D(latitude:20.291360291081812, longitude:85.84794446825981)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates, newCoodinate: newCoordinates, image: self.movingcar)
        })
        driverMarker.position = newCoodinate
        //this can be new position after car moved from old position to new position with animation
        driverMarker.map = self.googleMapView
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
        //found bearing value by calculation
        CATransaction.commit()
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

extension UIView {
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

extension UIView {
    
    func setShadowWithCornerRadius(corners : CGFloat){
        
        self.layer.cornerRadius = corners
        
        let shadowPath2 = UIBezierPath(rect: self.bounds)
        
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        
        self.layer.shadowOpacity = 0.5
        
        self.layer.shadowPath = shadowPath2.cgPath
        
    }
    
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}

extension Date {
    
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.x, y: -origin.y,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}




