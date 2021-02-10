//
//  PictureCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-23.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
    let usDownloader = UnsplashDownloader()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

	func downloadImage(from unsplash_id: String) {
        usDownloader.getImage(unsplash_id: unsplash_id) { (image, _, error) in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.backgroundImageView.image = image
        }
	}
}
