//
//  CustomKeyboard.h
//  CustomKeyboard
//
//  Created by 侯云鹏 on 16/4/18.
//  Copyright © 2016年 侯云鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyButton.h"
typedef void (^InputCharactor)(NSString*inputStr);

@protocol CustomKeyboardDelegate <NSObject>
@optional
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
@interface CustomKeyboard : UIView
@property (nonatomic,copy)InputCharactor callBack;
@property (nonatomic, assign)UITextField* textField;
@property (nonatomic, assign)id delegate;

-(instancetype)initKeyboard:(InputCharactor)callBack;
-(instancetype)initKeyboard;
@end
