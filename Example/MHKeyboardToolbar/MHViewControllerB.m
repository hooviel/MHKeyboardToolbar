//
//  MHViewControllerB.m
//  MHKeyboardToolbar_Example
//
//  Created by David on 2018/10/11.
//  Copyright © 2018 David. All rights reserved.
//

#import "MHViewControllerB.h"
#import <MHKeyboardToolbar/MHKeyboardToolbar.h>

@interface MHViewControllerB ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@end

@implementation MHViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _textField3.disableKeyboardToolbar = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MHKeyboardToolbar clearInputLink];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MHKeyboardToolbar setInputLink:@[_textField1, _textField2, _textField3, _textField4]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
