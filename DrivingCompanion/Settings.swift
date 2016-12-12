//
//  Settings.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/7/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit


class Settings: NSObject, NSCoding
{
    
    var numItems: String = "10"
  
    override init()
    {
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        numItems = aDecoder.decodeObject(forKey: "NumberOfItems") as! String
        super.init()
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(numItems, forKey: "NumberOfItems")
    }
}
