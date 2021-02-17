//
//  DarkModeManager.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-29.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class DarkModeManager {
    var isDarkMode: Bool {
        return UIViewController().traitCollection.userInterfaceStyle == .dark
    }
}
