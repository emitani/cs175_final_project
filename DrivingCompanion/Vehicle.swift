//
//  Vehicle.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/3/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import Foundation


protocol VehicleDelegate: class {
    
    func vehicleDidLoaded()
    func vehiclePosLoaded()
}

class Vehicle {
    var make: String
    var model: String
    var year: Int
    var fuel: Double
    
    init(make: String, model: String, year: Int, fuel: Double) {
        self.make = make
        self.model = model
        self.year = year
        self.fuel = fuel
    }
    
    
    //helper method for accessing by index from tableview
    func indexAt(_ index: Int) -> String
    {
        switch(index) {
        case 0: return make;
        case 1: return model;
        case 2: return String(year)
        case 3: return String(fuel) + " %"
        default: return ""
        }
    }
    
}


class VehicleStore
{
    
    weak var delegate: VehicleDelegate?

    var vehicle: Vehicle!
    
    var pos: LatLng!
    
    init(delegate: VehicleDelegate) {
        self.delegate = delegate
        
        fetchData()
        
    }
    

    func fetchData()
    {
        print("fetch data")
        fetchVehicleInfo(completion: { car in
            self.vehicle = car
            self.delegate?.vehicleDidLoaded()
        })
        
        fetchVehiclePos(completion: { pos in
            self.pos = pos
            self.delegate?.vehiclePosLoaded()
        })
    }
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration:config)
    }()
    
    
    /**
    * Get Vehicle's last known location.
    */
    func fetchVehiclePos(completion: @escaping (LatLng) -> ())
    {
        let url = AutomaticAPI.tripListURL(paramters: ["limit": "1"])
        var request = URLRequest(url: url)
        request.addValue(AutomaticAPI.authHeader(), forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                
                // print("***parsedData=\(parsedData)")
                let results = parsedData["results"] as! [[String:Any]]
                let result = results[0]
                let endPos = result["end_location"] as! [String: Any]
                let lat = endPos["lat"] as! Double
                let lon = endPos["lon"] as! Double
                
                print("lat:\(lat),lon:\(lon)")
                completion(LatLng(lat: lat, lon: lon))
                
                /*
                var trips = [TripData]()
                for result in results {
                    
                    let trip = TripData(fromJson: result)
                    trips.append(trip)
                    
                    
                }
                
                completion(trips) */
                
            } catch {
                
            }
        }
        
        task.resume()

    }
    
    /**
    * get Vehicle's basic information
    */
    func fetchVehicleInfo(completion: @escaping (Vehicle) -> ())
    {
        
        let url = AutomaticAPI.vehicleListURL()
        var request = URLRequest(url: url)
        request.addValue(AutomaticAPI.authHeader(), forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let results = parsedData["results"] as! [[String:Any]]
                let result = results[0]
                
                
                let make = result["make"] as! String
                let model = result["model"] as! String
                let year = result["year"] as! Int
                let fuel = result["fuel_level_percent"] as! Double
                
                print("make=\(make)")
                print("model=\(model)")
                print("year=\(year)")
                print("fuel=\(fuel)")
                
                
                let vehicle = Vehicle(make: make, model: model, year: year, fuel: fuel)
                completion(vehicle)
                
                
            } catch {
                
            }
        }
        
        task.resume()
        
    }
    
}
