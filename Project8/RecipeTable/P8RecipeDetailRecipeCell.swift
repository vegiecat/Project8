//
//  P8RecipeDetailTableViewCell.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/9/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

class P8RecipeDetailRecipeCell: UITableViewCell {

    @IBOutlet var recipeName: UILabel!
    @IBOutlet var recipeCoverPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
