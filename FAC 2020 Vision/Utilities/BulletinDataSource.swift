//
//  BulletinDataSource.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2021-01-08.
//  Copyright © 2021 Foothills Alliance Church. All rights reserved.
//

import UIKit
import BLTNBoard

class BulletinDataSource {
    lazy var authManager = AuthenticationManager()
    
    // MARK: - Pages

    // For notifications
    func getNotification(notification: APINotification, todayView: TodayView) -> BLTNPageItem {
        let page = BLTNPageItem(title: notification.title)
        
        page.descriptionText = notification.body
        page.actionButtonTitle = notification.actionButtonTitle
        page.alternativeButtonTitle = notification.dismissButtonTitle
        page.image = UIImage(named: "FAC_IconOnly_LightBlueSmall")
        
        page.actionHandler = { item in
//            if let _ = page.next {
//                item.manager?.displayNextItem()
//            } else {
                item.manager?.dismissBulletin()
                print("Closing pop up")
                
                
                // Open URL
                if let url = notification.actionButtonLink {
                    todayView.showSafariWebPageFor(url: url)
                }
//            }
        }

        page.alternativeHandler = { item in
            if let _ = page.next {
                item.manager?.displayNextItem()
            } else {
                item.manager?.dismissBulletin()
                print("Closing pop up")
            }
        }
        
        return page
    }
    
    // Set bookmarks and scripture as params
    func getIntoPage() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Transfer Data")
        let (bookmarks, scripture) = authManager.getCurrentDeviceProgress()
        page.descriptionText = "Would you like to transfer your \(bookmarks) bookmarks and \(scripture) completed scripture readings to your account?"
        page.actionButtonTitle = "Transfer Data"
        page.alternativeButtonTitle = "Not Now"
        page.requiresCloseButton = false
        page.isDismissable = false
        page.next = getTransferPage()
        
        page.actionHandler = { item in
            item.manager?.displayNextItem()
            guard let nextPage = page.next as? ProgressBulletinPage, let progressView = nextPage.progressView else {
                return
            }
            
            self.authManager.transferDeviceDataToAccount(progressView: progressView) { (error) in
                page.manager?.displayNextItem()
            }
            
        }

        page.alternativeHandler = { item in
            item.manager?.dismissBulletin()
        }
        
        page.dismissalHandler = { item in
            NotificationCenter.default.post(name: .DimissedBulletin, object: item)
        }

        
        
        
        return page
    }
    
    func getTransferPage() -> ProgressBulletinPage {
        let page = ProgressBulletinPage(title: "Transfering Data")
        page.requiresCloseButton = false
        page.descriptionText = "3 seconds remaining..."
        page.next = getTransferCompletePage()
        

        return page
    }
    
    func getTransferCompletePage() -> ProgressBulletinPage {
        let page = ProgressBulletinPage(title: "Transfer Complete!")
            
        if #available(iOS 13.0, *) {
            page.image = UIImage(systemName: "person.crop.circle.badge.checkmark")
        } else {
            // Fallback on earlier versions
        }
        
        page.actionButtonTitle = "Done"
        
        page.actionHandler = { item in
            item.manager?.dismissBulletin()
        }
        
        page.dismissalHandler = { item in
            NotificationCenter.default.post(name: .DimissedBulletin, object: item)
        }
        
        return page
    }
}

// MARK: - Notifications

extension Notification.Name {

    /**
     * The transfer did complete.
     *
     */

    static let DimissedBulletin = Notification.Name("PetBoardSetupDidCompleteNotification")

}
