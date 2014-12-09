//
//  Ingredient.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/4/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Ingredient)
class Ingredient: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var recipe: Recipe

    
    func toDict()->NSDictionary{
        
        //Deals with Regular Stuff
        let keys = ["name","id"]
        let ingredientDict = self.dictionaryWithValuesForKeys(keys) as NSDictionary
        var ingredientDictMutable = ingredientDict.mutableCopy() as NSMutableDictionary
        
        
        
        return ingredientDictMutable
    }

    
}
