//
//  SettingsViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/6/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, NumItemsViewControllerDelegate
{
    
    var items = ["Number of items to load"]
    var settings: Settings
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOptions" {
            
            let controller = segue.destination as! NumItemsViewController
            controller.settings = settings
            controller.delegate = self
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        settings = Settings()
        super.init(coder: aDecoder)
        loadSettings()
        
    }
    
    
    func loadSettings() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            settings = unarchiver.decodeObject(forKey: "Settings") as! Settings
            unarchiver.finishDecoding()
        }
        
    }
    
    func saveSettings() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(settings, forKey: "Settings")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    
    func dataFilePath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("settings.plist")
    }
    
    
    func optionSelected(_ controller: NumItemsViewController, selected item: Settings) {
        self.settings = item
        tableView.reloadData()
        saveSettings()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingItemCell") as! SettingItemCell
        
        cell.attribute.text = items[indexPath.row]
        cell.value.text = settings.numItems
        return cell
    }
    
    


}
