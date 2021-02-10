//
//  ScriptureCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-23.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class ScriptureCell: UITableViewCell {

	@IBOutlet weak var checkmarkImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
