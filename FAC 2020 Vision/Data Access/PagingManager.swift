//
//  PagingManager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-03.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum PagingViewType {
    case today
    case search
    case month
}

enum DevotionOrderType: String {
    case ascending = "date"
    case decending = "-date"
}

class PagingManager: DBAccessor {
	var count: Int?
	var prev: String?
    var pagingViewType: PagingViewType
	
//	#if DEBUG
//    let baseURL = "http://127.0.0.1:8100/api/v2/"
//	var next: String? = "http://127.0.0.1:8100/api/v2/devotionals/"
//	#else
    
//    let baseURL = "https://www.the2020project.ca/api/v2/"
    
    var monthNextPage: String?
    var searchingNextPage: String?
    var todayNextPage: String? = "https://www.the2020project.ca/api/v2/devotionals/"
    
    var next: String? {
        get {
            switch pagingViewType {
            case .today:
                return todayNextPage
            case .search:
                return searchingNextPage
            case .month:
                return monthNextPage
            }
        }
        set(value) {
            switch pagingViewType {
            case .today:
                self.todayNextPage = value
            case .search:
                self.searchingNextPage = value
            case .month:
                self.monthNextPage = value
            }
        }
    }
//	#endif

    init(pagingViewType: PagingViewType = .today) {
        self.pagingViewType = pagingViewType
    }

	/**
	Get the next 10 devotions. It will also set the next, prev, and count variable in the class
	- Returns: The next 10 devotions in an array
	*/
	func nextPage(completion: @escaping ([Devotion]?, Error?) throws -> Void) {

        if let url = next {
            var devotions: [Devotion] = []
            
            AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            try completion(nil, DBAccessError.dataNotFound)
                            return
                        }
                        
                        let json = try JSON(data: data)
                        self.next = json["next"].string
                        self.prev = json["prev"].string
                        self.count = json["count"].int
                        let results = json["results"]
                        results.forEach { (_, value) in devotions.append(Devotion(json: value)) }
                        
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
	}
    
    /**
    Get months devotionals
    - Parameters:
        - searchTerm: The string to search for
    - Returns: The devotions in an array
    */
    func search(searchTerm: String, completion: @escaping ([Devotion]?, Error?) throws -> Void) {
        let url = "\(baseURL)devotionals/"
        let parameters = ["search": searchTerm]
        var devotions: [Devotion] = []
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    
                    let json = try JSON(data: data)
                    self.next = json["next"].string
                    self.prev = json["prev"].string
                    self.count = json["count"].int
                    let results = json["results"]
                    results.forEach { (_, value) in devotions.append(Devotion(json: value)) }
                    
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
	
    /**
     Get a months devotions
     - Parameters:
     - year: Year of the devotions
     - month: Month of the devotions
     - Returns: The devotion in an array
     */
    func getMonthsDevotions(year: Int, month: Int, order: DevotionOrderType = .ascending, completion: @escaping ([Devotion]?, Error?) throws -> Void) {
        let url = "\(baseURL)devotionals/"
        let parameters: [String: Any] = ["date_year": year, "date_month": month, "ordering": order.rawValue]
        var devotions: [Devotion] = []
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    
                    let json = try JSON(data: data)
                    self.next = json["next"].string
                    self.prev = json["prev"].string
                    self.count = json["count"].int
                    let results = json["results"]
                    results.forEach { (_, value) in devotions.append(Devotion(json: value)) }
                    
                    try completion(devotions, nil)
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
