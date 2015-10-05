//
//  PickerViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/27/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    var plant: Plant?
    var choice: Int = 0
    
    @IBOutlet weak var picker: UIPickerView!
    
    let numbers: [String] = ["Today", "One day", "Two days", "Three days", "More than three"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextStep(sender: UIButton!) {
        if plant?.location == "Indoors" {
            if let plant = plant {
                plant.schedule = Schedule(size: plant.size, type: plant.type, light: plant.light, location: plant.location, firstDay: plant.firstDay, weatherEffects: plant.weatherEffects, completed: plant.completed)
            }
            self.performSegueWithIdentifier("goToEditPlant", sender: self)
        } else {
            self.performSegueWithIdentifier(self.restorationIdentifier!, sender: self)
        }
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let currentDate = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .LongStyle)
        let day = DateHelper.today()
        let firstDay = abs((day - choice) % 6)
        if let plant = plant {
            plant.firstDay = firstDay
            plant.created = currentDate
        }
        if segue.identifier == "goToEditPlant" {
            let destinationViewController = segue.destinationViewController as! EditPlantViewController
            destinationViewController.plant = self.plant
        } else {
            let destinationViewController = segue.destinationViewController as! AddPlantViewController
            destinationViewController.plant = self.plant
        }
    }

}

extension PickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return numbers[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choice = row
    }
    
}

extension PickerViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
}

