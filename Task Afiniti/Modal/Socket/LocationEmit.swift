//
//  LocationEmit.swift
//  rideely
//
//  Created by dev on 30/01/2020.
//  Copyright © 2020 Muhammad Danish Qureshi. All rights reserved.
//

import UIKit

class LocationEmit: Mappable, Stringify {
    var latitude: Double?
    var longitude: Double?
    var rideId: String?
    
    var name: String?
    var numberOfPassengers: String?
    var vehicle: DriverVehicleInTrip?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case rideId = "ride_id"
        case name = "name"
        case numberOfPassengers = "number_of_passengers"
        case vehicle = "vehicle"

    }
}
