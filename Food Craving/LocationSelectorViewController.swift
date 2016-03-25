//
//  LocationSelectorViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/25/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var locationsTableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    var searchResults = [AnyObject]()
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        cell.textLabel?.text = searchResults[indexPath.row] as? String
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //loading(true)
        searchResults.removeAll()
        GoogleClient.sharedInstance().searchForCities(searchText) { (success, results, error) in
            if success {
                self.searchResults = results
                self.locationsTableView.reloadData()
                //self.loading(false)
            } else {
                print(error)
                //self.alertError(error!, viewController: self)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let address = searchResults[indexPath.row] as? String
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                let defaults = NSUserDefaults.standardUserDefaults()
       
                defaults.setObject(address!, forKey: "selectedString")
             
            }
          
        })
        
       dismissViewControllerAnimated(true, completion: nil)
        
       
    }

    @IBAction func didPressCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    
}
