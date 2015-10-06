//
//  EditPlantViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/10/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit
import RealmSwift

class EditPlantViewController: UIViewController {
    
    let sizeArr = ["Seed", "Small", "Medium", "Large"]
    let typeArr = ["Edible", "Flowering", "Tree/Shrub", "Succulent"]
    let locArr = ["Indoors", "Outdoors"]
    let lightArr = ["Full", "Mostly", "Little", "Shade"]
    
    var plant: Plant?

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var size: UISegmentedControl!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var location: UISegmentedControl!
    @IBOutlet weak var light: UISegmentedControl!
    @IBOutlet weak var notify: UISwitch!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var scheduleContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        let info: [NSObject : AnyObject] = aNotification.userInfo!
        let keyPadFrame: CGRect = UIApplication.sharedApplication().keyWindow!.convertRect(info[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue, fromView: self.view)
        let kbSize: CGSize = keyPadFrame.size
        let activeRect: CGRect = self.view.convertRect(activeField.frame, fromView: activeField.superview)
        var aRect: CGRect = self.view.bounds
        aRect.size.height -= (kbSize.height)
        var origin: CGPoint = activeRect.origin
        origin.y -= scrollView.contentOffset.y
        if !CGRectContainsPoint(aRect, origin) {
            let scrollPoint: CGPoint = CGPointMake(0.0, CGRectGetMaxY(activeRect) - (aRect.size.height))
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func DismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // styling
        self.view.backgroundColor = UIColor.whiteColor()
        for view in self.view.subviews[0].subviews {
            if view.isKindOfClass(UILabel) {
                let view = view as! UILabel
                view.textColor = ColorHelper.greenText
            }
        }
        name.textColor = ColorHelper.greenText
        self.view.tintColor = ColorHelper.greenText
        // end styling
        
        if let plant = plant {
            name.text = plant.name
            segmentSolver(plant.size, array: sizeArr, segment: size)
            segmentSolver(plant.type, array: typeArr, segment: type)
            segmentSolver(plant.location, array: locArr, segment: location)
            segmentSolver(plant.light, array: lightArr, segment: light)
            zipcode.text = plant.zipcode
            notify.on = plant.notify
            
            let scheduleCont = self.childViewControllers[0] as! ScheduleViewController
            scheduleCont.plant =  plant
        }
    }
    
    func segmentSolver(attr: String, array:[String], segment: UISegmentedControl) {
        for var i = 0; i < array.count; i++ {
            if attr == array[i] {
                segment.selectedSegmentIndex = i
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        name.endEditing(true)
        if let plant = plant {
            let realm = try! Realm()
            realm.write() {
                plant.name = self.name.text!
                plant.size = self.sizeArr[self.size.selectedSegmentIndex]
                plant.type = self.typeArr[self.type.selectedSegmentIndex]
                plant.location = self.locArr[self.location.selectedSegmentIndex]
                plant.light = self.lightArr[self.light.selectedSegmentIndex]
                plant.notify = self.notify.on
                
                if plant.useWeather {
                    WeatherHelper.getWeatherInfo(plant, zip: plant.zipcode) { weatherEffects in
                        plant.weatherEffects = weatherEffects
                    }
                } else {
                    plant.schedule = Schedule(size: plant.size, type: plant.type, light: plant.light, location: plant.location, firstDay: plant.firstDay, weatherEffects: plant.weatherEffects, completed: plant.completed)
                }
                
                realm.add(plant)
            }
        }
        popToRoot(sender)
    }
    
    @IBAction func leftPressed(sender: UIBarButtonItem) {
        popToRoot(sender)
    }

    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

}

extension EditPlantViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = textField
    }
    
}


