//
//  JLImagePickerViewController.m
//  Project8
//
//  Created by Justin Lee on 1/12/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

#import "JLImagePickerViewController.h"
#import "UIImage+JLUtilities.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kJLImagePickerImageWidth 320.0


@interface JLImagePickerViewController ()

@end

@implementation JLImagePickerViewController

#pragma mark - Methods called on subclass when image is picked

- (void) didFinishPickingImage:(UIImage *)pickedImage {
    NSLog(@"JLImagePickerVC - didFinishPickingImage: / override this method!!!");
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

        //PASS THE IMAGE TO THE SUBCLASS
        NSData *scaledDownData = [UIImage imageDataFromImage:imageToSave scaledToSize:CGSizeMake(kJLImagePickerImageWidth,kJLImagePickerImageWidth)];
        
        UIImage *scaledImage = [UIImage imageWithData:scaledDownData];

        if (scaledImage) {
            [self didFinishPickingImage:scaledImage];
        } else {
            NSLog(@"JLImagePickerVC - error when passing image to subclass");
        }
        
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


#pragma mark - VC LIFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
