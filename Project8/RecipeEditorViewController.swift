//
//  RecipeEditorViewController.swift
//  Project8
//
//  Created by Justin Lee on 12/1/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//  Test for Git

import UIKit

class RecipeEditorViewController: UIViewController,JLStepEditorTableViewControllerDatasource {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let foo = JLStepEditorTableViewController()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JLStepEditorTableViewControllerDatasource


    func stepEditor(stepEditor: JLStepEditorTableViewController!, didUpdateStepsArray stepsArray: [AnyObject]!) {
        
        println("update called by step editor")
    }
    
    func stepsArrayForStepEditor(stepEditor: JLStepEditorTableViewController!) -> [AnyObject]! {
        
        println("step editor asking for steps")

        
        let step1 = Step()
        step1.stepText = "hello"
        
        let steps : [Step] = [step1]
        
        return steps
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let stepEditor = segue.destinationViewController as JLStepEditorTableViewController
        stepEditor.datasource = self
        
        
    }

}
