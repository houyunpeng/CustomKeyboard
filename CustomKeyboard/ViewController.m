//
//  ViewController.m
//  CustomKeyboard
//
//  Created by 侯云鹏 on 16/4/18.
//  Copyright © 2016年 侯云鹏. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField* tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(20, 60, 300, 30);
    tf.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:tf];
    
    CustomKeyboard* keyboard = [[CustomKeyboard alloc] initKeyboard];
    keyboard.textField = tf;
    keyboard.delegate = self;
    
    tf.inputView = keyboard;
    
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
