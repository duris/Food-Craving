//
//  MenuViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/16/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var sliderTableView:UITableView!
    var sliderNames = ["Hamburgers", "Pasta", "Sushi", "Wings"]
    var sliders = [Slider]()
    @IBOutlet weak var newCravingTextField:UITextField!
    @IBOutlet weak var cancelNewCravingButton:UIButton!
    @IBOutlet weak var deleteCravingButton:UIButton!
    @IBOutlet weak var slider: Slider!

    @IBOutlet weak var menuTitleTextField:UITextField!
    var menu: Menu!
    
    let menuTitleTextAttributes = [
        NSFontAttributeName : UIFont(name: "Arial", size: 20)!,
        NSForegroundColorAttributeName : UIColor.blackColor(),
        //NSStrokeColorAttributeName : UIColor.blackColor(),
        //NSStrokeWidthAttributeName: -3.0
    ]
    
    
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
        
        menuTitleTextField.text = menu.title
        menuTitleTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        sliderTableView.delegate = self
        sliderTableView.dataSource = self
        sliderTableView.scrollEnabled = false
        
        setupMenuTextField(menuTitleTextField)
        
        fetchedCravingsController.delegate = self
        
        fetchAllCravings()
        
        for craving in menu.cravings {
            print(craving.rating)
        }
    }

    
   
    override func viewWillDisappear(animated: Bool) {
        for cell in getAllCells() {
            let craving = cell.craving as Craving
                
                craving.rating = cell.slider.ratingNumber
            if craving.rating != 0 {
                saveContext()
            }                        
        }
    }
  
    /*
    Fetched Entries Controller
    */
    lazy var fetchedCravingsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Craving")
        //[NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "menu == %@", self.menu)
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
        
            cell.silderTitleLabel.text = craving.title
        
            cell.craving = craving
        
            cell.slider.ratingNumber = craving.rating
           
            print("slider rating: \(cell.slider.ratingNumber)")
        
            cell.slider.setSlideToRating(craving.rating)
        
 
           return cell
        
        
    }
    
    
    @IBAction func editSliders() {
        sliderTableView.editing = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField == newCravingTextField {
            textField.hidden = true
            cancelNewCravingButton.hidden = true
            if let newCraving = textField.text! as? String {

                let dictionary = [
                    "title": newCraving,
                    "rating": 5
                    ] as [String: AnyObject]
                let craving = Craving(dictionary: dictionary, context: sharedContext)
                craving.menu = menu
                saveContext()
//                sliderTableView.beginUpdates()
//                sliderTableView.insertRowsAtIndexPaths([
//                    NSIndexPath(forRow: menu.cravings.count - 1, inSection: 0)
//                    ], withRowAnimation: .Automatic)
//                sliderTableView.endUpdates()
                sliderTableView.reloadData()
            }
            textField.text = ""
            textField.resignFirstResponder()
            
            return true

        } else {
            
            if textField.text == "" {
                let menuCount = fetchedCravingsController.fetchedObjects?.count
                textField.text = "Menu \(menuCount! + 1)"
                
                textField.resignFirstResponder()
                return true
            } else {

                menu.title = textField.text
                saveContext()
                
                sliderTableView.reloadData()

                textField.resignFirstResponder()
                return true
            }
           
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
        
        var searchTerms = [String]()
        for cell in getAllCells() {
            let craving = cell.craving as Craving
            if craving.rating > 1 {
                searchTerms.append(craving.title)
            }
        }
        vc.searchStrings = searchTerms
        navigationController?.pushViewController(vc, animated: true)
    }
 
    
    func setupMenuTextField(textField:UITextField) {
        //Setup the text field's to the desired format
        textField.defaultTextAttributes = menuTitleTextAttributes
        textField.delegate = self
        textField.center = view.center
        textField.contentVerticalAlignment = .Center
        textField.textAlignment = .Center
        textField.borderStyle = .None
        
        //textField.autocapitalizationType = .AllCharacters
        
        //Reset the text fields if they're empty
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
    
    
    
}

