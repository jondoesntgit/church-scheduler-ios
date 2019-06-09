//
//  SimpleDoesItViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/4/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//
//  A demo of webView. Shows my personal business website


import UIKit
import WebKit

class SimpleDoesItViewController: UIViewController {
    
    struct Constants {
        static let websiteURL = URL(string: "http://simpledoesit.com")!
    }
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: Constants.websiteURL)
        webView.load(urlRequest)
        // Do any additional setup after loading the view.
    }
}
