//
//  P8RecipeCreateViewController.swift
//  P8ManagedObject
//
//  Created by Vegiecat Studio on 12/5/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

import UIKit

protocol P8RecipeEditorDataSource {
    func recipeForRecipeEditor(recipeEditor:P8RecipeEditorViewController)->Recipe
    //func ingredientsArray()->[Ingredient]
    //func newIngredient()->Ingredient
    func recipeEditorDidUpdateRecipe(recipeEditor:P8RecipeEditorViewController,recipe:Recipe)->Bool
}

class P8RecipeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    
    @IBOutlet var recipeCoverPhoto: UIImageView!
    @IBOutlet var recipeName: UITextField!
    var recipe:Recipe?
    
    //TODO: Need to Refine the setting of dataSource and its protocol
    var dataSource:P8CoreDataHelper?
    
    //for testing segue
    var imFrom:String = "I don't know where I'm from."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for testing segue
        println(self.imFrom)
        self.imFrom = "I don't know where I'm from."
        

        //Load the Recipe of Interest from the DataSource
        
        if dataSource != nil {
            self.recipe = dataSource!.recipeForRecipeEditor(self)
        }
        
        //Set the image and name
        if recipe!.name != "Recipe Name"{
            self.recipeName.text = recipe!.name
            let recipeCoverPhotoData:NSData = recipe!.coverPhoto
            let recipeCoverPhoto:UIImage? = UIImage(data: recipeCoverPhotoData)?
            
            var recipeCoverPhotoFrame:CGRect = self.recipeCoverPhoto.frame
            recipeCoverPhotoFrame.size = CGSizeMake(75, 75)
            self.recipeCoverPhoto.frame = recipeCoverPhotoFrame
            self.recipeCoverPhoto.image = recipeCoverPhoto
        }
        
        
        // Do any additional setup after loading the view.
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "chooseRecipeCoverPhoto:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        recipeCoverPhoto.addGestureRecognizer(tapGestureRecognizer)
        recipeCoverPhoto.userInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Image Process
    func chooseRecipeCoverPhoto(recognizer:UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func chooseImage(recognizer:UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
        let pickedImage:UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        // small picture
        let smallPicture = scaleImageWith(pickedImage, newSize: CGSizeMake(100, 100))
        var sizeOfImageView:CGRect = recipeCoverPhoto.frame
        sizeOfImageView.size = smallPicture.size
        recipeCoverPhoto.frame = sizeOfImageView
        recipeCoverPhoto.image = smallPicture
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func scaleImageWith(image:UIImage, newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    
    @IBAction func addUpdateRecipe(sender: AnyObject) {
        
        self.recipe!.name = recipeName.text
        self.recipe!.id = NSUUID().UUIDString
        let recipeCoverPhotoData:NSData = UIImagePNGRepresentation(recipeCoverPhoto.image)
        self.recipe!.coverPhoto = recipeCoverPhotoData
        
        if dataSource != nil {
            self.dataSource!.recipeEditorDidUpdateRecipe(self, recipe:self.recipe!)
        }


        /* Fot testing isolated DataHelper
        self.dataSource!.recipeEditorDidUpdateRecipe(self, recipe:self.recipe!)
        */
        self.navigationController?.popViewControllerAnimated(true)

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showIngredientEditor" {
            let temp = segue.destinationViewController as P8IngredientEditorTableViewController
            println(object_getClassName(temp))
            temp.imFrom = "I came from Recipe Editor"
            temp.dataSource = self.dataSource
        }
        
        if segue.identifier == "showStepEditor" {
            let stepEditor = segue.destinationViewController as JLStepEditorTableViewController
            stepEditor.datasource = self.dataSource
            stepEditor.imFrom = "I came from Recipe Editor"

        }

        
        


    }


}
