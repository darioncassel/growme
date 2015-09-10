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
    
    @IBAction func dayPressed(sender: AnyObject) {
        if let plant = plant {
            var day = keyFromButton(sender as! UIButton)
            if let day = day {
                plant.dayToggle(day) { complete in
                    if !complete {
                        var incomplete = UIImage(named: "Incomplete")!
                        sender.setBackgroundImage(incomplete, forState: .Normal)
                    } else {
                        var complete = UIImage(named: "Complete")!
                        sender.setBackgroundImage(complete, forState: .Normal)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // styling
        for view in self.view.subviews[0].subviews {
            var view = view as! UIView
            view.backgroundColor = UIColor.whiteColor()
            view.layer.borderWidth = 0.7
            view.layer.cornerRadius = 2
            view.layer.borderColor = ColorHelper.greenText.CGColor
            for subview in view.subviews {
                if subview.isKindOfClass(UILabel) {
                    var subview = subview as! UILabel
                    subview.textColor = UIColor.whiteColor()
                    subview.backgroundColor = ColorHelper.greenText
                }
            }
        }
        // end styling
        
        if let plant = plant {
            var schedule = plant.schedule!.freq
            for day in schedule {
                var amt = String(format: "%.1f", day.amount) + " oz"
                var complete = day.complete
                self.activateButton(day.number, amt: amt, complete: complete)
            }
        }
    }
    
    func activateButton(day: Int, amt: String, complete: Bool) {
        var button = buttonFromKey(day)
        if let button = button {
            button.setTitle(amt, forState: .Normal)
            button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            if !complete {
                var incomplete = UIImage(named: "Incomplete")!
                button.setBackgroundImage(incomplete, forState: .Normal)
            } else {
                var complete = UIImage(named: "Complete")!
                button.setBackgroundImage(complete, forState: .Normal)
            }
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
    
    func keyFromButton(button: UIButton) -> Int? {
        var num: Int!
        switch button {
        case su:
            num = 0
        case mo:
            num = 1
        case tu:
            num = 2
        case we:
            num = 3
        case th:
            num = 4
        case fr:
            num = 5
        case sa:
            num = 6
        default:
            num = nil
            println("error")
        }
        return num
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

