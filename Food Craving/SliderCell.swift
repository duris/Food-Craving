//
//  SliderCell.swift
//  Food Craving
//
//  Created by Ross Duris on 3/22/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
    
    //@IBOutlet weak var slider: Slider!
    @IBOutlet weak var silderTitleLabel:UILabel!
    var slider: Slider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
