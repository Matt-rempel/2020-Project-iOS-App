//
//  iCloud Manager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-08.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

class iCloudManager {
    
    var dateFormater = DateFormater()
    
    // MARK: iCloud Scripture Progress
    func getiCloudProgress(devotion: Devotion) {
        let devoDate = dateFormater.getStringFrom(date: devotion.date)

        // Pull iCloud Key Values
        if let iCloudCompletion = NSUbiquitousKeyValueStore.default.dictionary(forKey: devoDate) {
            for scripture in devotion.scriptue {
                if let isCompletedOniCloud = iCloudCompletion[scripture.title] as? Bool {
                    scripture.isCompleted = isCompletedOniCloud
                }
            }
        }
    }
    
    func setiCloudProgress( for devotion: Devotion, scripture: Scripture) {
        let devoDate = dateFormater.getStringFrom(date: devotion.date)
        var iCloudCompletion:[String:Bool] = [:]
        
        if let icc = NSUbiquitousKeyValueStore.default.dictionary(forKey: devoDate) as? [String : Bool] {
            iCloudCompletion = icc
        }
        
        iCloudCompletion[scripture.title] = true
        NSUbiquitousKeyValueStore.default.set(iCloudCompletion, forKey: devoDate)

    }
    
    func getAlliCloudProgressCount() -> Int {
        let iCloudCompletion = NSUbiquitousKeyValueStore.default.dictionaryRepresentation
        let keys = Array(iCloudCompletion.keys)
//        var total = 0
//        for key in keys {
//            let values = iCloudCompletion[key] as? [String : Bool]
//            print("\(key): \(values ?? [:])")
//
//        }
        
        return keys.count
    }
}
