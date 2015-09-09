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
    let lightArr = ["Full", "Mostly", "Partial", "Shade"]
    
    var plant: Plant?

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var size: UISegmentedControl!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var location: UISegmentedControl!
    @IBOutlet weak var light: UISegmentedControl!
    @IBOutlet weak var notify: UISwitch!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var scheduleContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // styling
        self.view.backgroundColor = UIColor.whiteColor()
        for view in self.view.subviews[0].subviews {
            if view.isKindOfClass(UILabel) {
                var view = view as! UILabel
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
            let realm = Realm()
            realm.write() {
                plant.name = self.name.text
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


