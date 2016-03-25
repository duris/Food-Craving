//
//  MenuViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/16/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var sliderTableView:UITableView!
    var searchTerms = [String]()
    var sliders = [Slider]()
    @IBOutlet weak var newCravingTextField:UITextField!
    @IBOutlet weak var cancelNewCravingButton:UIButton!
    @IBOutlet weak var deleteCravingButton:UIButton!
    @IBOutlet weak var slider: Slider!
    @IBOutlet weak var logoImage:UIImageView!
    var locManager = CLLocationManager()
    var currentLocation = CLLocation()
    @IBOutlet weak var locationButton:UIButton!
    @IBOutlet weak var sampleLabel:UILabel!


    
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
        
        newCravingTextField.hidden = true
        newCravingTextField.delegate = self
        
        cancelNewCravingButton.hidden = true
        
        
        sliderTableView.delegate = self
        sliderTableView.dataSource = self
        sliderTableView.scrollEnabled = false
        
        logoImage.image = logoImage.image!.imageWithRenderingMode(.AlwaysTemplate)
        logoImage.tintColor = UIColor.brownColor()
        
        fetchedCravingsController.delegate = self
        
        fetchAllCravings()
        
       
        locManager.requestWhenInUseAuthorization()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .AuthorizedAlways ){
                
                currentLocation = locManager.location!
                geocodeLocation(currentLocation)
        
        }
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
   
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        if fetchedCravingsController.fetchedObjects?.count != 0 {
            for cell in getAllCells() {
                let craving = cell.craving as Craving
                craving.rating = cell.slider.ratingNumber
                if craving.rating != 0 {
                    saveContext()
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if fetchedCravingsController.fetchedObjects?.count != 0 {
            for cell in getAllCells() {
                let craving = cell.craving as Craving
                craving.rating = cell.slider.ratingNumber
                if craving.rating != 0 {
                    saveContext()
                }
            }
        }
    }
  
    /*
    Fetched Cravings Controller
    */
    lazy var fetchedCravingsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Craving")
        let title = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [title]
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
                print(fetchedCravingsController.fetchedObjects?.count)
                
            case .Delete:
                print("delete")
                print(fetchedCravingsController.fetchedObjects?.count)
                
            case .Update:
                print("update")
                print(fetchedCravingsController.fetchedObjects?.count)
            default:
                return
            }
    }
    
    func fetchAllCravings() {
        do {
            try fetchedCravingsController.performFetch()
        } catch {
            print("error fetching")
        }
    }
    
    
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedCravingsController.sections![section]
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SliderCell
        
            let craving = fetchedCravingsController.objectAtIndexPath(indexPath) as! Craving
        
            cell.slider.sliderTitleLabel.text = craving.title
        
            cell.craving = craving
        
        
            cell.slider.ratingNumber = craving.rating
        
            if craving.rating > 1 {
                cell.slider.sliderTitleLabel.textColor = UIColor.blackColor()
                searchTerms.append(cell.slider.sliderTitleLabel.text!)
            }
           
            print("slider rating: \(cell.slider.ratingNumber)")
        
            cell.slider.setSlideToRating(craving.rating)
        
 
           return cell
        
        
    }
    
    func getSearchTerms() -> [String] {
        let items = fetchedCravingsController.fetchedObjects
        var strings = [String]()
        for item in items!{
            if let craving = item as? Craving {
                if craving.rating > 1 {
                    strings.append(item.title)   
                }
            }
        }
        return strings
    }
    
    @IBAction func editSliders() {
        sliderTableView.editing = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField == newCravingTextField {
            textField.hidden = true
            cancelNewCravingButton.hidden = true
            if let newCraving = textField.text! as? String {
                let timestamp = NSDate().timeIntervalSince1970
                let dictionary = [
                    "title": newCraving,
                    "rating": 5,
                    "timestamp": "\(timestamp)"
                    ] as [String: AnyObject]
                let craving = Craving(dictionary: dictionary, context: sharedContext)
                saveContext()
                sliderTableView.beginUpdates()
                let cravings = fetchedCravingsController.fetchedObjects
                sliderTableView.insertRowsAtIndexPaths([
                    NSIndexPath(forRow: cravings!.count - 1, inSection: 0)
                    ], withRowAnimation: .Automatic)
                sliderTableView.endUpdates()
               //sliderTableView.reloadData()
            }
            
            textField.text = ""
            textField.resignFirstResponder()
            
            return true

        } else {
            
            return true
        }
        
    }
    
    
    
    @IBAction func cancelNewCraving() {
        newCravingTextField.text = ""
        newCravingTextField.hidden = true
        cancelNewCravingButton.hidden = true
        newCravingTextField.resignFirstResponder()
    }
    
    @IBAction func deleteSlider(sender: AnyObject) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? SliderCell {
                    indexPath = sliderTableView.indexPathForCell(cell)
                    let craving = fetchedCravingsController.objectAtIndexPath(indexPath) as! Craving
                    sharedContext.deleteObject(craving)
                    saveContext()
                    
                    sliderTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)

                }
            }
        }

    }
    
    @IBAction func addNewCraving() {
        newCravingTextField.hidden = false
        cancelNewCravingButton.hidden = false
        newCravingTextField.becomeFirstResponder()
    }
    
    
    @IBAction func didPressSearchButton() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        
    
    
        //vc.searchStrings.removeAll()
        //vc.searchStrings = getSearchTerms()
        print("search terms: \(getSearchTerms())")

        navigationController?.pushViewController(vc, animated: true)
    }
 
    
    
    func getAllCells() -> [SliderCell] {
        
        var cells = [SliderCell]()
        // assuming tableView is your self.tableView defined somewhere
        for i in 0...sliderTableView.numberOfSections-1
        {
            for j in 0...sliderTableView.numberOfRowsInSection(i)-1
            {
                if let cell = sliderTableView.cellForRowAtIndexPath(NSIndexPath(forRow: j, inSection: i)) as? SliderCell{
                    
                    cells.append(cell)
                }
            }
        }
        return cells
    }
    
    
    func geocodeLocation(location: CLLocation) {
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            
            if error != nil {
                print("Reverse geocoder failed with error")
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as! CLPlacemark
                print(pm.locality)
                self.locationButton.center = self.view.center
                self.locationButton.titleLabel?.text = "Near \(pm.locality!)"

            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
}

