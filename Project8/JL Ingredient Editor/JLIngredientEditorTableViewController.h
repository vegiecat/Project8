//
//  JLIngredientEditorTableViewController.h
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/6/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLIngredientEditorTableViewController;
@class Ingredient;

@protocol JLIngredientEditorTableViewControllerDatasource <NSObject>

//called when ingredient editor is getting setup
- (NSArray *)ingredientsArrayForIngredientEditor:(JLIngredientEditorTableViewController *)editor;

//called when new ingredient is created
- (Ingredient *)newIngredientForIngredientEditor:(JLIngredientEditorTableViewController *)editor;

//called when ingredient order changed
- (void)ingredientEditor:(JLIngredientEditorTableViewController *)editor didUpdateIngredientsArray:(NSArray *)ingredientsArray;

//called when ingredient is updated
- (void)ingredientEditor:(JLIngredientEditorTableViewController *)editor didUpdateIngredient:(Ingredient *)editedIngredient;

//called when ingredient is deleted
- (void)ingredientEditor:(JLIngredientEditorTableViewController *)editor didDeleteIngredient:(Ingredient *)deletedIngredient;


@end

@interface JLIngredientEditorTableViewController : UITableViewController


@property (nonatomic,weak) id <JLIngredientEditorTableViewControllerDatasource> editorDatasource;

@end
