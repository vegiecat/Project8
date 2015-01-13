//
//  P8IngredientTableViewController.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/7/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

protocol P8IngredientEditorDataSource {
    func ingredientsArrayForIngredientEditor(ingredientEditor:P8IngredientEditorTableViewController)->[Ingredient]
    func newIngredientForIngredientEditor(ingredientEditor:P8IngredientEditorTableViewController)->Ingredient
    func ingredientsEditorDidUpdateIngredientsArray(ingredientEditor:P8IngredientEditorTableViewController,ingredientArray:[Ingredient])
}


class P8IngredientEditorTableViewController: UITableViewController {


    var ingredients = [Ingredient]()
    var dataSource:P8IngredientEditorDataSource?
    //for testing segue
    var imFrom:String = "I don't know where I'm from."

    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* "Edit" button for left side of nav bar
        `UIViewController#editButtonItem` returns `UIBarButtonItem`
        that toggles the `UITableView` editing mode */
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //for testing segue
        println(self.imFrom)
        self.imFrom = "I don't know where I'm from."

        self.loadData()
        
        //temp manual setting dataSource
        //dataSource = P8CoreDataHelper()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadData(){
        if dataSource != nil{
            self.ingredients = dataSource!.ingredientsArrayForIngredientEditor(self)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                self.ingredients.removeAtIndex(indexPath.row)
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
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
        return ingredients.count
    }

    
    @IBAction func addIngredient(sender: AnyObject) {
        var alert = UIAlertController(title: "New Ingredient",
            message: "Add a new ingredient",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title:"Save",style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                self.saveIngredient(textField.text)
                self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)


    }

    func saveIngredient(ingredientContent:String){
        let newIngredient:Ingredient = dataSource!.newIngredientForIngredientEditor(self) as Ingredient
        newIngredient.name = ingredientContent
        
        ingredients.append(newIngredient)
        if dataSource != nil{
            dataSource!.ingredientsEditorDidUpdateIngredientsArray(self, ingredientArray: self.ingredients)
        }
        self.tableView.reloadData()


    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel!.text = ingredients[indexPath.row].name

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

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    

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
        
        //let recipeEditor = segue.destinationViewController as P8RecipeCreateViewController
        //stepEditor.dataSource = self.

        
    }

}
