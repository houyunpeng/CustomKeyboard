//
//  KeyButton.h
//  CustomKeyboard
//
//  Created by 侯云鹏 on 16/4/20.
//  Copyright © 2016年 侯云鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum {
    KeyTypeNum = 0,//数字
    KeyTypeLetter,//字母
    KeyTypeCancel,//取消
    KeyTypeDone,//完成
    KeyTypeBlankKey,//空格
    KeyTypeSymbol,//符号
    KeyTypeDelete,//删除
    KeyTypeHidden,//隐藏键盘
    KeyTypeCaptain,//大写键
    
}KeyType;
@interface KeyButton : UIButton
@property (nonatomic, strong)NSString* value;
@property (nonatomic, assign)KeyType type;
@end
