//
//  BookmarksTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-01-02.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import UIKit

class BookmarksTableView: UITableViewController {

	
    var devotions:[Devotion] = []
	
    let dateFormater = DateFormater()
    let dbAccessor = DBAccessor()
    let udManager = UserDefaultsManager()
    let authManager = AuthenticationManager()
    let bookmarkManager = BookmarkManager()
    
    // Navigation bar
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		// TableView
        self.tableView.rowHeight = 60
        
	}

	override func viewWillAppear(_ animated: Bool) {
        
		// Navigation Controller
		self.navigationController?.navigationBar.prefersLargeTitles = true
		
        // Loading indicator
        let loadingButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(loadingButton, animated: true)

        // Get the bookmarks
        loadBookmarks()
        

	}
    
    func loadBookmarks() {
        setLoading(true)
        bookmarkManager.getBookmarks { (devotions, error) in
            print(error)
            // TODO: Handle error
            self.devotions = devotions ?? []
            self.devotions.sort(by: { $0.date < $1.date })
            self.tableView.reloadData()
            self.setLoading(false)
        }
        
        
    }
    
    

    func loadNewBookmarksFormat() {
        
    }
    
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devotions.count == 0 {
            self.tableView.setEmptyView(title: "No Bookmarks Found", message: "Tap the bookmark button on the top right when reading a devotion to save it here")
        } else {
            self.tableView.restore()
        }
        return devotions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookmarksTableViewCell
        let cellDevotion = devotions[indexPath.row]

        cell.dateLabel.text = dateFormater.getMedDate(input: cellDevotion.date)
		cell.titleLabel.text = cellDevotion.title
        cell.authorLabel.text = cellDevotion.author.name

        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDevotional = devotions[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let devotionalDetailView = storyBoard.instantiateViewController(withIdentifier: "DevotionalDetailView") as! DevotionalDetailView
        devotionalDetailView.devotion = selectedDevotional
        
        let navController = UINavigationController()
        navController.viewControllers = [devotionalDetailView]
        
        devotionalDetailView.addDoneButton()
        
        self.present(navController, animated: true, completion: nil)
        
	}
	
    // MARK: - Loading Indicator
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        activityIndicator.isHidden = !isLoading
    }
    
    
	// MARK: - IBActions
	@IBAction func donePressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
}
