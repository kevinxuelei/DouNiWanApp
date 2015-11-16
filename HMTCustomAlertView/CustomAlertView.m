//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by 胡明涛 on 14-5-6.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "CustomAlertView.h"
#import "DNWAppDelegate.h"
#import "DXAlertView.h"

@interface CustomAlertView (){

    UILabel * _titleLabel;
    UIButton * _cancelButton;
    UIButton * _otherButton;
    UIView * _view;
    UITextView * _reportTextField;

}

@end

@implementation CustomAlertView

- (void)dealloc{

    Block_release(_cancelBlock);
    Block_release(_otherBlcok);
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle{

    self = [super initWithFrame:CGRectMake(30, 64 ,260, 250)];
    if (self) {
        
        [self createCustomAlertView];
        _titleLabel.text = title;
        [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [_otherButton setTitle:otherTitle forState:UIControlStateNormal];
        
        __block CustomAlertView * SELF = self;
        [UIView animateWithDuration:0.2 animations:^{
           
            SELF.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);

        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                SELF.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                
            } completion:^(BOOL finished) {
               
                [UIView animateWithDuration:0.2 animations:^{
                    
                    SELF.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                    
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
        }];
        
    }
    
    // 阻碍其他响应事件
    _view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _view.backgroundColor = [UIColor blackColor];
    _view.alpha = 0.3;
    [[UIApplication sharedApplication].keyWindow addSubview:_view];
    [_view release];
    
    // 获得应用程序的单例对象,HCZAppDelegate是它的代理
//    DNWAppDelegate * APPDelegate = [[UIApplication sharedApplication] delegate];
//    [APPDelegate.window addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    return  self;
}

- (void)createCustomAlertView{
    
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dialog box_bg"]];
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 40)];
    _titleLabel.textColor = [UIColor redColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel release];
    
    _reportTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, self.bounds.size.width-40, 300-60-100)];
    _reportTextField.text = @"   该内容违反相关法律法规,含有色情,暴力等不和谐因素.....";
    //_reportTextField.borderStyle = UITextBorderStyleRoundedRect;
    _reportTextField.textAlignment = NSTextAlignmentLeft;
    _reportTextField.font = [UIFont systemFontOfSize:15.0];
    _reportTextField.scrollEnabled = YES;//是否可以拖动
    _reportTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [_reportTextField becomeFirstResponder];
    //_reportTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:_reportTextField];
    [_reportTextField release];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(10,300-100,self.bounds.size.width/2-15,40);
    _cancelButton.tag = 100;
    [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
    
    _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherButton.frame = CGRectMake(self.bounds.size.width/2 +5,300-100,self.bounds.size.width/2-15,40);
    [_otherButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
    _otherButton.tag = 200;
    [_otherButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_otherButton];

}

- (void)didClickCancelButton:(UIButton *)button{

        if (button.tag == 100) {
            
            if (_cancelBlock) {
                
                _cancelBlock();
                [self removeFromSuperview];
                [_view removeFromSuperview];
                _view = nil;
            }
            
        } else {
            
            if (_otherBlcok) {
                
                _otherBlcok();
                [self removeFromSuperview];
                [_view removeFromSuperview];
                _view = nil;
                
            }
            
        }
}

@end

//@implementation UIImage (colorful)
//
//+ (UIImage *)imageWithColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}
//
//@end

