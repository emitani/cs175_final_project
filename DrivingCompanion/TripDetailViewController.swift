//
//  TripDetailViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/4/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit
import GoogleMaps
import Charts

class TripDetailViewController: UIViewController, UINavigationControllerDelegate
{
    
    @IBOutlet var map: GMSMapView!
    
    @IBOutlet var cityHighway: PieChartView!
    @IBOutlet var distance: UILabel!
    @IBOutlet var duration: UILabel!
    var tripData: TripData!
    
    @IBOutlet var speedChart: PieChartView!
    @IBOutlet var mpg: UILabel!
    @IBOutlet var cost: UILabel!
    @IBOutlet var hardBreak: UILabel!
    
    @IBOutlet var hardAccels: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var time: UILabel!
    
    override func loadView() {
        super.loadView()
        
        setupMap()
        populateLabels()
        populatePieCharts()
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
    
    func populateLabels()
    {
        cost.text = "$" + String(tripData.fuelCost);
        hardBreak.text = String(tripData.hardBrakes) + " time(s)"
        hardAccels.text = String(tripData.hardAccels) + " times(s)"
        distance.text = numberFormatter.string(from: NSNumber(value:tripData.distance))! + " mi"
        duration.text = formatSeconds(seconds: tripData.durationSeconds)
        mpg.text = numberFormatter.string(from: NSNumber(value:tripData.aveMpg))! + " mpg"
        
        date.text = dateFormatter.string(from: tripData.startedAt)
        time.text = timeFormatter.string(from: tripData.startedAt) + " - " + timeFormatter.string(from: tripData.endAt)
        
    }
    
    func populatePieCharts()
    {
        populateSpeedChart()
        populateCityHwyChart()
    }
    
    func populateSpeedChart()
    {
    
        let chartData = PieChartData()
      
        var entries = [PieChartDataEntry]()
        
        let under70secs = tripData.durationSeconds - tripData.durationOver70InSeconds - tripData.durationOver75InSeconds - tripData.durationOver80InSeconds
        let under70 = PieChartDataEntry(value: Double(under70secs / 60), label: "<= 70 mph")
        entries.append(under70)
        
        if tripData.durationOver70InSeconds > 60 {
            let over70 = PieChartDataEntry(value: Double(tripData.durationOver70InSeconds / 60), label: "> 70 mph")
            entries.append(over70)
        }
        
        if tripData.durationOver80InSeconds > 60 {
            let over80 = PieChartDataEntry(value: Double(tripData.durationOver80InSeconds / 60), label: "> 80 mph")
            entries.append(over80)
        }
        
        if tripData.durationOver75InSeconds > 60 {
            let over85 = PieChartDataEntry(value: Double(tripData.durationOver75InSeconds / 60), label: "> 75 mph")
            entries.append(over85)
        }
        
        
        
        
        
        let dataSet = PieChartDataSet(values: entries, label: "Driving Speed")
        dataSet.colors =  ChartColorTemplates.joyful()
        chartData.addDataSet(dataSet)
        speedChart.data = chartData
        speedChart.chartDescription?.text = "Minutes driven."
        
        
    }
    
    func populateCityHwyChart()
    {
        let chartData = PieChartData()
        var entries = [PieChartDataEntry]()
        
        let city = PieChartDataEntry(value: tripData.cityFraction * 100, label: "City")
        let highway = PieChartDataEntry(value: tripData.highwayFraction * 100, label: "Highway")
        entries.append(city)
        entries.append(highway)
        
        let dataSet = PieChartDataSet(values: entries, label: "City vs. Highway")
        dataSet.colors = ChartColorTemplates.colorful()
        chartData.addDataSet(dataSet)
        cityHighway.data = chartData
        cityHighway.chartDescription?.text = "Percent driven."
        
    }
    
    func setupMap()
    {
        
        let path = tripData.pathEncoded
        let polyline = GMSPolyline(path: GMSPath(fromEncodedPath: path))
        polyline.strokeWidth = 2
        polyline.strokeColor = UIColor(red: 0.15, green: 0.50, blue: 0.73, alpha: 1.0)
        polyline.map = map
        
        let startLatLng = tripData.startLocation
        let start = CLLocationCoordinate2D(latitude: startLatLng.lat, longitude: startLatLng.lon)
        
        let endLatLng = tripData.endLocation
        let end = CLLocationCoordinate2D(latitude: endLatLng.lat, longitude: endLatLng.lon)
        
        let bounds = GMSCoordinateBounds(coordinate: start, coordinate: end)
        let camera = map.camera(for: bounds, insets: UIEdgeInsets())!
        map.camera = camera
        
    }
    
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



