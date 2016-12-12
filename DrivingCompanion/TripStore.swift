//
//  TripStore.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/4/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit


protocol TripStoreDelegate: class {
    
    func tripStoreDidLoad()
    
}

/**
 * This class holds an array of Trip object. 
 * It is modeled after ItemStore in "Homepwner" project in the text book.
 */
class TripStore {
    
    weak var delegate: TripStoreDelegate?
    
    var allItems = [TripData]()
    
    var statsData = StatisticsData()
    
    
    init() {
        load()
    }
   
    func load() {
        fetchTripData(completion: { items, stats in
            self.allItems = items
            self.statsData = stats
            self.delegate?.tripStoreDidLoad()
        })
    }
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration:config)
    }()
    
    
    func fetchTripData(completion: @escaping ([TripData], StatisticsData) -> ())
    {
        
        let url = AutomaticAPI.tripListURL(paramters: ["limit":limit()])
        var request = URLRequest(url: url)
        request.addValue(AutomaticAPI.authHeader(), forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            
            
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            do {
                
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                
               // print("***parsedData=\(parsedData)")
                let results = parsedData["results"] as! [[String:Any]]
                
                var trips = [TripData]()
                
                let stats = StatisticsData()
                for result in results {
                    
                    let trip = TripData(fromJson: result)
                    trips.append(trip)
                    
                    //print("mpg:\(trip.aveMpg)")
                    //print("mpgEPA:\(trip.aveMpgEPA)")
                    
                    
                    stats.addDataPoint(fuel: trip.aveMpg, distance: trip.distance)
                    
                }
                
                completion(trips, stats)
                
            } catch {
                
            }
        }
        
        task.resume()
        
    }

    
}
