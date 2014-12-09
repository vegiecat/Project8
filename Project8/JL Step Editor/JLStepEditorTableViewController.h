//
//  JLStepEditorTableViewController.h
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/2/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JLStepEditorTableViewController;
@class Step;

@protocol JLStepEditorTableViewControllerDatasource <NSObject>

//called when the view controller is getting set up
- (NSArray *)stepsArrayForStepEditor:(JLStepEditorTableViewController *)stepEditor;

//called when a new step is added
- (Step *)newStepForEditor:(JLStepEditorTableViewController *)stepEditor;

//single edits to an individual step
- (void)stepEditor:(JLStepEditorTableViewController *)stepEditor didEditStep:(Step *)editedStep;

//happens when a step is deleted
- (void)stepEditor:(JLStepEditorTableViewController *)stepEditor didDeleteStep:(Step *)editedStep;

//called when step order is changed
- (void)stepEditor:(JLStepEditorTableViewController *)stepEditor didUpdateStepsArray:(NSArray *)stepsArray;


@end

@interface JLStepEditorTableViewController : UITableViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic,weak) id <JLStepEditorTableViewControllerDatasource> datasource;

@end
