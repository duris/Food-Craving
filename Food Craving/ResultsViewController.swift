//
//  ResultsViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/22/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultsTableView: UITableView!
    var results = [Business]()
    var searchStrings = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        for term in searchStrings {
            runSearch(term)
        }

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! BusinessCell
        
        cell.resulTitleLabel.text = results[indexPath.row].name
        
        if let imageURL = NSURL(string: results[indexPath.row].imageUrl) {
            if let imageData = NSData(contentsOfURL: imageURL) {
                let image = UIImage(data: imageData)
                cell.resultImageView.image = image!
            }
        }
        
        cell.resultSubTitleLabel.text = results[indexPath.row].searchString
        return cell
    }
    
    func runSearch(term: String) {
        let parameters = [
            "ll": "39.9797, -83.0047",
            "radius_filter": "6000",
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
                                    print(id)
                                }
                                
                                if let image_url = biz["image_url"] {
                                   let biz = Business(imageUrl: image_url as! String, name: name as! String, searchString: term)
                                    self.results.append(biz)
                                    self.resultsTableView.reloadData()
                                }
                                
                               
                                
                                
                           
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
