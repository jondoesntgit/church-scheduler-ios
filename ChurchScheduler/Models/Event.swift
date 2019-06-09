//
//  Event.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/27/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

class Event: Codable {
    
    var name: String
    var startTime: Date = Date()
    var endTime: Date?
    var components = [EventComponent]()
    var notes: String?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var day: Date {
        get {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: startTime)
            let truncated = Calendar.current.date(from: components)!
            return truncated
        }
    }
    
    var amIInvolved: Bool {
        get {
            let myName = UserDefaults.standard.string(forKey: "UserName")
            for component in components {
                if myName == component.rightText {
                    return true
                }
            }
            return false
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        // Set components to [] if not present in JSON
        // https://stackoverflow.com/questions/44575293/with-jsondecoder-in-swift-4-can-missing-keys-use-a-default-value-instead-of-hav
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        components = try container.decodeIfPresent([EventComponent].self, forKey: .components) ?? []
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        address = try container.decodeIfPresent(String.self, forKey: .address)
    }
}
