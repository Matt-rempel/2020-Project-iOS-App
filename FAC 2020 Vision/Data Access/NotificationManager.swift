//
//  NotificationManager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2021-01-13.
//  Copyright © 2021 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NotificationManager: DBAccessor {
    
    //    MARK: Notification
    /**
     Get a specific devotion
     - Returns: The notifications
     */
    func getNotifications(_ completion: @escaping ([APINotification]?, Error?) throws -> ()) {
        let url = "\(baseURL)notifications/"
        var notifications:[APINotification] = []

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    let json = try JSON(data: data)
                    json.forEach { (key, value) in notifications.append(APINotification(json: value)) }
                    try completion(notifications, nil)
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
