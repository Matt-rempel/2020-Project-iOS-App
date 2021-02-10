//
//  Devo_loader.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-08-20.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import WidgetKit

//struct DevoSnippet {
//	let title: String
//	let scripture: String
//	let formatedScripture: String
//	let author: String
//	let date: String
//	let unsplash_url: String
//}



//class DevoSnippetLoader {
    
//    let slFormater = ScriptureListFormater()
    
//    func fetch(completion: @escaping (Result<DevoSnippet, Error>) -> Void) {
//
//		let url = URL(string: "https://v2.the2020project.ca/api/v2/devotionals/widget/")!
//
//		var request = URLRequest(url: url)
//
//		request.addValue("Token 586ed88705907f8e936b43bb71fd3a53623df2be", forHTTPHeaderField: "Authorization")
//		request.httpMethod = "GET"
//
//		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//			guard error == nil else {
//				completion(.failure(error!))
//				return
//			}
//            let commit = self.getDevoInfo(fromData: data!)
//			completion(.success(commit))
//		}
//
//
//		task.resume()
//	}
    
//	func getDevoInfo(fromData data: Foundation.Data) -> DevoSnippet {
//		let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [Any]
//		let data = json?[0] as! [String : Any]
//
//		let unsplash_id = data["unsplash_id"] as? String ?? "QwTquQ1zpsU"
//		let authorData = data["author"] as? [String : String] ?? [:]
//		let ntScriptureData = data["new_testaments"] as? [[String : String]] ?? []
//		let otScriptureData = data["old_testaments"] as? [[String : String]] ?? []
//		let ppScriptureData = data["psalm_proverbs"] as? [[String : String]] ?? []
//		let date = data["date"] as? String ?? ""
//		let title = data["title"] as? String ?? "Todays devotional could not be found"
//
//		let author = authorData["name"] ?? "The 2020 Project"
//		let ntScripture = ntScriptureData[0]["title"] ?? ""
//		let otScripture = otScriptureData[0]["title"] ?? ""
//		let ppScripture = ppScriptureData[0]["title"] ?? ""
//
//		var scripture = ""
//		var formatedScripture = ""
//
//		let ntFormatedTitle = slFormater.getFormatedTitle(title: ntScripture)
//		scripture += "• \(ntScripture)\n"
//		formatedScripture += "• \(ntFormatedTitle)\n"
//
//		let otFormatedTitle = slFormater.getFormatedTitle(title: otScripture)
//		scripture += "• \(otScripture)\n"
//		formatedScripture += "• \(otFormatedTitle)\n"
//
//		let ppFormatedTitle = slFormater.getFormatedTitle(title: ppScripture)
//		scripture += "• \(ppScripture)\n"
//		formatedScripture += "• \(ppFormatedTitle)"
//
//		let unsplash_url = "https://source.unsplash.com/" + unsplash_id + "/800x800"
//
//		return DevoSnippet(title: title, scripture: scripture, formatedScripture: formatedScripture, author: author, date: date, unsplash_url: unsplash_url)
//	}
//}
