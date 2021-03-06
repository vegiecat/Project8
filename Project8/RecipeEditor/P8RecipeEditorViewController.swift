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

class P8RecipeEditorViewController: JLImagePickerViewController,UITextFieldDelegate {
    
    @IBOutlet var recipeCoverPhoto: UIImageView!
    @IBOutlet var recipeName: UITextField!
    var recipe:Recipe?
    
    //TODO: Need to Refine the setting of dataSource and its protocol
    var dataSource:P8CoreDataHelper?
    
    //for testing segue
    var imFrom:String = "I don't know where I'm from."
    
    //MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up delegate of text field so we can dismiss keyboard when user taps done
        self.recipeName.delegate = self
        
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

    override func viewWillDisappear(animated: Bool) {
        
        /*
        if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
            // Navigation button was pressed. Do some stuff
            [self.navigationController popViewControllerAnimated:NO];
        }
        */
        
        
        //Detecting if backbutton is pressed, if yes, then rollback
        var VCs = self.navigationController?.viewControllers as[UIViewController]
        let selfInStackfound = find(VCs,self)
        if selfInStackfound == nil{
            println("backButtonPressed\(selfInStackfound)")
            self.dataSource?.hasChanges()
            self.dataSource?.rollBack()
        }else{
            println("otherButtonPressed\(selfInStackfound)")
        }
        
        println(self.recipeName.text)
        println(self.recipeCoverPhoto.image!)
        
        if self.recipeName.text == "" && self.recipeCoverPhoto == nil{
            println("Recipe not changed, delete it.")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Image Process
    func chooseRecipeCoverPhoto(recognizer:UITapGestureRecognizer){
        self.handleCameraAndPickerPresentation()
        
        /* OLD
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        */
    }
    
    func chooseImage(recognizer:UITapGestureRecognizer){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    override func didFinishPickingImage(pickedImage: UIImage!) {
        
        recipeCoverPhoto.image = pickedImage
        
    }
    
    /*
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
    */

    
    //MARK: Textfield Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    //Not Being Used Right Now
    @IBAction func multipleImagePicker(sender: AnyObject) {
        let multipleImagePickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("MultipleImagePicker") as UIViewController
        showViewController(multipleImagePickerVC, sender: sender)
    }
    
    @IBAction func addUpdateRecipe(sender: AnyObject) {
        
        self.recipe!.name = recipeName.text
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

    @IBAction func deleteRecipe(sender: AnyObject) {
        if dataSource != nil {
            self.dataSource!.recipeEditorDeleteRecipe(self, recipe:self.recipe!)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showIngredientEditor" {
            let editor = segue.destinationViewController as JLIngredientEditorTableViewController
            
            println(object_getClassName(editor))
            
            //temp.imFrom = "I came from Recipe Editor"
            
            editor.editorDatasource = self.dataSource
        }
        
        if segue.identifier == "showStepEditor" {
            let stepEditor = segue.destinationViewController as JLStepEditorTableViewController
            stepEditor.datasource = self.dataSource
            stepEditor.imFrom = "I came from Recipe Editor"

        }

        if segue.identifier == "showMultiImageSelector" {
            let multiImageSelector = segue.destinationViewController as JLMultiStepImagePickerViewController
            multiImageSelector.pickerDatasource = self.dataSource
            //multiImageSelector.imFrom = "I came from Recipe Editor"
            
        }
    }
}
