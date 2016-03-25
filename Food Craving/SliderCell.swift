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
       
//        let frame = CGRectMake(40, 5, self.frame.width - 80, 70)
//        let tabFrame = CGRectMake(frame.width/2 - 6, 33, 20, 20)
//        let tabView = UIView()
//        tabView.userInteractionEnabled = false
//        tabView.backgroundColor = UIColor.orangeColor()
//        tabView.frame = tabFrame
//        tabView.layer.cornerRadius = tabView.frame.height/2
//        tabView.layer.masksToBounds = true
        
        //slider.backgroundColor = UIColor.blueColor()
//        slider.sliderTab = tabView
//        slider.label = silderTitleLabel
//        slider.frame = frame
//
//        slider.addSubview(tabView)
       
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
        
//        
//        sliderTab.layer.borderWidth = 0.70
//        sliderTab.layer.borderColor = UIColor.lightGrayColor().CGColor
//        
//        let sliderBarFrame = CGRectMake(10, self.frame.height/2 + 5, self.frame.width - 20, 5)
//        sliderBar.frame = sliderBarFrame
//        sliderBar.backgroundColor = UIColor.lightGrayColor()
//        
//        sliderBar.layer.cornerRadius = 2
//        sliderBar.clipsToBounds = true
//        sliderBar.userInteractionEnabled = false
//        
//        
//        
//        self.addSubview(sliderBar)
//        self.bringSubviewToFront(sliderTab)
//        self.sendSubviewToBack(sliderBar)
//        
//        if self.ratingNumber > 1 {
//            label.textColor = UIColor.blackColor()
//        }
//        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
