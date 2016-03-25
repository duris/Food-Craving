//
//  LocationSelectorViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/25/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit

class LocationSelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var locationsTableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    var searchResults = [AnyObject]()

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

    @IBAction func didPressCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    

}
