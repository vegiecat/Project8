//
//  Recipe.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/4/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import Foundation
import CoreData

@objc(Recipe)
class Recipe: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var id: String
    @NSManaged var ingredient: NSOrderedSet
    @NSManaged var step: NSOrderedSet
    @NSManaged var coverPhoto: NSData
    
    func toDict()->NSDictionary{
        
        //Deals with Regular Stuff
        let keys = ["name","id","ingredient"]
        let recipeDict = self.dictionaryWithValuesForKeys(keys) as NSDictionary
        var recipeDictMutable = recipeDict.mutableCopy() as NSMutableDictionary
        
        //Deals with Ingredients
        let ingredientsArray = ingredient.array
        var ingredientsArrayFinal = [NSDictionary]()
        for counter in ingredientsArray{
            let ingredientDict = counter.toDict()
            ingredientsArrayFinal.append(ingredientDict)
        }
        recipeDictMutable.setValue(ingredientsArrayFinal, forKey: "ingredient")

        
        return recipeDictMutable
    }
    
    func printName(){
        if self.name == ""{
            println("no name?")
        }else{
            println(self.name)
        }
    }

}
