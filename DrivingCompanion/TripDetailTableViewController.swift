//
//  TripDetailTableViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/8/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit
import GoogleMaps

class TripDetailTableViewController: UITableViewController
{
    
    var tripData: TripData!

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func loadView() {
        super.loadView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath.row) {
            // Trip route map
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell") as! TripRouteCell
            
            let path = tripData.pathEncoded
            let polyline = GMSPolyline(path: GMSPath(fromEncodedPath: path))
            polyline.strokeWidth = 2
            polyline.strokeColor = UIColor(red: 0.15, green: 0.50, blue: 0.73, alpha: 1.0)
            polyline.map = cell.routeMap!
            cell.routeMap!.isMyLocationEnabled = true
            print("map=\(cell.routeMap)")
        //    let startLatLng = tripData.startLocation
       //     let start = CLLocationCoordinate2D(latitude: startLatLng.lat, longitude: startLatLng.lon)
            
        //    let endLatLng = tripData.endLocation
          //  let end = CLLocationCoordinate2D(latitude: endLatLng.lat, longitude: endLatLng.lon)
            
         //   let bounds = GMSCoordinateBounds(coordinate: start, coordinate: end)
            
            //(withTarget: bounds, zoom: UIEdgeInsets())!
         //   cell.routeMap.camera = camera
            
            return cell
            
        case 1:
            //date time
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTimeCell") as! DateTimeCell
            cell.date.text = dateFormatter.string(from: tripData.startedAt)
            cell.time.text = timeFormatter.string(from: tripData.startedAt) + " - " + timeFormatter.string(from: tripData.endAt)
            return cell
            

            
        case 2:
            //general info
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripInfoCell") as! TripInfoCell
            cell.costLabel.text = "Cost"
            cell.cost.text = "$" + String(tripData.fuelCost)
            cell.distanceLabel.text = "Distance"
            cell.distance.text = numberFormatter.string(from: NSNumber(value:tripData.distance))! + " mi"
            cell.duration.text = formatSeconds(seconds: tripData.durationSeconds)
            cell.durationLabel.text = "Duration"
            cell.efficiencyLabel.text = "Efficiency"
            cell.efficiency.text = numberFormatter.string(from: NSNumber(value:tripData.aveMpg))! + " mpg"
            cell.hardAccels.text = String(tripData.hardAccels) + " time(s)"
            cell.hardBrakes.text = String(tripData.hardBrakes) + " times(s)"
            return cell
            
        default:
            //charts
            print("chart")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartsCell") as! DoublePieChartCell
            cell.chart1.noDataText = "no data"
            cell.chart2.noDataText = "no data"
            
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row) {
        case 0: return CGFloat(141)
        case 1: return CGFloat(55)
        case 2: return CGFloat(170)
        default: return CGFloat(179)
        }
    }
    
    func formatSeconds(seconds: Int) -> String
    {
        print("secs=\(seconds)")
        let hour = seconds / (60 * 60)
        let mins = seconds / 60 % 60
        
        return "\(hour) hr \(mins) min"
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
}
