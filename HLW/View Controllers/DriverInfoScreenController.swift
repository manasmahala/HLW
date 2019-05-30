//
//  DriverInfoScreenController.swift
//  Taxi Booking
//
//  Created by Chinmaya Sahu on 29/01/18.
//  Copyright © 2018 OdiTek Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import SDWebImage
import Alamofire

class DriverInfoScreenController: UIViewController , GMSMapViewDelegate , CLLocationManagerDelegate  {

    @IBOutlet weak var driverProfilePic: UIImageView!
    @IBOutlet weak var callPoliceBtn: UIButton!
    @IBOutlet weak var sendAlertBtn: UIButton!
    @IBOutlet weak var openUpBtn: UIButton!
    @IBOutlet var googleMapView: GMSMapView!
    @IBOutlet var notificationCountLabel: UILabel!
    @IBOutlet var pickUpLocationTF: UITextField!
    @IBOutlet var dropLocationTF: UITextField!
    @IBOutlet var viewPickUpLocation: UIView!
    @IBOutlet var viewDropLocation: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var viewDriverInfo: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblVehicleName: UILabel!
    @IBOutlet var lblVehicleNumber: UILabel!
    @IBOutlet var lblOTP: UILabel!
    @IBOutlet weak var cancelRideBtn: UIButton!
    
    
    var locationManager = CLLocationManager()
    var pickUpCoordinate : CLLocationCoordinate2D? = nil
    var dropCoordinate : CLLocationCoordinate2D? = nil
    var pickUpAddress : String!
    var dropAddress : String!
    var driverProfileBo = DriverProfileBO()
    var arrLocations = [CLLocationCoordinate2D]()
    var driverCoordinate : CLLocationCoordinate2D? = nil
    var driver_lat_old : String!
    var driver_lon_old : String!
    var driver_lat_new : String!
    var driver_lon_new : String!
    var count : Int! = 1
    var timer = Timer()
    var driverStartLocMarker = GMSMarker()
    var currentCity : String!
    var driverMarker = GMSMarker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designAfterStoryBoard()
        //setValuesToView()manas
        //callInEvery5Sec()manas
        
        NotificationCenter.default.addObserver(self, selector: #selector(DriverInfoScreenController.disableDragFromNotification(notification:)), name: Notification.Name("DisableMapFromDragNotification"), object: nil)

    }
    
    // MARK: - Design Methods
    func designAfterStoryBoard() {
        //Manage for iPhone X
        if AppConstant.screenSize.height >= 812{
            navBarHeightConstraint.constant = 92
            bottomViewBottomConstraint.constant = 34
        }
        driverProfilePic.layer.cornerRadius = driverProfilePic.frame.size.width / 2
        driverProfilePic.clipsToBounds = true
        
        cancelRideBtn.layer.cornerRadius = 3
        cancelRideBtn.layer.borderColor = UIColor.init(hexString: "#FFC107").cgColor
        cancelRideBtn.layer.borderWidth = 1.0
        
        createMarker(titleMarker: "", iconMarker: UIImage.init(named: "car_map")!, latitude:"20.293355" , longitude: "85.862612")
        
//        openUpBtn.layer.borderColor = UIColor.init(red:108/255.0, green:163/255.0, blue:38/255.0, alpha: 1.0).cgColor
//        openUpBtn.layer.borderWidth = 2
//        openUpBtn.layer.cornerRadius = openUpBtn.frame.size.width / 2
//        openUpBtn.clipsToBounds = true
        
//        callPoliceBtn.layer.borderColor = UIColor.init(red:108/255.0, green:163/255.0, blue:38/255.0, alpha: 1.0).cgColor
//        callPoliceBtn.layer.borderWidth = 2
//        callPoliceBtn.layer.cornerRadius = callPoliceBtn.frame.height / 2
//
//        sendAlertBtn.layer.borderColor = UIColor.init(red:108/255.0, green:163/255.0, blue:38/255.0, alpha: 1.0).cgColor
//        sendAlertBtn.layer.borderWidth = 2
//        sendAlertBtn.layer.cornerRadius = sendAlertBtn.frame.height / 2
        
        viewPickUpLocation.layer.cornerRadius = 3
        viewPickUpLocation.clipsToBounds = true
        viewDropLocation.layer.cornerRadius = 3
        viewDropLocation.clipsToBounds = true
        
        googleMapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        pickUpLocationTF.text = self.pickUpAddress
        dropLocationTF.text = self.dropAddress
        
//        pickUpLocationTF.text = "Mancheswar IE Rd, Bhubaneswar, Odisha 751007, India"
//        dropLocationTF.text = "Kharabela nagar, Kharabela nagar, Bhubaneswar, Odisha, India"
        
        self.lblVehicleNumber.text = driverProfileBo.vehcile_registration_number
        
        let lat = Double(driverProfileBo.latitude)
        let lon = Double(driverProfileBo.longitude)
        
        driverCoordinate = CLLocationCoordinate2D(latitude:lat!
            , longitude:lon!)
        
//        arrLocations.append(driverCoordinate!)manas
//        arrLocations.append(pickUpCoordinate!)manas
        
//        self.drawPath(startLocation: self.pickUpCoordinate!, endLocation: self.driverCoordinate!)manas
        self.setBoundsForMap()
        
        //Hide My location button
        self.googleMapView.settings.myLocationButton = false
        
        if(AppConstant.count == 0){
            AppConstant.count = 600
        }
        
        
        // After bookingdetails api is called to driver details den uncomment the below
//        createMarker(titleMarker: "start", iconMarker: UIImage.init(named: AppConstant.selectedVehicleImgName)!, latitude: driverProfileBo.latitude, longitude: driverProfileBo.longitude)
        
        let pickuplat = String(describing: self.pickUpCoordinate!.latitude)
        let pickUplon = String(describing: self.pickUpCoordinate!.longitude)

        createMarker(titleMarker: "", iconMarker: UIImage.init(named: "map_pin_green")!, latitude: pickuplat, longitude: pickUplon)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewDriverInfoAction(sender:)))
        viewDriverInfo.addGestureRecognizer(tap)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        topView.setShadowWithCornerRadius(corners: 20.0)
    }
    
    func setValuesToView() {
        lblRating.text = "4.0"
        lblOTP.text = String(format : "OTP: %@", driverProfileBo.otp)
        lblDriverName.text = driverProfileBo.driver_name
        lblVehicleName.text = "\(driverProfileBo.vehcile_brand_name) \(driverProfileBo.vehcile_model_name)"
        
        driverProfilePic.sd_setImage(with: URL(string: driverProfileBo.driver_image), placeholderImage: UIImage(named: "driverProfile"))
        driver_lat_old = driverProfileBo.latitude
        driver_lon_old = driverProfileBo.longitude
        driver_lat_new = driverProfileBo.latitude
        driver_lon_new = driverProfileBo.longitude

    }
    func callInEvery5Sec(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 5 seconds
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.serviceCallToTrackDriverLocation), userInfo: nil, repeats: true)
        
//        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.trackDriver), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    // MARK: - Google Map Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
       // self.drawPath(startLocation: self.pickUpCoordinate!, endLocation: self.driverCoordinate!)
        setBoundsForMap()
        locationManager.stopUpdatingLocation()
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
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
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 15)
        self.googleMapView.animate(to: camera)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // MARK: Set bounds for Map
    
    func setBoundsForMap() {
        var bounds = GMSCoordinateBounds()
        for location in arrLocations
        {
            let latitude = location.latitude
            let longitude = location.longitude
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
            //marker.map = self.googleMapView
            marker.icon = UIImage.init(named: "map_pin")
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 20)
        self.googleMapView.animate(with: update)
    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D)
    {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        print("Drawpath url ->",String(describing: url))
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            if let json = try? JSON(data: response.data!) {
                print(json)
                let routes = json["routes"].arrayValue
                
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
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 5
                    polyline.strokeColor = UIColor.init(red: 105.0/255.0, green: 161.0/255.0, blue: 240.0/255.0, alpha: 1)
                    polyline.map = self.googleMapView
                }
            }
            
        }
    }
    
    // MARK: function for create a marker pin on map
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: String, longitude: String) {
        let lat = Double(latitude)
        let lon = Double(longitude)
        
        let coordinates = CLLocationCoordinate2D(latitude:lat!
            , longitude:lon!)
        
        if(titleMarker == "start"){
            self.driverStartLocMarker.position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
            self.driverStartLocMarker.title = titleMarker
            self.driverStartLocMarker.icon = iconMarker
            self.driverStartLocMarker.map = googleMapView
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // change 5 to desired number of seconds
                // Your code with delay
                self.driverStartLocMarker.map = nil
            }
        }else{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
            marker.title = titleMarker
            marker.icon = iconMarker
            marker.map = googleMapView
        }
        
    }
    
    @objc func disableDragFromNotification(notification: Notification){
        //Take Action on Notification
        if (AppConstant.isSlideMenu) {
            googleMapView.settings.scrollGestures = false
        }else{
            googleMapView.settings.scrollGestures = true
        }
        
    }
    
    //MARK: - Button Action
    @IBAction func btnUpArrowAction(_ sender: Any) {
//        self.performSegue(withIdentifier: "arrivePickupLocation", sender: self)
        
        // push view controller but animate modally
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DriverToReachVC") as! DriverToReachPickUpPointViewController
        vc.driverProfileBo = self.driverProfileBo
        
        let navigationController = self.navigationController
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
//        _ = self.navigationController?.popViewController(animated: true)
        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnCallDriverAction(_ sender: Any) {
        let phoneNumber:String = driverProfileBo.driver_mobile
       // UIApplication.shared.openURL(URL(string: phoneNumber)!)
        
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(phoneCallURL as URL)
                }
                
            }
        }
    }

    @IBAction func btnShareDetailsAction(_ sender: Any) {
        let message = "Riding in HLW cab driven by John Catar (+912345678876). OTP: 1234 is needed to start the ride after booking the cab. Final bill amount will be shown on driver device."
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDriverProfleAction(_ sender: Any) {
        
    }

    @IBAction func btnHelpDeskAction(_ sender: Any) {
        
    }
    
    @IBAction func btnCancelRideAction(_ sender: Any) {
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
    
    @objc func viewDriverInfoAction(sender: UITapGestureRecognizer? = nil){
        self.performSegue(withIdentifier: "arrivePickupLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "arrivePickupLocation"{
            let vc = segue.destination as! DriverToReachPickUpPointViewController
            //vc.driverProfileBo = self.driverProfileBo manas
        }
    }
    
    //MARK: - Service Call Method
    
    @objc func serviceCallToTrackDriverLocation() {
        if AppConstant.hasConnectivity() {
            // AppConstant.showHUD()
            //Remove a Particular Marker
           // self.marker.map = nil
            var params: Parameters!
            params = [
                "driver_id" : driverProfileBo.driver_id
            ]
            
            
            print("params===\(params)")
            
            Alamofire.request( AppConstant.driverLocationTrackingUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
                .responseString { response in
                    // AppConstant.hideHUD()
                    
                    debugPrint(response)
                    switch(response.result) {
                    case .success(_):
                        let arrData = AppConstant.convertToArray(text: response.result.value!)
                        let dict = arrData![0] as Dictionary
                        
                        if let status = dict["status"] as? Int {
                            if(status == 0){
//                                let msg = dict["msg"] as? String
//                                AppConstant.showAlert(strTitle: msg!, delegate: self)
                            }else  if(status == 1){
                                if let latitude = dict["latitude"] as? String{
                                    self.driver_lat_new = latitude
                                }
                                if let longitude = dict["longitude"] as? String{
                                    self.driver_lon_new = longitude
                                }
                                var oldCoordinates : CLLocationCoordinate2D? = nil
                                let oldLat = Double(self.driver_lat_old)
                                let oldLon = Double(self.driver_lon_old)
                                oldCoordinates = CLLocationCoordinate2D(latitude:oldLat!
                                    , longitude:oldLon!)
                                
                                var newCoordinates : CLLocationCoordinate2D? = nil
                                let newLat = Double(self.driver_lat_old)
                                let newLon = Double(self.driver_lon_old)
                                newCoordinates = CLLocationCoordinate2D(latitude:newLat!
                                    , longitude:newLon!)
                                self.driverMarker.map = nil
                                self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
                                
                                
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
    
    func trackDriver(){
        switch count {
        case 1:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(driverProfileBo.latitude)
            let oldLon = Double(driverProfileBo.longitude)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat!
                , longitude:oldLon!)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3053085781551)
            let newLon = Double(85.8646724000573)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 2:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3053085781551)
            let oldLon = Double(85.8646724000573)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3063138427396)
            let newLon = Double(85.8705393970013)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 3:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3063138427396)
            let oldLon = Double(85.8705393970013)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3102288726002)
            let newLon = Double(85.8751088753343)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 4:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3102288726002)
            let oldLon = Double(85.8751088753343)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3131917275415)
            let newLon = Double(85.8783811703324)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 5:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3131917275415)
            let oldLon = Double(85.8783811703324)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3149515541489)
            let newLon = Double(85.878726169467)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 6:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3149515541489)
            let oldLon = Double(85.878726169467)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3186340138287)
            let newLon = Double(85.8802496641874)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 7:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3186340138287)
            let oldLon = Double(85.8802496641874)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3236645548139)
            let newLon = Double(85.8830820769072)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 8:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3236645548139)
            let oldLon = Double(85.8830820769072)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3259845223184)
            let newLon = Double(85.8832282572985)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 9:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3259845223184)
            let oldLon = Double(85.8832282572985)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3264708967827)
            let newLon = Double(85.8838914334774)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        case 10:
            var oldCoordinates : CLLocationCoordinate2D? = nil
            let oldLat = Double(20.3264708967827)
            let oldLon = Double(85.8838914334774)
            oldCoordinates = CLLocationCoordinate2D(latitude:oldLat
                , longitude:oldLon)
            
            var newCoordinates : CLLocationCoordinate2D? = nil
            let newLat = Double(20.3264708967827)
            let newLon = Double(85.8838914334774)
            newCoordinates = CLLocationCoordinate2D(latitude:newLat
                , longitude:newLon)
            
            self.animateVehiceLocation(oldCoodinate: oldCoordinates!, newCoodinate: newCoordinates!, imageName: AppConstant.selectedVehicleImgName)
            count  = count + 1
            break
        default:
            break
        }
    }
    
    // MARK: - Animation Method
    
    func animateVehiceLocation(oldCoodinate: CLLocationCoordinate2D , newCoodinate: CLLocationCoordinate2D, imageName: String) {
//        let driverMarker = GMSMarker()
        driverMarker = GMSMarker()
        driverMarker.icon = UIImage.init(named: imageName)!
        driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        driverMarker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
        //found bearing value by calculation when marker add
        driverMarker.position = oldCoodinate
        //this can be old position to make car movement to new position
        driverMarker.map = self.googleMapView
        //marker movement animation
        CATransaction.begin()
        CATransaction.setValue(Int(5.0), forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({() -> Void in
            self.driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            //            driverMarker.rotation = CDouble(data.value(forKey: "bearing"))
//            driverMarker.rotation = 90
            //New bearing value from backend after car movement is done
            
            self.driver_lat_old = self.driver_lat_new
            self.driver_lon_old = self.driver_lon_new
//            if(self.count <= 10){
//                driverMarker.map = nil
//            }
//            if(self.count == 10){
//                self.timer.invalidate()
//            }
//            driverMarker.map = nil
            
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
    
    //MARK: - Memory Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
