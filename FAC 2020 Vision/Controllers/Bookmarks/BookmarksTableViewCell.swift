//
//  BookmarksTableViewCell.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-08.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import UIKit

class BookmarksTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
