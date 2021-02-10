//
//  CirclePieBuilder.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-08.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class CirclePieBuilder {
    // MARK: - Cell Progress Circle
    func setUpProgressCircle( for progressCircle: CirclePieView, checkMarkImageView: UIImageView, devotion: Devotion) {
        
        var totalScriptures:Double = 0
        var completedScriptures:Double = 0
        
        for scripture in devotion.scriptue {
            totalScriptures += 1
            completedScriptures += scripture.isCompleted ? 1 : 0
        }
        
        let progress:Double = completedScriptures / totalScriptures
        
        progressCircle.backgroundColor = UIColor.clear
        
        if progress == 0.0 {
            progressCircle.backgroundColor = UIColor.clear
        } else if #available(iOS 13.0, *) {
            progressCircle.backgroundColor = UIColor.clear
        } else {
            progressCircle.backgroundColor = Colors.fadedColor
        }
        
        if progress > 0.95 {
            if #available(iOS 13.0, *) {
                checkMarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                checkMarkImageView.image = UIImage(named: "checkmark")
            }
            checkMarkImageView.isHidden = false
            progressCircle.isHidden = true
        } else {
            checkMarkImageView.isHidden = true
            progressCircle.isHidden = false
        }
        
        progressCircle.pieFilling = CGFloat(progress)
        progressCircle.setNeedsDisplay()
    }
}
