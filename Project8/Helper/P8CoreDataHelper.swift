//
//  P8CoreDataHelper.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/5/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit
import CoreData

class P8CoreDataHelper: NSObject,
    P8RecipeEditorDataSource,
    JLStepEditorTableViewControllerDatasource,
    JLIngredientEditorTableViewControllerDatasource{
    
    var recipeOfInterest:Recipe?
    let globalMOC = managedObjectContext()
    let P8CoreDataHelperDebugMode = true
    override init(){
        super.init()
        
        /*
        let allRecipes = [Recipe]()
        let fetchRecipes = NSFetchRequest(entityName:"Recipe")
        var error: NSError?
        let fetchedResults = globalMOC.executeFetchRequest(fetchRecipes, error: &error) as [Recipe]?
        if let results = fetchedResults {
            allRecipes = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        */
        
        /*
        println(allRecipes.count)
        for counter in allRecipes{
            var singleRecipe = allRecipes[0]
            println(counter.name)
            println(counter.valueForKey("className"))
            let childIngredients:NSOrderedSet = counter.ingredient
            
            var childIngredientsArray = childIngredients.array
            for ingredientItem in childIngredientsArray{
                println(ingredientItem.name)
            }
        }
        */
    }
    

    //MARK: recipeTable
    func getAllRecipes()->NSArray{
        
        var allYourRecipes:NSArray = NSArray()
        let fetchRecipes = NSFetchRequest(entityName:"Recipe")
        var error: NSError?
        let fetchedResults = globalMOC.executeFetchRequest(fetchRecipes, error: &error) as [Recipe]?
        
        if let results = fetchedResults {
            allYourRecipes = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }

        /*
        for recipe in allRecipes{
            let singleRecipe:Recipe = recipe as Recipe
            println("haha \(singleRecipe.name)")
            let recipeDict:NSDictionary = ["id":"test","name":singleRecipe.name]
            yourRecipes.addObject(recipeDict)
        }
        */
        return allYourRecipes
    }

    func userDidSelectRecipe(recipeSelected:Recipe){
        println("----userDidSelectRecipe----")
        recipeOfInterest = recipeSelected
    }
    
    //MARK: recipeDetail
    func recipeForRecipeDetail(recipeDetail:P8RecipeDetailTableViewController)->Recipe{
        println("----recipeForRecipeEditor----")
        checkCurrentRecipe()
        return recipeOfInterest!

    }

    //MARK: recipeEditor
    //addNewRecipe is a hack to make the flow work right now
    func addNewRecipe(){
        self.recipeOfInterest = nil
    }
    
    func recipeForRecipeEditor(recipeEditor:P8RecipeEditorViewController)->Recipe{
        println("----recipeForRecipeEditor----")
        checkCurrentRecipe()
        if recipeOfInterest != nil{
            if recipeOfInterest!.name != "Recipe Name"{
            }
        }else{
            self.recipeOfInterest = self.newRecipe()
            self.recipeOfInterest!.name = "Recipe Name"
        }
        //self.currentEditingRecipe = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: globalMOC) as Recipe
        /*
        var temp = NSEntityDescription.insertNewObjectForEntityForName("Recipe", inManagedObjectContext: globalMOC) as Recipe
        let entity =  NSEntityDescription.entityForName("Recipe",inManagedObjectContext:globalMOC)
        let NSMO = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:globalMOC) as Recipe
        NSMO.name = "test"
        println(NSMO.name)
        */
        checkCurrentRecipe()
        return self.recipeOfInterest!
        /*
        let recipeOfInterest = self.newRecipe()
        self.currentEditingRecipe = recipeOfInterest
        return recipeOfInterest
        */
    }
    
    func recipeEditorDidUpdateRecipe(recipeEditor:P8RecipeEditorViewController,recipe:Recipe)->Bool{
        println("----recipeEditorDidUpdateRecipe----")
        checkCurrentRecipe()
        //self.currentEditingRecipe = recipe
        //checkCurrentRecipe()
        return update()
    }
    
    func recipeEditorDeleteRecipe(recipeEditor:P8RecipeEditorViewController,recipe:Recipe)->Bool{
        return deleteRecipe(recipe)
    }
    

    //MARK: JLStepEditor
    //called when the view controller is getting set up
    func stepsArrayForStepEditor(stepEditor: JLStepEditorTableViewController!) -> [AnyObject]! {
        println("----stepsArrayForStepEditor----")
        var tempArray = NSArray()
        tempArray = recipeOfInterest!.step.array
        return tempArray

    }
    //called when a new step is added
    func newStepForEditor(stepEditor: JLStepEditorTableViewController!) -> Step! {
        println("----newStepForEditor----")
        checkCurrentRecipe()
        let anotherStep = newStep()
        anotherStep.recipe = self.recipeOfInterest!
        return anotherStep
    }
    
    //single edits to an individual step
    func stepEditor(stepEditor: JLStepEditorTableViewController!, didEditStep editedStep: Step!) {
        
    }
    
    //happens when a step is deleted
    func stepEditor(stepEditor: JLStepEditorTableViewController!, didDeleteStep editedStep: Step!) {

    }
    
    //called when step order is changed
    func stepEditor(stepEditor: JLStepEditorTableViewController!, didUpdateStepsArray stepsArray: [AnyObject]!) {
        println("----stepEditor didUpdateStepsArray----")
        self.recipeOfInterest?.step = NSOrderedSet(array:stepsArray)
        update()
        checkCurrentRecipe()
    }
    

    //MARK: JLIngredientEditor
    //called when ingredient editor is getting setup
    func ingredientsArrayForIngredientEditor(editor: JLIngredientEditorTableViewController!) -> [AnyObject]! {
        println("----ingredientsArrayForIngredientEditor----")
        checkCurrentRecipe()
        return self.recipeOfInterest?.ingredient.array as [Ingredient]
    }
    
    //called when new ingredient is created
    func newIngredientForIngredientEditor(editor: JLIngredientEditorTableViewController!) -> Ingredient! {
        println("----newIngredientForIngredientEditor----")
        checkCurrentRecipe()
        let anotherIngredient = newIngredient()
        anotherIngredient.recipe = self.recipeOfInterest!
        return anotherIngredient
    }
    
    //called when ingredient order changed
    func ingredientEditor(editor: JLIngredientEditorTableViewController!, didUpdateIngredientsArray ingredientsArray: [AnyObject]!) {
        println("----ingredientEditorDidUpdateIngredientsArray----")
        self.recipeOfInterest?.ingredient = NSOrderedSet(array:ingredientsArray)
        checkCurrentRecipe()
        update()
    }
    
    //called when ingredient is updated
    func ingredientEditor(editor: JLIngredientEditorTableViewController!, didUpdateIngredient editedIngredient: Ingredient!) {
        update()
    }
    
    //called when ingredient is deleted
    func ingredientEditor(editor: JLIngredientEditorTableViewController!, didDeleteIngredient deletedIngredient: Ingredient!) {
    }

    
    
    //MARK: getItems
    func newRecipe()->Recipe{
        let newRecipe = self.insertManagedObject(NSStringFromClass(Recipe),managedObjectContext:globalMOC) as Recipe
        newRecipe.id = NSUUID().UUIDString
        return newRecipe
    }
    
    func newIngredient()->Ingredient{
        let newIngredient = self.insertManagedObject(NSStringFromClass(Ingredient),managedObjectContext:globalMOC) as Ingredient
        newIngredient.id = NSUUID().UUIDString
        return newIngredient
    }
    
    func newStep()->Step{
        let newStep = self.insertManagedObject(NSStringFromClass(Step),managedObjectContext:globalMOC) as Step
        newStep.id = NSUUID().UUIDString
        return newStep
    }

    //MARK: deleteItems
    func deleteRecipe(recipe:Recipe)->Bool {
        globalMOC.deleteObject(recipe)
        return self.update()
    }
    func deleteIngredient(ingredient:Ingredient) {
        globalMOC.deleteObject(ingredient)
        self.update()
    }
    func deleteStep(step:Step) {
        globalMOC.deleteObject(step)
        self.update()
    }

    
    //MARK: CoreDataConnectivity

    func managedObjectContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        return managedObjectContext
    }
    
    func insertManagedObject(className:String, managedObjectContext:NSManagedObjectContext)->AnyObject{
        let entity =  NSEntityDescription.entityForName(className,inManagedObjectContext:globalMOC)
        let NSMO = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:globalMOC)
        //let entity = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectContext) as NSManagedObject
        return NSMO
    }
    
    func update()->Bool{
        //Consider saving using logic from AppDelegate
        var error: NSError?
        if !globalMOC.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }else{
            return true
        }
    }
    
    
    func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }else{
            return true
        }
    }

    
    //consider remove this in the future when all coredata stuff is fenced off.
    class func managedObjectContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        return managedObjectContext
    }
    
    class func insertManagedObject(className:String, managedObjectContext:NSManagedObjectContext)->AnyObject{
        //let entity = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)
        //let managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        let entity = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectContext) as NSManagedObject
        return entity
    }
    
    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }else{
            return true
        }
    }
    
    //MARK: Helper Classes
    func checkCurrentRecipe(){
        if self.P8CoreDataHelperDebugMode{
            if self.recipeOfInterest != nil{
                println("current EditingRecipe Is Still Here")
                println("Name:\(recipeOfInterest?.name)")
                if recipeOfInterest?.ingredient.count > 0{
                    println("Ingredient:")
                    for ingredient in recipeOfInterest!.ingredient.array{
                        println(ingredient.name)
                    }
                }else{
                    println("EditingRecipe has no ingredients")
                }
                if recipeOfInterest?.step.count > 0{
                    println("Step:")
                    for step in recipeOfInterest!.step.array{
                        let tempStep = step as Step
                        println(tempStep.stepText)
                    }
                }else{
                    println("EditingRecipe has no steps")
                }
                
            }else{
                println("current EditingRecipe Is nil")
            }
        }
    }
    
    
    //MARK: Debug Functions
    func getAllIngredients()->[Ingredient]{
        var allIngredients = [Ingredient]()
        let fetchIngredients = NSFetchRequest(entityName:"Ingredient")
        var error: NSError?
        let fetchedResults = globalMOC.executeFetchRequest(fetchIngredients, error: &error) as [Ingredient]?
        
        if let results = fetchedResults {
            allIngredients = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        return allIngredients
    }
    
    func getAllSteps()->[Step]{
        var allSteps = [Step]()
        let fetchSteps = NSFetchRequest(entityName:"Step")
        var error: NSError?
        let fetchedResults = globalMOC.executeFetchRequest(fetchSteps, error: &error) as [Step]?
        
        if let results = fetchedResults {
            allSteps = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        return allSteps
    }

    
    //MARK:Obsolete function
    func getAllRecipesArrayWithDictionary()->NSArray{
        
        var yourRecipes = [NSDictionary]()
        for recipe in getAllRecipes(){
            let singleRecipe:Recipe = recipe as Recipe
            let recipeDict:NSDictionary = ["id":"test","name":singleRecipe.name]
            yourRecipes.append(recipeDict)
            
        }
        return yourRecipes
    }

    //MARK: ingredientEditor
    /*
    func ingredientsArrayForIngredientEditor(ingredientEditor:P8IngredientEditorTableViewController)->[Ingredient]{
    println("----ingredientsArrayForIngredientEditor----")
    checkCurrentRecipe()
    self.recipeOfInterest?.ingredient
    //let ingredientsArray = [Ingredient]()
    //return ingredientsArray
    return self.recipeOfInterest?.ingredient.array as [Ingredient]
    }
    
    func newIngredientForIngredientEditor(ingredientEditor:P8IngredientEditorTableViewController)->Ingredient{
    println("----newIngredientsForIngredientEditor----")
    checkCurrentRecipe()
    println("you have \(ingredientEditor.ingredients.count) ingredients")
    let anotherIngredient = newIngredient()
    anotherIngredient.recipe = self.recipeOfInterest!
    return anotherIngredient
    }
    
    
    func ingredientsEditorDidUpdateIngredientsArray(ingredientEditor:P8IngredientEditorTableViewController,ingredientArray:[Ingredient]){
    println("----ingredientsEditorDidUpdateIngredientsArray----")
    self.recipeOfInterest?.ingredient = NSOrderedSet(array:ingredientArray)
    checkCurrentRecipe()
    update()
    }
    */

    func rollBack(){
        globalMOC.rollback()
    }
    
    func hasChanges()->Bool{
        var hasChanged = false
        if globalMOC.hasChanges{
            hasChanged = true
        }
        
        if hasChanged {
            println("**MOC HAS Changes**")
        }else{
            println("**MOC NO Changes**")
        }
        
        
        return hasChanged
    }
    
}
