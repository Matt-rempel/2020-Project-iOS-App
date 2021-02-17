//
//  LargeCollectionViewCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-10.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class LargeCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var progressCircle: CirclePieView!
	@IBOutlet weak var checkMarkImageView: UIImageView!
	@IBOutlet weak var cellBackgroundView: UIView!
	@IBOutlet weak var gradientView: UIView!
    	
	override func awakeFromNib() {
	   super.awakeFromNib()
	   // Initialization code
   }

	// Image Alpha Gradient
	func addGradient() {
		let mask = CAGradientLayer()
		mask.startPoint = CGPoint(x: 0.5, y: 0.7)
		mask.endPoint = CGPoint(x: 0.5, y: 0.0)
		
		let blackColor = UIColor.black

		mask.colors = [blackColor.withAlphaComponent(0.0).cgColor,
					   blackColor.withAlphaComponent(1.0),
					   blackColor.withAlphaComponent(1.0).cgColor]
		
		mask.locations = [NSNumber(value: 0.0), NSNumber(value: 0.2), NSNumber(value: 1.0)]
		mask.frame = gradientView.bounds
		
		gradientView.layer.mask = mask
		
		gradientView.layer.cornerRadius = 15.0
	}
	
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
