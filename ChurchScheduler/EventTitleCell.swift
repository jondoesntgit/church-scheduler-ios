//
//  EventTitleCell.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/3/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class EventTitleCell: UITableViewCell, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleTextArea.delegate = self
        self.selectionStyle = .none
    }
    @IBOutlet weak var titleTextArea: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var event: Event!
    @IBAction func didFinishEditing(_ sender: UITextField) {
        if let newTitle = sender.text {
            event.name = newTitle
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleTextArea.becomeFirstResponder()
        // Configure the view for the selected state
    }

}
