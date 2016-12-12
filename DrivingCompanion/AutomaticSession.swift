//
//  AutomaticSession.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/3/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit

/**
 * This class represents "Automatic" session for its REST APIs.
 */
class AutomaticSession: NSObject
{
    var access_token: String
    var expires_in: Int
   // var refresh_token: String
    var token_type: String
    
    init(access_token: String, expires_in: Int, token_type: String)
    
  //  init(access_token: String, expires_in: Int, refresh_token: String, token_type: String)
    {
        self.access_token = access_token
        self.expires_in = expires_in
       // self.refresh_token = refresh_token
        self.token_type = token_type
        
        super.init()
    }
    
    
}


