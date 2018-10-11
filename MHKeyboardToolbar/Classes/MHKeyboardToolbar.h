//
//  MHKeyboardToolbar.h
//  BigBTC
//
//  Created by David on 2018/8/16.
//  Copyright © 2018年 MoHu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHKeyboardToolbar : UIToolbar

+ (instancetype)shareKeyboardToolbar;
/**
 输入链表顺序，可以实现 键盘上的ReturnKey切换到下一个控件，已经工具栏上【上一项】【下一项】实现切换输入控件功能
 1、viewDidAppear 中设置 [MHKeyboardToolbar setInputLink];
 2、viewWillDisappear或viewDidDisappear 调用 [MHKeyboardToolbar clearInputLink] 清空 arrInputView
 */
@property (nonatomic, copy, readonly) NSArray<UIView<UITextInput> *> *arrInputLink;

@property (nonatomic, strong, readonly) UIBarButtonItem *bbiClear;
@property (nonatomic, strong, readonly) UIBarButtonItem *bbiPrev;
@property (nonatomic, strong, readonly) UIBarButtonItem *bbiNext;
@property (nonatomic, strong, readonly) UIBarButtonItem *bbiDone;

- (void)prevInputView;
- (void)nextInputView;

/**
 设置输入链
 [UIViewController viewDidAppear] 设置 [MHKeyboardToolbar setInputLink:@[...]];
 */
+ (void)setInputLink:(NSArray<UIView<UITextInput> *> *)inputLink;
/**
 清空输入链表
 [UIViewController viewWillDisappear]或[UIViewController viewDidDisappear] 调用 [MHKeyboardToolbar clearInputLink] 清空 arrInputView
 */
+ (void)clearInputLink;

@end

@interface UITextField (MHKeyboardToolbar)

/**
 是否不显示keyboardToolbar，默认NO，表示显示
 */
@property (nonatomic, assign) BOOL disableKeyboardToolbar;

@end

@interface UITextView (MHKeyboardToolbar)
/**
 是否不显示keyboardToolbar，默认NO，表示显示
 */
@property (nonatomic, assign) BOOL disableKeyboardToolbar;

@end

//@interface YYTextView (MHKeyboardToolbar)
///**
// 是否不显示keyboardToolbar，默认NO，表示显示
// */
//@property (nonatomic, assign) BOOL disableKeyboardToolbar;
//
//@end
