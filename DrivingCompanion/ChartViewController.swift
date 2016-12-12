//
//  BarChartViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/5/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController
{
    
    @IBOutlet weak var chartView: CombinedChartView!
    var isDataLoaded = false
    
    var stats: StatisticsData! {
        didSet {
            if isDataLoaded {
                //reload new data
                loadChart()
            }
            isDataLoaded = true
        }
    }
    
    
    
    override func viewDidLoad() {
        chartView.noDataText = "No available data"
        chartView.chartDescription?.text = "Fuel efficiency vs. travel distance"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadChart()
    }
    
    func loadChart()
    {
        if isDataLoaded, isViewLoaded {
            let combinedData = CombinedChartData()
            combinedData.lineData = self.setFuelLineData()
            combinedData.barData = self.setDistanceBarData()
            
            chartView.data = combinedData
        }
    }
    
    /**
    *  set fuel efficiency line graph
    */
    func setFuelLineData() -> LineChartData
    {
        var dataPoints = stats.fuelStats
        
        var entries = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            entries.append(ChartDataEntry(x: Double(i), y: dataPoints[i]))
        }
        
        let lineDataSet = LineChartDataSet(values: entries, label: "Fuel Efficiency (mpg)")
        let lineData = LineChartData(dataSet: lineDataSet)
        
        return lineData
    }
    
    
    func setDistanceBarData() -> BarChartData
    {
        let dataPoints = stats.distanceStats
        
        var entries = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            entries.append(BarChartDataEntry(x: Double(i), y: dataPoints[i]))
        }
        
        let barDataSet = BarChartDataSet(values: entries, label: "Traveled Distance (mi)")
        barDataSet.colors = ChartColorTemplates.liberty()
        //barDataSet.colors = ChartColorTemplates.pastel()
        
        
        let barData = BarChartData(dataSet: barDataSet)
        return barData
    }
    
}
