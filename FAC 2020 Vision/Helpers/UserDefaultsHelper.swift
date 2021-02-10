//
//  UserDefaultsHelper.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-19.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    
    // *** KEYS *** //
    public static let scriptureColorKey = "kScriptureColor"
	public static let scriptureFontFamilyKey = "kScriptureFontFamily"
	public static let scriptureFontSizeKey = "kScriptureFontSize"
    public static let appIconKey = "kAppIcon"
	public static let scriptureTranslationKey = "kScriptureVersion"
	public static let savedDevoVersionKey =  "kSavedDevoVersion"
	public static let bookmarksKey = "kBookmakrs"
	public static let notificationKey = "kNotification"
    public static let closedPopUpsKey = "kClosedPopUps"
	
    // *** MAIN METHODS *** //
    public static func set(value: Any?, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public static func getBoolValueWith(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    public static func getStringValueWith(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public static func getIntValueWith(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
	
	public static func getArrayWith(key: String) -> [Any]? {
		return UserDefaults.standard.array(forKey: key)
	}
	
	public static func getDictionaryValueWith(key: String) -> [String : Any]? {
		return UserDefaults.standard.dictionary(forKey: key)
    }
    
    
    // *** Helper Methods *** //
    public static func getScriptureColor() -> ScriptureColor {
		return ScriptureColor(rawValue: getStringValueWith(key: self.scriptureColorKey) ?? "light") ?? .light
    }
	
    public static func getScriptureFontSize() -> ScriptureFontSize {
		return ScriptureFontSize(rawValue: getStringValueWith(key: self.scriptureFontSizeKey) ?? "medium") ?? .medium
    }
	
    public static func getScriptureFontFamily() -> ScriptureFontFamily {
		return ScriptureFontFamily(rawValue: getStringValueWith(key: self.scriptureFontFamilyKey) ?? "arial") ?? .arial
    }
	
	public static func getAppIcon() -> AppIconType {
		return AppIconType(rawValue: getStringValueWith(key: self.appIconKey) ?? "lightBlue") ?? .lightBlue
    }
	
	public static func getScriptureTranslation() -> ScriptureTranslation {
		return ScriptureTranslation(rawValue: getStringValueWith(key: self.scriptureTranslationKey) ?? "niv") ?? .niv
	}
	
	public static func getSavedDevoVersion(key: String) -> Int? {
		return getIntValueWith(key: self.savedDevoVersionKey + key)
	}
	
	public static func setSavedDevoVersion(key: String, value: Int) {
		set(value: value, key: self.savedDevoVersionKey + key)
	}
	
	public static func getSavedBookmarks() -> [String: [String]] {
		return getDictionaryValueWith(key: self.bookmarksKey) as? [String: [String]] ?? [:]
	}
	
	public static func setSavedBookmarks(bookmarks: [String: [String]]) {
		return set(value: bookmarks, key: self.bookmarksKey)
	}
	
	public static func addBookmarkWith(month:String, UDID: String) {
		var bookmarks = self.getSavedBookmarks()
		if let _ = bookmarks[month] {
			bookmarks[month]?.append(UDID)
		} else {
			bookmarks[month] = [UDID]
		}
		self.setSavedBookmarks(bookmarks: bookmarks)
	}
	
	public static func removeBookmarkWith(month:String, UDID: String) {
		var bookmarks = self.getSavedBookmarks()
		if let monthArray = bookmarks[month] {
			bookmarks[month] = monthArray.filter { $0 != UDID }
		}
		self.setSavedBookmarks(bookmarks: bookmarks)
	}
	
	public static func setNotificationTime(time: String) {
		self.set(value: time, key: self.notificationKey)
	}
	
	public static func getNotificationTime() -> String {
		self.getStringValueWith(key: self.notificationKey) ?? "None"
	}
	
	public static func removeNotificationTime() {
		UserDefaults.standard.removeObject(forKey: self.notificationKey)
	}
	
    public static func getClosedPopUpUPUIDs() -> [String] {
        return self.getArrayWith(key: self.closedPopUpsKey) as? [String] ?? [""]
    }
    
    public static func setClosedPopUpUPUIDs(UPUIDs: [String]) {
        self.set(value: UPUIDs, key: self.closedPopUpsKey)
    }
    
    public static func addClosedPopUpUPUID(UPUID: String) {
        var closedPopUps = self.getClosedPopUpUPUIDs()
        closedPopUps.append(UPUID)
        print(closedPopUps)
        self.setClosedPopUpUPUIDs(UPUIDs: closedPopUps)
    }
    
    public static func forceReload() {
        UserDefaults.standard.removeObject(forKey: savedDevoVersionKey)
    }
    
    public static func resetUserDefaults() {
        let stnd = UserDefaults.standard
        stnd.removeObject(forKey: scriptureColorKey)
        stnd.removeObject(forKey: scriptureFontFamilyKey)
        stnd.removeObject(forKey: scriptureFontSizeKey)
        stnd.removeObject(forKey: appIconKey)
        stnd.removeObject(forKey: scriptureTranslationKey)
        stnd.removeObject(forKey: savedDevoVersionKey)
        stnd.removeObject(forKey: bookmarksKey)
        stnd.removeObject(forKey: notificationKey)
        stnd.removeObject(forKey: closedPopUpsKey)
    }
}
