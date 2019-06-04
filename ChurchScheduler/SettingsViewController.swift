//
//  SettingsViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/3/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextArea.delegate = self
        let defaults = UserDefaults.standard
        nameTextArea.text = defaults.string(forKey: "UserName")
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var nameTextArea: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func didFinishEditing(_ sender: UITextField) {
        if let userName = sender.text {
            UserDefaults.standard.set(userName, forKey: "UserName")
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Allow only second section to be selected
        return (indexPath.section == 1) ? indexPath : nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
