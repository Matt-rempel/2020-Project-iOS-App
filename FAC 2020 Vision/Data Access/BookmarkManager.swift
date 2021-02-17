//
//  BookmarkManager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2021-01-09.
//  Copyright © 2021 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BookmarkManager: DBAccessor {
    
    let authManager = AuthenticationManager()
    let udManager = UserDefaultsManager()
    let dateFormater = DateFormater()
    var bookmarkUDIDs: [String: [String]] = [:]
    
    // MARK: - Set a scripture as read
    func toggleBookmark(devotion: Devotion, completion: @escaping (Error?) throws -> Void) {
        if let key = authManager.key {
            self.toggleBookmarkAPI(devotion: devotion, key: key) { (error) in
                do {
                    try completion(error)
                } catch {
                    
                }
            }
        } else {
            
            let month = dateFormater.getMonthString(input: devotion.date)
            let devoID = dateFormater.getStringFrom(date: devotion.date)
            udManager.toggleBookmark(month: month, UDID: devoID)
            
            do {
                try completion(nil)
            } catch {
                
            }
        }
    }
    
    func toggleBookmarkAPI(devotion: Devotion, key: String, completion: @escaping (Error?) throws -> Void) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: devotion.date)
        let month = calendar.component(.month, from: devotion.date)
        let day = calendar.component(.day, from: devotion.date)
        
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/favourite/"
        let headers: HTTPHeaders = ["Authorization": "Token \(key)"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                print("Toggled Bookmark successfully")
            case .failure(let error):
                do {
                    try completion(error)
                } catch {
                    
                }
                
            }
        }
    }

    func toggleBookmarkAPI(year: Int, month: Int, day: Int, completion: @escaping (Error?) throws -> Void) {
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/favourite/"
        guard let key = authManager.key else {
            // TODO: Handle error
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Token \(key)"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                print("Toggled Bookmark successfully")
            case .failure(let error):
                do {
                    try completion(error)
                } catch {
                    
                }
                
            }
        }
    }

    // MARK: Get bookmarks
    func getBookmarks(completion: @escaping ([Devotion]?, Error?) throws -> Void) {
        if let key = authManager.key {
            self.getAPIBookmarks(key: key) { (devotions, _) in
                do {
                    try completion(devotions, nil)
                } catch {
                    
                }
            }
        } else {
            self.loadLocalBookmarks { (devotions, _) in
                do {
                    try completion(devotions, nil)
                } catch {
                    
                }
            }
            
        }
    }
    
    private func getAPIBookmarks(key: String, completion: @escaping ([Devotion]?, Error?) throws -> Void) {
        let url = "\(baseURL)favourites/devotionals/"
        let headers: HTTPHeaders = ["Authorization": "Token \(key)"]
        
        var devotions: [Devotion] = []
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    
                    let json = try JSON(data: data)
                    json.forEach { (_, value) in devotions.append(Devotion(json: value)) }
                    
                    try completion(devotions, nil)
                } catch {
                    print("Devo could not be cast")
                }
            case .failure(let error):
                do {
                    try completion(nil, error)
                } catch {
                    
                }
                
            }
        }
    }
    
    private func loadLocalBookmarks(completion: @escaping ([Devotion]?, Error?) throws -> Void) {
        
        // Get the saved UDID's
        if bookmarkUDIDs == udManager.getSavedBookmarks() {
            return
        }
        
        bookmarkUDIDs = udManager.getSavedBookmarks()
        
        let taskGroup = DispatchGroup()
        var devotions: [Devotion] = []
        
        for (_, devoDates) in bookmarkUDIDs {
            // Load the devo from the API
            for date in Array(Set(devoDates)) {
                taskGroup.enter()
                // date is in the format dd-MM-yyyy
                let (year, month, day) = dateFormater.devoDateToParts(devoDate: date)
                if let year = year, let month = month, let day = day {
                    super.getDevotion(year: year, month: month, day: day) { (devotion, error)  in
                        if let error = error {
                            print("There was an error getting this bookmark!!")
                            print(error)
                        }
                        
                        if let devotion = devotion {
                            devotions.append(devotion)
                        }
                        taskGroup.leave()
                    }
                } else {
                    // TODO: Handle error
                }
                
            }
        }
        
        taskGroup.notify(queue: .main) {
            do {
                try completion(devotions, nil)
            } catch {
                
            }
        }
        
    }
    
    // MARK: - Check if devotion is bookmarked
    func isBookmarked(devotion: Devotion, completion: @escaping (Bool, Error?) throws -> Void) {
        if let key = authManager.key {
            self.isDevotionBookmarked(devotion: devotion, key: key) { (isBookmarked, error) in
                do {
                    try completion(isBookmarked, error)
                } catch {
                    
                }
            }
        } else {
            do {
                let month = dateFormater.getMonthString(input: devotion.date)
                let devoID = dateFormater.getStringFrom(date: devotion.date)
                try completion(udManager.checkIfInBookmarks(month: month, UDID: devoID), nil)
            } catch {
                
            }
        }
    
    }
    
    func isDevotionBookmarked(devotion: Devotion, key: String, completion: @escaping (Bool, Error?) throws -> Void) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: devotion.date)
        let month = calendar.component(.month, from: devotion.date)
        let day = calendar.component(.day, from: devotion.date)
        
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/favourite/"
        let headers: HTTPHeaders = ["Authorization": "Token \(key)"]
        
        var isBookmarked = false
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(isBookmarked, DBAccessError.dataNotFound)
                        return
                    }
                    
                    let json = try JSON(data: data)
                    isBookmarked = json["is_favourite"].boolValue
                    
                    try completion(isBookmarked, nil)
                } catch {
                    print("Bool could not be cast")
                }
            case .failure(let error):
                do {
                    try completion(isBookmarked, error)
                } catch {
                    
                }
                
            }
        }
    }
    
}
