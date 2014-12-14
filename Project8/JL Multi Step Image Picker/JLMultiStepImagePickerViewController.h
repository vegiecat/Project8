//
//  JLMultiStepImagePickerViewController.h
//  Project8
//
//  Created by Justin Lee on 12/12/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

//NEEDED FOR MULTI-IMAGE PICKER
#import "ELCImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>


#import "UIImage+JLUtilities.h"

@class JLMultiStepImagePickerViewController;
@class Step;

@protocol JLMultiStepImagePickerViewControllerDatasource <NSObject>

//called when it needs a new step to assign a selected image
- (Step *)newStepForMultiStepImagePicker:(JLMultiStepImagePickerViewController *)picker;

//called when user has finished image selection; returns an array of steps each assigned with an image selected by user
- (void)multiStepImagePicker:(JLMultiStepImagePickerViewController *)picker didFinishCreatingSteps:(NSArray *)steps;



@end

@interface JLMultiStepImagePickerViewController : UIViewController <ELCImagePickerControllerDelegate>

@property (nonatomic,weak) id <JLMultiStepImagePickerViewControllerDatasource> pickerDatasource;

@end

