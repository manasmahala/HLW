//
//  CustomObject.swift
//  HLW
//
//  Created by Chinmaya Sahu on 1/7/19.
//  Copyright © 2019 OdiTek Solutions. All rights reserved.
//

import UIKit

class CustomObject: NSObject {
    var name: String = ""
    var id: String = ""
}
class RentalBookingPackages: NSObject {
    var packageName: String = ""
    var packageId: String = ""
}
class RentalBookingCabTypes: NSObject {
    var cabId: String = ""
    var cabName: String = ""
    var cabType: String = ""
    var cabAvailableTime: String = ""
    var cabPrice: String = ""
    var cabBlue: String = ""
    var cabWhite: String = ""
    var baseFare: String = ""
    var addKmFare: String = ""
    var addTimeFare: String = ""
    var minFare: String = ""
    var isShowing: Bool = false
}
class MyProfileBO: NSObject {
    var user_id: String?
    var name: String?
    var email: String?
    var mobile: String?
    var dob: String?
    var address: String?
    var gender: String?
    var image: String?
    var imagepath: String?
}
class CabLocationBO: NSObject {
    var latitide: String?
    var longitude: String?
    var driver_id: String?
    var category_id: String?
    var category_name: String?
    var name: String?
    var mobile: String?
    var distance: String?
    var time: String?
}
class VehicleTypeBO {
    var name: String?
    var vehicleId: String = "0"
    var minTime: String = "0 min"
    var unselectedImage: String = ""
    var selectedImage: String  = ""
    var isSelected: Bool = false
    var rowIndex: Int = 0
}
class DriverProfileBO: NSObject {
    var driver_id: String = ""
    var driver_name: String = ""
    var vehicle_image: String = ""
    var driver_image: String = ""
    var vehcile_brand_name: String = ""
    var vehcile_model_name: String = ""
    var vehcile_registration_number: String = ""
    var category_id: String = ""
    var imagepath: String = ""
    var driver_mobile: String = ""
    var driver_rating: String = ""
    var latitude: String = "0"
    var longitude: String = "0"
    var address: String = ""
    var otp: String = ""
}
class EmergencyContactBO: NSObject {
    var name: String?
    var number: String?
    var share_status: String?
    var image: String?
}
class BookRideForContactBO: NSObject {
    var name: String?
    var number: String?
}
class FeedbackQuestionsForNormalRides: NSObject {
    var normalFeedbackQuestions: String?
    var selectedQuestionsStatus: Int = 0
}
class FeedbackQuestionsForBestRides: NSObject {
    var bestFeedbackQuestions: String?
    var selectedQuestionsStatus: Int = 0
}
class PreviousBookedLocationBO: NSObject {
    var addressName: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}
class FareDetails: NSObject {
    var title: String = ""
    var price: String = ""
    var type: Int = 0
}
class CouponBO: NSObject {
    var id: String = ""
    var title: String = ""
    var desc: String = ""
}
class TripBO: NSObject {
    var bookId: String = ""
    var bookStatus: String = ""
    var bookStatusStr: String = ""
    var bookDate: String = ""
    var bookTime: String = ""
    var bookStartDateTime: String = ""
    var bookEndDateTime: String = ""
    var rideId: String = ""
    var rideName: String = ""
    var rentalName: String = ""
    var catId: String = ""
    var catName: String = ""
    var imgPath: String = ""
    var source: String = ""
    var destination: String = ""
    var totalfare: String = ""
    var payMode: String = ""
}
class TripDetailsBO: NSObject {
    var tripBo  = TripBO()
    var bookStatus: String = ""
    var bookStatusStr: String = ""
    var driverBo = DriverProfileBO()
    var source: String = ""
    var destination: String = ""
    var sourceLat: String = ""
    var sourceLng: String = ""
    var destinationLat: String = ""
    var destinationLng: String = ""
    var totalCost: String = ""
    var arrFareDettails = [FareDetails]()
}
class BookingInfoBO: NSObject {
    var bookId: String = ""
    var book_status: String = ""
    var ride_cancel: Int = 0
    var book_status_str: String = ""
    var book_otp: String = ""
    var pick_pnt: String = ""
    var drop_pnt: String = ""
    var src_lat: String = ""
    var src_lon: String = ""
    var des_lat: String = ""
    var des_lon: String = ""
    var ride_id: String = ""
    var ride_name: String = ""
    var rental_name: String = ""
    var cat_name: String = ""
    var wait_time: Int = 0
    var ride_time: Int = 0
    var ride_completed: String = ""
}
class BookingStatusBO: NSObject {
    var bookingInfoBo = BookingInfoBO()
    var driverBo = DriverProfileBO()
}
