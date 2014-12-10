//
//  P8RecipeDetailTableViewController.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/5/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

class P8RecipeDetailTableViewController: UITableViewController,P8RecipeSelectionDelegate {

    var recipe:Recipe?
    var ingredients:[Ingredient]?
    var dataSource:P8CoreDataHelper?
    //for testing segue
    var imFrom:String = "I don't know where I'm from."

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //for testing segue
        println(self.imFrom)
        self.imFrom = "I don't know where I'm from."
        //Load the Recipe of Interest from the DataSource
        if dataSource != nil {
            self.recipe = dataSource!.recipeForRecipeDetail(self)
            self.ingredients = self.recipe?.ingredient.array as [Ingredient]?
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func userDidSelectRecipe(){
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var numberOfRows = 0
        if section == 0{
            numberOfRows = 1
            println("This is Section#\(section)")
        }
        if section == 1{
            numberOfRows = self.ingredients!.count
            println("This is Section#\(section)")
        }

        
        return numberOfRows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        let recipe:Recipe = self.recipe!

        if indexPath.section == 0{
            let recipeCell:P8RecipeDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeDetailCell", forIndexPath: indexPath) as P8RecipeDetailTableViewCell
            
            
            let recipeCoverPhotoData:NSData = recipe.coverPhoto
            let recipeCoverPhoto:UIImage? = UIImage(data: recipeCoverPhotoData)?
            
            var recipeCoverPhotoFrame:CGRect = recipeCell.recipeCoverPhoto.frame
            recipeCoverPhotoFrame.size = CGSizeMake(75, 75)
            recipeCell.recipeCoverPhoto.frame = recipeCoverPhotoFrame
            recipeCell.recipeCoverPhoto.image = recipeCoverPhoto
            
            println(recipe.name)
            recipeCell.recipeName.text = recipe.name
            cell = recipeCell
            //manually setting the row height, should be a smarter way
            self.tableView.rowHeight = 311

        }
        if indexPath.section == 1{
            
            var ingredientCell = tableView.dequeueReusableCellWithIdentifier("IngredientDetailCell", forIndexPath: indexPath) as P8IngredientDetailTableViewCell
            
            let ingredients = self.ingredients
            let ingredientText = ingredients![indexPath.row].name
            
            ingredientCell.textLabel!.text = ingredientText
            
            cell=ingredientCell
            //manually setting the row height, should be a smarter way
            self.tableView.rowHeight = 50

        }
        
        
        /*
        var cell = tableView.dequeueReusableCellWithIdentifier("IngredientDetailCell", forIndexPath: indexPath) as UITableViewCell
        var counter1 = 1
        var counter0 = 1
        if indexPath.section == 1{
            println("section1")
            println(counter1++)
            cell.textLabel!.text = "test"
            return cell
            
        }else if indexPath.section == 0{
            let recipeCell:P8RecipeDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeDetailCell", forIndexPath: indexPath) as P8RecipeDetailTableViewCell
            
            let recipe:Recipe = self.recipe!
            println("section0")
            println(counter0++)

            println(recipe.name)
            recipeCell.recipeName.text = recipe.name
            /*
            let recipeCoverPhotoData:NSData = recipe.coverPhoto
            let recipeCoverPhoto:UIImage? = UIImage(data: recipeCoverPhotoData)?
            
            var recipeCoverPhotoFrame:CGRect = recipeCell.recipeCoverPhoto.frame
            recipeCoverPhotoFrame.size = CGSizeMake(75, 75)
            recipeCell.recipeCoverPhoto.frame = recipeCoverPhotoFrame
            recipeCell.recipeCoverPhoto.image = recipeCoverPhoto
            */
            return recipeCell
        }
        */

        return cell
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecipeEditor" {
            let recipeEditor = segue.destinationViewController as P8RecipeEditorViewController
            recipeEditor.imFrom = "I came from Recipe Detail"
            recipeEditor.dataSource = self.dataSource
        }
    }

}
