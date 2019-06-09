//
//  ComponentEditorViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/3/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class ComponentEditorViewController: UIViewController {

    
    @IBOutlet weak var leftTextLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    @IBOutlet weak var centerTextLabel: UILabel!
    
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var eventComponent: EventComponent!
    
    @IBAction func tapButton(_ sender: UIButton) {
        if sender == saveButton {
            eventComponent.leftText = leftTextField.text
            eventComponent.rightText = rightTextField.text
            eventComponent.centerText = centerTextField.text
        }
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leftTextField.text = eventComponent?.leftText
        rightTextField.text = eventComponent?.rightText
        centerTextField.text = eventComponent?.centerText
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
