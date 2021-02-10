//
//  ShareCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-23.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class ShareCell: UITableViewCell {

	@IBOutlet weak var shareButton: ShareButton!
	
	var delegate:DevotionalDetailView?
	var sharingURL = ""
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func sharePressed(_ sender: Any) {
		if let delegate = delegate {
			let items = [URL(string: sharingURL)!]
			let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
			
			if let popOver = ac.popoverPresentationController {
				popOver.sourceView = shareButton
			}
			
			delegate.present(ac, animated: true)
		}
	}
	
}
