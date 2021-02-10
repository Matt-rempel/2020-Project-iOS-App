//
//  Notification.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2021-01-13.
//  Copyright © 2021 Foothills Alliance Church. All rights reserved.
//

import Foundation
import SwiftyJSON

struct APINotification {
    
    var id: Int
    var title: String
    var body: String
    var actionButtonTitle: String
    var actionButtonLink: URL?
    var dismissButtonTitle: String
    var platform: String
    var appVersion: String

    internal init(json:JSON) {
        
        id = json["id"].int ?? 0
        title = json["title"].string ?? ""
        body = json["body"].string ?? ""
        actionButtonTitle = json["actionButtonTitle"].string ?? ""
        dismissButtonTitle = json["dismissButtonTitle"].string ?? ""
        platform = json["platform"].string ?? "ALL"
        appVersion = json["appVersion"].string ?? "ALL"
        
        if let buttonURLString = json["actionButtonLink"].string {
            actionButtonLink = URL(string: buttonURLString)
        }
    }
    
    
}

