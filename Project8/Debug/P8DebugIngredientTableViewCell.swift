//
//  P8DebugIngredientTableViewCell.swift
//  Project8
//
//  Created by Vegiecat Studio on 12/15/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

class P8DebugIngredientTableViewCell: UITableViewCell {

    
    
    @IBOutlet var name: UILabel!
    @IBOutlet var id: UILabel!
    @IBOutlet var recipe: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
