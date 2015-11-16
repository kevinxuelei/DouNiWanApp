//
//  CustomButton.m
//  DouNiWan
//
//  Created by apple on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
-(void)dealloc
{
    RELEASE_SAFELY(_countNumberLabel);
    RELEASE_SAFELY(_button);
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.bounds.size.width;
        CGFloat heigh = self.bounds.size.height;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, width/2, heigh);
        [self addSubview:_button];
        self.countNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2, 0, width/2, heigh)];
        [self addSubview:self.countNumberLabel];
        [self.countNumberLabel release];
        
        
        
    }
    return self;
}

- (id)init{
    
    self = [super init];
    if (self) {
        CGFloat width = 80;
        CGFloat heigh = 40;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = CGRectMake(0, 0, width/2, heigh);
        [self addSubview:_button];
        self.countNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(width/2, 0, width/2, heigh)];
        [self addSubview:self.countNumberLabel];
        [self.countNumberLabel release];
        
        
        
    }
    return self;


}

@end
