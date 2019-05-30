//
//  TripDetailsTableViewCell.swift
//  HLW
//
//  Created by OdiTek Solutions on 14/01/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit
import GoogleMaps

class TripDetailsTableViewCell: UITableViewCell, GMSMapViewDelegate {
    
    @IBOutlet var imgViewDriverPic: UIImageView!
    @IBOutlet var lblPickupAddress: UILabel!
    @IBOutlet var lblDropAddress: UILabel!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblDriverRating: UILabel!
    @IBOutlet var imgViewCab: UIImageView!
    @IBOutlet var lblRideType: UILabel!
    @IBOutlet var lblCabType: UILabel!
    @IBOutlet var lblcabName: UILabel!
    @IBOutlet var lblStartTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblRideDetailsTitle: UILabel!
    @IBOutlet var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var lblStartTimeWidthConstraint: NSLayoutConstraint!
    
    var arrLocations = [CLLocationCoordinate2D]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initDesign()
        
    }
    
    func initDesign(){
        imgViewDriverPic.layer.cornerRadius = imgViewDriverPic.frame.height/2
        imgViewDriverPic.clipsToBounds = true
        
        lblPickupAddress.font = UIFont.init(name: "Poppins-Regular", size: 11.0)
        lblDropAddress.font = UIFont.init(name: "Poppins-Regular", size: 11.0)
        googleMapView.delegate = self
        self.googleMapView.settings.myLocationButton = false
        googleMapView.isMyLocationEnabled = false
        
        

        
        setBoundsForMap()
    }
    
    // MARK: - Google Map Delegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
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
        if arrLocations.count == 0{
            return
        }
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
        let update = GMSCameraUpdate.fit(bounds, withPadding: 40)
        self.googleMapView.animate(with: update)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
