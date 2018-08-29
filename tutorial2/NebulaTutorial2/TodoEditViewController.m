//
//  TodoEditViewController.m
//  NebulaTutorial2
//  Copyright (c) 2014年 NEC Corporation. All rights reserved.
//

#import "TodoEditViewController.h"
#import "TodoListViewController.h"

@implementation TodoEditViewController
{
    __weak IBOutlet UITextView *textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    textView.text = self.todoText;

    [textView becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.todoText = textView.text;
}

@end
