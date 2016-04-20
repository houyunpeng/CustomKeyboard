//
//  CustomKeyboard.m
//  CustomKeyboard
//
//  Created by 侯云鹏 on 16/4/18.
//  Copyright © 2016年 侯云鹏. All rights reserved.
//

#import "CustomKeyboard.h"

#define BLANKKEY @"BLANKKEY"
#define CANCELKEY @"CANCELKEY"
#define DELETEKEY @"DELETEKEY"


#define keyboardHeight 240
#define keyboardWidth [UIScreen mainScreen].bounds.size.width

@interface CustomKeyboard()

@end
@implementation CustomKeyboard

-(instancetype)initKeyboard:(InputCharactor)callBack
{
    self.callBack = callBack;
    
    return [self initKeyboard];
}

-(instancetype)initKeyboard
{
    self = [super init];
    if (self) {
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        self.bounds = CGRectMake(0, 0, bounds.size.width, keyboardHeight);
        self.center = CGPointMake(bounds.size.width/2, bounds.size.height - keyboardHeight/2);
        self.backgroundColor = [UIColor whiteColor];
        
        [self initNumKeyboard];
        
    }
    return self;
}

-(void)initNumKeyboard
{
    CGFloat cellWidth = keyboardWidth/3.0;
    CGFloat cellHeight = keyboardHeight/4.0;
    NSMutableArray* numStrs = [self insertBlankKey:[self randomNumsArr:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]]];
    [numStrs addObject:DELETEKEY];
    for (int i = 0; i<numStrs.count; i++) {
        NSString* c = numStrs[i];
        if ([c isEqualToString:BLANKKEY]) {
            
            continue;

        }
        
        
        
        KeyButton* keyBtn = [KeyButton buttonWithType:UIButtonTypeSystem];
        [keyBtn setTintColor:[UIColor blackColor]];
        keyBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        keyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [keyBtn setTitle:c forState:UIControlStateNormal];
        keyBtn.frame = CGRectMake(cellWidth*(i%3), cellHeight*(i/3), cellWidth, cellHeight);
        [keyBtn addTarget:self action:@selector(keyActions:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyBtn];
        keyBtn.type = KeyTypeNum;
        keyBtn.value = c;
        if ([c isEqualToString:DELETEKEY]) {
            [keyBtn setTitle:@"del" forState:UIControlStateNormal];
            keyBtn.type = KeyTypeDelete;
            keyBtn.value = @"";
        }
        
    }
    
    
}

-(void)initLetterKeyboard
{
    
}


-(void)keyActions:(KeyButton*)keyBtn
{
    if (self.callBack) {
        self.callBack(keyBtn.value);
    }
//    NSLog(@"touch value %@",keyBtn.value);
    
    
    NSInteger location = [_textField offsetFromPosition:_textField.beginningOfDocument toPosition:_textField.selectedTextRange.start];
    NSInteger length = [_textField offsetFromPosition:_textField.selectedTextRange.start toPosition:_textField.selectedTextRange.end];
    NSRange currentRange = NSMakeRange(location, length);
     NSLog(@"location= %ld  length= %ld",(long)location,(long)length);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField: shouldChangeCharactersInRange: replacementString:)]) {
        BOOL b = [self.delegate textField:_textField shouldChangeCharactersInRange:currentRange replacementString:keyBtn.value];
        if (b) {
            switch (keyBtn.type) {
                case KeyTypeLetter:
                case KeyTypeNum:
                {
                    NSMutableString* text = [NSMutableString stringWithString:_textField.text];
                    [text insertString:keyBtn.value atIndex:currentRange.location];
                    _textField.text = text;
                    
                    UITextPosition* beginning = _textField.beginningOfDocument;
                    
                    UITextPosition* startPosition = [_textField positionFromPosition:beginning offset:currentRange.location + currentRange.length + keyBtn.value.length];
                    UITextPosition* endPosition = [_textField positionFromPosition:beginning offset:currentRange.location + currentRange.length + keyBtn.value.length];
                    UITextRange* selectionRange = [_textField textRangeFromPosition:startPosition toPosition:endPosition];
                    
                    
                    
                    [_textField setSelectedTextRange:selectionRange];
                }
                    break;
                case KeyTypeDelete:
                {
                    if (currentRange.location == 0) {
                        return;
                    }
                    NSMutableString* text = [NSMutableString stringWithString:_textField.text];
                    [text replaceCharactersInRange:NSMakeRange(currentRange.location - 1, 1) withString:@""];
                    _textField.text = text;
                    UITextPosition* beginning = _textField.beginningOfDocument;
                    
                    UITextPosition* startPosition = [_textField positionFromPosition:beginning offset:currentRange.location - 1];
                    UITextPosition* endPosition = [_textField positionFromPosition:beginning offset:currentRange.location - 1];
                    UITextRange* selectionRange = [_textField textRangeFromPosition:startPosition toPosition:endPosition];
                    
                    
                    
                    [_textField setSelectedTextRange:selectionRange];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    
}
-(NSArray*)randomNumsArr:(NSArray*)tempArr
{
    NSMutableArray* nums = [NSMutableArray arrayWithArray:tempArr];
    NSMutableArray* resultNums = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger indexCount = nums.count;
    for (int i = 0;i<indexCount;i++) {
        NSInteger count = nums.count;
        NSInteger index = arc4random()%count;
        [resultNums addObject:nums[index]];
        [nums removeObjectAtIndex:index];
    }
    return resultNums;
    
}
-(NSMutableArray*)insertBlankKey:(NSArray*)arr
{
    NSMutableArray* resultNums = [NSMutableArray arrayWithArray:arr];
    [resultNums insertObject:BLANKKEY atIndex:resultNums.count-1];
    return resultNums;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
