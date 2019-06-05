//
//  SimpleDoesItViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/4/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit
import WebKit

class SimpleDoesItViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://simpledoesit.com")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        // Do any additional setup after loading the view.
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
