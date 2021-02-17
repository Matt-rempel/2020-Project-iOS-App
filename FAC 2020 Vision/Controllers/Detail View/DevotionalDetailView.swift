//
//  DevotionalDetailView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-17.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit
//import NotificationBannerSwift
import Alamofire

class DevotionalDetailView: UITableViewController {

	// Variables
	let numOfTableViewSections = 4
	
	var devotion: Devotion!
	var selectedScripture: Scripture!
    // I made it like this so that the UI will always reflect the bool value
    var viewDevotionIsBookmarked: Bool = false {
        didSet(value) {
            updateBookmarkUI()
        }
    }
    
    let dbAccessor = DBAccessor()
    let usDownloader = UnsplashDownloader()
    let icloudManager = IcloudManager()
    let dateFormater = DateFormater()
    let udManager = UserDefaultsManager()
    let scriptureManager = ScriptureManager()
    let authManager = AuthenticationManager()
    let bookmarkManager = BookmarkManager()
    
	// IBOutlets
	@IBOutlet weak var bookmarkButton: UIBarButtonItem!
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Navigation Controller
        self.navigationItem.title = dateFormater.getPrettyStringFrom(date: devotion.date)
		
		// TableView
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 60.0
		self.tableView.reloadData()
		self.tableView.tableFooterView = UIView()
        
        // Bookmark Button
        setUpBookmarkButton()
        
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		// Navigation Controller
		self.navigationController?.hidesBarsOnSwipe = false
		self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.navigationBar.prefersLargeTitles = false

        // Load the devo from the api
        loadDevoFromAPI()
        
		self.tableView.reloadData()
		
		// Bookmark Button
		updateBookmarkUI()
	}
    
    // MARK: API
    func loadDevoFromAPI() {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: devotion.date)
        let month = calendar.component(.month, from: devotion.date)
        let day = calendar.component(.day, from: devotion.date)
       
        dbAccessor.getDevotion(year: year, month: month, day: day) { (devotion, error) in
            if let devotion = devotion {
                self.devotion = devotion
                self.scriptureManager.getScriptureProgress(devotion: devotion) { (error) in
                    self.tableView.reloadData()
                    if let error = error {
                        print(error)
                    }
                }
                
            }
            
            if let error = error {
                let alert = UIAlertController(title: "Error loading devotions", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {_ in
                    self.loadDevoFromAPI()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    // MARK: - Navigation Bar
    func addDoneButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.setLeftBarButton(doneButton, animated: true)
    }
    
    @objc func doneTapped() {
        self.dismiss(animated: true, completion: nil)
    }
	
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numOfTableViewSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
            return devotion.scriptue.count
		case 2:
			return 1
		case 3:
			return 1
		default:
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! PictureCell
			cell.titleLabel.text = devotion.title
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
            cell.downloadImage(from: devotion.unsplashId)
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: "scriptureCell", for: indexPath) as! ScriptureCell
            let cellData = devotion.scriptue[indexPath.row]

			cell.titleLabel?.text = cellData.title
			cell.checkmarkImageView.isHidden = !cellData.isCompleted

			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell

            var formatedText = devotion.body ?? "Loading..."
            
            // So when Dayla uploads these sometime there are just a ton of extra lines... so this is the "solution"
            formatedText = formatedText.replacingOccurrences(of: "\n\n \n\n", with: "\n\n")
            formatedText = formatedText.replacingOccurrences(of: "\n\n\n\n\n", with: "\n\n")
            formatedText = formatedText.replacingOccurrences(of: "\n\n\n\n", with: "\n\n")

            // Give the text some better spacing
			let attributedString = NSMutableAttributedString(string: formatedText)
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 5
			attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
			
			cell.messageBodyLabel?.attributedText = attributedString
			cell.authorLabel.text = devotion.author.name
            cell.authorTitleLabel.text = devotion.author.title
			
			return cell
		case 3:
			let cell = tableView.dequeueReusableCell(withIdentifier: "shareCell", for: indexPath) as! ShareCell
			
			cell.delegate = self
			cell.sharingURL = devotion.shareURL

			return cell
		default:
			print("Error: Cells out of range!!")
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			
			return cell
		}
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedScripture = devotion.scriptue[indexPath.row]
            performSegue(withIdentifier: "scriptureView", sender: nil)
            scriptureManager.setScriptureProgress(devotion: devotion, scripture: selectedScripture) { (error) in
                if let error = error {
                    // TODO: Handle error
                    print(error)
                }
            }
        }
    }

	// MARK: - IBOutlets
	@IBAction func didPressBookmark(_ sender: Any) {
        bookmarkManager.toggleBookmark(devotion: devotion) { (_) in
            self.viewDevotionIsBookmarked.toggle()
            self.updateBookmarkUI()
        }
	}
	
	// MARK: - Bookmarks
    func setUpBookmarkButton() {
        bookmarkManager.isBookmarked(devotion: devotion) { (isBookmarked, error) in
            self.viewDevotionIsBookmarked = isBookmarked
            if let error = error {
                print(error)
                self.showAlert(withTitle: "Error Bookmarking", message: "Could not bookmark devotion, try again later.")
            }
        }
    }
    
	private func updateBookmarkUI() {
        if self.viewDevotionIsBookmarked {
            if #available(iOS 13.0, *) {
                bookmarkButton.image = UIImage(systemName: "bookmark.fill")
            } else {
                bookmarkButton.image = UIImage(named: "bookmark icon fill")
            }
		} else {
            if #available(iOS 13.0, *) {
                bookmarkButton.image = UIImage(systemName: "bookmark")
            } else {
                bookmarkButton.image = UIImage(named: "bookmark icon")
            }
		}
	}

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let scriptureVC = segue.destination as! ScriptureViewController
        scriptureVC.viewScripture = selectedScripture
    }
}
