//
//  MenuViewController.swift
//  Food Craving
//
//  Created by Ross Duris on 3/16/16.
//  Copyright © 2016 duris.io. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var sliderTableView:UITableView!
    var sliderNames = ["Hamburgers", "Pasta", "Sushi", "Wings"]
    @IBOutlet weak var newCravingTextField:UITextField!
    @IBOutlet weak var cancelNewCravingButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCravingTextField.hidden = true
        newCravingTextField.delegate = self
        
        cancelNewCravingButton.hidden = true
        
        sliderTableView.delegate = self
        sliderTableView.dataSource = self
        sliderTableView.scrollEnabled = false
        
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliderNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SliderCell
        
        
        
        let frame = CGRectMake(30, 0, view.frame.width - 60, 70)
        let tabFrame = CGRectMake(frame.width/2 - 6, 35, 15, 15)
        let tabView = UIView()
    
        tabView.userInteractionEnabled = false
        tabView.backgroundColor = UIColor.greenColor()
        tabView.frame = tabFrame
        tabView.layer.cornerRadius = tabView.frame.height/2
        tabView.layer.masksToBounds = true
        
        let slider = Slider()
        //slider.backgroundColor = UIColor.blueColor()
        slider.sliderTab = tabView
        slider.frame = frame
        cell.slider = slider
        
        slider.addSubview(tabView)
        cell.addSubview(slider)
        print("Slider rating: \(slider.ratingNumber)")
        cell.silderTitleLabel.text = sliderNames[indexPath.row]
        //Slider bar image
        
        //Slider tab image
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            sliderNames.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        }
    }
    
    @IBAction func editSliders() {
        sliderTableView.editing = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newCravingTextField.hidden = true
        cancelNewCravingButton.hidden = true
        
        if let newCraving = textField.text! as? String {
            
            sliderNames.append(newCraving)
            
            sliderTableView.beginUpdates()
            sliderTableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow: sliderNames.count-1, inSection: 0)
                ], withRowAnimation: .Automatic)
            sliderTableView.endUpdates()
           
        }
        newCravingTextField.text = ""
        newCravingTextField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func cancelNewCraving() {
        newCravingTextField.text = ""
        newCravingTextField.hidden = true
        cancelNewCravingButton.hidden = true
    }
    
    @IBAction func deleteSlider(sender: AnyObject) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? SliderCell {
                    indexPath = sliderTableView.indexPathForCell(cell)
                    sliderNames.removeAtIndex(indexPath.row)
                    sliderTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                    
                    cell.slider.removeFromSuperview()
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
        vc.searchStrings = sliderNames
        navigationController?.pushViewController(vc, animated: true)
    }
 
    
    
}

