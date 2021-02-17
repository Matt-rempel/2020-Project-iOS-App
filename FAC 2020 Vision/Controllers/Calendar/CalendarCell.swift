//
//  CalendarCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2019-11-26.
//  Copyright © 2019 Foothills Alliance Church. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

	@IBOutlet weak var progressPie: CirclePieView!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var checkMarkImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
