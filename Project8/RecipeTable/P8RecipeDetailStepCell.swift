//
//  P8RecipeDetailStepCell.swift
//  Project8
//
//  Created by Vegiecat Studio on 12/17/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

class P8RecipeDetailStepCell: UITableViewCell {

    
    @IBOutlet var stepImage: UIImageView!
    @IBOutlet var stepText: UILabel!
    @IBOutlet var stepCount: UILabel!
    
    @IBOutlet var stepImageTemp: UIImageView!
    @IBOutlet var stepTextTemp: UILabel!
    @IBOutlet var stepCountTemp: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
