//
//  DNWFirstPapersViewController.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class DNWWeatherData;
//typedef void(^PushWeatherDataToOtherViewController)(DNWWeatherData *);
//

@interface DNWFirstPaperViewController : UIViewController<UIScrollViewDelegate>

/**
 *  bottomImageView  取得自定义底部标签栏视图
 */
@property (nonatomic,retain)UIImageView * bottomImageView;

/**
 *  pushWeatherData  传递天气数据
 */
//@property (nonatomic,copy)PushWeatherDataToOtherViewController pushWeatherData;
@end
