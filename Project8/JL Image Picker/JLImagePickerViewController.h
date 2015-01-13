//
//  JLImagePickerViewController.h
//  Project8
//
//  Created by Justin Lee on 1/12/15.
//  Copyright (c) 2015 Vegiecat Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLImagePickerViewController : UIViewController

<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//OVERRIDE THIS
- (void) didFinishPickingImage:(UIImage *)pickedImage;

- (void)handleCameraAndPickerPresentation;



@end
