//
//  JLStepEditorTableViewController.h
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/2/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLStepEditorTableViewController;

@protocol JLStepEditorTableViewControllerDatasource <NSObject>

- (NSArray *)stepsArrayForStepEditor:(JLStepEditorTableViewController *)stepEditor;
- (void)stepEditor:(JLStepEditorTableViewController *)stepEditor didUpdateStepsArray:(NSArray *)stepsArray;

@end

@interface JLStepEditorTableViewController : UITableViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic,weak) id <JLStepEditorTableViewControllerDatasource> datasource;

@end
