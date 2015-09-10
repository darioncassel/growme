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
                        var dayComplete = UIImage(named: "Complete")!
                        complete.setBackgroundImage(dayComplete, forState: .Normal)
                    } else {
                        var incomplete = UIImage(named: "Incomplete")!
                        complete.setBackgroundImage(incomplete, forState: .Normal)
                    }
                }
            }
        }
    }
    
    @IBAction func completePress(sender: AnyObject) {
        var sender = sender as! UIButton
        if let plant = plant {
            var todayNum = DateHelper.today()
            plant.dayToggle(todayNum) { complete in
                if complete {
                    var dayComplete = UIImage(named: "Complete")!
                    sender.setBackgroundImage(dayComplete, forState: .Normal)
                } else {
                    var incomplete = UIImage(named: "Incomplete")!
                    sender.setBackgroundImage(incomplete, forState: .Normal)
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
