//
//  TripDataTableViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/4/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit




class TripDataTableViewController: UITableViewController, TripStoreDelegate
{
    
    var itemStore: TripStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(TripDataTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        itemStore.load()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    
    func tripStoreDidLoad() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            //set trip statistics data to stat tab.
            
            
            let chartTabNav = self.tabBarController?.viewControllers![2] as! UINavigationController
            let chartTab = chartTabNav.visibleViewController as! ChartViewController
            
            chartTab.stats = self.itemStore.statsData
        }
        
        
    }
    
    override func loadView() {
        super.loadView()
        itemStore = TripStore()
        itemStore.delegate = self

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemStore.allItems.count
    }
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripDataItemCell", for: indexPath) as! TripDataItemCell
        
        //cell.updateLabels()
        let item = itemStore.allItems[indexPath.row]
        
        cell.tripName.text = item.startAddress.city + " to " + item.endAddress.city
        cell.tripTime.text = dateFormatter.string(from: item.startedAt) + " " + timeFormatter.string(from: item.startedAt) + " - " + timeFormatter.string(from: item.endAt)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TripDetail" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
              //  let detailViewController = segue.destination as! TripDetailTableViewController
                let detailViewController = segue.destination as! TripDetailViewController
                detailViewController.tripData = item
            }
        }

    }
    
}

