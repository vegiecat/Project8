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
    //show our image picker
}


#pragma mark - Picker delegates
- (void)didFinish {
    
    //receive a array of alassets
    NSArray *assets;
    
    [self convertALAssetsToSteps:assets];
    
}

#pragma mark -

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

#warning may have to auto release to release our image immediately


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
