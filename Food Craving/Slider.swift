//
//  Slider.swift
//  Food Craving
//
//  Created by Ross Duris on 3/22/16.
//  Copyright © 2016 duris.io. All rights reserved.
//


import UIKit
import CoreData

class Slider: UIControl {
    
    var sliderTab = UIView()
    var ratingNumber = 0
    var label = UILabel()
    var sliderBar = UIView()
    var sliderFillColor = UIView()
    var craving: Craving!
    
    /*
    Core Data Convenience
    */
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let barWidth = self.frame.width
        let halfOfSlider = sliderTab.frame.width/2
        print(barWidth)
        let touchX = touch.locationInView(touch.view).x
        if touchX < barWidth - halfOfSlider - 4 && touchX > 0 {
            sliderTab.frame.origin.x = touch.locationInView(touch.view).x - halfOfSlider
            let frame = CGRectMake(touchX, sliderBar.frame.origin.y - (sliderTab.frame.height/2) + 2, CGFloat(ratingNumber + 15), CGFloat(ratingNumber + 15))
            
            let sliderDistance = sliderTab.frame.origin.x
            
            if sliderTab.frame.origin.x > 0 && ratingNumber > 5 {
                let sliderFrame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 10, sliderFillColor.frame.height)
                sliderFillColor.frame = sliderFrame
            } else if sliderTab.frame.origin.x > 0{
                let sliderFrame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 4, sliderFillColor.frame.height)
                sliderFillColor.frame = sliderFrame
            } else if sliderFillColor.frame.width > sliderTab.frame.origin.x && sliderTab.frame.origin.x > 0 {
                let sliderFrame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance, sliderFillColor.frame.height)
                sliderFillColor.frame = sliderFrame
            }
            
        
            
            
            sliderTab.layer.cornerRadius = sliderTab.frame.height/2
            sliderTab.layer.masksToBounds = true
            
            sliderTab.frame = frame
        }
        
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        print(touch.locationInView(touch.view))
        
        let barWidth = self.frame.width
        let halfOfSlider = sliderTab.frame.width/2
        print(barWidth)
        let touchX = touch.locationInView(touch.view).x
        if touchX < barWidth - halfOfSlider - 4 && touchX > 10 {
            sliderTab.frame.origin.x = touch.locationInView(touch.view).x - halfOfSlider
            let frame = CGRectMake(touchX - halfOfSlider, sliderBar.frame.origin.y - (sliderTab.frame.height/2) + 2, CGFloat(ratingNumber + 15), CGFloat(ratingNumber + 15))
            
            let sliderDistance = sliderTab.frame.origin.x
            
            if sliderTab.frame.origin.x > 0 && ratingNumber > 5 {
                let sliderFrame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 10, sliderFillColor.frame.height)
                sliderFillColor.frame = sliderFrame
            } else if sliderTab.frame.origin.x > 0{
                let sliderFrame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 4, sliderFillColor.frame.height)
                sliderFillColor.frame = sliderFrame
            } else if sliderFillColor.frame.width > sliderTab.frame.origin.x && sliderTab.frame.origin.x > 0 {
                let sliderFrame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance, sliderFillColor.frame.height)
                sliderFillColor.frame = sliderFrame
            }
            
            
            
            
            sliderTab.layer.cornerRadius = sliderTab.frame.height/2
            sliderTab.layer.masksToBounds = true
            
            sliderTab.frame = frame
        }
        
        var ratingPercent = NSNumber()
        
        if touchX  > barWidth/2 {
            ratingPercent = round((sliderTab.frame.origin.x/(barWidth-sliderTab.frame.width))*100)
            print(ratingPercent)
            
            let value = ((Double(100 - Int(ratingPercent)) * 0.01)*255 * 1.9) + Double(halfOfSlider)
            print(value)
            
            let activeColor = UIColor(red: CGFloat(round(value))/255, green: 1, blue: 0, alpha: 1)
            
            //            sliderBarImage.tintColor = activeColor
            //            sliderOutline.tintColor = activeColor
            //            ratingNumberLabel.textColor = activeColor
            
        } else {
            ratingPercent = round((sliderTab.frame.origin.x/barWidth)*100)
            print(ratingPercent)
            let value = ((Double(ratingPercent) * 0.01)*255 * 2)
            print(value)
            let activeColor = UIColor(red: 1, green: CGFloat(round(value))/255, blue: 0, alpha: 1)
            
            //            sliderBarImage.tintColor = activeColor
            //            sliderOutline.tintColor = activeColor
            //            ratingNumberLabel.textColor = activeColor
            
        }
        
        let rating = Int(ratingPercent)
        
                switch rating {
                case 0..<15:
                    ratingNumber = 1
                    label.textColor = UIColor.lightGrayColor()
                case 15..<25:
                    ratingNumber = 2
                    label.textColor = UIColor.blackColor()
                    sliderFillColor.backgroundColor = UIColor.orangeColor()
                case 25..<35:
                    ratingNumber = 3
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 35..<45:
                    ratingNumber = 4
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 45..<55:
                    ratingNumber = 5
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 55..<65:
                    ratingNumber = 6
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 65..<75:
                    ratingNumber = 7
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 75..<85:
                    ratingNumber = 8
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 85..<95:
                    ratingNumber = 9
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                case 95..<115:
                    ratingNumber = 10
                    label.textColor = UIColor.blackColor()
                    //sliderTab.backgroundColor = UIColor.blackColor()
                default:
                    sliderFillColor.backgroundColor = UIColor.orangeColor()
                    print("Not in range")
                }
        
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        true
    }
    
    func setSlideToRating(rating: Int) {
        if rating == 10 {
            sliderTab.frame.origin.x = CGFloat(rating*32) - 36
            let sliderDistance = sliderTab.frame.origin.x
            sliderFillColor.frame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 10, sliderFillColor.frame.height)
        } else if  rating == 5{
            sliderTab.frame.origin.x = CGFloat(rating*32) - 4
            let sliderDistance = sliderTab.frame.origin.x
            sliderFillColor.frame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 10, sliderFillColor.frame.height)
        }else {
        sliderTab.frame.origin.x = CGFloat(rating*32) - 25
        let sliderDistance = sliderTab.frame.origin.x
        sliderFillColor.frame = CGRectMake(sliderFillColor.frame.origin.x, sliderFillColor.frame.origin.y, sliderDistance + 10, sliderFillColor.frame.height)
        }
    }
    
    override func layoutSubviews() {
        
        
      
        sliderTab.backgroundColor = UIColor.whiteColor()
        sliderTab.layer.shadowColor = UIColor.blackColor().CGColor
        sliderTab.layer.shadowOpacity = 1
        sliderTab.layer.shadowOffset = CGSizeMake(5, 5)
        sliderTab.layer.shadowRadius = 10
        
        sliderTab.layer.cornerRadius = sliderTab.frame.height/2
        sliderTab.layer.masksToBounds = true
        
        sliderTab.layer.borderWidth = 0.70
        sliderTab.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.addSubview(sliderTab)

        let sliderBarFrame = CGRectMake(10, self.frame.height/2 + 5, self.frame.width - 20, 5)
        sliderBar.frame = sliderBarFrame
        sliderBar.backgroundColor = UIColor.lightGrayColor()

        sliderBar.layer.cornerRadius = 2
        sliderBar.clipsToBounds = true
        sliderBar.userInteractionEnabled = false
        
//    
//        let sliderFillFrame = CGRectMake(10, self.frame.height/2 + 5, self.frame.width/2, 5)
//        sliderFillColor.frame = sliderFillFrame
//        sliderFillColor.backgroundColor = UIColor.orangeColor()
//        sliderFillColor.layer.cornerRadius = 2
//        sliderFillColor.clipsToBounds = true
//        sliderBar.addSubview(sliderFillColor)
        
        self.addSubview(sliderBar)
        self.bringSubviewToFront(sliderFillColor)
        self.bringSubviewToFront(sliderTab)
        self.sendSubviewToBack(sliderBar)
        
        if self.ratingNumber > 1 {
         label.textColor = UIColor.blackColor()
        }
        
        
    }
    
    func getRating() -> Int{
        
        return ratingNumber
    }
    
}
