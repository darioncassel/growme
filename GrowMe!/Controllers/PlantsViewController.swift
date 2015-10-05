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
        var navBar = self.navigationController?.navigationBar
        navBar?.barStyle = UIBarStyle.Black
        navBar?.barTintColor = ColorHelper.greenBar
        navBar?.tintColor = ColorHelper.grayText
        tableView.rowHeight = 60
        // end styling
        
        let realm = Realm()
        plants = realm.objects(Plant).sorted("created", ascending: false)
        var notifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]
        print(notifications)
        for notification in notifications {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        var tomorrow = DateHelper.today() + 1
        var count = 0
        for plant in plants {
            var days = plant.schedule?.freq
            if let days = days {
                var contains = false
                for day in days {
                    if day.number == tomorrow && !day.notified && !day.complete{
                        contains = true
                        realm.write() {
                            day.notified = true
                        }
                    }
                }
                if contains {
                    count++
                }
            }
        }
        if count > 0 {
            var today = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Day, fromDate: NSDate())
            today.day = today.day + 1
            var notification = UILocalNotification()
            notification.fireDate = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)?.dateFromComponents(today)
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
            var cell = sender as! PlantsTableViewCell
            var destination = segue.destinationViewController as! EditPlantViewController
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
            let realm = Realm()
            realm.write() {
                realm.delete(plant)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
}

