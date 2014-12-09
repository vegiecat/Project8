//
//  JLStepTableViewCell.h
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/2/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLStepTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *stepTextEditButton;
@property (weak, nonatomic) IBOutlet UITextView *stepTextView;
@property (weak, nonatomic) IBOutlet UIButton *stepImageButton;

- (void)setupWithImage:(UIImage *)stepImage text:(NSString *)stepText;


@end
