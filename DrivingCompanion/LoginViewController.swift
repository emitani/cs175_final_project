//
//  LoginViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/2/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet var loginButton: UIButton!
    
    
    let longPressRecognizer = UILongPressGestureRecognizer()
    
    @IBAction func login(sender: AnyObject)
    {
        //print("Button clicked")
        authorize(scopes: [Scope.vehicle_profile, Scope.user_profile, Scope.location, Scope.trip, Scope.vehicle_events, Scope.behavior])
        
    }

    override func viewDidLoad() {
        loginButton.addGestureRecognizer(longPressRecognizer)
        longPressRecognizer.addTarget(self, action: #selector(LoginViewController.longPressedView))
        loginButton.isUserInteractionEnabled = true
        super.viewDidLoad()
        
    }

    
    func longPressedView(){
        performSegue(withIdentifier: "About", sender: self)
    }
    
    
}
