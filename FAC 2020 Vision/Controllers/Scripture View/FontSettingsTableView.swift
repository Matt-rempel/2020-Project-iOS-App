//
//  FontSettingsTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-18.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class FontSettingsTableView: UITableViewController {
    
    // IBOutlers
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontFamilyLabel: UILabel!
    @IBOutlet weak var fontColorLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    
    // Variable
    weak var delegate: ScriptureViewController!
    var numberOfSections = 2
    var rowsPerSection = [3, 1]
    let udManager = UserDefaultsManager()
    let scriptureSS = ScriptureStyleSheet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pullUserDefaultsAndFillInUI()
    }
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsPerSection[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                showFontSizeActionSheet()
            } else if indexPath.row == 1 {
                showFontStyleActionSheet()
            } else if indexPath.row == 2 {
                showFontColorActionSheet()
            }
        } else {
            showScriptureActionSheet()
        }
    }
    
    // MARK: - User Defaults
    func pullUserDefaultsAndFillInUI() {
        let fontSize = udManager.getScriptureFontSize()
        let fontFamily = udManager.getScriptureFontFamily()
        let fontColor = udManager.getScriptureColor()
        let translation = udManager.getScriptureTranslation()
        let prettyFontName = scriptureSS.getFullFontName(font: fontFamily)
        let prettyFontSize = scriptureSS.getFullFontSize(size: fontSize)
        let prettyFontColor = scriptureSS.getFullColor(color: fontColor)
        let prettyTranslation = scriptureSS.getFullTranslation(translation: translation)
        
        fontSizeLabel.text = prettyFontSize
        fontFamilyLabel.text = prettyFontName
        fontColorLabel.text = prettyFontColor
        translationLabel.text = prettyTranslation
        
        fontFamilyLabel.font = UIFont(name: prettyFontName, size: 17)
        
        self.delegate.getPassages()
    }
    
    // MARK: - Action Sheets
    func showFontSizeActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fontSizes: [ScriptureFontSize] = [.extraSmall, .small, .medium, .large, .extraLarge, .boomer]
        
        for font in fontSizes {
            let action: UIAlertAction = UIAlertAction(title: scriptureSS.getFullFontSize(size: font), style: .default) { _ -> Void in
                self.udManager.setScriptureFontSize(fontSize: font)
                self.pullUserDefaultsAndFillInUI()
            }
            
            actionSheetController.addAction(action)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)  
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        present(actionSheetController, animated: true) {
        }
    }
    
    func showFontStyleActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fontFamilies: [ScriptureFontFamily] = [.times, .arial, .helvetica, .georgia, .avenir]
        
        for font in fontFamilies {
            let action: UIAlertAction = UIAlertAction(title: scriptureSS.getFullFontName(font: font), style: .default) { _ -> Void in
                self.udManager.setScriptureFontFamily(font: font)
                self.pullUserDefaultsAndFillInUI()
            }
            actionSheetController.addAction(action)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        
        present(actionSheetController, animated: true) {
        }
    }
    
    func showFontColorActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fontColors: [ScriptureColor] = [.system, .light, .sepia, .dark]
        
        for color in fontColors {
            let action: UIAlertAction = UIAlertAction(title: scriptureSS.getFullColor(color: color), style: .default) { _ -> Void in
                self.udManager.setScriptureColor(color: color)
                self.pullUserDefaultsAndFillInUI()
            }
            actionSheetController.addAction(action)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in }
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = tableView.cellForRow(at: IndexPath(row: 2, section: 0))
        
        present(actionSheetController, animated: true) {
        }
    }

    func showScriptureActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let translations: [ScriptureTranslation] = [.niv, .kjv, .nlt]
        
        for translation in translations {
            let action: UIAlertAction = UIAlertAction(title: scriptureSS.getFullTranslation(translation: translation), style: .default) { _ -> Void in
                self.udManager.setScriptureTranslation(translation: translation)
                self.pullUserDefaultsAndFillInUI()
            }
            actionSheetController.addAction(action)
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = tableView.cellForRow(at: IndexPath(row: 0, section: 1))

        present(actionSheetController, animated: true) {
        }
    }
    
    // MARK: - IBActions
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
