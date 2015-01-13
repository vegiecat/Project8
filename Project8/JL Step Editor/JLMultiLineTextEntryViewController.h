//
//  JLMultiLineTextEntryViewController.h
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/3/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLMultiLineTextEntryViewController;

@protocol JLMultiLineTextEntryViewControllerDelegate <NSObject>

- (void)multiLineTextEntryViewController:(JLMultiLineTextEntryViewController *)textEntryVC didFinishEnterText:(NSString *)enteredText;

@end



@interface JLMultiLineTextEntryViewController : UIViewController

- (void)setTitle:(NSString *)title initialText:(NSString *)initialText;

@property (nonatomic,weak) id <JLMultiLineTextEntryViewControllerDelegate> delegate;

#pragma mark - STORYBOARD
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
