//
//  ListMemesViewCell.swift
//  MeMeShare
//
//  Created by Kavya Joshi on 7/13/21.
//

import UIKit

class ListMemesViewCell: UITableViewCell {

    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
