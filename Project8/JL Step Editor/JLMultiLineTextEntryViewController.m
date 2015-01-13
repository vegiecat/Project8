//
//  JLMultiLineTextEntryViewController.m
//  JLRecipeEditor
//
//  Created by Justin Lee on 12/3/14.
//  Copyright (c) 2014 Apperie. All rights reserved.
//

#import "JLMultiLineTextEntryViewController.h"

@interface JLMultiLineTextEntryViewController () {
    
    NSString *_initialText;
    NSString *_title;
}

@end

@implementation JLMultiLineTextEntryViewController

- (void)setTitle:(NSString *)title initialText:(NSString *)initialText {
    _initialText = initialText;
    _title = title;
}


- (void)didTapDoneButton:(id)sender {
    [self.textView resignFirstResponder];
    [self.delegate multiLineTextEntryViewController:self didFinishEnterText:self.textView.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(didTapDoneButton:)];
    
    [self.navigationItem setTitle:_title];
    
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
    self.textView.text = _initialText;
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

@end
