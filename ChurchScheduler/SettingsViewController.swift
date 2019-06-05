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
        self.navigationController?.title = Storyboard.title
        nameTextArea.delegate = self
        let defaults = UserDefaults.standard
        nameTextArea.text = defaults.string(forKey: "UserName")
        
        for cell in [notifyNowCell, notifyLaterCell] {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.handleTap(sender:)))
            cell?.addGestureRecognizer(tapGestureRecognizer)
        }
        isAdminSwitch.isOn = Globals.isAdmin
    }
    
    
    @IBOutlet weak var isAdminSwitch: UISwitch!
    
    @IBAction func didChangeAdminSwitch(_ sender: UISwitch) {
        Globals.isAdmin = sender.isOn
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
        let content = UNMutableNotificationContent()
        content.title = NotificationConstants.title
        content.body = "Here is your notification from \(inSeconds) seconds ago."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let identifier = NotificationConstants.identifier
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: { (error) in
            if (error != nil) {
                print("Something went wrong while adding the request")
            }
        })
    }
    
    private struct NotificationConstants {
        static var identifier: String = "UYLLocalNotification"
        static var title: String = "Delayed notification"
    }
    
    private struct Storyboard {
        static var title: String = "Settings"
    }

}



