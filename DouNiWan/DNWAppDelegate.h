//
//  DNWAppDelegate.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Reachability;
@interface DNWAppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate>{

    Reachability * hostReach;
}

@property (strong, nonatomic) UIWindow *window;
@property   (nonatomic, assign) BOOL shouldAutorotate;


@end
