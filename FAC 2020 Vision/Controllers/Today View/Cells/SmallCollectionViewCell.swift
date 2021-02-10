//
//  SmallCollectionViewCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-10.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var progressCircle: CirclePieView!
	@IBOutlet weak var checkMarkImageView: UIImageView!
	@IBOutlet weak var cellBackgroundView: UIView!
	
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
}
