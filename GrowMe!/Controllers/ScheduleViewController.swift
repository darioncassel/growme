//
//  ScheduleViewController.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/30/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var plant: Plant?

    @IBOutlet weak var su: UIButton!
    @IBOutlet weak var mo: UIButton!
    @IBOutlet weak var tu: UIButton!
    @IBOutlet weak var we: UIButton!
    @IBOutlet weak var th: UIButton!
    @IBOutlet weak var fr: UIButton!
    @IBOutlet weak var sa: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let plant = plant {
            var schedule = plant.schedule.freq
            for day in schedule {
                var amt = String(format: "%.1f", day.amount) + " oz"
                activateButton(day.number, amt: amt)
            }
            var dayNum = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.CalendarUnitWeekday, fromDate: NSDate()).weekday - 1 
            if let button = buttonFromKey(dayNum) {
                button.backgroundColor = UIColor.yellowColor()
            }
        }
    }
    
    func activateButton(day: Int, amt: String) {
        var button = buttonFromKey(day)
        if let button = button {
            button.setTitle(amt, forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    }
    
    func buttonFromKey(key: Int) -> UIButton? {
        var button: UIButton!
        switch key {
        case 0:
            button = su
        case 1:
            button = mo
        case 2:
            button = tu
        case 3:
            button = we
        case 4:
            button = th
        case 5:
            button = fr
        case 6:
            button = sa
        default:
            button = nil
            println("error")
        }
        return button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

