//
//  CalendarDetailTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-12-29.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class CalendarDetailTableView: UITableViewController {
	
	var ALL_DEVOS:[Devotional]! = []
	var all_devos:[Devotional]! = []
	var delegate:DevotionalCollectionView!
	var viewYear:String!
	var viewMonth:String!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Navigation Bar
		self.navigationItem.title = viewMonth
		
		// TableView
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 60.0
        
		
		if Reachability.isConnectedToNetwork() {
			// Firebase
			checkVersion(with: viewMonth, and: viewYear)
		} else {
			self.loadDevosFromStorage(month: viewMonth, year: viewYear, firebaseVersion: 0)
		}
    }

    // MARK: - TableView
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return all_devos.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarCell
		let cellData = all_devos[indexPath.row]

//		let progress = cellData.scripture?.getProgess() ?? 0.0

		cell.dayLabel.text = DateHelper.getStringDateOfMonth(date: cellData.date)
		cell.titleLabel.text = cellData.message?.title
		cell.authorLabel.text = cellData.message?.author?.name
		
//		if progress == 0.0 || progress > 0.95 {
//			cell.progressPie.backgroundColor = UIColor.clear
//		} else if #available(iOS 13.0, *) {
//			cell.progressPie.backgroundColor = UIColor.clear
//		} else {
//			cell.progressPie.backgroundColor = Colors.fadedColor
//		}
//
//		if progress > 0.95 {
//			if #available(iOS 13.0, *) {
//				cell.checkMarkImageView.image = UIImage(systemName: "checkmark.circle")
//			} else {
//				cell.checkMarkImageView.image = UIImage(named: "checkmark")
//			}
//			cell.checkMarkImageView.isHidden = false
//			cell.progressPie.isHidden = true
//		} else {
//			cell.checkMarkImageView.isHidden = true
//			cell.progressPie.isHidden = false
//		}
//
//		cell.progressPie.pieFilling = CGFloat(progress)
//		cell.progressPie.setNeedsDisplay()

        return cell

	}
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let selectedDevotional = all_devos[indexPath.row]
//		delegate.selectedDevotional = selectedDevotional

		self.dismiss(animated: true) {
			self.delegate.performSegue(withIdentifier: "segue", sender: nil)
		}
		
	}

    // MARK: - User Defaults
	func loadDevosFromStorage(month:String, year: String, firebaseVersion: Int) {
		let key = month + year + "k"
		if let value = UserDefaultsHelper.getDictionaryValueWith(key: key) as? [String : [String : Any]] {
			createObjects(value: value, month: month)
		} else {
			if Reachability.isConnectedToNetwork() {
				pullFirebase(month: month, year: year, firebaseVersion: firebaseVersion)
			} else {
				self.showAlert(withTitle: "No Network Connection!", message: "Connect to the internet and try again.")
			}
		}
	}
	
	func saveDevosToStorage(month:String, year:String, value:[String : [String : Any]], firebaseVersion: Int) {
		// Save Value
		let key = month + year + "k"
		UserDefaultsHelper.set(value: value, key: key)
		
		// Save Version Number
		let versionKey = year + "-" + month
		UserDefaultsHelper.setSavedDevoVersion(key: versionKey, value: firebaseVersion)
	}
	
	// MARK: - Firebase
	// This will pull the full month. Instead of pulling each day from the month I'm pulling the full month... idk what's better a bunch of short connections or one "big" (~25kb) one...
	func checkVersion( with month:String, and year:String) {
		// Check if saved data is current
//		let versionKey = year + "-" + month
//		if let firebaseVersion = FBHelper.versionNumbers[versionKey] {
//			let localVersion = UserDefaultsHelper.getSavedDevoVersion(key: versionKey)
//			if firebaseVersion == localVersion {
//				self.loadDevosFromStorage(month: month, year: year, firebaseVersion: firebaseVersion)
//			} else {
//				self.pullFirebase(month: month, year: year, firebaseVersion: firebaseVersion)
//			}
//		} else {
//			self.pullFirebase(month: month, year: year, firebaseVersion: 0)
//			print("No versions key for FBHelper.ref.child(versions).child(\(year)-\(month))")
//		}
	
	}
	
	func pullFirebase(month:String, year:String, firebaseVersion:Int) {
//		FBHelper.ref.child("devotionals").child(year).child(month).observeSingleEvent(of: .value, with: { (snapshot) in
//			if let value = snapshot.value as? [String : [String : Any]] {
//				self.saveDevosToStorage(month: month, year: year, value: value, firebaseVersion: firebaseVersion)
//				self.createObjects(value: value, month: month)
//			} else {
//				print("FBHelper.ref.child(devotionals).child(\(year)).child(\(month)) is giving me: \(snapshot.value ?? "none")")
//			}
//		}) { (error) in
//			print(error.localizedDescription)
//		}
	}
	
	
	// MARK: - Make Objects
		func createObjects(value: [String : [String : Any]], month: String) {
							
//			for (date, dateDate) in value {
//				if let dateObj = DateHelper.getDateFrom(string: date) {
//
//					#if DEBUG
//						let isCurrent = true
//					#else
//						let isCurrent = dateObj <= Date()
//					#endif
//					
//					if isCurrent {
//						
//						let newDevotional = Devotional()
//						let newAuthor = Author()
//						let newMessage = Message()
////						let newScripture = Scripture()
//						
//
//						newDevotional.date = dateObj
//						newDevotional.month = month
//						
//						// Get iCloud completion data
//						let iCloudCompletion = NSUbiquitousKeyValueStore.default.dictionary(forKey: date) ?? [:]
//						
//						// Get message
//						if let messageData = dateDate["message"] as? [String : Any] {
//							
//							if let authorData = messageData["author"] as? [String : String] {
//								newAuthor.name = authorData["name"]
//								newAuthor.title = authorData["title"]
//								newAuthor.bio = authorData["bio"]
//							} else {
//								newAuthor.name = ""
//								newAuthor.title = ""
//								newAuthor.bio = ""
//							}
//							
//							newMessage.author = newAuthor
//							newMessage.title = messageData["title"] as? String ?? ""
//							if let title = messageData["title"] as? String {
//								newMessage.title = title
//							} else {
//								if let dateObj = newDevotional.date {
//									newMessage.title = DateHelper.getPrettyStringFrom(date: dateObj)
//								} else {
//									newMessage.title = date
//								}
//							}
//							newMessage.body = messageData["body"] as? String ?? "No devotional message for today"
//						}
//						
//						// Get scripture
//						if let scriptureData = dateDate["scripture"] as? [String : [[String : Any]]] {
//							if let NTData = scriptureData["NT"] {
//								for passageIndex in 0...NTData.count-1 {
//									let passage = NTData[passageIndex]
//									let newPassge = Passage()
//									newPassge.title = passage["title"] as? String ?? ""
//									newPassge.KJV_text = passage["kjv"] as? String ?? ""
//									newPassge.ESV_text = passage["esv"] as? String ?? ""
//									newPassge.NLT_text = passage["nlt"] as? String ?? ""
//                                    let parts = passage["parts"] as? [String:String] ?? [:]
//                                    newPassge.parts = PassageParts(start: parts["start"], end: parts["end"], book: parts["book"])
//									
//									
//									if let completionData = iCloudCompletion[newPassge.title] as? Bool {
//										newPassge.isCompleted = completionData
//									}
//									
//									newScripture.NT.append(newPassge)
//								}
//							}
//							
//							if let OTData = scriptureData["OT"] {
//								for passage in OTData {
//									let newPassge = Passage()
//									newPassge.title = passage["title"] as? String ?? ""
//									newPassge.KJV_text = passage["kjv"] as? String ?? ""
//									newPassge.ESV_text = passage["esv"] as? String ?? ""
//									newPassge.NLT_text = passage["nlt"] as? String ?? ""
//                                    let parts = passage["parts"] as? [String:String] ?? [:]
//                                    newPassge.parts = PassageParts(start: parts["start"], end: parts["end"], book: parts["book"])
//                                    
//									if let completionData = iCloudCompletion[newPassge.title] as? Bool {
//										newPassge.isCompleted = completionData
//									}
//									
//									newScripture.OT.append(newPassge)
//								}
//							}
//							
//							if let PPData = scriptureData["PP"] {
//								for passage in PPData {
//									let newPassge = Passage()
//									newPassge.title = passage["title"] as? String ?? ""
//									newPassge.KJV_text = passage["kjv"] as? String ?? ""
//									newPassge.ESV_text = passage["esv"] as? String ?? ""
//									newPassge.NLT_text = passage["nlt"] as? String ?? ""
//                                    let parts = passage["parts"] as? [String:String] ?? [:]
//                                    newPassge.parts = PassageParts(start: parts["start"], end: parts["end"], book: parts["book"])
//                                    
//									if let completionData = iCloudCompletion[newPassge.title] as? Bool {
//										newPassge.isCompleted = completionData
//									}
//									
//									newScripture.PP.append(newPassge)
//								}
//							}
//						} else {
//							newScripture.hasScripture = false
//						}
//						
//						let unsplash_link = dateDate["unsplash_photo"] as? String ?? ""
//						
//						newDevotional.message = newMessage
//						newDevotional.UDID = date
//						newDevotional.scripture = newScripture
//						newDevotional.unsplah_link = unsplash_link
//						
//						self.all_devos.append(newDevotional)
//					}
//				}
//			}
//			
//			self.all_devos = self.all_devos.sorted(by: { $0.date ?? Date() < $1.date ?? Date()})
//
//			self.ALL_DEVOS = self.all_devos
//
//			self.tableView.reloadData()
			
		}

}
