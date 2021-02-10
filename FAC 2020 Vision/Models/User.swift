//
//  User.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-11-26.
//  Copyright © 2020 Foothills Alliance Church. All rights reserve  d.
//

import Foundation
import SwiftyJSON
import UIKit

struct User {
    var firstName: String?
    var lastName: String?
    var email: String?
    var dateJoined: Date?
    var isActive: Bool?
    var isStaff: Bool?
    var username: String?
    
//    init(name: String?, email: String?) {
//        self.name = name
//        self.email = email
//    }
    
    internal init(json:JSON)  {
        dateJoined = DateFormater().getDateFromStringLong(json["date_joined"].string)
        email = json["email"].string
        firstName = json["first_name"].string
        lastName = json["last_name"].string
        isActive = json["is_active"].bool
        isStaff = json["is_staff"].bool
        username = json["username"].string
    }
}

