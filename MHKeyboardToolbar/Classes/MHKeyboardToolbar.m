//
//  MHKeyboardToolbar.m
//  BigBTC
//
//  Created by David on 2018/8/16.
//  Copyright © 2018年 MoHu Inc. All rights reserved.
//

#import "MHKeyboardToolbar.h"
#import <objc/runtime.h>

static MHKeyboardToolbar *_keyboardToolbar;

@interface MHKeyboardToolbar ()

@property (nonatomic, strong) UIView<UITextInput> *inputView;
@property (nonatomic, assign) BOOL hasBar;

@end

@interface UITextView (MHKeyboardToolbarActive)

@property (nonatomic, assign) BOOL isKeyboardToolbarActive;

@end

//@interface YYTextView (MHKeyboardToolbarActive)
//
//@property (nonatomic, assign) BOOL isKeyboardToolbarActive;
//
//@end

@implementation UITextField (MHKeyboardToolbar)

- (void)setDisableKeyboardToolbar:(BOOL)disableKeyboardToolbar {
    [self willChangeValueForKey:@"disableKeyboardToolbar"];
    NSValue *value = [NSValue value:&disableKeyboardToolbar withObjCType:@encode(BOOL)];
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"disableKeyboardToolbar"];
}

- (BOOL)disableKeyboardToolbar {
    BOOL cValue = NO;
    NSValue *value = objc_getAssociatedObject(self, @selector(setDisableKeyboardToolbar:));
    [value getValue:&cValue];
    return cValue;
}

@end

@implementation UITextView (MHKeyboardToolbar)

- (void)setDisableKeyboardToolbar:(BOOL)disableKeyboardToolbar {
    [self willChangeValueForKey:@"disableKeyboardToolbar"];
    NSValue *value = [NSValue value:&disableKeyboardToolbar withObjCType:@encode(BOOL)];
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"disableKeyboardToolbar"];
}

- (BOOL)disableKeyboardToolbar {
    BOOL cValue = NO;
    NSValue *value = objc_getAssociatedObject(self, @selector(setDisableKeyboardToolbar:));
    [value getValue:&cValue];
    return cValue;
}

@end

//@implementation YYTextView (MHKeyboardToolbar)
//
//- (void)setDisableKeyboardToolbar:(BOOL)disableKeyboardToolbar {
//    [self willChangeValueForKey:@"disableKeyboardToolbar"];
//    NSValue *value = [NSValue value:&disableKeyboardToolbar withObjCType:@encode(BOOL)];
//    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN);
//    [self didChangeValueForKey:@"disableKeyboardToolbar"];
//}
//
//- (BOOL)disableKeyboardToolbar {
//    BOOL cValue = NO;
//    NSValue *value = objc_getAssociatedObject(self, @selector(setDisableKeyboardToolbar:));
//    [value getValue:&cValue];
//    return cValue;
//}
//
//@end

@implementation UITextView (MHKeyboardToolbarActive)

- (void)setIsKeyboardToolbarActive:(BOOL)isKeyboardToolbarActive {
    [self willChangeValueForKey:@"isKeyboardToolbarActive"];
    NSValue *value = [NSValue value:&isKeyboardToolbarActive withObjCType:@encode(BOOL)];
    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"isKeyboardToolbarActive"];
}

- (BOOL)isKeyboardToolbarActive {
    BOOL cValue = NO;
    NSValue *value = objc_getAssociatedObject(self, @selector(setIsKeyboardToolbarActive:));
    [value getValue:&cValue];
    return cValue;
}

@end

//@implementation YYTextView (MHKeyboardToolbarActive)
//
//- (void)setIsKeyboardToolbarActive:(BOOL)isKeyboardToolbarActive {
//    [self willChangeValueForKey:@"isKeyboardToolbarActive"];
//    NSValue *value = [NSValue value:&isKeyboardToolbarActive withObjCType:@encode(BOOL)];
//    objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN);
//    [self didChangeValueForKey:@"isKeyboardToolbarActive"];
//}
//
//- (BOOL)isKeyboardToolbarActive {
//    BOOL cValue = NO;
//    NSValue *value = objc_getAssociatedObject(self, @selector(setIsKeyboardToolbarActive:));
//    [value getValue:&cValue];
//    return cValue;
//}
//
//@end

@implementation MHKeyboardToolbar

+ (void)load {
    [MHKeyboardToolbar shareKeyboardToolbar];
}

+ (instancetype)shareKeyboardToolbar {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _keyboardToolbar = [MHKeyboardToolbar new];
    });
    return _keyboardToolbar;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _keyboardToolbar = [super allocWithZone:zone];
    });
    return _keyboardToolbar;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _keyboardToolbar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44)];
    if (self) {
        _bbiClear = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStyleDone target:self action:@selector(clearText)];
        _bbiPrev = [[UIBarButtonItem alloc] initWithTitle:@"上一项" style:UIBarButtonItemStyleDone target:self action:@selector(prevInputView)];
        _bbiNext = [[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleDone target:self action:@selector(nextInputView)];
        _bbiDone = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(onTouchDone)];
        self.items = @[_bbiClear,
                       [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       _bbiPrev,
                       _bbiNext,
                       _bbiDone];
        
        
        [self addNotification];
    }
    return self;
}

- (void)_setArrInputLink:(NSArray<UIView<UITextInput> *> *)arrInputLink {
    _arrInputLink = arrInputLink.copy;
}

- (void)updateControlsState {
    _bbiClear.enabled = [[_inputView valueForKeyPath:@"text"] length];
    if (_arrInputLink.count) {
        NSInteger currIndex = [_arrInputLink indexOfObjectIdenticalTo:_inputView];
        _bbiPrev.enabled = currIndex>0;
        _bbiNext.enabled = currIndex<_arrInputLink.count-1;
    }
    else {
        _bbiPrev.enabled = NO;
        _bbiNext.enabled = NO;
    }
}

- (void)prevInputView {
    if (_arrInputLink.count==0) return;
    NSInteger currIndex = [_arrInputLink indexOfObjectIdenticalTo:_inputView];
    if (currIndex>0) {
        [_arrInputLink[currIndex-1] becomeFirstResponder];
    }
}

- (void)nextInputView {
    if (_arrInputLink.count==0) return;
    NSInteger currIndex = [_arrInputLink indexOfObjectIdenticalTo:_inputView];
    if (currIndex<_arrInputLink.count-1) {
        [_arrInputLink[currIndex+1] becomeFirstResponder];
    }
}

/**
 设置输入链
 */
+ (void)setInputLink:(NSArray<UIView<UITextInput> *> *)inputLink {
    [MHKeyboardToolbar.shareKeyboardToolbar _setArrInputLink:inputLink];
    [MHKeyboardToolbar.shareKeyboardToolbar updateControlsState];
}

/**
 清空响应链表
 */
+ (void)clearInputLink {
    [MHKeyboardToolbar.shareKeyboardToolbar _setArrInputLink:nil];
}

- (void)onTouchDone {
    [self.inputView endEditing:YES];
}

- (void)clearText {
    [_inputView setValue:nil forKeyPath:@"text"];
    _bbiClear.enabled = NO;
    NSString *notif = UITextFieldTextDidChangeNotification;
    if ([_inputView isKindOfClass:[UITextField class]]) {
        notif = UITextFieldTextDidChangeNotification;
    }
    else if ([_inputView isKindOfClass:[UITextView class]]) {
        notif = UITextViewTextDidChangeNotification;
    }
//    else if ([_inputView isKindOfClass:[YYTextView class]]) {
//        notif = YYTextViewTextDidChangeNotification;
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:notif object:_inputView];
}

- (void)addNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textViewTextDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(yyTextViewTextDidBeginEditingNotification:) name:@"YYTextViewTextDidBeginEditing" object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(yyTextViewTextDidChangeNotification:) name:@"YYTextViewTextDidChange" object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textFieldTextDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textViewTextDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(yyTextViewTextDidEndEditingNotification:) name:@"YYTextViewTextDidEndEditing" object:nil];
}

- (void)removeNotification {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - DidBeginEditing
- (void)textFieldTextDidBeginEditingNotification:(NSNotification *)notification {
    UITextField *inputView = notification.object;
    if (!inputView.disableKeyboardToolbar) {
        inputView.inputAccessoryView = self;
        self.inputView = inputView;
        // UITextFieldDidBeginEditing —> UIKeyboardWillShow
        
        [self updateControlsState];
    }
}

- (void)textViewTextDidBeginEditingNotification:(NSNotification *)notification {
    UITextView *inputView = notification.object;
    if (!inputView.disableKeyboardToolbar) {
        inputView.inputAccessoryView = self;
        self.inputView = inputView;
        if (!inputView.isKeyboardToolbarActive) {
            inputView.isKeyboardToolbarActive = YES;
            // 为什么要这样？因为 UIKeyboardWillShow —> UITextFieldDidBeginEditing
            [inputView resignFirstResponder];
            [inputView becomeFirstResponder];
        }
        
        [self updateControlsState];
    }
}

- (void)yyTextViewTextDidBeginEditingNotification:(NSNotification *)notification {
    UITextView *inputView = notification.object;// 其实是YYTextView
    if (!inputView.disableKeyboardToolbar) {
        inputView.inputAccessoryView = self;
        self.inputView = inputView;
        if (!inputView.isKeyboardToolbarActive) {
            inputView.isKeyboardToolbarActive = YES;
            // 为什么要这样？因为 UIKeyboardWillShow —> UITextFieldDidBeginEditing
            [inputView resignFirstResponder];
            [inputView becomeFirstResponder];
        }
        
        [self updateControlsState];
    }
}

#pragma mark - TextDidChange
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification {
    self.bbiClear.enabled = [(NSString *)[notification.object valueForKeyPath:@"text"] length];
}

- (void)textViewTextDidChangeNotification:(NSNotification *)notification {
    self.bbiClear.enabled = [(NSString *)[notification.object valueForKeyPath:@"text"] length];
}

- (void)yyTextViewTextDidChangeNotification:(NSNotification *)notification {
    self.bbiClear.enabled = [(NSString *)[notification.object valueForKeyPath:@"text"] length];
}

#pragma mark - DidEndEditing
- (void)textFieldTextDidEndEditingNotification:(NSNotification *)notification {
    self.inputView = nil;
}

- (void)textViewTextDidEndEditingNotification:(NSNotification *)notification {
    self.inputView = nil;
}

- (void)yyTextViewTextDidEndEditingNotification:(NSNotification *)notification {
    self.inputView = nil;
}

@end
