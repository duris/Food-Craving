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

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var sliderTableView:UITableView!
    var searchTerms = [String]()
    var sliders = [Slider]()
    @IBOutlet weak var newCravingTextField:UITextField!
    @IBOutlet weak var cancelNewCravingButton:UIButton!
    @IBOutlet weak var deleteCravingButton:UIButton!
    @IBOutlet weak var slider: Slider!
    @IBOutlet weak var logoImage:UIImageView!
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    var distanceMeters = 1609.34
    var currentLocation = CLLocation()
    @IBOutlet weak var locationButton:UIButton!
    @IBOutlet weak var deleteView:UIView!
    @IBOutlet weak var editButton:UIButton!
    var myLocations: [CLLocation] = []
    var locManager = CLLocationManager()
    
    
    
    
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
        
        prepareSegment()
        
        sliderTableView.delegate = self
        sliderTableView.dataSource = self
        sliderTableView.scrollEnabled = false
        
        logoImage.image = logoImage.image!.imageWithRenderingMode(.AlwaysTemplate)
        logoImage.tintColor = UIColor.brownColor()
        
        fetchedCravingsController.delegate = self
        
        
        
        
        
        fetchAllCravings()
        
        if fetchedCravingsController.fetchedObjects?.count > 0 {
            editButton.enabled = true
        } else {
            editButton.enabled = false
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
            locManager.requestAlwaysAuthorization()
            locManager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("last chance")
            print(locations.first?.coordinate.latitude)
        }
        for location in locations {
            myLocations.append(location)
        }
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let selected = defaults.stringForKey("selectedString")
        {
            print("selected :\(selected)")
            locationButton.setTitle(selected, forState: .Normal)
        }
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
    
    @IBAction func didTouchEditButton() {
        if fetchedCravingsController.fetchedObjects?.count != 0 {
            for cell in getAllCells() {
                if cell.deleteButton.hidden == true {
                    cell.deleteButton.hidden = false
                    editButton.setTitle("Done", forState: .Normal)
                } else {
                    cell.deleteButton.hidden = true
                    editButton.setTitle("Edit", forState: .Normal)
                }
            }
        }
        
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
                editButton.enabled = true
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
                    cell.deleteButton.hidden = true
                    saveContext()
                    
                    sliderTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                    
                }
            }
        }
        if fetchedCravingsController.fetchedObjects?.count == 0 {
            editButton.setTitle("Edit", forState: .Normal)
            editButton.enabled = false
        }
        
    }
    
    @IBAction func addNewCraving() {
        newCravingTextField.hidden = false
        cancelNewCravingButton.hidden = false
        newCravingTextField.becomeFirstResponder()
        if fetchedCravingsController.fetchedObjects?.count != 0 {
            for cell in getAllCells() {
                editButton.setTitle("Edit", forState: .Normal)
                cell.deleteButton.hidden = true
            }
        }
    }
    
    
    @IBAction func didPressSearchButton() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController
        
        
        
        //vc.searchStrings.removeAll()
        //vc.searchStrings = getSearchTerms()
        
        vc.distance = distanceMeters
        if myLocations.first != nil {
            
            vc.myLocations.append(myLocations.first!)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            
            //using static location for testing
            navigationController?.pushViewController(vc, animated: true)
        }
        
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
    
    @IBAction func didPressChangeLocationButton() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("LocationSelectorNavigationController") as! UINavigationController
        navigationController?.presentViewController(vc, animated: true, completion: nil)
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
                print("Near \(pm.locality!)")
                
                
                let defaults = NSUserDefaults.standardUserDefaults()
                //                let lat = "\(pm.location?.coordinate.latitude)"
                //                let lon = "\(pm.location?.coordinate.longitude)"
                defaults.setObject(pm.location?.coordinate.latitude, forKey: "userLatitude")
                defaults.setObject(pm.location?.coordinate.longitude, forKey: "userLongitude")
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func prepareSegment() {
        let items = ["1 Mi", "5 Mi", "10 Mi", "15 Mi"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(frame.minX + 30, frame.maxY - 140,
            frame.width - 60, 40)
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.clearColor()
        customSC.tintColor = UIColor.brownColor()
        
        
        // Add target action method
        customSC.addTarget(self, action: "changeColor:", forControlEvents: .ValueChanged)
        
        self.view.addSubview(customSC)
    }
    
    func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            distanceMeters = 1 * 1609.34
        case 1:
            distanceMeters = 5 * 1609.34
        case 2:
            distanceMeters = 10 * 1609.34
        case 3:
            distanceMeters = 15 * 1609.34
        default:
            distanceMeters = 1 * 1609.34
        }
    }
    
    
    
    
    
}

