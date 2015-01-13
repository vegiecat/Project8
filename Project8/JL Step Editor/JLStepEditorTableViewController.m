//
//  JLStepEditorTableViewController.m
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/2/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import "JLStepEditorTableViewController.h"
#import "JLStepTableViewCell.h"

#import "Project8-Swift.h"

#import "JLMultiLineTextEntryViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "UIImage+JLUtilities.h"


#define kSegueIDStepTextEntry @"showStepTextEntry"
#define kStepImageWidth 320

//cell will be populated with this if text data is blank
#define kPlaceHolderStepText @"Tap here to enter instructions for this step."


@interface JLStepEditorTableViewController () <JLMultiLineTextEntryViewControllerDelegate> {
    NSIndexPath *_selectedIndexPath;
    BOOL _isEditMode;

}

- (IBAction)addStepButtonPressed:(id)sender;

@property (nonatomic,strong) NSMutableArray *steps;

@end

@implementation JLStepEditorTableViewController

- (IBAction)addStepButtonPressed:(id)sender {
    
    //add new step to model
    Step *step1 = [self.datasource newStepForEditor:self];
    if (step1) {
        step1.stepText = @"";
        [self.steps addObject:step1];
        
        //if we want to add first row [self.steps insertObject:step1 atIndex:0];
        //NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        
        //add new row to table
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.steps.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}



#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load, %@",self.imFrom);
    [self.navigationItem setTitle:@"Steps"];
    
    //set up mutabale array of steps
    self.steps = [[NSMutableArray alloc] initWithCapacity:10];
    
    //ask datasource for steps
    NSArray *datasourceSteps = [self.datasource stepsArrayForStepEditor:self];
    if (datasourceSteps != nil) [self.steps addObjectsFromArray:datasourceSteps];
   
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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    return self.steps.count;
}

#define kStepCellID @"StepCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //GET THE CELL
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStepCellID forIndexPath:indexPath];
    JLStepTableViewCell *stepCell = (JLStepTableViewCell *)cell;

    //GET THE DATA OBJECT
    Step *aStep = self.steps[indexPath.row];
    
    //PREP THE STEP TEXT
    NSString *stepText = kPlaceHolderStepText;
    if ((aStep.stepText != nil) && ![aStep.stepText isEqualToString:@""]) {
        stepText = aStep.stepText;
    }
    //PREP IMAGE
    UIImage *stepImage = nil;
    if (aStep.stepImage != nil) {
        UIImage *image = [UIImage imageWithData:aStep.stepImage];
        if (image) {
            stepImage = image;
        }
    }
    
    //MAP DATA OBJECT TO CELL
    [stepCell setupWithImage:stepImage text:stepText];

    //OTHER SETUP FOR THE CELL
    [stepCell.stepImageButton addTarget:self action:@selector(stepImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [stepCell.stepTextEditButton addTarget:self action:@selector(stepTextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Get the step to be deleted
        Step *deletedStep = self.steps[indexPath.row];
        
        //delete step from data source
        [self.datasource stepEditor:self didDeleteStep:deletedStep];
        
        //delete step from table VC data source
        [self.steps removeObjectAtIndex:indexPath.row];
        
        //Update table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
    
    /*
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } 
     */

}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.steps exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    [self updateDatasource];
}





/*
 
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Handling Cell Interaction

- (void)stepImageButtonTapped:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        _selectedIndexPath = indexPath;
        [self handleCameraAndPickerPresentation];
    }
}

- (void)stepTextButtonTapped:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        _selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:kSegueIDStepTextEntry sender:self];
    }

}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if ([segue.identifier isEqualToString:kSegueIDStepTextEntry]) {
         
         UINavigationController *navCon = (UINavigationController *)segue.destinationViewController;
         
        
         //GET THE DATA OBJ
         Step *aStep = self.steps[_selectedIndexPath.row];
         
         //PASS THE DATA TO VC
         JLMultiLineTextEntryViewController *textEntryVC = (JLMultiLineTextEntryViewController *)navCon.topViewController;
                  
         
         [textEntryVC setTitle:@"Step Instructions" initialText:aStep.stepText];
         textEntryVC.delegate = self;
         
     }
 }

#pragma mark - Multi-Line Entry VC Delegate

- (void)multiLineTextEntryViewController:(JLMultiLineTextEntryViewController *)textEntryVC didFinishEnterText:(NSString *)enteredText {

    if (!enteredText) return;
    
    //UPDATE THE MODEL
    Step *aStep = self.steps[_selectedIndexPath.row];
    aStep.stepText = enteredText;

    [self.datasource stepEditor:self didEditStep:aStep];

    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Camera

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:NULL];
    return YES;
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:NULL];

    return YES;
}

#pragma mark - Camera Delegate
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    NSLog(@"JLLog: Image Picker Cancelled");

    [self dismissViewControllerAnimated:YES completion:NULL];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSLog(@"picked");
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        /* code for saving the image to album
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
         */
        
        //UPDATE THE MODEL
        Step *aStep = self.steps[_selectedIndexPath.row];
        
        NSData *scaledDownData = [UIImage imageDataFromImage:imageToSave scaledToSize:CGSizeMake(kStepImageWidth,kStepImageWidth)];
        
        if (scaledDownData) {
            aStep.stepImage = scaledDownData;
        }
        
        [self.datasource stepEditor:self didEditStep:aStep];
        
        [self.tableView reloadData];
        [[self parentViewController] dismissViewControllerAnimated:YES completion:NULL];
        
    } else {
        [[self parentViewController] dismissViewControllerAnimated:YES completion:NULL];

    }
    
}

#pragma mark - Present Camera/Picker

- (void)handleCameraAndPickerPresentation {
    
    //if we have cam, then present action sheet so user can choose from camera and library
    //else launch them straight into library
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Let's Pick a Photo!"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Choose from photo library" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self startMediaBrowserFromViewController:self usingDelegate:self];
                                                              }];
        
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 [self startCameraControllerFromViewController:self usingDelegate:self];
                                                             }];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];

        [alert addAction:cameraAction];

    } else {
        [self startMediaBrowserFromViewController:self usingDelegate:self];
    }
    
    
}


#pragma mark - Helpers

- (void)updateDatasource {
    [self.datasource stepEditor:self didUpdateStepsArray:[self stepsAsArray]];
}

- (NSArray *)stepsAsArray {
    return [NSArray arrayWithArray:self.steps];
}



@end
