//
//  MyCarViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/3/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit
import GoogleMaps

class MyCarViewController: UITableViewController, GMSMapViewDelegate, VehicleDelegate, CLLocationManagerDelegate
{
    
    
    var vehicleStore : VehicleStore!
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var _mapView: GMSMapView!
    
    
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var fuel: UILabel!
    
    @IBOutlet var refControl: UIRefreshControl!
    
    
    
    override func loadView() {
        vehicleStore = VehicleStore(delegate: self)
        super.loadView()
    }
    
  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            _mapView.isMyLocationEnabled = true
            _mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            _mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
        }
    }
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(MyCarViewController.reload(_:)), for: UIControlEvents.valueChanged)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }                                                                                         
    
    @IBAction func reload(_ sender: Any) {
        vehicleStore.fetchData()
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func vehiclePosLoaded() {
        DispatchQueue.main.async { [unowned self] in
            
            let lat = self.vehicleStore.pos.lat
            let lon = self.vehicleStore.pos.lon
            
            let camera = GMSCameraPosition.camera(withLatitude: lat,
                                                  longitude:lon,
                                                  zoom:14)
            
            let pos = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let marker = GMSMarker(position: pos)
            marker.title = "My Car"
            marker.map = self._mapView
            self._mapView.camera = camera
        }
    }
    
    
    func vehicleDidLoaded() {
        DispatchQueue.main.async { [unowned self] in
            self.make.text = self.vehicleStore.vehicle.make
            self.model.text = self.vehicleStore.vehicle.model
            self.year.text = String(self.vehicleStore.vehicle.year)
            self.fuel.text = String(self.vehicleStore.vehicle.fuel) + " %"
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    }
    
    

    
    
}
