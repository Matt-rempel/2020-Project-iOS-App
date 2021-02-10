//
//  AccountTableViewTableViewController.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-22.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class AccountTableViewTableViewController: UITableViewController {
//, UIAdaptivePresentationControllerDelegate
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signInPartnerLabel: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    
    let authManager = AuthenticationManager()
    
    var isSignedIn:Bool {
        get {
            return (authManager.key != nil)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set sign in button text
        reloadUI()
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (isSignedIn ? 1 : 0)
        }
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            if self.isSignedIn {
                return ""
            } else {
                return "Sign in to save your progress and "
            }
        }
        return nil
    }
    
//    MARK: - IBActions
    @IBAction func tappedSignIn(_ sender: Any) {
        if self.isSignedIn {
            self.authManager.signOut()
            reloadUI()
            self.showAlert(withTitle: "Signed Out", message: "You have successfully signed out")
        } else {
            
//            if #available(iOS 13.0, *) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
    //            signInViewController.presentationController?.delegate = self
                signInViewController.accountTV = self
                self.present(signInViewController, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//                self.showAlert(withTitle: "Feature unsupported", message: "Please update your iOS device to get this feature")
//            }
        }
    }
    

//  MARK: - UI Reloaders
    func reloadUI() {
        reloadUserCell()
        reloadSignInButton()
        self.tableView.reloadData()
    }
    
    func reloadSignInButton() {
        if let _ = authManager.key {
            signInButton.setTitle("Sign Out", for: .normal)
            signInButton.setTitleColor(.red, for: .normal)
        } else {
            signInButton.setTitle("Sign In", for: .normal)
            signInButton.setTitleColor(Colors.tintColor, for: .normal)
        }
    }
    
    func reloadUserCell() {
        self.nameLabel.text = "\(AuthenticationManager.user?.firstName ?? "") \(AuthenticationManager.user?.lastName ?? "")"
        self.emailLabel.text = AuthenticationManager.user?.email
        if let partener = authManager.signInMethod?.rawValue {
            self.signInPartnerLabel.text = "Signed in with \(partener)"
        }
    }
    
    
//    MARK: - Presentation Controller
//    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        reloadSignInButton()
//        self.tableView.reloadData()
//    }
//
//    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
//        reloadSignInButton()
//        self.tableView.reloadData()
//    }
}
