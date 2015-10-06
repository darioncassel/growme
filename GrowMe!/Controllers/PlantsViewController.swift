//
//  PlantsViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/10/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit
import RealmSwift

class PlantsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var plants: Results<Plant>! {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // styling
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = UIBarStyle.Black
        navBar?.barTintColor = ColorHelper.greenBar
        navBar?.tintColor = ColorHelper.grayText
        tableView.rowHeight = 60
        // end styling
        
        let realm = try! Realm()
        plants = realm.objects(Plant).sorted("created", ascending: false)
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let tomorrow = DateHelper.today() + 1
        var count = 0
        for plant in plants {
            if plant.notify {
                let days = plant.schedule?.freq
                if let days = days {
                    var contains = false
                    for day in days {
                        if day.number == tomorrow && !day.complete{
                            contains = true
                        }
                    }
                    if contains {
                        count++
                    }
                }
            }
        }
        if count > 0 {
            let notification = UILocalNotification()
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.fireDate = NSDate().tomorrowAt8am
            if count == 1 {
                notification.alertBody = "1 plant needs water!"
            } else {
                notification.alertBody = "\(count) plants need water"
            }
            notification.applicationIconBadgeNumber = count
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editPlant" {
            let destination = segue.destinationViewController as! EditPlantViewController
            destination.plant = sender!.plant
        }
    }

}

extension PlantsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlantCell", forIndexPath: indexPath) as! PlantsTableViewCell
        let plant = plants[indexPath.row] as Plant
        cell.plant = plant
        cell.tintColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(plants?.count ?? 0)
    }
    
}

extension PlantsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // none
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let plant = plants[indexPath.row] as Plant
            let realm = try! Realm()
            realm.write() {
                realm.delete(plant)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
}

extension NSDate {
    
    var day: Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: self).day
    }
    var month: Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: self).month
    }
    var year: Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year,  fromDate: self).year
    }
    var tomorrowAt8am: NSDate {
        return  NSCalendar.currentCalendar().dateWithEra(1, year: year, month: month, day: day+1, hour: 8, minute: 0, second: 0, nanosecond: 0)!
    }
    
}

