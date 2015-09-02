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
    
    let sizeArr = ["Seed", "Sapling", "Medium", "Large"]
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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        let realm = Realm()
        if let plant = plant {
            realm.write() {
                plant.name = self.name.text
                plant.size = self.sizeArr[self.size.selectedSegmentIndex]
                plant.type = self.typeArr[self.type.selectedSegmentIndex]
                plant.location = self.locArr[self.location.selectedSegmentIndex]
                plant.light = self.lightArr[self.light.selectedSegmentIndex]
                plant.notify = self.notify.on
                plant.schedule =  Schedule(size: plant.size, type: plant.type, light: plant.light, location: plant.location, firstDay: plant.firstDay, weatherEffects: nil)
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


