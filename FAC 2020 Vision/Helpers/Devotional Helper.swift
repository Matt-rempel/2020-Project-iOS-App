//
//  Devotional.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-10.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

/**
 THIS FILE IS UNUSED AS OF VERSION 2.0.0
 */

//import Foundation
//import UIKit

//class DevotionalHelper {
//	enum sortDirection{
//		case up
//		case down
//	}
//	public static var ALL_DEVOS:[Devotional] = []
//
//	public static func sortDevosByDate(devos: [Devotional], direction: sortDirection? = .up) -> [Devotional] {
//		if direction == .down {
//			return devos.sorted(by: { $0.date ?? Date() > $1.date ?? Date()})
//		} else {
//			return devos.sorted(by: { $0.date ?? Date() < $1.date ?? Date()})
//		}
//	}
//
//	public static func sortStringMonths(input: [String]) -> [String] {
//		let formatter : DateFormatter = {
//			let df = DateFormatter()
//			df.locale = Locale(identifier: "en_US_POSIX")
//			df.dateFormat = "MMMM"
//			return df
//		}()
//
//		return input.sorted( by: { formatter.date(from: $0)! < formatter.date(from: $1)! })
//	}
//
//}


//class ScriptureHelper {
//	public static func getScripturePreviewText(scripture: Scripture?) -> String {
//		var output = ""
//		
//		if let scripture = scripture {
//			output += getPassgeTextPreviews(passages: scripture.OT) + "\n"
//			output += getPassgeTextPreviews(passages: scripture.NT) + "\n"
//			output += getPassgeTextPreviews(passages: scripture.PP)
//		}
//		
//		return output
//	}
//	
//	static func getPassgeTextPreviews(passages: [Passage]) -> String {
//		var output = ""
//		
//		for passage in passages {
//			if let passageText = passage.title {
//				output += "\(passageText)"
//			}
//		}
//		
//		return output
//	}
//}

//class Devotional {
//	var UDID:String?
//	var month:String?
//	var backgroundImage:UIImage?
//	var date:Date?
//	var message:Message?
////	var scripture:Scripture?
//	var unsplah_link:String?
//
//	// MARK: - Image Downloading
//	func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//	}
//
//    func downloadImage(from url: URL, indexPath: IndexPath, hasLoadedPopUps: Bool, completion: @escaping (_ result:Bool, _ image: UIImage?, _ indexPath: IndexPath, _ hasLoadedPopUps: Bool) -> ()) {
//		getData(from: url) { data, response, error in
//			guard let data = data, error == nil else { return }
//
//            DispatchQueue.main.async() {
//                let image = UIImage(data: data)
//				self.backgroundImage = image
//				completion(true, image, indexPath, hasLoadedPopUps)
//			}
//		}
//	}
//}

//class Author {
//	var name:String?
//	var title:String?
//	var bio:String?
//}

//class Scripture {
//	var hasScripture:Bool = true
//	var OT:[Passage] = []
//	var NT:[Passage] = []
//	var PP:[Passage] = []
//
//	func getAllPassages() -> [Passage] {
//		return self.OT + self.NT + self.PP
//	}
//
//	func getProgess() -> Float {
//		var total = 0
//		var completed = 0
//
//		let passages = self.getAllPassages()
//		for p in passages {
//			total += 1
//			completed += (p.isCompleted ? 1 : 0)
//		}
//		return Float(completed) / Float(total)
//	}
//}

//class Message {
//	var author:Author?
//	var title:String?
//	var body:String?
//}

//class Passage {
//	var title:String!
//    var parts:PassageParts!
//	var KJV_text:String?
//	var NLT_text:String?
//	var ESV_text:String?
//    var NIV_text:String?
//	var isCompleted:Bool! = false
//}

//class PassageParts {
//    var start:String?
//    var end:String?
//    var book:String?
//
//    init(start: String?, end: String?, book: String?) {
//        self.start = start
//        self.end = end
//        self.book = book
//    }
//}
