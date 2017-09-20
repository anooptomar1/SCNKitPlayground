//
//  TitleCell.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-20.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var tile: TileObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
