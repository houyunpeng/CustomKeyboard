//
//  CustomKeyboard.m
//  CustomKeyboard
//
//  Created by 侯云鹏 on 16/4/18.
//  Copyright © 2016年 侯云鹏. All rights reserved.
//

#import "CustomKeyboard.h"
#import <objc/runtime.h>
#define BLANKKEY                @" "
#define CANCELKEY               @"CANCELKEY"
#define DELETEKEY               @"DELETEKEY"
#define DONEKEY                 @"DONEKEY"
#define TRANSTONUMKEYBOARD      @"TRANSTONUMKEYBOARD"
#define TRANSTOLETTERKEYBOARD   @"TRANSTOLETTERKEYBOARD"
#define TRANSFORLETTERCAPTAIN   @"TRANSFORLETTERCAPTAIN"
#define TRANSFORLETTERLOWERCASE   @"TRANSFORLETTERLOWERCASE"



#define keyboardHeight 200
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
        
        
        
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        return;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (self.keyboardType) {
        case UIKeyboardTypeDefault:
        {
            [self initASCIICapableKeyboardLowerKey];
        }
            break;
        case UIKeyboardTypeASCIICapable://字母全键盘
        {
            [self initASCIICapableKeyboardLowerKey];
        }
            break;
        case UIKeyboardTypeNumberPad:
        {
            [self initNumKeyboard];
        }
            break;
        
            
        default:
            break;
    }
    
    
}

-(void)initNumKeyboard
{
    self.keyboardType = UIKeyboardTypeNumberPad;
    CGFloat cellWidth = keyboardWidth/3.0;
    CGFloat cellHeight = keyboardHeight/4.0;
//    NSMutableArray* numStrs = [self insertBlankKey:[self randomNumsArr:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]]];
//    NSMutableArray* numStrs = [self insertBlankKey:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]];

    NSMutableArray* numStrs = [self insertKey:TRANSTOLETTERKEYBOARD toArr:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"] atIndex:9];
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
        if ([c isEqualToString:TRANSTOLETTERKEYBOARD]) {
            [keyBtn setTitle:@"ABC" forState:UIControlStateNormal];
            keyBtn.type = KeyTypeTransToLetter;
            keyBtn.value = TRANSTOLETTERKEYBOARD;
        }
        
    }
    
    
}
-(void)initASCIICapableKeyboardCaptialKey
{
    self.keyboardType = UIKeyboardTypeASCIICapable;
    NSDictionary* letterDic = @{@"1":@[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P"],
                                @"2":@[@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L"],
                                @"3":@[TRANSFORLETTERLOWERCASE,@"Z",@"X",@"C",@"V",@"B",@"N",@"M",DELETEKEY],
                                @"4":@[TRANSTONUMKEYBOARD,TRANSTOLETTERKEYBOARD,BLANKKEY,DONEKEY]};
    [self initASCIICapableKeyboardWithKeysDic:letterDic];
}
-(void)initASCIICapableKeyboardLowerKey
{

    self.keyboardType = UIKeyboardTypeASCIICapable;
    
    NSDictionary* letterDic = @{@"1":@[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p"],
                                @"2":@[@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l"],
                                @"3":@[TRANSFORLETTERCAPTAIN,@"z",@"x",@"c",@"v",@"b",@"n",@"m",DELETEKEY],
                                @"4":@[TRANSTONUMKEYBOARD,TRANSTOLETTERKEYBOARD,BLANKKEY,DONEKEY]};
    [self initASCIICapableKeyboardWithKeysDic:letterDic];
}
-(void)initASCIICapableKeyboardWithKeysDic:(NSDictionary*)letterDic{
    NSArray* lines = @[@"1",@"2",@"3",@"4"];
    CGFloat cellKeyWidth = 0;
    CGFloat cellKeyHeight = 0;
    CGFloat gapWidth = 0;
    gapWidth = keyboardWidth/(7*10 + 1);
    cellKeyWidth = 6* gapWidth;
    cellKeyHeight = (keyboardHeight - 5.5*gapWidth)/lines.count;
    for (int i = 0;i<lines.count;i++) {
        NSString* line = lines[i];
        NSInteger lineInt = [line integerValue];
        
        NSArray* keys = letterDic[line];
        

        switch (lineInt) {
            case 1:
            case 2:
            {
                for (int i = 0;i<keys.count ; i++) {
                    KeyButton* keyBtn = [KeyButton buttonWithType:UIButtonTypeSystem];
                    [keyBtn setTintColor:[UIColor blackColor]];
                    keyBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
                    keyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                    [keyBtn setTitle:[letterDic[line] objectAtIndex:i] forState:UIControlStateNormal];
                    keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth + gapWidth)*i + (lineInt - 1)*0.5*cellKeyWidth, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth, cellKeyHeight);
                    [keyBtn addTarget:self action:@selector(keyActions:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:keyBtn];
                    keyBtn.type = KeyTypeLetter;
                    keyBtn.value = [letterDic[line] objectAtIndex:i];
                }
            }
                break;
            case 3:{
                for (int i = 0;i<keys.count ; i++) {
                    KeyButton* keyBtn = [KeyButton buttonWithType:UIButtonTypeSystem];
                    [keyBtn setTintColor:[UIColor blackColor]];
                    keyBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
                    keyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                    
                    [keyBtn addTarget:self action:@selector(keyActions:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:keyBtn];
                    if ([keys[i] isEqualToString:TRANSFORLETTERLOWERCASE]) {
                        [keyBtn setTitle:@"CAP" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth + gapWidth)*i, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth*1.2, cellKeyHeight);
                        keyBtn.type = KeyTypeLowerCase;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }else if ([keys[i] isEqualToString:TRANSFORLETTERCAPTAIN]) {
                        [keyBtn setTitle:@"CAP" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth + gapWidth)*i, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth*1.2, cellKeyHeight);
                        keyBtn.type = KeyTypeCaptain;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }else if(i == keys.count-1){
                        [keyBtn setTitle:@"DEL" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth + gapWidth)*i + 0.5*cellKeyWidth, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth*1.5, cellKeyHeight);
                        keyBtn.type = KeyTypeDelete;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }else{
                        [keyBtn setTitle:[letterDic[line] objectAtIndex:i] forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth + gapWidth)*i + 0.5*cellKeyWidth, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth, cellKeyHeight);
                        keyBtn.type = KeyTypeLetter;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }
                    
                }
            }
                break;
            case 4:{
                for (int i = 0;i<keys.count ; i++) {
                    KeyButton* keyBtn = [KeyButton buttonWithType:UIButtonTypeSystem];
                    [keyBtn setTintColor:[UIColor blackColor]];
                    keyBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
                    keyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                    
                    [keyBtn addTarget:self action:@selector(keyActions:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:keyBtn];
                    NSString* keyFuncName = keys[i];
                    if ([keyFuncName isEqualToString:TRANSTOLETTERKEYBOARD]) {
                        [keyBtn setTitle:@"@" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ cellKeyWidth*1.2 + gapWidth, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth*1.2, cellKeyHeight);
                        keyBtn.type = KeyTypeSymbol;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }else if([keyFuncName isEqualToString:TRANSTONUMKEYBOARD]){
                        [keyBtn setTitle:@"123" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth*1.2, cellKeyHeight);
                        keyBtn.type = KeyTypeTransToNum;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }else if([keyFuncName isEqualToString:BLANKKEY]){
                        [keyBtn setTitle:@"空格" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth*1.2 + gapWidth)*i, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), cellKeyWidth*5 + gapWidth*4, cellKeyHeight);
                        keyBtn.type = KeyTypeBlankKey;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }else if([keyFuncName isEqualToString:DONEKEY]){
                        [keyBtn setTitle:@"DONE" forState:UIControlStateNormal];
                        keyBtn.frame = CGRectMake(gapWidth+ (cellKeyWidth + gapWidth)*7 + 0.5*cellKeyWidth, gapWidth+(cellKeyHeight + 1.5*gapWidth)*(lineInt-1), keyboardWidth - (gapWidth+ (cellKeyWidth + gapWidth)*7 + 0.5*cellKeyWidth) - gapWidth, cellKeyHeight);
                        keyBtn.type = KeyTypeDone;
                        keyBtn.value = [letterDic[line] objectAtIndex:i];
                    }
                    
                }
            }
                break;
                
            default:
                break;
        }
        
       
        
        
        
    }
    
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
                case KeyTypeBlankKey:
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
                    case KeyTypeTransToNum:
                {
                    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [self initNumKeyboard];
                }
                    break;
                case KeyTypeLowerCase:
                case KeyTypeTransToLetter:
                {
                    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [self initASCIICapableKeyboardLowerKey];
                }
                    break;
                case KeyTypeCaptain:
                {
                    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    [self initASCIICapableKeyboardCaptialKey];
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

-(NSMutableArray*)insertKey:(NSString*)key toArr:(NSArray*)arr atIndex:(NSInteger)index
{
    NSMutableArray* resultNums = [NSMutableArray arrayWithArray:arr];
    [resultNums insertObject:key atIndex:index];
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
