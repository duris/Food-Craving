
//
//  BusinessCell.swift
//  Food Craving
//
//  Created by Ross Duris on 3/22/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit


class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView:UIImageView!
    @IBOutlet weak var resulTitleLabel:UILabel!
    @IBOutlet weak var resultSubTitleLabel:UILabel!
    @IBOutlet weak var ratingImageView:UIImageView!
    @IBOutlet weak var reviewCountLabel:UILabel!
    @IBOutlet weak var yelpLogo:UIImageView!
    var business: Business!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        resultImageView.layer.cornerRadius = resultImageView.frame.width/2
        resultImageView.clipsToBounds = true

        resultImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        resultImageView.layer.borderWidth = 1
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}