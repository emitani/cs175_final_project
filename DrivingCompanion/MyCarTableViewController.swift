//
//  MyCarTableViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/7/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit
import GoogleMaps

class MyCarTableViewController: UITableViewController, GMSMapViewDelegate, VehicleDelegate, CLLocationManagerDelegate
{
    
    var vehicleStore : VehicleStore!
    let locationManager = CLLocationManager()
    
    var _mapView: GMSMapView!
    
    let sections = ["General", "Current Position"]
    let attributes = ["Make of the car", "Model name", "Year made", "Current fuel level"]
    
    
    override func loadView() {
        vehicleStore = VehicleStore(delegate: self)
        _mapView = GMSMapView()
        super.loadView()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return attributes.count
        }
        
        return 1
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(MyCarTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl){
        vehicleStore.fetchData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return CGFloat(43)
        }
        else {
            return CGFloat(245)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 1
        {
            //map cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell") as! MapViewCell
            
            
            if let lat = self.vehicleStore.pos?.lat, let lon = self.vehicleStore.pos?.lon {
                
                let camera = GMSCameraPosition.camera(withLatitude: lat,
                                                      longitude:lon,
                                                      zoom:14)
                
                let pos = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let marker = GMSMarker(position: pos)
                marker.title = "My Car"
                cell.mapView.camera = camera
                cell.mapView.delegate = self
                marker.map = cell.mapView
                cell.mapView.isMyLocationEnabled = true
                cell.mapView.settings.myLocationButton = true
            }
            return cell
            
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell") as! AttributeValueCell
            cell.attribute.text = attributes[indexPath.row]
            cell.value.text = vehicleStore.vehicle?.indexAt(indexPath.row)
            return cell
        }
        
        
    }
    
    
    
    
    
    /// Callback methods from VehicleDelegate. They notify when the data is loaded from server.
    func vehiclePosLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func vehicleDidLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            _mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
        }
    }

    
    
}
