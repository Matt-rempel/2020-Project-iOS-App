//
//  DevotionalCollectionView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-10.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit
import BLTNBoard
import SafariServices

class TodayView: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating, SFSafariViewControllerDelegate {
    
    var selectedDevotional:Devotion!
    var isLoadingNext = false {
        willSet(value) {
            setLoading(value)
        }
    }
    var hasShownNetworkErrorAlert = false
    
    let dbAccessor = DBAccessor()
    var pagingManager = PagingManager()
    let usDownloader = UnsplashDownloader()
    let dateFormater = DateFormater()
    let circleProgressPieBuilder = CirclePieBuilder()
    let icloudManager = iCloudManager()
    let authManager = AuthenticationManager()
    let scManager = ScriptureManager()
    let notificationManager = NotificationManager()
    let bltnDataSource = BulletinDataSource()
    
    var pagedDevotions:[Devotion] = []
    var searchedDevotions:[Devotion] = []
    var devotions:[Devotion] {
        get {
            return isSearching ? searchedDevotions : pagedDevotions
        }
        set (value) { }
    }
    
    // Search
    let searchController = UISearchController(searchResultsController: nil)
    var searchTerm = ""
    var isSearching: Bool = false {
        willSet(value) {
            self.pagingManager.pagingViewType = (value) ? .search : .today
        }
    }
    
    
    // Navigation bar
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // Bulletin
    var bulletinManager: BLTNItemManager?
    
    @IBOutlet var calendarButton: UIBarButtonItem!
    @IBOutlet var bookmarksButton: UIBarButtonItem!
    @IBOutlet var settingsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Controller
        #if DEBUG
        self.navigationItem.title = "Debug Enabled"
        #else
        self.navigationItem.title = "The 20/20 Project"
        #endif
        
        // Search Controller
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.placeholder = "Devotion titles, Authors..."
        self.searchController.searchBar.barStyle = .default
        self.searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
        // CollectionView
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.keyboardDismissMode = .onDrag
        
        // Loading indicator
        let loadingButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setLeftBarButtonItems([settingsButton, loadingButton], animated: true)
        
        // Load from API
        loadTodayFromAPI()
        
        // Auth Manager
        authManager.autoSignIn()
        
        // Bar Buttons
        if #available(iOS 13, *) {
            
        } else {
            // Some iOS 12 UI Stuff
            calendarButton.image = UIImage(named: "calendar")
            bookmarksButton.image = UIImage(named: "bookmark icon")
            settingsButton.image = UIImage(named: "gear")
        }
        
        // Observe when the app opens from the home screen
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        // Notifications
        getNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Controller
        self.navigationController?.hidesBarsOnSwipe = false
        
        self.collectionView.reloadData()
        

    }
    
    /**
     When a user opens the app and the state of the app was restored from RAM the devotions may not be up to date.
     If the user closed the app close to midnight and opened the app again in the morning there is a high chance that the app will not call the api to get the new devotion
     The following code addresses this problem
     */
    @objc func willEnterForeground() {
        // If the current top devotion isn't from today then reload them from the API
        if let firstDevotion = self.devotions.first, !isSearching {
            let topDevoDate = dateFormater.getStringFrom(date: firstDevotion.date)
            let todaysDate = dateFormater.getStringFrom(date: Date())
            if topDevoDate != todaysDate {
                self.pagingManager = PagingManager()
                self.pagedDevotions.removeAll()
                // Load from API
                loadTodayFromAPI()
            }
        }
    }
    
    // MARK: API calling
    func loadTodayFromAPI() {
        if Reachability.isConnectedToNetwork() {
            self.loadNext()
        } else {
            self.showAlert(withTitle: "No Internet Connection", message: "Could not connect to the internet")
            self.collectionView.setEmptyView(title: "", message: "Could not connect to the internet")
        }
    }
    
    // MARK: Notifications
    func getNotifications() {
        notificationManager.getNotifications { (notifications, error) in
            print(notifications ?? nil)
            var pages:[BLTNItem] = []
            
            for n in notifications ?? [] {
                print(n)
                // TODO: Check notification app version, platform and id
                if n.platform == "ALL" || n.platform == "iOS" {
                    let notificationPage = self.bltnDataSource.getNotification(notification: n, todayView: self)
    //                self.bulletinManager = BLTNItemManager(rootItem: notificationPage)
                    pages.append(notificationPage)
                }
            
            }
            
            if pages.count > 1 {
                for pageIndex in 1...pages.count-1 {
                    let page = pages[pageIndex]
                    pages[pageIndex-1].next = page
                }
            }
            
            guard let firstPage = pages.first else {
                return
            }
            
            self.bulletinManager = BLTNItemManager(rootItem: firstPage)
            self.bulletinManager!.showBulletin(above: self)
            
        }
    }
    
    
    // MARK: SafariServices
    func showSafariWebPageFor(url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        
        present(vc, animated: true)
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
                    if self.isSearching {
                        self.searchedDevotions.append(contentsOf: devotions)
                    } else {
                        self.pagedDevotions.append(contentsOf: devotions)
                    }
                    
                }
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    if !self.hasShownNetworkErrorAlert {
                        let alert = UIAlertController(title: "Error loading devotions", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {_ in
                            self.loadNext()
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.hasShownNetworkErrorAlert = true
                    }
                } else {
                    self.hasShownNetworkErrorAlert = false
                }
                
                self.isLoadingNext = false
                
                self.collectionView.reloadData()
            }
            
        }
    }
    
    // MARK: UICollectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if self.devotions.count == 0 {
            if isSearching {
                self.collectionView.setEmptyView(title: "No Results", message: "Try a new search.")
            } else if isLoadingNext {
                self.collectionView.setEmptyView(title: "", message: "Loading...")
            } else {
                self.collectionView.setEmptyView(title: "", message: "Could not connect to the internet")
            }
        } else {
            self.collectionView.restore()
        }
        
        return self.devotions.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellDevotion = self.devotions[indexPath.section]
        let cell:LargeCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_large", for: indexPath) as? LargeCollectionViewCell
        
        cell.titleLabel.text = cellDevotion.title
        cell.subtitleLabel.text = cellDevotion.scriptureList
        cell.authorLabel.text = cellDevotion.author.name
        
        circleProgressPieBuilder.setUpProgressCircle(for: cell.progressCircle, checkMarkImageView: cell.checkMarkImageView, devotion: cellDevotion, scManager: scManager)
        
        if cell.progressCircle.pieFilling > 0 {
            print("uhhhhh")
            
        }
        
        let unsplash_link = cellDevotion.unsplash_id
        
        if let image = UnsplashCache.photos[unsplash_link] {
            cell.imageView.image = image
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        } else {
            
            let image = UIImage(named: "Dynamic Small")
            cell.imageView.image = image
            
            cell.activityIndicator.startAnimating()
            cell.activityIndicator.isHidden = false
            
            self.usDownloader.getImage(unsplash_id: unsplash_link, indexPath: indexPath) { (image, indexPath, error) in
                
                guard let indexPath = indexPath else {
                    return
                }
                    
                if let callBackCell:LargeCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as? LargeCollectionViewCell {
                    callBackCell.activityIndicator.stopAnimating()
                    callBackCell.activityIndicator.isHidden = true
                    callBackCell.imageView.image = image
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                } else {
                    
                    print("Error: Downloaded image for indexPath (\(indexPath)) and date \(self.dateFormater.getRelativeDateString(date: self.devotions[indexPath.section].date)) is not in view anymore")
                    // I'm not sure this is the best solution to make the images load into the correct cells
                    /**
                     When loading images async sometimes the images will load when the cell is not on screen resulting in the above cellForItem(at: indexPath) to return nil
                     This causes the cell to then show on screen later when the user scroll to it to show a cell trying to load the image even though the image has been loaded
                     onto the device. Calling reloadData() on the collectionview fixes this problem however is seems like an expensive option to fix this problem
                     */
                    self.collectionView.reloadData()
                }
                
                
            }
        }
        
        cell.cellBackgroundView.cardDesign()
        cell.imageView.roundTopCorners()
        cell.gradientView.cardDesign()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        let width:CGFloat = (viewWidth-10)
        let height:CGFloat = 382
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header:LargeHeaderCollectionViewCell! = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "large_header", for: indexPath) as? LargeHeaderCollectionViewCell
        
        if devotions.count != 0 {
            let cellData = self.devotions[indexPath.section]
            header.titleLabel.text = dateFormater.getRelativeDateString(date: cellData.date)
            header.dateLabel.text = dateFormater.getPrettyStringWithDayOfWeekFrom(date: cellData.date)
        } else {
            header.titleLabel.text = ""
            header.dateLabel.text = ""
        }
        
        header.dateLabel.isHidden = false
        header.titleLabel.isHidden = false
        header.previous7DaysLabel.isHidden = true
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDevotional = self.devotions[indexPath.section]
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        
        if let searchText = searchText, searchText.count > 2 {
            pagingManager.search(searchTerm: searchText) { (devotions, error) in

                if let devotions = devotions {
                    self.searchedDevotions = devotions
                }
                
                if let error = error {
                    self.searchedDevotions = []
                    print(error.localizedDescription)
                }
                
                
                self.collectionView.reloadData()
            }
        } else {
            self.searchedDevotions = []
        }
        
        self.collectionView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Reset tableview
        isSearching = false
        self.collectionView.reloadData()
        self.searchedDevotions = []
    }
    
    // MARK: ScrollView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If at bottom
        if (scrollView.contentOffset.y + 200 >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if !isSearching {
                loadNext()
            } else if self.searchedDevotions.count > 0 {
                loadNext()
            }
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
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        flowLayout.invalidateLayout()
    }
    
    // MARK: - IBOutlets
    @IBAction func calendarTapped(_ sender: Any) {
        performSegue(withIdentifier: "calendarSegue", sender: nil)
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue") {
            
            let vc = segue.destination as! DevotionalDetailView
            vc.devotion = selectedDevotional
            
        }
    }
    
}
