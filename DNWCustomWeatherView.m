//
//  DNWCustomWeatherView.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//


#import "DNWCustomWeatherView.h"

@interface DNWCustomWeatherView ()

@end

@implementation DNWCustomWeatherView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self createCustomWeaterView];
        
    }
    return self;
}

- (void)createCustomWeaterView{

#pragma mark - 天气图像
    _weatherImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 41)];
    _weatherImage1.alpha = 0.0;
    _weatherImage1.userInteractionEnabled = YES;
    [self addSubview:_weatherImage1];
    [_weatherImage1 release];
    
    _weatherImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 41)];
    _weatherImage2.alpha = 0.0;
    _weatherImage2.userInteractionEnabled = YES;
    [self addSubview:_weatherImage2];
    [_weatherImage2 release];

#pragma mark - 天气温度
    _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 40, 22)];
    _temperatureLabel.textAlignment = NSTextAlignmentCenter;
    _temperatureLabel.alpha = 0.0;
    _temperatureLabel.textColor = [UIColor whiteColor];
    _temperatureLabel.font = [UIFont systemFontOfSize:7.0];
    [self addSubview:_temperatureLabel];
    [_temperatureLabel release];

#pragma mark - 地方名称
    _loactionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 22, 40, 20)];
    _loactionNameLabel.textAlignment = NSTextAlignmentCenter;
    _loactionNameLabel.alpha = 0.0;
    _loactionNameLabel.textColor = [UIColor whiteColor];
    _loactionNameLabel.font = [UIFont systemFontOfSize:11.0];
    [self addSubview:_loactionNameLabel];
    [_loactionNameLabel release];
    
}



@end