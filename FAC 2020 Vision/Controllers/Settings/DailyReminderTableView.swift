//
//  DailyReminderTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-01-03.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import UIKit
import UserNotifications

class DailyReminderTableView: UITableViewController {

	// IBOutlets
	@IBOutlet weak var showNotificationsSwitch: UISwitch!
	@IBOutlet weak var notificationTimeLabel: UILabel!
	@IBOutlet weak var notificationTimeDatePicker: UIDatePicker!
    @IBOutlet weak var setNotificationButton: UIButton!
	@IBOutlet weak var openSettingsButton: UIButton!
	
	// Variables
	var NUMBER_OF_SECTIONS = 3
	var canShowDatePicker = false
	var canShowErrorCell = false
	
    var dateFormater = DateFormater()
    let udManager = UserDefaultsManager()
    
	let center = UNUserNotificationCenter.current()
	let options: UNAuthorizationOptions = [.alert, .sound];
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// TableView
        self.tableView.keyboardDismissMode = .onDrag
        
		// UI
		setNotificationButton.roundDesign()
		openSettingsButton.roundDesign()
		
		// Forground Listener
		NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
	
	override func viewWillAppear(_ animated: Bool) {
		// Check if there is a saved notification
		checkIfThereIsASavedNotification()
		
	}

    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return canShowDatePicker ? 1 : 0
        case 2:
			return canShowErrorCell ? 1 : 0
		default:
			return 1
		}
    }

    // MARK: - IBActions
	@IBAction func showNotificationsToggled(_ sender: Any) {
		if showNotificationsSwitch.isOn {
			canShowDatePicker = true
			
			checkNotificationPermissions()
			
			// Request to show notifications
			center.requestAuthorization(options: options) { (granted, error) in
				if granted {
					DispatchQueue.main.async {
						self.canShowDatePicker = true
						self.canShowErrorCell = false
                        let savedTime = self.udManager.getNotificationTime()
						if savedTime == "None" {
                            let newSaveTime = self.dateFormater.getStringFrom(time: self.notificationTimeDatePicker.date)
                            self.udManager.setNotificationTime(time: newSaveTime)
						} else {
							self.notificationTimeLabel.text = "Notification Time: " + savedTime
						}
						
						self.tableView.reloadData()
					}
				} else {
					print("Something went wrong")
					DispatchQueue.main.async {
						self.canShowErrorCell = true
						self.tableView.reloadData()
					}
				}
			}
		} else {
			canShowDatePicker = false
			canShowErrorCell = false
			
			udManager.removeNotificationTime()
			
			self.tableView.reloadData()
			
			center.removeAllPendingNotificationRequests()
			center.removeAllDeliveredNotifications()
		}
		
	}
	
	@IBAction func notificationTimeDatePickerChanged(_ sender: Any) {
//		let saveTime = DateHelper.getStringFrom(time: notificationTimeDatePicker.date)
//		UserDefaultsHelper.setNotificationTime(time: saveTime)
//
//		removeAllNotifications()
//		createNotification()
	}
	
	@IBAction func setNotificationButtonPressed(_ sender: Any) {
		let saveTime = dateFormater.getStringFrom(time: notificationTimeDatePicker.date)
		udManager.setNotificationTime(time: saveTime)

		notificationTimeLabel.text = "Notification Time: " + saveTime
		
		removeAllNotifications()
		createNotification()
        
        self.showAlert(withTitle: "Notification Set!", message: "You will be notified at: \(saveTime)")
	}
	
	@IBAction func openSettingsPressed(_ sender: Any) {
		openSettings()
	}
	
	// MARK: - Helper Methods
	
	@objc func willEnterForeground() {
		print("willEnterForeground() willEnterForeground willEnterForeground willEnterForeground willEnterForeground willEnterForeground")
		checkIfThereIsASavedNotification()
	}
	
	func openSettings() {
		guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
			return
		}
	   
		if UIApplication.shared.canOpenURL(settingsUrl) {
			UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
				print("Settings opened: \(success)") // Prints true
			})
		}
	}
	
	// MARK: - Notifications
	func checkIfThereIsASavedNotification() {
		let savedTime = udManager.getNotificationTime()
		if savedTime != "None" {
			notificationTimeLabel.text = "Notification Time: " + savedTime
			self.showNotificationsSwitch.isOn = true
			self.canShowDatePicker = true
			self.notificationTimeDatePicker.date = dateFormater.getTimeFromString(string: savedTime) ?? Date()
			self.tableView.reloadData()
		}
		
		self.checkNotificationPermissions()

	}
	
	func createNotification() {
		// Create Notification
		let content = UNMutableNotificationContent()
		content.title = ""
        content.body = "Take a break and read today's devotional."
		content.sound = UNNotificationSound.default
		
		// Create Trigger
		let date = notificationTimeDatePicker.date
		let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
		
		// Schedual Trigger
		let identifier = "UYLLocalNotification"
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		center.add(request, withCompletionHandler: { (error) in
			if let error = error {
				// Something went wrong
				self.showAlert(withTitle: "Could Not Create Notification", message: error.localizedDescription)
			}
		})
	}
	
	func removeAllNotifications() {
		center.removeAllPendingNotificationRequests()
	}
	
	func checkNotificationPermissions() {
		// Check notification permissions
		center.getNotificationSettings { (settings) in
			if settings.authorizationStatus != .authorized {
				// Notifications not allowed
				DispatchQueue.main.async {
					if (self.showNotificationsSwitch.isOn) {
						self.canShowErrorCell = true
						self.tableView.reloadData()
					}
				}
			} else {
				DispatchQueue.main.async {
					if (self.showNotificationsSwitch.isOn) {
						self.canShowErrorCell = false
						self.tableView.reloadData()
					}
				}
			}
		}
	}
}
