//
//  JLMultiStepImagePickerViewController.m
//  Project8
//
//  Created by Justin Lee on 12/12/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

#import "JLMultiStepImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h> 


#import "Project8-Swift.h"

@implementation JLMultiStepImagePickerViewController

#pragma mark - Presenting the picker
- (IBAction)didTapShowPickerButton:(id)sender {
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}


#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        //NSLog(@"dict: %@",dict);
        
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    
    [self convertImagesToSteps:images];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Picker delegates
- (void)didFinish {
    
    //receive a array of alassets
    NSArray *assets;
    
    [self convertALAssetsToSteps:assets];
    
}

#pragma mark -

- (void)convertImagesToSteps:(NSArray *)images {
    //containers
    NSMutableArray *stepsContainer = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    //loop through array
    //for each asset, convert it to image
    //and then use that image to create a step
    //add that to continer
    //after we're all done, pass an array of the new steps to our datasource
    for (UIImage *anImage in images) {
        if (anImage) {
            Step *newStep = [self createStepFromImage:anImage]; //if datasource not implemented, new step will be a nil
            if (newStep) {
                [stepsContainer addObject:anImage];
            }
        }
    }
    
    NSLog(@"steps container: %@",stepsContainer);
    
    //tell our datasource we're done, and we give them a new array of the steps created
    [self.pickerDatasource multiStepImagePicker:self didFinishCreatingSteps:[NSArray arrayWithArray:stepsContainer]];
}

- (void)convertALAssetsToSteps:(NSArray *)assets {
    
    //containers
    NSMutableArray *stepsContainer = [[NSMutableArray alloc] initWithCapacity:assets.count];
    UIImage *stepImage;
    
    //loop through array
    //for each asset, convert it to image
    //and then use that image to create a step
    //add that to continer
    //after we're all done, pass an array of the new steps to our datasource
    for (ALAsset *asset in assets) {
        stepImage = [self imagefromAsset:asset];
        if (stepImage) {
            Step *newStep = [self createStepFromImage:stepImage];
            [stepsContainer addObject:newStep];
        }
    }
    
    //tell our datasource we're done, and we give them a new array of the steps created
    [self.pickerDatasource multiStepImagePicker:self didFinishCreatingSteps:[NSArray arrayWithArray:stepsContainer]];
}





- (UIImage *)imagefromAsset:(ALAsset *)asset {
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
    CGImageRef imageRef = [assetRepresentation fullScreenImage];
    UIImage *anImage = [UIImage imageWithCGImage:imageRef];
    return anImage;
}

- (Step *)createStepFromImage:(UIImage *)image {
    
    //ask delegate for a new source
    Step *newStep = [self.pickerDatasource newStepForMultiStepImagePicker:self];

    if (newStep) {
        //take the image provided, scale it down to 320 by 320, convert it to data
        //asign it to our step
        NSData *imgData = [UIImage imageDataFromImage:image scaledToSize:CGSizeMake(320.0, 320.0)];
        newStep.stepImage = imgData;
    }
    
    return newStep;
}

@end
