//
//  BusinessViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/25/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController {
    
    @IBOutlet weak var businessImageView:UIImageView!
    @IBOutlet weak var starRatingImageView:UIImageView!
    
    var business:Business!

    override func viewDidLoad() {
        super.viewDidLoad()

        YelpClient.sharedInstance().getBusinessInformationOf(business.id, successSearch: { (data, response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options:[])
                    print(jsonArray)
                    
                    if let rating = jsonArray["rating"] {
                        print("Star Rating:")
                        print(rating)
                    }
                    
                    if let displayAddress = jsonArray["location"] {
                        print(displayAddress)
                    }
                    
                    
                    if let photoUrl = jsonArray["image_url"] {
                        print("Start url:")

                        let url = photoUrl as? String
                        if let imageURL = NSURL(string: url!) {
                            if let imageData = NSData(contentsOfURL: imageURL) {
                                let image = UIImage(data: imageData)
                                self.businessImageView.image = image
                            }
                        }
                    }
                    
                }
                    
                    
                catch {
                    print("Error: \(error)")
                }
            })
            
            }, failureSearch: { (error) -> Void in
                print(error)
        })

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
