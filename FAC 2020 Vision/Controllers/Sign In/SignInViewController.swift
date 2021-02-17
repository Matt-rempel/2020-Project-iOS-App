//
//  SignInViewController.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-05.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit
import BLTNBoard

@available(iOS 13.0, *)
class SignInViewController: UIViewController, ASAuthorizationControllerDelegate, GIDSignInDelegate {
    
    var authManager = AuthenticationManager()
    let udManager = UserDefaultsManager()
    let bltnDataSource = BulletinDataSource()
    
    // This solution isn't great
    var accountTV: AccountTableViewTableViewController?
    
    lazy var bulletinManager: BLTNItemManager = {
        let introPage = bltnDataSource.getIntoPage()
        return BLTNItemManager(rootItem: introPage)
    }()
    
    @IBOutlet weak var signInWithAppleButton: UIButton!
//    @IBOutlet weak var signInWithGoogleButton: GIDSignInButton!
    @IBOutlet weak var signInWithGoogleButton: UIButton!
    @IBOutlet weak var signInWithFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google Sign In
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Facebook Sign In
        listenForFacebookSignIn()
        
        // BLTN Observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(transferDidComplete),
                                               name: .DimissedBulletin,
                                               object: nil)
        
    }

    // MARK: IBActions
    @IBAction func signInWithGooglePressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func signInWithApplePressed(_ sender: Any) {
        handleAppleIdRequest()
    }
    
    @IBAction func singInWithFacebookPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in

            // Check for error
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                self!.showAlert(withTitle: "Sign in Error", message: error!.localizedDescription)
                return
            }
            
            // Check for cancel
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
        }
    }
    
    @IBAction func notNowPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Facebook
    func listenForFacebookSignIn() {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (_) in
            if let accessToken = AccessToken.current?.tokenString {
                // Send token to back end
                self.performSignIn(accessToken: accessToken, provider: .google)
                
            }
        }
    }
    
    // MARK: Apple
    func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
//            dump(appleIDCredential.fullName)
//            let givenName = appleIDCredential.fullName?.givenName
//            let familyName = appleIDCredential.fullName?.familyName
//            let name = "\(givenName ?? "") \(familyName ?? "")"
//            let email = appleIDCredential.email
            
            guard
                let authCodeData = appleIDCredential.authorizationCode,
                let authCode = String(data: authCodeData, encoding: .utf8),
                let idTokenData = appleIDCredential.identityToken,
                let idToken = String(data: idTokenData, encoding: .utf8)
            else { return }
            
            print("id token: \(idToken)")
            print("access token: \(authCode)")
            
            // Now send the data to the backend to get an API token.
            performSignIn(idToken: idToken, accessToken: authCode, provider: .apple)
            
            self.udManager.setSignInWithAppleUserId(userIdentifier)

        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.showAlert(withTitle: "Error Signing In", message: "Could not complete sign in, please try again later")
    }

    // MARK: - Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }

//        let name = user.profile.name
//        let email = user.profile.email
//        AuthenticationManager.user = User(name: name, email: email)
        
        if let accessToken = user.authentication.accessToken {
            print("accessToken: \(accessToken)")

            performSignIn(accessToken: accessToken, provider: .google)
        }

    }
    
    // MARK: - API Token Sign in
    func performSignIn(idToken: String? = nil, accessToken: String, provider: SignInMethod) {
        authManager.signInWithProvider(idToken: idToken, accessToken: accessToken, provider: .google, completion: { (error) in
            guard error == nil else {
                print("error: \(error!)")
                if let error = error as? DBAccessError {
                    switch error {
                    case .nonFieldError(let message):
                        self.showAlert(withTitle: "Sign in Error", message: message)
                    default:
                        self.showAlert(withTitle: "Sign in Error", message: "Please try again later")
                    }
                } else {
                    self.showAlert(withTitle: "Sign in Error", message: "Please try again later")
                }

                return
            }

            self.transferDeviceDataToAccount()
        })
    }

    // MARK: Transfer Device Data
    func transferDeviceDataToAccount() {
        let (bookmarks, scripture) = authManager.getCurrentDeviceProgress()
        if bookmarks != 0 || scripture != 0 {
            // Ask user if they would like to transfer data
            // Show bulletin
            bulletinManager.showBulletin(above: self)
            
//            if let accountTV = self.accountTV {
//                accountTV.reloadUI()
//            }
//            self.dismiss(animated: true, completion: nil)
        }

    }

    // MARK: - Notifications
    @objc func transferDidComplete() {
        if let accountTV = self.accountTV {
            accountTV.reloadUI()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
