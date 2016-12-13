//
//  AboutViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/12/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit
import CoreMotion


// tilting the screen will move the car back and forth.
// sample code used http://avikam.com/software/using-core-motion-in-swift-2-2

class AboutViewController: UIViewController {

    @IBOutlet var carImage: UIImageView!
    let motionManager = CMMotionManager()
    
    let swipeRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        swipeRecognizer.addTarget(self, action: #selector(AboutViewController.swipeClose))
        view.addGestureRecognizer(swipeRecognizer)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
                guard let data = data else { return }
                
                let attitude = data.attitude
                
                if attitude.roll > 0.5 {
                    self.carImage.center.x = self.carImage.center.x + 1
                }
                else if attitude.roll < -0.5 {
                    self.carImage.center.x = self.carImage.center.x - 1

                }
            })
        }
        
    }
    
    func swipeClose()
    {
        print("close")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close()
    {
        dismiss(animated: true, completion: nil)
    }
}
