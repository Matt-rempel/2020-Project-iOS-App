//
//  SettingsTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-25.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit
import MessageUI
//import Crashlytics

class SettingsTableView: UITableViewController, MFMailComposeViewControllerDelegate {
	
	// MARK: - IBOutlets
	@IBOutlet weak var versionLabel: UILabel!
	@IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var signInLabel: UILabel!
    
	// App Icon Outlets
	@IBOutlet weak var lightBlueButton: UIButton!
	@IBOutlet weak var lightBlueView: UIView!
	@IBOutlet weak var lightBlueImage: UIImageView!
	@IBOutlet weak var lightBlueButtonCheckImage: UIImageView!
	
	@IBOutlet weak var darkBlueButton: UIButton!
	@IBOutlet weak var darkBlueView: UIView!
	@IBOutlet weak var darkBlueImage: UIImageView!
	@IBOutlet weak var darkBlueImageCheckImage: UIImageView!
	
	@IBOutlet weak var blackButton: UIButton!
	@IBOutlet weak var blackView: UIView!
	@IBOutlet weak var blackImage: UIImageView!
	@IBOutlet weak var blackImageCheckImage: UIImageView!
	
	@IBOutlet weak var dailyReminderLabel: UILabel!
	
	let NUMBER_OF_SECTIONS = 7
    var NUMBER_OF_CELLS:[Int] = []
    var SECTION_HEADERS:[String?]!
    var supportEmail = "foothills2020vision@gmail.com"
	
    let udManager = UserDefaultsManager()
    let authManager = AuthenticationManager()
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        // iOS 12 UI Support
        if #available(iOS 13.0, *) {
            NUMBER_OF_CELLS = [1, 1, 1, 2, 1, 1, 1]
            SECTION_HEADERS = ["Account", "App Icon", "Reminder", "Build Info", "Support", "Legal", nil]
        } else {
            NUMBER_OF_CELLS = [0, 1, 1, 2, 1, 1, 1]
            SECTION_HEADERS = [nil, "App Icon", "Reminder", "Build Info", "Support", "Legal", nil]
        }
        
        // Fill In UI
        versionLabel.text = getAppVersion()
        buildLabel.text = getBuildNumber()
		
		// App Icon UI
		updateCurrentIconUI()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		// Navigation Controller
		self.navigationController?.navigationBar.prefersLargeTitles = true
		
		// Fill in UI
		dailyReminderLabel.text = udManager.getNotificationTime()
        
	}

	// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_CELLS[section]
    }

	override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 4
	}

	override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
		return action == #selector(copy(_:))
	}

	override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
		if action == #selector(copy(_:)) {
			let pasteboard = UIPasteboard.general
			pasteboard.string = supportEmail
		}
	}
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "account", sender: nil)
        } else if indexPath.section == 4 {
            sendEmail()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SECTION_HEADERS[section]
    }
	
    // MARK: - Helper Methods
    func getAppVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}
    
    func getBuildNumber() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

	// MARK: - IBOutlets
	@IBAction func lightBluePressed(_ sender: Any) {
		changeIcon(to: nil)
	}
	
	@IBAction func darkBluePressed(_ sender: Any) {
		changeIcon(to: AppIconType.darkBlue.rawValue)
	}
	
	@IBAction func blackPressed(_ sender: Any) {
		changeIcon(to: AppIconType.blackIcon.rawValue)
	}
	
    
    @IBAction func donePressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

    // MARK: - Email
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([supportEmail])
            mail.setSubject("App Support")
            mail.setMessageBody("Version: \(getAppVersion() ?? "Unknown")\nBuild: \(getBuildNumber() ?? "Unknown")\n\n\n", isHTML: false)

            present(mail, animated: true)
        } else {
            let pasteboard = UIPasteboard.general
            pasteboard.string = supportEmail
            self.showAlert(withTitle: "Email Coppied", message: "The support email was coppied to your clipboard.")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
	// MARK: - Multiple App Icons
	func changeIcon(to iconName: String?) {
		
		guard UIApplication.shared.supportsAlternateIcons else {
			return
		}

		UIApplication.shared.setAlternateIconName(iconName, completionHandler: { (error) in
			if let error = error {
				print("App icon failed to change due to \(error.localizedDescription)")
					self.showAlert(withTitle: "App Icon Error", message: error.localizedDescription)
			} else {
				print("App icon changed successfully")
				self.updateCurrentIconUI()
			}
		})
	}
	
	
	func updateCurrentIconUI() {
		lightBlueView.appIconDesign(selected: false)
		darkBlueView.appIconDesign(selected: false)
		blackView.appIconDesign(selected: false)
		
        if #available(iOS 13.0, *) {
            lightBlueButtonCheckImage.image = UIImage(systemName: "checkmark.circle")
            darkBlueImageCheckImage.image = UIImage(systemName: "checkmark.circle")
            blackImageCheckImage.image = UIImage(systemName: "checkmark.circle")
            
        } else {
            // Fallback on earlier versions
            lightBlueButtonCheckImage.image = UIImage(named: "checkmark")
            darkBlueImageCheckImage.image = UIImage(named: "checkmark")
            blackImageCheckImage.image = UIImage(named: "checkmark")
            
        }
		
		switch getCurrentAppIcon() {
		case .lightBlue:
			lightBlueView.appIconDesign(selected: true)
            if #available(iOS 13.0, *) {
                lightBlueButtonCheckImage.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                // Fallback on earlier versions
                lightBlueButtonCheckImage.image = UIImage(named: "checkmark")
            }
		case .darkBlue:
			darkBlueView.appIconDesign(selected: true)
            if #available(iOS 13.0, *) {
                darkBlueImageCheckImage.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                // Fallback on earlier versions
                darkBlueImageCheckImage.image = UIImage(named: "checkmark")
            }
		case .blackIcon:
			blackView.appIconDesign(selected: true)
            if #available(iOS 13.0, *) {
                blackImageCheckImage.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                // Fallback on earlier versions
                blackImageCheckImage.image = UIImage(named: "checkmark")
            }
		}
	}
	
	func getCurrentAppIcon() -> AppIconType {
		return AppIconType(rawValue: UIApplication.shared.alternateIconName ?? "lightBlue") ?? .lightBlue
	}
}
