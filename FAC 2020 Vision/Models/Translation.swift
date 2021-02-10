//
//  Translation.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-03.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

struct Translation {
    var translation: String
    var reading: String
    var copyright: String
    
    internal init(json: [String : String]) {
        translation = json["translation"] ?? ""
        reading = json["reading"] ?? ""
        copyright = json["copyright"] ?? ""
    }
}
