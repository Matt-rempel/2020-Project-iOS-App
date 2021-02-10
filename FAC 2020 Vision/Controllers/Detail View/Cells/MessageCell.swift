//
//  MessageCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-23.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

	@IBOutlet weak var messageBodyLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var authorTitleLabel: UILabel!
	@IBOutlet weak var authorBioLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
