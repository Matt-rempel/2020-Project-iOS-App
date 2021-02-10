//
//  CalendarDetailTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-12-29.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class CalendarDetailTableView: UITableViewController {
	
	var viewYear:String!
	var viewMonth:String!
    var devotions:[Devotion] = []
    var isLoadingNext = true {
        willSet(value) {
            setLoading(value)
        }
    }
    
    var dateFormater = DateFormater()
    var pagingManager = PagingManager(pagingViewType: .month)
    var udManager = UserDefaultsManager()
    lazy var scManager = ScriptureManager()
   
    // DB Access
    let dbAccessor = DBAccessor()
    let usDownloader = UnsplashDownloader()
    let circleProgressPieBuilder = CirclePieBuilder()
    let icloudManager = iCloudManager()
    
    // Navigation bar
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    // IBOutlets
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

		// Navigation Bar
		self.navigationItem.title = viewMonth
        
        // Loading indicator
        let loadingButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButtonItems([sortButton, loadingButton], animated: true)
        
		// TableView
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 60.0
        
		
		if Reachability.isConnectedToNetwork() {
            loadDevotionsFromAPI()
		} else {
            self.tableView.setEmptyView(title: "", message: "Could not connect to the internet")
		}
        
        // Bar Buttons
        if #available(iOS 13, *) {
            
        } else {
            // Some iOS 12 UI Stuff
            sortButton.image = UIImage(named: "sort")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - IBActions
    @IBAction func sortPressed(_ sender: Any) {
        udManager.toggleOrder()
        loadDevotionsFromAPI()
    }
    
    
    // MARK: - TableView
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devotions.count > 0 {
            self.tableView.restore()
        }
		return devotions.count
	}
    
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarCell
		let cellDevotion = devotions[indexPath.row]

		cell.dayLabel.text = dateFormater.getStringDateOfMonth(date: cellDevotion.date)
		cell.titleLabel.text = cellDevotion.title
        cell.authorLabel.text = cellDevotion.author.name
        circleProgressPieBuilder.setUpProgressCircle(for: cell.progressPie, checkMarkImageView: cell.checkMarkImageView, devotion: cellDevotion, scManager: scManager)

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
    
    // MARK: ScrollView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If at bottom
        if (scrollView.contentOffset.y + 200 >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            loadNext()
        }
        
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
    
    // MARK: Paging Manager
    func loadNext() {
        if !isLoadingNext {
            
            guard let _ = pagingManager.next else {
                return
            }
            
            isLoadingNext = true
            
            pagingManager.nextPage { (devotions, error) in

                if let devotions = devotions {
                    self.devotions.append(contentsOf: devotions)
                    self.tableView.reloadData()
                }
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    let alert = UIAlertController(title: "Error loading devotions", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {_ in
                        self.loadNext()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                self.isLoadingNext = false
            }
            
        }
    }
    
    func loadDevotionsFromAPI() {
        if let year = Int(viewYear) {
            let month = dateFormater.monthNameToInt(input: viewMonth)
            let order = udManager.getSortOrder() ?? .ascending
            pagingManager.getMonthsDevotions(year: year, month: month, order: order) { (devotions, error) in
                if let devotions = devotions {
                    self.devotions = devotions
                    print(self.devotions)
                }

                if let error = error {
                    self.showAlert(withTitle: "Could not get devotions", message: "Check your internet connection and try again")
                    print(error)
                }
                
                self.isLoadingNext = false
                self.tableView.reloadData()
            }
        } else {
            // TODO: Handle error
        }
    }

}
