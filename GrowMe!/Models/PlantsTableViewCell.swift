//
//  PlantsTableViewCell.swift
//  GrowMe!
//
//  Created by Darion Cassel on 8/10/15.
//  Copyright (c) 2015 Darion Cassel. All rights reserved.
//

import UIKit

class PlantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plantCellTitle: UILabel!
    @IBOutlet weak var complete: UIButton!
    
    var plant: Plant? {
        didSet {
            if let plant = plant, plantCellTitle = plantCellTitle {
                plantCellTitle.text = plant.name
                var todayNum = DateHelper.today()
                var today = plant.getDay(todayNum)
                if let today = today {
                    if today.0 {
                        complete.backgroundColor = UIColor.clearColor()
                    } else {
                        complete.backgroundColor = UIColor.blueColor()
                    }
                    var amt = String(format: "%.1f", today.1) + " oz"
                    complete.setTitle(amt, forState: .Normal)
                } else {
                    complete.backgroundColor = UIColor.clearColor()
                    complete.setTitle("\\|/", forState: .Normal)
                }
            }
        }
    }
    
    @IBAction func completePress(sender: AnyObject) {
        var sender = sender as! UIButton
        if let plant = plant {
            var todayNum = DateHelper.today()
            plant.dayComplete(todayNum) { complete in
                if complete {
                    sender.backgroundColor = UIColor.clearColor()
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plantCellTitle.textColor = ColorHelper.greenText
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }


}
