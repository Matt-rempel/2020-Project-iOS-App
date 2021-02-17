//
//  AuthenticationManager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-21.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

/**
 TODO: Maybe use a Singleton pattern for this class? Idk I got some static stuff here so many a singleton will work better
 */
enum SignInMethod: String {
    case google
    case facebook
    case apple
}

class AuthenticationManager: DBAccessor {
    //    #if DEBUG
    //    let baseURL = "http://127.0.0.1:8100/api/v2/"
    //    #else
//            let baseURL = "https://www.the2020project.ca/api/v2/"
    //    #endif
        
    var key: String? {
        get {
            return udManager.getSignInKey()
        }
        set(value) {
            udManager.setSignKey(value)
        }
    }
    
    static var user: User?
    var udManager = UserDefaultsManager()
    var icManager = IcloudManager()
    lazy var dateFormater = DateFormater()
    lazy var scriptureManager = ScriptureManager()
    lazy var bookmarkManager = BookmarkManager()
    
    var signInMethod: SignInMethod? {
        get {
            return udManager.getSignInMethod()
        }
        set(value) {
            udManager.setSignInMethod(signInMethod: value)
        }
    }
    
    // MARK: Auto Sign In
    func autoSignIn() {
        self.getUserProfile { (error) in
            if let error = error {
                print(error)
            }
        }
        switch signInMethod {
        case .none:
            break
        case .some(.google):
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        case .some(.facebook):
            // I'm not sure I actually do anything but idk...
            break
        case .some(.apple):
            if #available(iOS 13.0, *) {
                checkSignInStatus()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        self.key = nil
        switch signInMethod {
        case .none:
            break
        case .some(.google):
            GIDSignIn.sharedInstance().signOut()
        case .some(.facebook):
            let loginManager = LoginManager()
            loginManager.logOut()
        case .some(.apple):
            break
        }
        self.signInMethod = nil
    }
    
    // MARK: Sign in with Apple
    @available(iOS 13.0, *)
    func checkSignInStatus() {
        if let userIdentifier = udManager.getSignInWithAppleUserId() {
            let authorizationProvider = ASAuthorizationAppleIDProvider()
            authorizationProvider.getCredentialState(forUserID: userIdentifier) { (state, _) in
                switch state {
                case .authorized:
                    print("Account Found - Signed In")
                case .revoked:
                    print("No Account Found")
                    fallthrough
                case .notFound:
                    print("No Account Found")
                    
                default:
                    break
                }
            }
        }
    }
    
    // MARK: Get Device Progress
    /**
     Returns:
     - (Int, Int) (Bookmarks, ReadScriptures)
     */
    func getCurrentDeviceProgress() -> (Int, Int) {
        let totalBookmarks = udManager.getTotalSavedBookmarks()
        let totalReadScriptures = icManager.getAlliCloudProgressCount()

        return (totalBookmarks, totalReadScriptures)
    }
    
    // MARK: Transfer Data to Account
    func transferDeviceDataToAccount(progressView: UIProgressView, completion: @escaping (Error?) throws -> Void) {
        var totalTasks: Float = 0
        var completedTasks: Float = 0 {
            willSet(value) {
                progressView.progress = value / totalTasks
            }
        }
        
        let (bookmarksTodo, scriptureTodo) = getCurrentDeviceProgress()
        totalTasks = Float(bookmarksTodo + scriptureTodo)
        
        // Transfer scripture progress
        let iCloudCompletion = NSUbiquitousKeyValueStore.default.dictionaryRepresentation
        let keys = Array(iCloudCompletion.keys)
        let taskGroup = DispatchGroup()
        
        for key in keys {
            let values = iCloudCompletion[key] as? [String: Bool] ?? [:]
            print("\(key): \(values)") // 04-01-2019: ["Ruth 2": true, "Proverbs 2:1-4": true]
            // Some how call this method without creating a devotion or scripture... idk might have to rework scManager
            let (year, month, day) = dateFormater.devoDateToParts(devoDate: key)
            for (title, isDone) in values {
                if let year = year, let month = month, let day = day, isDone {
                    taskGroup.enter()
                    scriptureManager.setScriptureAsRead(title: title, year: year, month: month, day: day) { (error) in
                        if let error = error {
                            // TODO: Handle error
                            print(error)
                        }
                        completedTasks += 1
                        taskGroup.leave()
                    }
                }
            }
        }
        
        // Transfer bookmarks
        // Get UD list of bookmarks
        let udBookmarks = udManager.getSavedBookmarks()
        var udBookmarksToSend: [String] = []
        
        // TODO: This is bad code, it's too complex for what it needs to do
        // Get the API list of bookmarks
        bookmarkManager.getBookmarks { (devotions, error) in
            // Remove from the UD list any that are already in the API list
            
            // Convert the API bookmark dates to the UD format
            for (_, devoDates) in udBookmarks {
                for date in Array(Set(devoDates)) {
                    udBookmarksToSend.append(date)
                    // date is in the format dd-MM-yyyy
                        for devotion in devotions ?? [] {
                            let udStyleDateString = self.dateFormater.getStringFrom(date: devotion.date)
                            if udStyleDateString == date {
                                // This UD bookmark already exists in the API bookmarks so remove it from the list
                                udBookmarksToSend = udBookmarksToSend.filter { $0 != date }
                            }
                        }
                    
                }
            }
            
            // Push all remaining in the UD list to the API
            for bookmark in udBookmarksToSend {
                let (year, month, day) = self.dateFormater.devoDateToParts(devoDate: bookmark)
                
                if let year = year, let month = month, let day = day {
                    taskGroup.enter()
                    self.bookmarkManager.toggleBookmarkAPI(year: year, month: month, day: day) { (error) in
                        if let error = error {
                            // TODO: Handle error
                            print(error)
                        }
                        completedTasks += 1
                        taskGroup.leave()
                    }
                } else {
                    // TODO: Handle error
                }
            }
        }
        
        // Task Groups
        
        taskGroup.notify(queue: .main) {
            
            do {
                try completion(nil)
            } catch {
                
            }
        }
 
    }
    
    // MARK: Auth end points
    /**
     Sign in with Apple, Facebook or Google
     - Parameters:
     - code: The id_token (Apple only)
     - access_token: The auth token
     */
    func signInWithProvider(idToken: String?, accessToken: String, provider: SignInMethod, completion: @escaping (Error?) throws -> Void) {
        let url = "\(baseURL)dj-rest-auth/\(provider.rawValue)/"
        var parameters = ["access_token": accessToken]
        
        if let idToken = idToken {
            parameters["id_token"] = idToken
        }

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(DBAccessError.dataNotFound)
                        return
                    }
//                    dump(data)
                    let json = try JSON(data: data)
                    
                    // Check for non field errors
                    if let nonFieldError = json["non_field_errors"].arrayObject as? [String] {
                        print(nonFieldError)
                        let errorMsg = nonFieldError.first
                        try completion(DBAccessError.nonFieldError(message: errorMsg))
                        return
                    }
                    
                    let key = json["key"].string
                    print("key: \(key ?? "")") // 0c017190fe27ef86e95e175cc85263948028c908
                    self.key = key
                    self.signInMethod = provider
                    self.getUserProfile { (error) in
                        try completion(error)
                    }
                   
                } catch {
                    do {
                        try completion(DBAccessError.badData)
                    } catch {
                        
                    }
                }
            case .failure(let error):
                do {
                    try completion(error)
                } catch {
                    
                }
                
            }
        }
    }
    
    // MARK: Get user profile
    func getUserProfile(completion: @escaping (Error?) throws -> Void) {
        guard let key = key else {
            return
        }
        
        let url = "\(baseURL)user/"
        let headers: HTTPHeaders = ["Authorization": "Token \(key)"]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(DBAccessError.dataNotFound)
                        return
                    }
                    dump(data)
                    let json = try JSON(data: data)
                    AuthenticationManager.user = User(json: json)
                    try completion(nil)
                } catch {
                    do {
                        try completion(DBAccessError.badData)
                    } catch {

                    }
                }
            case .failure(let error):
                do {
                    try completion(error)
                } catch {

                }
            }
        }
    }

    // Register with email
    
    // Sign in with email
    
    // Password reset request
    
    // Password reset
    
    // Update user info
    
    // Favourite devotionals
    
    // Favourite authors
    
    // Add favourite devotional
    
    // Add favourite author
    
    // Get users reading status for a devotional
//    https://v2.the2020project.ca/api/v2/devotionals/2020/12/09/reading-history/
    /**
     Get the users reading history for a specific devotion
     - Parameters:
     - devotion: The devotion to get the reading history
     - Returns:
     - key: The generated API Key
     */
    func getReadingHistory(devotion: Devotion?, key: String, completion: @escaping ([String: Bool]?, Error?) throws -> Void) {
        let url = "\(baseURL)devotionals/2020/12/09/reading-history/"
        let headers: HTTPHeaders = ["Authorization": "Token \(key)"]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        try completion(nil, DBAccessError.dataNotFound)
                        return
                    }
                    dump(data)
//                    let json = try JSON(data: data)
//                    dump(json)
                    if let readingProgress = data as? [String: Bool] {
                        try completion(readingProgress, nil)
                    } else {
                        try completion(nil, DBAccessError.badData)
                    }
                } catch {
                    do {
                        try completion(nil, DBAccessError.badData)
                    } catch {
                        
                    }
                }
            case .failure(let error):
                do {
                    try completion(nil, error)
                } catch {
                    
                }
                
            }
        }
    }
    
    // Set scripture for a devo as read
}
