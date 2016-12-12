//
//  StatisticsData.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/5/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import Foundation


class StatisticsData
{
    
    var fuelStats = [Double]()
    var distanceStats = [Double]()
    
    
    /**
    *@param fuel  fuel consumption for a trip
    *@param distance distance travelled for a trip.
    */
    func addDataPoint(fuel: Double, distance: Double)
    {
        fuelStats.append(fuel)
        distanceStats.append(distance)
    }
    
    
}
