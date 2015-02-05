//
//  P8RecipeDetailViewController.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/9/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

class P8RecipeDetailViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet var recipeCoverPhoto: UIImageView!
    
    @IBOutlet var stepsTable: UITableView!
    
    var recipe:Recipe?
    var ingredients:[Ingredient]?
    var steps:[Step]?
    var dataSource:P8CoreDataHelper?

    //Temp solution
    let fbHelper = FBHelper()

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
            self.steps = self.recipe?.step.array as [Step]?
        }
        
        
        let coverPhotoData:NSData = self.recipe!.coverPhoto
        let coverPhoto:UIImage? = UIImage(data: coverPhotoData)?
        self.recipeCoverPhoto.image = coverPhoto
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = self.steps!.count
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        let recipe:Recipe = self.recipe!
        

            
            var stepCell = tableView.dequeueReusableCellWithIdentifier("RecipeDetailStepCellTemp", forIndexPath: indexPath) as P8RecipeDetailStepCell
            stepCell.stepTextTemp.text = self.steps![indexPath.row].stepText
            //stepCell.stepCountTemp.text = String(indexPath.row+1)
            
            
            stepCell.stepImageTemp.image = UIImage(data: steps![indexPath.row].stepImage)
            cell=stepCell
            //manually setting the row height, should be a smarter way
            self.stepsTable.rowHeight = 420
            

        
        return cell
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "embedRecipeDetailTable" {
            
            let recipeTableViewController = segue.destinationViewController as P8RecipeDetailTableViewController
            recipeTableViewController.imFrom = "I came from Recipe Detail Page"
            recipeTableViewController.dataSource = self.dataSource
        }
        
    }

    
}

/*
class P8RecipeDetailViewController: UIViewController {
    
    var recipe:Recipe?
    var dataSource:P8CoreDataHelper?
    //for testing segue
    var imFrom:String = "I don't know where I'm from."

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //for testing segue
        println(self.imFrom)
        self.imFrom = "I don't know where I'm from."
        //Load the Recipe of Interest from the DataSource
        if dataSource != nil {
            self.recipe = dataSource!.recipeForRecipeEditor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
*/