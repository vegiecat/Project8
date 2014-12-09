//
//  JLStepTableViewCell.m
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/2/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import "JLStepTableViewCell.h"

@interface JLStepTableViewCell () {}



@end

@implementation JLStepTableViewCell

- (void)setupWithImage:(UIImage *)stepImage text:(NSString *)stepText {
    [self.stepImageButton setImage:stepImage forState:UIControlStateNormal];
    self.stepTextView.text = stepText;
    
}

- (void)awakeFromNib {
    
    self.stepImageButton.layer.cornerRadius = 10;
    self.stepImageButton.clipsToBounds = YES;
    
    self.stepImageButton.backgroundColor = [UIColor grayColor];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
