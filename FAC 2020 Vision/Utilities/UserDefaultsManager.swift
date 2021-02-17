//
//  UserDefaultsHelper.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-19.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultsManager {
    
    // *** KEYS *** //
    let scriptureColorKey = "kScriptureColor"
	let scriptureFontFamilyKey = "kScriptureFontFamily"
	let scriptureFontSizeKey = "kScriptureFontSize"
    let appIconKey = "kAppIcon"
	let scriptureTranslationKey = "kScriptureVersion"
	let bookmarksKey = "kBookmakrs"
	let notificationKey = "kNotification"
    let calendarSortOrderKey = "kCalendarSortOrderKey"
    let signInMethodKey = "kSignInMethod"
    let signInWithAppleUserID = "ksignInWithAppleUserID"
	let userAuthKey = "kuserAuthKey"
    
    // *** Private Methods *** //
    private func set(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private func getBoolValueWith(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    private func getStringValueWith(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    private func getIntValueWith(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
	
    private func getArrayWith(key: String) -> [Any]? {
		return UserDefaults.standard.array(forKey: key)
	}
	
    private func getDictionaryValueWith(key: String) -> [String: Any]? {
		return UserDefaults.standard.dictionary(forKey: key)
    }
    
    // MARK: Scripture Methods
    func getScriptureColor() -> ScriptureColor {
        return ScriptureColor(rawValue: getStringValueWith(key: self.scriptureColorKey) ?? "system") ?? .system
    }
	
    func getScriptureFontSize() -> ScriptureFontSize {
		return ScriptureFontSize(rawValue: getStringValueWith(key: self.scriptureFontSizeKey) ?? "medium") ?? .medium
    }
	
    func getScriptureFontFamily() -> ScriptureFontFamily {
		return ScriptureFontFamily(rawValue: getStringValueWith(key: self.scriptureFontFamilyKey) ?? "arial") ?? .arial
    }
	
    func getScriptureTranslation() -> ScriptureTranslation {
        return ScriptureTranslation(rawValue: getStringValueWith(key: self.scriptureTranslationKey) ?? "niv") ?? .niv
    }
    
    func setScriptureColor(color: ScriptureColor) {
        self.set(value: color.rawValue, key: self.scriptureColorKey)
    }
    
    func setScriptureFontSize(fontSize: ScriptureFontSize) {
        self.set(value: fontSize.rawValue, key: self.scriptureFontSizeKey)
    }
    
    func setScriptureFontFamily(font: ScriptureFontFamily) {
        self.set(value: font.rawValue, key: self.scriptureFontFamilyKey)
    }
    
    func setScriptureTranslation(translation: ScriptureTranslation) {
        self.set(value: translation.rawValue, key: self.scriptureTranslationKey)
    }
    
    // MARK: App Icon Methods
	func getAppIcon() -> AppIconType {
		return AppIconType(rawValue: getStringValueWith(key: self.appIconKey) ?? "lightBlue") ?? .lightBlue
    }
	
//	func getSavedDevoVersion(key: String) -> Int? {
//		return getIntValueWith(key: self.savedDevoVersionKey + key)
//	}
//
//	func setSavedDevoVersion(key: String, value: Int) {
//		set(value: value, key: self.savedDevoVersionKey + key)
//	}
	
    // MARK: Bookmark Methods
	func getSavedBookmarks() -> [String: [String]] {
		return getDictionaryValueWith(key: self.bookmarksKey) as? [String: [String]] ?? [:]
	}
	
	func setSavedBookmarks(bookmarks: [String: [String]]) {
		return set(value: bookmarks, key: self.bookmarksKey)
	}
	
	func addBookmarkWith(month: String, UDID: String) {
		var bookmarks = self.getSavedBookmarks()
		if bookmarks[month] != nil {
			bookmarks[month]?.append(UDID)
		} else {
			bookmarks[month] = [UDID]
		}
		self.setSavedBookmarks(bookmarks: bookmarks)
	}
	
	func removeBookmarkWith(month: String, UDID: String) {
		var bookmarks = self.getSavedBookmarks()
		if let monthArray = bookmarks[month] {
			bookmarks[month] = monthArray.filter { $0 != UDID }
		}
		self.setSavedBookmarks(bookmarks: bookmarks)
	}
    
    func toggleBookmark(month: String, UDID: String) {
        if checkIfInBookmarks(month: month, UDID: UDID) {
            self.removeBookmarkWith(month: month, UDID: UDID)
        } else {
            self.addBookmarkWith(month: month, UDID: UDID)
        }
    }
    
    func checkIfInBookmarks(month: String, UDID: String) -> Bool {
        let allBookmarks = self.getSavedBookmarks()
        if let monthDevos = allBookmarks[month] {
            return monthDevos.contains(UDID)
        } else {
            return false
        }
    }
    
    func getTotalSavedBookmarks() -> Int {
        var totalBookmarks = 0
        let bookmarkUDIDs = self.getSavedBookmarks()
        for (_, devoDates) in bookmarkUDIDs {
            totalBookmarks += Array(Set(devoDates)).count
        }
        
        return totalBookmarks
    }
	
    // MARK: Notification Methods
	func setNotificationTime(time: String) {
		self.set(value: time, key: self.notificationKey)
	}
	
	func getNotificationTime() -> String {
		self.getStringValueWith(key: self.notificationKey) ?? "None"
	}
	
	func removeNotificationTime() {
		UserDefaults.standard.removeObject(forKey: self.notificationKey)
	}
    
    // MARK: Calendar Methods
    func toggleOrder() {
        let currentOrder = getSortOrder()
        let newOrder: DevotionOrderType = (currentOrder == .decending) ? .ascending : .decending
        self.set(value: newOrder.rawValue, key: self.calendarSortOrderKey)
    }
	
    func getSortOrder() -> DevotionOrderType? {
        guard let savedValue = getStringValueWith(key: self.calendarSortOrderKey) else {
            return nil
        }
        return DevotionOrderType(rawValue: savedValue)
    }
    
    // MARK: Sign in with Apple Methods
    func setSignInWithAppleUserId(_ userId: String) {
        self.set(value: userId, key: self.signInWithAppleUserID)
    }
    
    func getSignInWithAppleUserId() -> String? {
        return self.getStringValueWith(key: self.signInWithAppleUserID)
    }
    
    // MARK: Sign in Methods
    func setSignKey(_ userId: String?) {
        self.set(value: userId, key: self.userAuthKey)
    }
    
    func getSignInKey() -> String? {
        return self.getStringValueWith(key: self.userAuthKey)
    }
    
    func getSignInMethod() -> SignInMethod? {
        guard let signInMethodString = getStringValueWith(key: self.signInMethodKey) else {
            return nil
        }
        return SignInMethod(rawValue: signInMethodString)
    }
    
    func setSignInMethod(signInMethod: SignInMethod?) {
        if let signInMethod = signInMethod {
            self.set(value: signInMethod.rawValue, key: self.signInMethodKey)
        }
    }
    
//    func getClosedPopUpUPUIDs() -> [String] {
//        return self.getArrayWith(key: self.closedPopUpsKey) as? [String] ?? [""]
//    }
    
//    func setClosedPopUpUPUIDs(UPUIDs: [String]) {
//        self.set(value: UPUIDs, key: self.closedPopUpsKey)
//    }
    
//    func addClosedPopUpUPUID(UPUID: String) {
//        var closedPopUps = self.getClosedPopUpUPUIDs()
//        closedPopUps.append(UPUID)
//        print(closedPopUps)
//        self.setClosedPopUpUPUIDs(UPUIDs: closedPopUps)
//    }
    
//    func forceReload() {
//        UserDefaults.standard.removeObject(forKey: savedDevoVersionKey)
//    }
    
    func resetUserDefaults() {
        let stnd = UserDefaults.standard
        stnd.removeObject(forKey: scriptureColorKey)
        stnd.removeObject(forKey: scriptureFontFamilyKey)
        stnd.removeObject(forKey: scriptureFontSizeKey)
        stnd.removeObject(forKey: appIconKey)
        stnd.removeObject(forKey: scriptureTranslationKey)
//        stnd.removeObject(forKey: savedDevoVersionKey)
        stnd.removeObject(forKey: bookmarksKey)
        stnd.removeObject(forKey: notificationKey)
//        stnd.removeObject(forKey: closedPopUpsKey)
    }
}
