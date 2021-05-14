//
//  RankingsTableViewCell.swift
//  movie match
//
//  Created by Ana Carolina Cunha on 5/14/21.
//

import UIKit

class RankingsTableViewCell: UITableViewCell {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
