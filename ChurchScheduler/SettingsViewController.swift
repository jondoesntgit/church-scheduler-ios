//
//  SettingsViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/3/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Settings"
        nameTextArea.delegate = self
        let defaults = UserDefaults.standard
        nameTextArea.text = defaults.string(forKey: "UserName")
        
        for cell in [notifyNowCell, notifyLaterCell] {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleTap(sender:)))
            cell?.addGestureRecognizer(tapGestureRecognizer)
        }
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
        return (indexPath.section == 2) ? indexPath : nil
    }
    
    @IBOutlet weak var notifyNowCell: UIView!
    @IBOutlet weak var notifyLaterCell: UIView!
    
    @objc func handleTap(sender: UIGestureRecognizer?) {
        if let cell = sender?.view {
            if cell == notifyNowCell {
                notify(inSeconds: 5)
            } else if cell == notifyLaterCell {
                notify(inSeconds: 60)
            }
        }
    }
    
    //https://stackoverflow.com/a/43411623/3635467
    func notify(inSeconds: TimeInterval) {
        print("Notifying")
        let content = UNMutableNotificationContent()
        content.title = "Delayed notification"
        content.body = "Here is your notification from \(inSeconds) seconds ago."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let identifier = "UYLLocalNotification"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Something went wrong while adding the request")
            }
        })
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
