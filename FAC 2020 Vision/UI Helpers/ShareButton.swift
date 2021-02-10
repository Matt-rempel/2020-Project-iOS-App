//
//  ShareButton.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-26.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class ShareButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
		self.fadedDesign()
		self.titleLabel?.text = "Share"
		
		if #available(iOS 13.0, *) {
			self.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
		}
		
        if let imageView = imageView {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: imageView.frame.width - 10, bottom: 0, right: 0)
        }
    }
}
