//
//  Step.swift
//  Project8
//
//  Created by Vegiecat Studio on 12/9/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Step)
class Step: NSManagedObject {

    @NSManaged var stepText: String
    @NSManaged var id: String
    @NSManaged var stepImage: NSData
    @NSManaged var recipe: Recipe

}
