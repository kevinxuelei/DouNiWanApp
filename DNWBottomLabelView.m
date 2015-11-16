//
//  DNWBottomLabelView.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWBottomLabelView.h"

@implementation DNWBottomLabelView

- (void)dealloc{

    RELEASE_SAFELY(_clearButton);
    Block_release(_passBlock);
    [super dealloc];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createBottomLabelView];
        
    }
    return self;
}

- (void)createBottomLabelView{

    _labelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
    _labelImageView.userInteractionEnabled = YES;
    [self addSubview:_labelImageView];
    [_labelImageView release];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 45, 35)];
    _numberLabel.userInteractionEnabled = YES;
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:15.0];
    _numberLabel.textColor = [UIColor grayColor];
    [self addSubview:_numberLabel];
    [_numberLabel release];

    //  设计为透明的,只为增加响应方法
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _clearButton.backgroundColor = [UIColor clearColor];
    _clearButton.frame = CGRectMake(0, 0, 80, 40);
    [_clearButton addTarget:self action:@selector(didClickClearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clearButton];
    
}

#pragma mark - 点击按钮
- (void)didClickClearButtonAction:(UIButton *)button{

    //  分享block
    if (_passBlock) {
        _passBlock();
    }
    
}

@end









