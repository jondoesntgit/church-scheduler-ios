//
//  EventInspector.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/28/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class EventInspector: UITableViewController {
    
    var event: Event!
    
    // MARK: - View Controller Lifecycle Code
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        if Globals.isAdmin {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        self.tableView.allowsSelection = false
        self.tableView.allowsSelectionDuringEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        // Update data when modal is dismissed
        tableView.reloadData()
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2 //event.components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else if section == 1 {
            return event.components.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let row = indexPath.row
            
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell") as! EventTitleCell
                cell.event = event
                cell.titleTextArea.text = event.name
                return cell
            } else if row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Event Date Picker") as! EventDatePickerTableViewCell
                cell.event = event!
                cell.startOrStop = .start
                return cell
            } else if row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Event Date Picker") as! EventDatePickerTableViewCell
                cell.event = event!
                cell.startOrStop = .stop
                return cell
            } else if row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Event Map Picker") as! EventLocationTableViewCell
                cell.event = event
                //cell.accessoryType = .disclosureIndicator
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventInspector.segueToMap(sender:)))
                cell.addGestureRecognizer(tapGestureRecognizer)
                return cell
            } else {
                return UITableViewCell()
            }
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Event Component", for: indexPath) as! EventPropertyTableViewCell
            let eventComponent = event.components[indexPath.row]
            cell.eventComponent = eventComponent
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
            if let datePickerCell = cell as? EventDatePickerTableViewCell {
                let textArea = datePickerCell.timeTextField
                    
                textArea?.isUserInteractionEnabled = true
                textArea?.becomeFirstResponder()
            } else if let titleCell = cell as? EventTitleCell {
                let textArea = titleCell.titleTextArea
                textArea?.isUserInteractionEnabled = true
                textArea?.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Event Details"
        case 1:
            return "Event Program"
        default:
            return nil
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    @objc func segueToMap(sender: Any?) {
        performSegue(withIdentifier: "Show Map Details", sender: sender)
    }
    
    @IBAction func unwindToEventInspector(segue: UIStoryboardSegue) {
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                if indexPath.section == 1 {
                    return true
                } else {
                    return indexPath.row == 3
                }
            }
        }
        return false
    }
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "Edit Component Information" {
            if let destination = segue.destination.contents as? ComponentEditorViewController {
                if let cell = sender as? EventPropertyTableViewCell {
                    destination.eventComponent = cell.eventComponent
                }
            }
        } else if segue.identifier! == "Show Map Details" {
            if let mapViewController = segue.destination.contents as? MapViewController {
                print("Going to maps")
                mapViewController.parentController = self
            }
        }
    }
 

}
