//
//  Address.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/4/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit

/**
 * This class represents a street address.
 */

class Address: NSObject {

    var name: String
    var displayName: String
    var streetNumber: String
    var streetName: String
    var city: String
    var state: String
    var country: String
    
    
    init(name: String, displayName: String, streetNumber: String, streetName:String, city: String, state: String, country: String) {
        self.name = name
        self.displayName = displayName
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.city = city
        self.state = state
        self.country = country
    }
}
