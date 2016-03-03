//
//  photoCell.swift
//  CourseRater
//
//  Created by New on 2/27/16.
//  Copyright © 2016 CodeMonkey. All rights reserved.
//

import UIKit

class photoCell: UITableViewCell {
    @IBOutlet var captionLabel: UILabel!

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var usernamelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
