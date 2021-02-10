//
//  ScriptureManager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2021-01-09.
//  Copyright © 2021 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ScriptureManager: DBAccessor {
    
    let authManager = AuthenticationManager()
    let icloudManager = iCloudManager()
    
    // MARK: - Set a scripture as read
    func setScriptureProgress(devotion: Devotion, scripture: Scripture, completion: @escaping (Error?) throws -> ()) {
        if let key = authManager.key {
            self.setScriptureAsRead(devotion: devotion, scripture: scripture, key: key) { (error) in
                do {
                    try completion(error)
                } catch {
                    
                }
            }
        } else {
            icloudManager.setiCloudProgress(for: devotion, scripture: scripture)
            do {
                try completion(nil)
            } catch {
                
            }
        }
    }
    
    func setScriptureAsRead(devotion: Devotion, scripture: Scripture, key: String, completion: @escaping (Error?) throws -> ()) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: devotion.date)
        let month = calendar.component(.month, from: devotion.date)
        let day = calendar.component(.day, from: devotion.date)
        guard let scriptureSlug = scripture.title.convertedToSlug() else {
            do {
                try completion(DBAccessError.couldNotEncodeData)
            } catch {
                
            }
            return
        }
        
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/scripture/\(scriptureSlug)/read/"
        let headers:HTTPHeaders = ["Authorization": "Token \(key)"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
               print("Set scripture as read successfully")
            case .failure(let error):
                do {
                    try completion(error)
                } catch {
                    
                }
                
            }
        }
    }
    
    func setScriptureAsRead(title: String, year: Int, month: Int, day: Int, completion: @escaping (Error?) throws -> ()) {
        guard let scriptureSlug = title.convertedToSlug() else {
            do {
                try completion(DBAccessError.couldNotEncodeData)
            } catch {
                
            }
            return
        }
        
        guard let key = authManager.key else {
            // TODO: Handle error
            return
        }
        
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/scripture/\(scriptureSlug)/read/"
        let headers:HTTPHeaders = ["Authorization": "Token \(key)"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
               print("Set scripture as read successfully")
            case .failure(let error):
                do {
                    print(url)
                    try completion(error)
                } catch {
                    
                }
                
            }
        }
    }

    // MARK: - Get scripture progress
    func getScriptureProgress(devotion: Devotion, completion: @escaping (Error?) throws -> ()) {
        if let key = authManager.key {
            self.getScriptureProgressFromAPI(devotion: devotion, key: key) { (error) in
                do {
                    try completion(error)
                } catch {
                    
                }
            }
        } else {
            icloudManager.getiCloudProgress(devotion: devotion)
            do {
                try completion(nil)
            } catch {
                
            }
        }
    }
    
    private func getScriptureProgressFromAPI(devotion: Devotion, key: String, completion: @escaping (Error?) throws -> ()) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: devotion.date)
        let month = calendar.component(.month, from: devotion.date)
        let day = calendar.component(.day, from: devotion.date)
        
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/reading-history/"
        let headers:HTTPHeaders = ["Authorization": "Token \(key)"]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            print(response)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(DBAccessError.dataNotFound)
                        return
                    }
//                    dump(data)
                    let json = try JSON(data: data)
//                    dump(json)
                    if let readingProgress = json.dictionaryObject as? [String : Bool] {
                        // Match the readingProgress keys with the devotion scripture titles
                        for scripture in devotion.scriptue {
                            let isDone = readingProgress[scripture.title] ?? false
                            scripture.isCompleted = isDone
                            
                        }
                        print("Got progress for: \(DateFormater().getStringFrom(date: devotion.date))")
                        try completion(nil)
                    } else {
                        try completion(DBAccessError.badData)
                    }
                } catch {
                    do {
                        try completion(DBAccessError.badData)
                    } catch {
                        
                    }
                }
            case .failure(let error):
                do {
                    try completion(error)
                } catch {
                    
                }
                
            }
        }
    }

    
    
}
