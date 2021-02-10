//
//  DevoSnippet.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-11-26.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct Devotion {
	
	var title: String
	var author: Author
	var date: Date
	var unsplash_id: String
	var body: String?
	var bodyHTML: String?
    var scriptue: [Scripture] = []
	var scriptureList: String = ""
	var scriptureListFormated: String = ""
    var shareURL: String = "https://2020project.ca/devotionals/"
//    lazy var scriptureManager = ScriptureManager()
	
	internal init(json:JSON) {
        let dateFormater = DateFormater()
        
        date = dateFormater.getDateFrom(string: json["date"].string ?? "") ?? Date()
		title = json["title"].string ?? ""
	    unsplash_id = json["unsplash_id"].string ?? ""
	    body = json["body"].string
		bodyHTML = json["body_html"].string
	    let author_name = json["author"]["name"].string ?? ""
	    let author_title = json["author"]["title"].string ?? ""
		author = Author(title: author_title, name: author_name)
        if let datePath = json["date"].string?.replacingOccurrences(of: "-", with: "/") {
            shareURL += "\(datePath)/"
        }
        let scriptureJSONArray = json["scripture"].arrayObject as? [[String : Any]] ?? []
        
        let scriptureFormater = ScriptureListFormater()
        
        if scriptureJSONArray.count > 0 {
            for i in 0...scriptureJSONArray.count-1 {
                let scriptureJSON = scriptureJSONArray[i]
                let scripture = Scripture(json: scriptureJSON)
                scriptue.append(scripture)
                
                let formatedTitle = scriptureFormater.getFormatedTitle(title: scripture.title)
                scriptureList += "• \(scripture.title)"
                scriptureListFormated += "• \(formatedTitle)"
                
                if i != scriptureJSONArray.count-1 {
                    scriptureList += "\n"
                    scriptureListFormated += "\n"
                }
            }
        }
        
//        print("Getting progress for: \(json["date"])")
//        scriptureManager.getScriptureProgress(devotion: self)
        
	}
    
    internal init() {
        let photos = ["dqx3HQDrXuw", "NHUni99NTYc", "9xlBSoik8-E", "VTTIwD65eD4", "TnqnRxBEVek", "ZTpW2l8XZkw"]
        date = Date()
        title = "In The Beginning"
        unsplash_id = photos.randomElement() ?? "dqx3HQDrXuw"
        author = Author(title: "Lead Pastor", name: "Ian Trigg")
        scriptureList = "• Matthew 1:1-25\n• Genesis 1:1-2:17\n• Psalm 1:1-6"
        scriptureListFormated = "• Matt. 1:1-25\n• Gen. 1:1-2:17\n• Psalm 1:1-6"
    }
    
    internal init(error: Error) {
        let photos = ["dqx3HQDrXuw", "NHUni99NTYc", "9xlBSoik8-E", "VTTIwD65eD4", "TnqnRxBEVek", "ZTpW2l8XZkw"]
        date = Date()
        title = "Today's Devotion"
        unsplash_id = photos.randomElement() ?? "dqx3HQDrXuw"
        author = Author(title: "", name: "")
        scriptureList = "We are working on getting today's devotion ready"
        scriptureListFormated = "We are working on getting today's devotion ready"
    }
}
