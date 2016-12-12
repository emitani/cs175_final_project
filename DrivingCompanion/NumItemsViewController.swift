//
//  NumItemsViewController.swift
//  DrivingCompanion
//
//  Created by Eiko Mitani on 12/7/16.
//  Copyright © 2016 Eiko Mitani. All rights reserved.
//

import UIKit

protocol NumItemsViewControllerDelegate: class {
    func optionSelected(_ controller: NumItemsViewController, selected item: Settings)
}

class NumItemsViewController: UITableViewController
{
    
    var settings: Settings!
    var options = ["1", "3", "5", "8", "10"]
    weak var delegate: NumItemsViewControllerDelegate?
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumItemsOptionCell")!
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = options[indexPath.row]
        
        if settings.numItems == options[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        let selected = options[indexPath.row]
        settings.numItems = selected
        delegate?.optionSelected(self, selected: settings)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
