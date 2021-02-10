//
//  CalendarTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-23.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class CalendarTableView: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    var searchTerm = ""
	
	var ALL_DEVOS_ALL_TIME:[String : [Devotional]]! = [:]
	var all_devos_all_time:[String : [Devotional]]! = [:]
	var ALL_MONTHS:[String]! = []
	var sectionTitles:[String]! = []
	var delegate:DevotionalCollectionView!
	var selectedYear:String!
	var selectedMonth:String!
    var isSearching = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Table View
        self.tableView.estimatedRowHeight = 60.0

        // Search Controller
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search..."
        self.searchController.searchBar.barStyle = .default
        self.searchController.searchBar.delegate = self

//        self.definesPresentationContext = false
//        self.providesPresentationContextTransitionStyle = true
		
		// Navigation Item
		
		// Navigation Controller
//		self.navigationItem.largeTitleDisplayMode = .always
//		self.navigationController?.navigationItem.largeTitleDisplayMode = .always
//		self.navigationController?.navigationBar.prefersLargeTitles = true
		
		self.navigationItem.searchController = searchController
		self.navigationItem.hidesSearchBarWhenScrolling = true
		
		sectionTitles = getMonths()
		
		
    }
	

	override func viewWillAppear(_ animated: Bool) {
		tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
		
		// Navigation Controller
		self.navigationItem.largeTitleDisplayMode = .always
		self.navigationController?.navigationItem.largeTitleDisplayMode = .always
		self.navigationController?.navigationBar.prefersLargeTitles = true
		
		tableView.reloadData()
	}

	
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return Array(all_devos_all_time.keys).count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            var months = Array(all_devos_all_time.keys)
            months = DevotionalHelper.sortStringMonths(input: months)
            let currentMonth = months[section]
            let currentDevos = all_devos_all_time[currentMonth]
            return currentDevos?.count ?? 0
        } else {
            return sectionTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell:CalendarCell! = tableView.dequeueReusableCell(withIdentifier: "devoCell", for: indexPath) as? CalendarCell
            var months = Array(all_devos_all_time.keys)
            months = DevotionalHelper.sortStringMonths(input: months)
            
            let currentMonth = months[indexPath.section]
            let currentDevos = all_devos_all_time[currentMonth]
            let cellData = currentDevos![indexPath.row]
            
//            let progress = cellData.scripture?.getProgess() ?? 0.0

            cell.dayLabel.text = DateHelper.getStringDateOfMonth(date: cellData.date)
            cell.titleLabel.text = cellData.message?.title
            cell.authorLabel.text = cellData.message?.author?.name
            
//            if progress == 0.0 || progress > 0.95 {
//                cell.progressPie.backgroundColor = UIColor.clear
//            } else if #available(iOS 13.0, *) {
//                cell.progressPie.backgroundColor = UIColor.clear
//            } else {
//                cell.progressPie.backgroundColor = Colors.fadedColor
//            }

//            if progress > 0.95 {
//                if #available(iOS 13.0, *) {
//                    cell.checkMarkImageView.image = UIImage(systemName: "checkmark.circle")
//                } else {
//                    cell.checkMarkImageView.image = UIImage(named: "checkmark")
//                }
//                cell.checkMarkImageView.isHidden = false
//                cell.progressPie.isHidden = true
//            } else {
//                cell.checkMarkImageView.isHidden = true
//                cell.progressPie.isHidden = false
//            }
//
//            cell.progressPie.pieFilling = CGFloat(progress)
//            cell.progressPie.setNeedsDisplay()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let cellData = sectionTitles[indexPath.row]
            
            cell.textLabel?.text = cellData
            
            return cell
        }
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            var months = Array(all_devos_all_time.keys)
            months = DevotionalHelper.sortStringMonths(input: months)
            let currentMonth = months[indexPath.section]
            let currentDevos = all_devos_all_time[currentMonth]
            let selectedDevotional = currentDevos![indexPath.row]
            
//            delegate.selectedDevotional = selectedDevotional
            
            self.navigationController?.dismiss(animated: true, completion: {
                self.delegate.performSegue(withIdentifier: "segue", sender: nil)
            })
        } else {
            let currentYear = "2020"
    //            DateHelper.getCurrentYearString()
            selectedYear = currentYear
            selectedMonth = sectionTitles[indexPath.row]
            self.performSegue(withIdentifier: "detail", sender: nil)
        }
	}
    
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            var months = Array(all_devos_all_time.keys)
            months = DevotionalHelper.sortStringMonths(input: months)
            return months[section]
        } else {
            return ""
        }
	}
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            return UITableView().estimatedRowHeight
        } else {
            return 60
        }
    }
	
	// MARK: - Dates
	func getMonths() -> [String] {
		#if DEBUG
			let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
		#else
			let months = DateHelper.getMonthsSoFar()
		#endif
		
		return DevotionalHelper.sortStringMonths(input: months)
	}
	
	
	// MARK: - IBOutlets
	@IBAction func donePressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detail" {
			let vc = segue.destination as! CalendarDetailTableView
			vc.delegate = delegate
			vc.viewYear = selectedYear
			vc.viewMonth = selectedMonth
		}
	}
	
	// MARK: - UISearchResultsUpdating Delegate
	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text

		all_devos_all_time = ALL_DEVOS_ALL_TIME
        if let searchText = searchText {
            if searchText != "" {
                var output_all_devos:[String : [Devotional]] = [:]
//                for (month, monthData) in ALL_DEVOS_ALL_TIME {
//                    var monthDataSearched = monthData.filter({( item : Devotional) -> Bool in
//                        return ScriptureHelper.getScripturePreviewText(scripture: item.scripture).lowercased().contains(searchText.lowercased()) ||
//                            (item.message?.title?.lowercased().contains(searchText.lowercased()))!  ||
//                            (item.message?.author?.name?.lowercased().contains(searchText.lowercased()))! ||
//                            (item.message?.body?.lowercased().contains(searchText.lowercased()))!
//                    })
//                    monthDataSearched.removeDuplicates()
//                    if monthDataSearched.count > 0 {
//                        output_all_devos[month] = monthDataSearched
//                    }
//                }
                all_devos_all_time = output_all_devos
            }
        }
        
		self.tableView.reloadData()
	}
    
    func searchScripture(searchText: String, passages: [Passage]?) -> Bool {
        var output = false
        if let passages = passages {
            for passage in passages {
                if passage.title.lowercased().contains(searchText.lowercased()) {
                    output = true
                }
            }
        }
        return output
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        if ALL_DEVOS_ALL_TIME.isEmpty {
            loadAllDevos()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Reset tableview
        isSearching = false
        self.tableView.reloadData()
    }
    
    // MARK: - Load all devos
    func loadAllDevos() {
        var months = DateHelper.getMonthsSoFar()
        months = DevotionalHelper.sortStringMonths(input: months)
        
        let currentYear = "2020"
        
        for month in months {
            checkVersion(with: month, and: currentYear)
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
//        let versionKey = year + "-" + month
//        if let firebaseVersion = FBHelper.versionNumbers[versionKey] {
//            let localVersion = UserDefaultsHelper.getSavedDevoVersion(key: versionKey)
//            if firebaseVersion == localVersion {
//                self.loadDevosFromStorage(month: month, year: year, firebaseVersion: firebaseVersion)
//            } else {
//                self.pullFirebase(month: month, year: year, firebaseVersion: firebaseVersion)
//            }
//        } else {
//            self.pullFirebase(month: month, year: year, firebaseVersion: 0)
//            print("No versions key for FBHelper.ref.child(versions).child(\(year)-\(month))")
//        }
    
    }
    
    func pullFirebase(month:String, year:String, firebaseVersion:Int) {
//        FBHelper.ref.child("devotionals").child(year).child(month).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let value = snapshot.value as? [String : [String : Any]] {
//                self.saveDevosToStorage(month: month, year: year, value: value, firebaseVersion: firebaseVersion)
//                self.createObjects(value: value, month: month)
//            } else {
//                print("FBHelper.ref.child(devotionals).child(\(year)).child(\(month)) is giving me: \(snapshot.value ?? "none")")
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    
    
    // MARK: - Make Objects
        func createObjects(value: [String : [String : Any]], month: String) {
//            var all_devos:[Devotional] = []
//            for (date, dateDate) in value {
//                if let dateObj = DateHelper.getDateFrom(string: date) {
//
//                    #if DEBUG
//                        let isCurrent = true
//                    #else
//                        let isCurrent = dateObj <= Date()
//                    #endif
//
//                    if isCurrent {
//
//                        let newDevotional = Devotional()
//                        let newAuthor = Author()
//                        let newMessage = Message()
//                        let newScripture = Scripture()
//
//
//                        newDevotional.date = dateObj
//                        newDevotional.month = month
//
//                        // Get iCloud completion data
//                        let iCloudCompletion = NSUbiquitousKeyValueStore.default.dictionary(forKey: date) ?? [:]
//
//                        // Get message
//                        if let messageData = dateDate["message"] as? [String : Any] {
//
//                            if let authorData = messageData["author"] as? [String : String] {
//                                newAuthor.name = authorData["name"]
//                                newAuthor.title = authorData["title"]
//                                newAuthor.bio = authorData["bio"]
//                            } else {
//                                newAuthor.name = ""
//                                newAuthor.title = ""
//                                newAuthor.bio = ""
//                            }
//
//                            newMessage.author = newAuthor
//                            newMessage.title = messageData["title"] as? String ?? ""
//                            if let title = messageData["title"] as? String {
//                                newMessage.title = title
//                            } else {
//                                if let dateObj = newDevotional.date {
//                                    newMessage.title = DateHelper.getPrettyStringFrom(date: dateObj)
//                                } else {
//                                    newMessage.title = date
//                                }
//                            }
//                            newMessage.body = messageData["body"] as? String ?? "No devotional message for today"
//                        }
//
//                        // Get scripture
//                        if let scriptureData = dateDate["scripture"] as? [String : [[String : Any]]] {
//                            if let NTData = scriptureData["NT"] {
//                                for passageIndex in 0...NTData.count-1 {
//                                    let passage = NTData[passageIndex]
//                                    let newPassge = Passage()
//                                    newPassge.title = passage["title"] as? String ?? ""
//                                    newPassge.KJV_text = passage["kjv"] as? String ?? ""
//                                    newPassge.ESV_text = passage["esv"] as? String ?? ""
//                                    newPassge.NLT_text = passage["nlt"] as? String ?? ""
//                                    let parts = passage["parts"] as? [String:String] ?? [:]
//                                    newPassge.parts = PassageParts(start: parts["start"], end: parts["end"], book: parts["book"])
//
//
//
//                                    if let completionData = iCloudCompletion[newPassge.title] as? Bool {
//                                        newPassge.isCompleted = completionData
//                                    }
//
//                                    newScripture.NT.append(newPassge)
//                                }
//                            }
//
//                            if let OTData = scriptureData["OT"] {
//                                for passage in OTData {
//                                    let newPassge = Passage()
//                                    newPassge.title = passage["title"] as? String ?? ""
//                                    newPassge.KJV_text = passage["kjv"] as? String ?? ""
//                                    newPassge.ESV_text = passage["esv"] as? String ?? ""
//                                    newPassge.NLT_text = passage["nlt"] as? String ?? ""
//                                    let parts = passage["parts"] as? [String:String] ?? [:]
//                                    newPassge.parts = PassageParts(start: parts["start"], end: parts["end"], book: parts["book"])
//
//                                    if let completionData = iCloudCompletion[newPassge.title] as? Bool {
//                                        newPassge.isCompleted = completionData
//                                    }
//
//                                    newScripture.OT.append(newPassge)
//                                }
//                            }
//
//                            if let PPData = scriptureData["PP"] {
//                                for passage in PPData {
//                                    let newPassge = Passage()
//                                    newPassge.title = passage["title"] as? String ?? ""
//                                    newPassge.KJV_text = passage["kjv"] as? String ?? ""
//                                    newPassge.ESV_text = passage["esv"] as? String ?? ""
//                                    newPassge.NLT_text = passage["nlt"] as? String ?? ""
//                                    let parts = passage["parts"] as? [String:String] ?? [:]
//                                    newPassge.parts = PassageParts(start: parts["start"], end: parts["end"], book: parts["book"])
//
//                                    if let completionData = iCloudCompletion[newPassge.title] as? Bool {
//                                        newPassge.isCompleted = completionData
//                                    }
//
//                                    newScripture.PP.append(newPassge)
//                                }
//                            }
//                        } else {
//                            newScripture.hasScripture = false
//                        }
//
//                        let unsplash_link = dateDate["unsplash_photo"] as? String ?? ""
//
//
//                        newDevotional.message = newMessage
//                        newDevotional.UDID = date
//                        newDevotional.scripture = newScripture
//                        newDevotional.unsplah_link = unsplash_link
//
//                        all_devos.append(newDevotional)
//                    }
//                }
//            }
//
//            all_devos = all_devos.sorted(by: { $0.date ?? Date() < $1.date ?? Date()})
//
//            if all_devos.count > 0 {
//                self.ALL_DEVOS_ALL_TIME[month] = all_devos
//            }
//
        }

}
