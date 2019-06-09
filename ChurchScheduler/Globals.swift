//
//  Globals.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/5/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

class Globals {
    
    private struct Constants {
        static let userName = "UserName"
        static let isAdmin = "isAdmin"
    }
    
    static var dataSourceURL = URL(string: "http://s3.jamwheeler.com/mvj_scheduler/data2.json")!
    
    static var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.userName)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.userName)
        }
    }
    
    static var isAdmin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isAdmin)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.isAdmin)
        }
    }
}
