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
    @IBOutlet weak var slider: Slider!
    var craving: Craving!
    
    var rating = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
       

       
        var tabFrame = CGRectMake(slider.bounds.width/2 - 100, 14, 20, 20)
        
        if rating == 10 {
             tabFrame = CGRectMake(slider.bounds.width/2 , 14, 20, 20)
        }
        
        slider.sliderTab.frame = tabFrame
        
        let sliderFillFrame = CGRectMake(10, slider.frame.height/2 + 5, slider.frame.width/2 - 100, 5)
        slider.sliderFillColor.frame = sliderFillFrame
        slider.sliderFillColor.backgroundColor = UIColor.orangeColor()
        slider.sliderFillColor.layer.cornerRadius = 2
        slider.sliderFillColor.clipsToBounds = true
        slider.addSubview(slider.sliderFillColor)
        slider.sliderFillColor.userInteractionEnabled = false
        slider.sliderTab.userInteractionEnabled = false
        slider.bringSubviewToFront(slider.sliderFillColor)
   
       

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
