//
//  WineTableViewCell.swift
//  wineList
//
//  Created by jimmy kim on 2018. 3. 4..
//  Copyright © 2018년 yunaz. All rights reserved.
//

import UIKit

class WineTableViewCell: UITableViewCell {

    @IBOutlet weak var nameItem: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
