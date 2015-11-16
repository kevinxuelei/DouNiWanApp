//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by 胡明涛 on 14-5-6.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Myblcok)();

@interface CustomAlertView : UIView

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle;


@property (nonatomic,copy)Myblcok cancelBlock;
@property (nonatomic,copy)Myblcok otherBlcok;



@end

//@interface UIImage (colorful)

//+ (UIImage *)imageWithColor:(UIColor *)color;

//@end