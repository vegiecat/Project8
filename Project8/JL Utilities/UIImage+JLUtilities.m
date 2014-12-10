//
//  UIImage+JLUtilities.m
//  Project8
//
//  Created by Justin Lee on 12/10/14.
//  Copyright (c) 2014 Vegiecat Studio. All rights reserved.
//

#import "UIImage+JLUtilities.h"

@implementation UIImage (JLUtilities)

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSData *)imageDataFromImage:(UIImage *)image scaledToSize:(CGSize)size {
    
    UIImage *scaledDown = [UIImage imageWithImage:image scaledToSize:CGSizeMake(320.0, 320.0)];
    NSData *imgData = UIImagePNGRepresentation(scaledDown);
    
    return imgData;
}


@end
