//
//  CalendarManager.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/31/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

enum CalendarManagerError: Error {
    case InvalidURL
    case couldntFetchData
    case noDataReturned
    case DataNotValid
}

class CalendarManager {
    
    let url: URL
    let downloadDelegate: CalendarViewController
    
    init(urlString: String, delegate: CalendarViewController) throws {

        self.downloadDelegate = delegate
        if let url = URL(string: urlString) {
            self.url = url
        } else {
            print("not valid")
            throw CalendarManagerError.InvalidURL
        }
    }
}
