//
//  P8RecipeTableViewController.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/5/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

protocol P8RecipeSelectionDelegate {
    func userDidSelectRecipe()
    //func ingredientsArray()->[Ingredient]
    //func newIngredient()->Ingredient
    //func recipeEditorDidUpdateRecipe(recipeEditor:P8RecipeEditorViewController,recipe:Recipe)->Bool
}

class P8RecipeTableViewController: UITableViewController {

    var yourRecipes:NSArray = NSArray()
    let dataSource = P8CoreDataHelper()
    let delegate = P8RecipeDetailTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Regiester the cell to return the cell of the correct type.
        //tableView.registerClass(P8RecipeTableViewCell.self,forCellReuseIdentifier: "RecipeCell")

        //P8CoreDataHelper.getReci
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("viewAppeared")
        self.loadData()
    }

    func loadData(){
        self.yourRecipes = dataSource.getAllRecipes()
        self.tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return yourRecipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:P8RecipeTableViewCell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as P8RecipeTableViewCell
        let recipe:Recipe = yourRecipes.objectAtIndex(indexPath.row) as Recipe
        
        //let recipeDict:NSDictionary = yourRecipes.objectAtIndex(indexPath.row) as NSDictionary
        //let name = recipeDict.objectForKey("name") as String
        
        //cell.recipeCoverPhoto = nil
        cell.recipeName.text = recipe.name

        let recipeCoverPhotoData:NSData = recipe.coverPhoto
        let recipeCoverPhoto:UIImage? = UIImage(data: recipeCoverPhotoData)?
        
        var recipeCoverPhotoFrame:CGRect = cell.recipeCoverPhoto.frame
        recipeCoverPhotoFrame.size = CGSizeMake(75, 75)
        cell.recipeCoverPhoto.frame = recipeCoverPhotoFrame
        cell.recipeCoverPhoto.image = recipeCoverPhoto
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let recipeSelected = yourRecipes.objectAtIndex(indexPath.row) as Recipe
        println("i got selected \(recipeSelected.id)")
        
        dataSource.userDidSelectRecipe(recipeSelected)
        
        performSegueWithIdentifier("showRecipeDetail", sender: self)

        //self.navigationController!.popViewControllerAnimated(true)
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
        if segue.identifier == "toRecipeEditor" {
            let recipeCreateViewController = segue.destinationViewController as P8RecipeEditorViewController
            recipeCreateViewController.imFrom = "I came from Main Recipe Page"
            recipeCreateViewController.dataSource = self.dataSource
        } else if segue.identifier == "showRecipeDetail" {
            let recipeController = segue.destinationViewController as P8RecipeDetailTableViewController
            recipeController.imFrom = "I came from Main Recipe Page"
            recipeController.dataSource = self.dataSource
        }

    }
    
    
}
