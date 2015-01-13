//
//  TableViewController.swift
//  Project8
//
//  Created by Vegiecat Studio on 12/15/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

class P8DebugIngredientTableViewController: UITableViewController {

    let dataSource = P8CoreDataHelper()
    var allIngredients:NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        self.navigationController?.toolbarHidden = true
    }
    
    
    func loadData(){
        self.allIngredients = dataSource.getAllIngredients()
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
        return self.allIngredients.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DebugIngredientCell", forIndexPath: indexPath) as P8DebugIngredientTableViewCell
        let ingredient = self.allIngredients.objectAtIndex(indexPath.row) as Ingredient
        cell.name.text = ingredient.name
        cell.id.text = ingredient.id

        let recipeTemp:Recipe = ingredient.recipe
        if self.pointerToString(recipeTemp) == "0x0000000000000000"{
            cell.recipe.text = "NULL Pointer Dereference"
        }else{
            cell.recipe.text = ingredient.recipe.name
        }
        return cell
    }

    func pointerToString(objRef: AnyObject) -> String {
        let ptr: COpaquePointer =
        Unmanaged<AnyObject>.passUnretained(objRef).toOpaque()
        return "\(ptr)"
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let ingredientToBeDeleted = self.allIngredients[indexPath.row] as Ingredient
        
        
        var alert = UIAlertController(title: "Delete Ingredient",
            message: "Delete '\(ingredientToBeDeleted.name)' Perminately",
            preferredStyle: .Alert)
        
        let deleteAction = UIAlertAction(title: "Delete",
            style: .Default) { (action: UIAlertAction!) -> Void in
                self.dataSource.deleteIngredient(ingredientToBeDeleted)
                //let textField = alert.textFields![0] as UITextField
                //self.names.append(textField.text)
                self.loadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        //alert.addTextFieldWithConfigurationHandler {(textField: UITextField!) -> Void in}
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    
    }
    func deleteIndegridient(ingredient:Ingredient){
        self.dataSource.deleteIngredient(ingredient)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
