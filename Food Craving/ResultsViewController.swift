//
//  ResultsViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/22/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultsTableView: UITableView!
    var results = [Business]()
    var tempResults = [String]()
    var tempIds = [String]()
    var searchStrings = [String]()
    var duplicates = [Business]()
    var newResults = [Business]()
    var activeCravings = [Craving]()
    var distance : Double!
    var cravingLoadedCount = 0
    var latitude: String!
    var longitude: String!
 var myLocations: [CLLocation] = []
    let locationManager = CLLocationManager()
    
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
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        print(round(distance))

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
                    if craving.rating > 1 {
                        activeCravings.append(craving)
                    }
                }
            }
            
           
//            searchYelp(cravings) { (success) in
//                if success {
//                    //self.sortSimilar()
//                    print("Craving Count: \(self.cravingLoadedCount)")
//                }
//            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            myLocations.append(location)
        }
        
        print(myLocations.first)
    }
    
    
    func searchYelp(cravings:[Craving], completionHandler: (success: Bool) -> Void) {
        for craving in cravings {
            if craving.rating == 10 {
                let limit = "\(round(Float(craving.rating)*2/Float(self.activeCravings.count)))"
                print("The limit is : \(limit)")
                self.runSearch(craving.title, limit: limit)
                
            }else if craving.rating > 1 {
                let limit = "\(round(Float(craving.rating)*2.1/Float(self.activeCravings.count)))"
                print("The limit is : \(limit)")
                self.runSearch(craving.title, limit: limit)
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.cravingLoadedCount = cravings.count
            completionHandler(success: true)
        })
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BusinessViewController") as! BusinessViewController

        let business = results[indexPath.row]
        vc.business = business
        navigationController?.pushViewController(vc, animated: true)
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
        
        if let starURL = NSURL(string: results[indexPath.row].starRating) {
            if let imageData = NSData(contentsOfURL: starURL) {
                let image = UIImage(data: imageData)
                cell.ratingImageView.image = image!
            }
        }
        
        let reviewCount = results[indexPath.row].reviewCount
        cell.reviewCountLabel.text = "\(reviewCount) Reviews"
        
        cell.resultSubTitleLabel.text = results[indexPath.row].searchString
        return cell
    }
    
    
    
    func runSearch(term: String, limit: String) {
        print(latitude)
        print(longitude)
        print("lat long: \(latitude!)")
        let lat = "lat long: \(latitude!)"
        let lon = longitude!
        let ll = "\(self.latitude!),\(self.longitude!)"
        let parameters = [
            "ll": "\(ll)",
            "radius_filter": "\(round(distance))",
            "sort": "0",
            "term": term,
            "limit": limit]
        
        YelpClient.sharedInstance().searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
            //print(NSString(data: data, encoding: NSUTF8StringEncoding))
            dispatch_async(dispatch_get_main_queue(), {
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options:[])
                    
                    if let businesses = jsonArray["businesses"] as? NSArray{
                        for biz in (businesses as? [[String:AnyObject]])!{
                            if let name = biz["name"] {
                                
                               
                                
                                let id = biz["id"] as? String
                                if let image_url = biz["image_url"] {
                                    var url = ""
                                    var reviewCount = ""
                                    if let starRating = biz["rating_img_url"] {
                                        url = starRating as! String
                                    }
                                    if let reviews = biz["review_count"] {
                                        print("review count")
                                        print(reviewCount)
                                        reviewCount = "\(reviews)"
                                    }
                                    var biz = Business(imageUrl: image_url as! String, name: name as! String, searchString: term, id: id, duplicate:false, doubleDupe: false, starRating: url, reviewCount: reviewCount)
                                    self.tempIds.append(id!)
                                    //print(id!)
                                    
                                    
                                    for item in self.results {
                                        if item.id == id {
                                            biz.duplicate = true
                                            for doubleDupe in self.duplicates {
                                                if doubleDupe.id == item.id {
                                                    print("Double dupe: \(doubleDupe.name)")
                                                    print("\(doubleDupe.searchString)")
                                                    biz.doubleDupe = true
                                                }
                                            }
                                            if biz.doubleDupe == false {
                                                print(biz.name)
                                                print(biz.searchString)
                                                self.duplicates.append(biz)
                                                print("duplicates: \(self.duplicates.count)")
                                            }
                           
                                        } else {
                                        }
                                    }
                                    if biz.duplicate == false {
                                        self.results.append(biz)
                                        self.resultsTableView.reloadData()
                                        self.tempResults.append(biz.id)
                                    }
                                   

                                }
                           
                            }
                        }
                    }
                    
                    self.cravingLoadedCount = self.cravingLoadedCount + 1
                    print("craving loaded count:\(self.cravingLoadedCount)")
                    print("active cravings: \(self.activeCravings.count)")
                    if self.cravingLoadedCount/2 == self.activeCravings.count {
                         self.sortSimilar()
                        
                        //Stop Loading Results :)
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
    
    func sortSimilar() {
        newResults.removeAll()
        for result in results {
            if var biz = result as? Business {
                for duplicate in duplicates {
                    
                    if result.id == duplicate.id {
                        print(result)
                        print(duplicate.name)
                        
                        biz.searchString = "\(result.searchString), \(duplicate.searchString)"
                        print(biz.searchString)
                        //newResults.append(biz)
                        newResults.insert(biz, atIndex: 0)
                        biz.duplicate = true
                        print(biz.name)
                        print(biz.searchString)
                    
                        print("duplicates: \(self.duplicates.count)")
                        } else {
                            //newResults.append(result)
                        }
                    }
                    if biz.duplicate == false {
                        newResults.append(biz)
                    }
                }
   
            }
        
            results = newResults
            resultsTableView.reloadData()
        
   
        
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
