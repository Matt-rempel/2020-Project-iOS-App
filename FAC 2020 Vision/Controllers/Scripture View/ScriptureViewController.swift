//
//  ScriptureViewController.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-17.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit
import Alamofire

class ScriptureViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingBox: UIView!
    @IBOutlet weak var activitiyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    
    var viewScripture: Scripture!
    var didLayoutSubviews = false
    let udManager = UserDefaultsManager()
    let scriptureSS = ScriptureStyleSheet()
    
    override var prefersStatusBarHidden: Bool {
        return self.navigationController?.isNavigationBarHidden ?? true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextView
        self.textView.attributedText = nil
        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        // Navigation Controller
        self.title = viewScripture.title
        
        if #available(iOS 13.0, *) {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "ellipsis.circle")
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "more")
        }
        
        // Loading Box
        loadingBox.layer.cornerRadius = 8.0
        loadingBox.clipsToBounds = true
        
        // Bar Button
        if #available(iOS 13, *) {
            
        } else {
            // Some iOS 12 UI Stuff
            moreButton.image = UIImage(named: "more")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.hidesBarsOnTap = true
        
        // Get Passages
        getPassages()

        // Prevent UINavigationBar overlap of UITextView
        if #available(iOS 13.0, *) {
            self.textView.setContentOffset(CGPoint(x: 0, y: -(self.getTopbarHeight + 100)), animated: true)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if !didLayoutSubviews {
            if #available(iOS 13.0, *) {
                
            } else {
                self.textView.setContentOffset(.zero, animated: false)
                let offset = CGPoint(x: self.textView.contentOffset.x, y: self.textView.contentOffset.y - (self.getTopbarHeight))
                self.textView.setContentOffset(offset, animated: false)
            }
        }
        
        didLayoutSubviews = true
    }
    
    // MARK: - Loading Indicator
    func showLoadingIndicator() {
        activitiyIndicator.startAnimating()
        loadingBox.isHidden = false
    }
    
    func hideLoadingIndicator() {
        loadingBox.isHidden = true
        activitiyIndicator.stopAnimating()
    }
    
    // MARK: - Scripture
    func getPassages() {
        switch udManager.getScriptureColor() {
        case .dark:
            textView.backgroundColor = .black
        case .light:
            textView.backgroundColor = .white
        case .sepia:
            textView.backgroundColor = .white
        case .system:
            textView.backgroundColor = DarkModeManager().isDarkMode ? .black : .white
        }
        
        let passageHTML = getScripture(scripture: viewScripture, translationType: udManager.getScriptureTranslation())
        
        // Set textview HTML
        if let htmlToFormatedString = passageHTML.htmlToAttributedString {
            self.textView.attributedText = htmlToFormatedString
        }
        
    }
    
    func getScripture(scripture: Scripture, translationType: ScriptureTranslation) -> String {
        let translationName = translationType.rawValue.lowercased()
        var passageHTML: String = "Translation not found. Please try again later."
        
        if let translations = scripture.translations {
            for translation in translations {
                if translation.translation.lowercased() == translationName {
                    passageHTML = scriptureSS.getFullHTMLWith(body: translation.reading)
                    passageHTML += scriptureSS.getCopyright(copyright: translation.copyright)
                }
                
            }
        }
        
        return passageHTML
    }

    // MARK: - IBActions
    @IBAction func moreButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "fontView", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController,
           let fontSettingsTableView = navVC.viewControllers[0] as? FontSettingsTableView {
            fontSettingsTableView.delegate = self
        }
    }
    
}
