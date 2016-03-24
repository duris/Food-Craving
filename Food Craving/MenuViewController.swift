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
    var sliders = [Slider]()
    @IBOutlet weak var newCravingTextField:UITextField!
    @IBOutlet weak var cancelNewCravingButton:UIButton!
    @IBOutlet weak var deleteCravingButton:UIButton!
    @IBOutlet weak var slideMenu: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCravingTextField.hidden = true
        newCravingTextField.delegate = self
        
        cancelNewCravingButton.hidden = true
        
        
        
        sliderTableView.delegate = self
        sliderTableView.dataSource = self
        sliderTableView.scrollEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        slideMenu.hidden = true
        slideMenu.frame.origin.x -= slideMenu.frame.width
    }

    
    @IBAction func didPressMenuButton() {
        
        if slideMenu.hidden == true {
        slideMenu.hidden = false
   
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5,
            options: [], animations: {
                // 3
                self.slideMenu.frame.origin.x += self.slideMenu.frame.width + 10
            },
            completion: { _ in
                // 4
                UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 4.5,
                    options: [], animations: {
                        // 5
                        self.slideMenu.frame.origin.x -= 10
                    }, 
                    completion: { _ in
                        // 6
                        print("done")
                })
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.slideMenu.frame.origin.x -= self.slideMenu.frame.width
                },
                completion: { _ in
                    // 4
                    UIView.animateWithDuration(0.35, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 4.5,
                        options: [], animations: {
                            // 5

                            //Animate Menu button?
                            
                        },
                        completion: { _ in
                            // 6
                            self.slideMenu.hidden = true
                    })
            })

        }
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliderNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SliderCell
        
        
        
        let frame = CGRectMake(40, 5, view.frame.width - 80, 70)
        let tabFrame = CGRectMake(frame.width/2 - 6, 33, 20, 20)
        let tabView = UIView()
    
        tabView.userInteractionEnabled = false
        tabView.backgroundColor = UIColor.whiteColor()
        tabView.layer.borderColor = UIColor.orangeColor().CGColor
        tabView.layer.borderWidth = 2
        tabView.frame = tabFrame
        tabView.layer.cornerRadius = tabView.frame.height/2
        tabView.layer.masksToBounds = true
        
        
        let slider = Slider()
        //slider.backgroundColor = UIColor.blueColor()
        slider.sliderTab = tabView
        slider.label = cell.silderTitleLabel
        slider.frame = frame
        cell.slider = slider
        sliders.append(slider)
        slider.addSubview(tabView)
        cell.addSubview(slider)
        print("Slider rating: \(slider.ratingNumber)")
        cell.silderTitleLabel.text = sliderNames[indexPath.row]
        //Slider bar image
        
        //Slider tab image
        
        let sliderFillFrame = CGRectMake(10, slider.frame.height/2 + 5, slider.frame.width/2, 5)
        slider.sliderFillColor.frame = sliderFillFrame
        slider.sliderFillColor.backgroundColor = UIColor.orangeColor()
        slider.sliderFillColor.layer.cornerRadius = 2
        slider.sliderFillColor.clipsToBounds = true
        slider.addSubview(slider.sliderFillColor)
        
        
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
        newCravingTextField.resignFirstResponder()
    }
    
    @IBAction func deleteSlider(sender: AnyObject) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? SliderCell {
                    indexPath = sliderTableView.indexPathForCell(cell)
                    sliderNames.removeAtIndex(indexPath.row)
                    sliderTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                    sliders.removeAtIndex(indexPath.row)
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
        
        var searchTerms = [String]()
        for slider in sliders {
            if slider.ratingNumber > 1 {
                searchTerms.append(slider.label.text!)
            }
        }
        vc.searchStrings = searchTerms
        navigationController?.pushViewController(vc, animated: true)
    }
 
    
    
}

