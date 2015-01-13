//
//  UIImage+JLUtilities.h
//  Project8
//
//  Created by Justin Lee on 12/10/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JLUtilities)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

+ (NSData *)imageDataFromImage:(UIImage *)image scaledToSize:(CGSize)size;


@end
