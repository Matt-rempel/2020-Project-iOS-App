//
//  Devotion DB Access.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-11-26.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 This class is used to connect to the database and transmit data to and from it
 TODO: Make network connect tests within this class and not the calling classes
 */
class DBAccessor {
//    #if DEBUG
//    let baseURL = "http://127.0.0.1:8100/api/v2/"
//    #else
        let baseURL = "https://www.the2020project.ca/api/v2/"
//    #endif
    
    // MARK: Devotion end points
    /**
     Get a specific devotion
     - Parameters:
     - year: Year of the devotion
     - month: Month of the devotion
     - day: Day of the devotion
     - Returns: The devotion
     */
    func getDevotion(year: Int, month: Int, day: Int, completion: @escaping (Devotion?, Error?) throws -> Void) {
        let url = "\(baseURL)devotionals/\(year)/\(month)/\(day)/"
        var devotion: Devotion?

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    let json = try JSON(data: data)
                    devotion = Devotion(json: json)
                    try completion(devotion, nil)
                } catch {
                    do {
                        try completion(nil, DBAccessError.badData)
                    } catch {
                        
                    }
                }
            case .failure(let error):
                do {
                    try completion(nil, error)
                } catch {
                    
                }
                
            }
        }
    }

    // MARK: Devotion end points
    /**
     Get months devotionals
     - Parameters:
     - year: Year of the devotional
     - month: Month of the devotional
     - day: Day of the devotional
     - Returns: The devotions in an array
     */
    func getWidget(completion: @escaping (Devotion?, Error?) throws -> Void) {
        let url = "\(baseURL)devotionals/widget/"
        var devotion: Devotion?
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let status = response.response?.statusCode
                    if status != 200 {
                        try completion(nil, DBAccessError.badData)
                    }

                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    let json = try JSON(data: data)
                    devotion = Devotion(json: json)
                    try completion(devotion, nil)
                } catch {
                    do {
                        try completion(nil, DBAccessError.badData)
                    } catch {
                        
                    }
                }
            case .failure(let error):
                do {
                    try completion(nil, error)
                } catch {
                    
                }
                
            }
        }
    }
    
}
