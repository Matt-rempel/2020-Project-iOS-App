//
//  Scripture.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-11-26.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

class Scripture {
	var title: String
	var slug: String
	var translations: [Translation]? = []
    var isCompleted = false
	
    internal init(json: [String: Any]) {
		title = json["title"] as? String ?? ""
		slug = json["slug"] as? String ?? ""
        let translationJSONArray = json["translations"] as? [[String: String]] ?? []
        for translationJSON in translationJSONArray {
            translations?.append(Translation(json: translationJSON))
        }
	}
}
