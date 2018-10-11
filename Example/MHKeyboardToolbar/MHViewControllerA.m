//
//  MHViewControllerA.m
//  MHKeyboardToolbar_Example
//
//  Created by David on 2018/10/11.
//  Copyright © 2018 David. All rights reserved.
//

#import "MHViewControllerA.h"
#import "MHKeyboardToolbar.h"

@interface MHViewControllerA ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@end

@implementation MHViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MHKeyboardToolbar clearInputLink];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MHKeyboardToolbar setInputLink:@[_textField1, _textField2]];
}

@end
