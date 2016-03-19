//
//  ViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/16/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        runSearch("Hamburgers")
        runSearch("Pasta")
        runSearch("Sushi")
        runSearch("Wings")
    }



    func runSearch(term: String) {
        let parameters = [
            "ll": "39.9797, -83.0047",
            "category_filter": "food",
            "radius_filter": "4000",
            "sort": "0",
            "term": term,
            "limit": "5"]
        
        YelpClient.sharedInstance().searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
            //print(NSString(data: data, encoding: NSUTF8StringEncoding))
            dispatch_async(dispatch_get_main_queue(), {
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options:[])
                    
                    if let businesses = jsonArray["businesses"] as? NSArray{
                        for biz in (businesses as? [[String:AnyObject]])!{
                            if let name = biz["name"] {
                                print(name)
                                
                                if let id = biz["id"]{
                                    //print(id)
                                }
                                
                                let image_url = biz["image_url"]
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
}

