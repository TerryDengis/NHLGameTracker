//
//  GameCell.swift
//  MyDietLog
//
//  Created by Terry Dengis on 11/17/18.
//  Copyright © 2018 Terry Dengis. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    @IBOutlet weak var visitingTeam: UIImageView!
    @IBOutlet weak var vistingScore: UILabel!
    @IBOutlet weak var visitingName: UILabel!
    
    @IBOutlet weak var homeTeam: UIImageView!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var homeName: UILabel!
    
    @IBOutlet weak var gameStatus: UILabel!
    
    // Reuser identifier
    
    
    class func reuseIdentifier() -> String {
        return "GameCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "GameCell"
    }

    // Cell height
    class func cellHeight() -> CGFloat {
        return 60.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
