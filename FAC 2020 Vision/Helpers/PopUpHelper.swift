//
//  PopUpHelper.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-05-20.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation

class PopUp {
    var UPUID:String!
    var title:String?
    var subtitle:String?
    var action:String? = "https://www.the2020project.ca"
    var secondaryButtonTitle:String?
    var primaryButtonTitle:String?
    var isActive:Bool = true
    var isActiveInFirebase:Bool = false
    
    init(UPUID: String) {
        self.UPUID = UPUID
        self.getIsActive()
    }
    
    func getIsActive() {
        let inActivePopUps = UserDefaultsHelper.getClosedPopUpUPUIDs()
        print(inActivePopUps)
        print(self.UPUID)
        print(inActivePopUps.contains(self.UPUID))
        if inActivePopUps.contains(self.UPUID) {
            self.isActive = false
        }
    }
}

class PopUpManager {
    
    var popUps:[PopUp] = []
    
    func getActivePopUps() -> [PopUp] {
        return self.popUps.filter { $0.isActive && $0.isActiveInFirebase }
    }
    
    
}
