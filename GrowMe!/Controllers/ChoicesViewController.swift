//
//  ChoicesViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/11/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit

class ChoicesViewController: UIViewController {
    
    var plant: Plant!
    var choice: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextStep(sender: UIButton!) {
        choice = sender.titleLabel?.text
        self.performSegueWithIdentifier(self.restorationIdentifier!, sender: self)
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "step1" {
            let destination = segue.destinationViewController as! ChoicesViewController
            if let plant = plant {
                plant.size = choice ?? ""
            } else {
                plant = Plant()
                plant.size = choice ?? ""
            }
            destination.plant = self.plant
        } else if segue.identifier == "step2" {
            let destination = segue.destinationViewController as! ChoicesViewController
            plant.type = choice ?? ""
            destination.plant = self.plant
        } else if segue.identifier == "step3" {
            let destination = segue.destinationViewController as! ChoicesViewController
            plant.location = choice ?? ""
            destination.plant = self.plant
        } else if segue.identifier == "step4" {
            let destination = segue.destinationViewController as! PickerViewController
            plant.light = choice ?? ""
            destination.plant = self.plant
        }
    }

}
