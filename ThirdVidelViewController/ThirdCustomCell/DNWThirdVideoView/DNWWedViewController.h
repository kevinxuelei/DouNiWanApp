//
//  DNWWedViewController.h
//  DouNiWan
//
//  Created by chenfengchang on 14-5-13.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNWThirdData;
@interface DNWWedViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,retain)NSURL * url;
@property (nonatomic,retain)DNWThirdData *WedThirdData;


@end