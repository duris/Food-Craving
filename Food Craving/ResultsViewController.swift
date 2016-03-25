//
//  ResultsViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/22/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultsTableView: UITableView!
    var results = [Business]()
    var tempResults = [Business]()
    var tempIds = [String]()
    var searchStrings = [String]()
    var duplicates = [Business]()

    
    
    
    /*
    Core Data Convenience
    */
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableView.delegate = self
        resultsTableView.dataSource = self

        
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entityForName("Craving", inManagedObjectContext: self.sharedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.sharedContext.executeFetchRequest(fetchRequest)
            var cravings = [Craving]()
            for item in result{
                if let craving = item as? Craving {
                    cravings.append(craving)
                }
            }
            
           
            dispatch_async(dispatch_get_main_queue(), {
            
            for craving in cravings {
                cravings.sortInPlace {(craving1:Craving, craving2:Craving) -> Bool in
                    craving1.rating < craving2.rating
                }
                if craving.rating > 1 {
                    self.runSearch(craving.title)
                    print(craving.rating)
                }
            }
            })

            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        resultsTableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        searchStrings.removeAll()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! BusinessCell

       
        cell.resulTitleLabel.text = results[indexPath.row].name
        cell.business = results[indexPath.row]
        
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
                                //print(name)
                                
                                let id = biz["id"] as? String
                                if let image_url = biz["image_url"] {
                                    var biz = Business(imageUrl: image_url as! String, name: name as! String, searchString: term, id: id, duplicate:false)
                                    self.tempIds.append(id!)
                                    //print(id!)
                                    
//                                    for item in self.tempResults {
//                                        if item.id != biz.id {
//                                            self.tempResults.append(biz)
//                                        }
//                                    }
                                    for item in self.results {
                                        if item.id == id {
                                            biz.duplicate = true
                                            print(biz.name)
                                            print(biz.searchString)
                                            self.duplicates.append(biz)
                                            print("duplicates: \(self.duplicates.count)")
                                        } else {
                                        }
                                    }
                                    if biz.duplicate == false {
                                        self.results.append(biz)
                                        self.resultsTableView.reloadData()
                                    }
                                   

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
    
    func getAllCells() -> [BusinessCell] {
        
        var cells = [BusinessCell]()
        // assuming tableView is your self.tableView defined somewhere
        for i in 0...resultsTableView.numberOfSections-1
        {
            for j in 0...resultsTableView.numberOfRowsInSection(i)-1
            {
                if let cell = resultsTableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as? BusinessCell{
                    
                    if cell.business.duplicate == true {
//                        resultsTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: j, inSection: i)], withRowAnimation: .None)
                        results.removeAtIndex(j)
                        resultsTableView.reloadData()
                    }
                }
                
            }
        }
        return cells
    }

    
}
