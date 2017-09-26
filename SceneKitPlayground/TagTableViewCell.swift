//
//  TagTableViewCell.swift
//  SceneKitPlayground
//
//  Created by Minhung Ling on 2017-09-22.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    var tagObject: TagObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchToggled(_ sender: UISwitch) {
        tagObject.isOn = sender.isOn
    }    
}
