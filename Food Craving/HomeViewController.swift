//
//  HomeViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/24/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var menuTableView:UITableView!
    
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

        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        fetchedMenuesController.delegate = self
        
        fetchAllMenues()
    }
    
    override func viewWillAppear(animated: Bool) {
        menuTableView.reloadData()  
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedMenuesController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let menu = fetchedMenuesController.objectAtIndexPath(indexPath) as! Menu
        
        print(menu.title)
        
        cell.textLabel?.text = menu.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menu = fetchedMenuesController.objectAtIndexPath(indexPath) as! Menu
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        
        vc.menu = menu
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    Fetched Entries Controller
    */
    lazy var fetchedMenuesController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Menu")
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()
    
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            switch type {
            case .Insert:
                print("insert")
                print(fetchedMenuesController.fetchedObjects?.count)
                
            case .Delete:
                print("delete")
                print(fetchedMenuesController.fetchedObjects?.count)
            default:
                return
            }
    }
    
    func fetchAllMenues() {
        do {
            try fetchedMenuesController.performFetch()
        } catch {
            print("error fetching")
        }
    }
    
    
    @IBAction func didPressNewMenuButton() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        
        let dictionary = [
            "title": ""
        ] as [String: AnyObject]
        let menu = Menu(dictionary: dictionary, context: sharedContext)
        saveContext()
        vc.menu = menu
        navigationController?.pushViewController(vc, animated: true)
    }

}
