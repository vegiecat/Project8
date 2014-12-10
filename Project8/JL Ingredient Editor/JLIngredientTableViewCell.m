//
//  JLIngredientTableViewCell.m
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/6/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import "JLIngredientTableViewCell.h"

@implementation JLIngredientTableViewCell

- (void)setupWithingredientText:(NSString *)ingredientText {
    self.textView.text = ingredientText;
}

@end
