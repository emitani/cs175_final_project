//
//  TripData.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/4/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit

/**
 * coordinate
 */
struct LatLng {
    var lat: Double
    var lon: Double
}

/**
 *
 */
class TripData: NSObject
{
    
    var startAddress: Address
    var endAddress: Address
    var distance: Double
    var durationSeconds: Int
    
    var startedAt: Date
    var endAt: Date
    
    var startLocation: LatLng
    var endLocation: LatLng
    
    var pathEncoded: String
    
    var fuelCost: Double
    var fuelVolumeLiter: Double
    var aveMpg: Double
    var aveMpgEPA: Double
    
    var scoreEvents: Double
    var scoreSpeeding: Double
    var hardBrakes: Int
    var hardAccels: Int
    
    var durationOver70InSeconds: Int
    var durationOver75InSeconds: Int
    var durationOver80InSeconds: Int
    
    var vehicleEvents: [VehicleEvent]?
    
    var highwayFraction: Double
    var cityFraction: Double
    var idlingTime: Double
    
    
    // construct TripData from JSON string.
    init(fromJson json: [String:Any]) {
        let _startAddress = json["start_address"] as! [String:String]
        let startAddress = parseAddress(fromJson: _startAddress)
        
        let _endAddress = json["end_address"] as! [String:String]
        let endAddress = parseAddress(fromJson: _endAddress)
        
        let distance = json["distance_m"] as! Double / 1000
        let duration = json["duration_s"] as! Int
        
        
        let startLocation = json["start_location"] as! [String:Double]
        let startLat = startLocation["lat"]! as Double
        let startLng = startLocation["lon"]! as Double
        let startLatLng = LatLng(lat: startLat, lon: startLng)
        
        let endLocation = json["end_location"] as! [String:Double]
        let endLat = endLocation["lat"]! as Double
        let endLng = endLocation["lon"]! as Double
        let endLatLng = LatLng(lat: endLat, lon: endLng)
        
        let path = json["path"] as! String
        
        let fuelCost = json["fuel_cost_usd"] as! Double
        let fuelVolL = json["fuel_volume_l"] as! Double
        
        let scoreEvents = json["score_events"] as! Double
        let scoreSpeeding = json["score_speeding"] as! Double
        
        let hardBrakes = json["hard_brakes"] as! Int
        let hardAccels = json["hard_accels"] as! Int
        
        let over70 = json["duration_over_70_s"] as! Int
        let over75 = json["duration_over_75_s"] as! Int
        let over80 = json["duration_over_80_s"] as! Int
        
        let mpg = json["average_kmpl"] as! Double * 2.352145106 // km/l -> m/g conversion; thank you physics class!
        let mpgEPA = json["average_from_epa_kmpl"] as! Double * 2.352145106 // km/l -> m/g conversio
        
        let startDateString = json["started_at"] as! String
        if startDateString.contains(".") {
            self.startedAt = dateFormatter1.date(from: startDateString)!
        } else {
            self.startedAt = dateFormatter2.date(from: startDateString)!
        }
        
        
        let endDateString = json["ended_at"] as! String
        if endDateString.contains(".") {
            self.endAt = dateFormatter1.date(from: endDateString)!
        } else {
            self.endAt = dateFormatter2.date(from: endDateString)!

        }
        
        
        let cityFrac = json["city_fraction"] as! Double
        let highwayFrac = json["highway_fraction"] as! Double
        let idlingTime = json["idling_time_s"] as! Double
        
        
        self.startAddress = startAddress
        self.endAddress = endAddress
        self.distance = distance * 0.621371 // convert from km to mile
        self.durationSeconds = duration
        self.startLocation = startLatLng
        self.endLocation = endLatLng
        self.pathEncoded = path
        self.fuelCost = fuelCost
        self.fuelVolumeLiter = fuelVolL
        self.scoreEvents = scoreEvents
        self.scoreSpeeding = scoreSpeeding
        self.hardBrakes = hardBrakes
        self.hardAccels = hardAccels
        self.durationOver70InSeconds = over70
        self.durationOver75InSeconds = over75
        self.durationOver80InSeconds = over80
        self.aveMpg = mpg
        self.aveMpgEPA = mpgEPA
        
        self.cityFraction = cityFrac
        self.highwayFraction = highwayFrac
        self.idlingTime = idlingTime
        
        super.init()
        
    }
    
    
    
}

let dateFormatter1: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()

let dateFormatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()

func parseAddress(fromJson json: [String:Any]) -> Address {
    let name = json["name"] as! String
    let displayName = json["display_name"] as! String
    let streetNumber = json["street_number"] as! String
    let streetName = json["street_name"] as! String
    let city = json["city"] as! String
    let state = json["state"] as! String
    let country = json["country"] as! String
    
    let address = Address(name: name, displayName: displayName, streetNumber: streetNumber, streetName: streetName, city: city, state: state, country: country)
    return address
}





class VehicleEvent
{
    var type: String
    var location: LatLng
    
    init(type:String, location: LatLng) {
        self.type = type
        self.location = location
    }
}
