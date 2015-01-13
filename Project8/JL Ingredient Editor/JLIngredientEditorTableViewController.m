//
//  JLIngredientEditorTableViewController.m
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/6/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import "JLIngredientEditorTableViewController.h"
#import "JLIngredientTableViewCell.h"

#import "Project8-Swift.h"
#import "JLMultiLineTextEntryViewController.h"

#define kSegueIDIngredientTextEntry @"showIngredientTextEntry"
//cell will be populated with this if text data is blank
#define kPlaceHolderIngredientText @"Tap here to enter an ingredient."

@interface JLIngredientEditorTableViewController () <JLMultiLineTextEntryViewControllerDelegate> {
    NSIndexPath *_selectedIndexPath;
    BOOL _isEditMode;
}

@property (nonatomic,strong) NSMutableArray *ingredients;

@end

@implementation JLIngredientEditorTableViewController

- (IBAction)addIngredientButtonTapped:(id)sender {
    
    Ingredient *ingredient = [self.editorDatasource newIngredientForIngredientEditor:self];
    
    if (ingredient) {
        ingredient.name = @"";
        [self.ingredients addObject:ingredient];
        
        [self updateDatasource];
        
        //add new row to table
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.ingredients.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}



#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Ingredients"];
    
    //set up mutabale array of steps
    self.ingredients = [[NSMutableArray alloc] initWithCapacity:10];
    
    //ask datasource for steps
    NSArray *datasourceIngredients = [self.editorDatasource ingredientsArrayForIngredientEditor:self];
    
    if (datasourceIngredients != nil) [self.ingredients addObjectsFromArray:datasourceIngredients];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setEditing:YES];
    
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL];
    
    [self setToolbarItems:@[space,editButton]];
    
    self.tableView.editing = NO;
    
    
}

- (void)editButtonPressed:(id)sender {
    _isEditMode = !_isEditMode;
    
    [self.tableView setEditing:_isEditMode animated:YES];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self.tableView setEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ingredients.count;
}


#define kIngredientCellID @"IngredientCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //GET THE CELL
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIngredientCellID forIndexPath:indexPath];
    JLIngredientTableViewCell *ingredientCell = (JLIngredientTableViewCell *)cell;
    
    //GET THE DATA OBJECT
    Ingredient *anIngredient = self.ingredients[indexPath.row];
    
    //PREP THE TEXT
    NSString *ingredientText = kPlaceHolderIngredientText;
    if ((anIngredient.name != nil) && ![anIngredient.name isEqualToString:@""]) {
        ingredientText = anIngredient.name;
    }
    
    //MAP DATA OBJECT TO CELL
    [ingredientCell setupWithingredientText:ingredientText];
    
    //OTHER SETUP FOR THE CELL
    [ingredientCell.textEditButton addTarget:self action:@selector(ingredientTextEditButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //get the deleted object
        Ingredient *deleted = self.ingredients[indexPath.row];
        [self.editorDatasource ingredientEditor:self didDeleteIngredient:deleted];
        
        // Delete the row from the data source
        [self.ingredients removeObjectAtIndex:indexPath.row];
        
        //Update table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateDatasource];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.ingredients exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [self updateDatasource];
}




#pragma mark - Handling Cell Interaction

- (void)ingredientTextEditButtonTapped:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        _selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:kSegueIDIngredientTextEntry sender:self];
    }
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueIDIngredientTextEntry]) {
        
        UINavigationController *navCon = (UINavigationController *)segue.destinationViewController;
        
        //GET THE DATA OBJ
        Ingredient *anIngredient = self.ingredients[_selectedIndexPath.row];
        
        //PASS THE DATA TO VC
        JLMultiLineTextEntryViewController *textEntryVC = (JLMultiLineTextEntryViewController *)navCon.topViewController;
        
        [textEntryVC setTitle:@"Yummy Ingredients" initialText:anIngredient.name];
        textEntryVC.delegate = self;
    }
}

#pragma mark - Multi-Line Entry VC Delegate

- (void)multiLineTextEntryViewController:(JLMultiLineTextEntryViewController *)textEntryVC didFinishEnterText:(NSString *)enteredText {
    
    if (!enteredText) return;
    
    //UPDATE THE MODEL
    Ingredient *anIngredient = self.ingredients[_selectedIndexPath.row];
    anIngredient.name = enteredText;
    
    [self.editorDatasource ingredientEditor:self didUpdateIngredient:anIngredient];
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Helpers

- (void)updateDatasource {
    [self.editorDatasource ingredientEditor:self didUpdateIngredientsArray:[self ingredientsAsArray]];
}

- (NSArray *)ingredientsAsArray {
    return [NSArray arrayWithArray:self.ingredients];
}


@end
