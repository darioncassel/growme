//
//  AddPlantViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/10/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit
import RealmSwift

class AddPlantViewController: UIViewController {
    
    var plant: Plant?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        // set up later
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPlant(sender: AnyObject) {
        self.performSegueWithIdentifier("goToEditPlant", sender: self)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController: UIViewController = segue.destinationViewController as! UIViewController
        
        var saveButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        saveButton.addTarget(self, action: "saveToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        saveButton.sizeToFit()
        
        var saveButtonItem: UIBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        var discardButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        discardButton.addTarget(self, action: "discardToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        discardButton.setTitle("Discard", forState: UIControlState.Normal)
        discardButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        discardButton.sizeToFit()
        
        var discardButtonItem: UIBarButtonItem = UIBarButtonItem(customView: discardButton)
        
        destinationViewController.navigationItem.setHidesBackButton(true, animated: false)
        destinationViewController.navigationItem.leftBarButtonItem = discardButtonItem
        destinationViewController.navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    func saveToRoot(sender:UIBarButtonItem){
        let realm = Realm()
        plant = Plant()
        plant!.name = "Test Plant"
        realm.write() {
            realm.add(self.plant!)
        }
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func discardToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

}
