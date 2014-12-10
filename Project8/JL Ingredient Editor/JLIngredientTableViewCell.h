//
//  JLIngredientTableViewCell.h
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/6/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLIngredientTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *textEditButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)setupWithingredientText:(NSString *)ingredientText;

@end
