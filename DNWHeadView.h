//
//  DNWHeadView.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-15.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HandleRefreshEvent)();
typedef void(^HandleTapGesture)();

@class CUSFlashLabel;
@class SYWaterDropView;

@interface DNWHeadView : UIView
{

    BOOL touch1,touch2,hasStop;
    BOOL isrefreshed;

}

/**
 *  img_banner  背景图片
 *  loginLabel  登录labelName
 *  waterView   Path水滴视图
 *  showView    展示效果视图
 *  avatarView  头像视图
 */
@property (nonatomic,retain)  UIImageView *img_banner;
@property (nonatomic,retain)  CUSFlashLabel *loginLabel;
@property (nonatomic,retain)  SYWaterDropView *waterView;
@property (nonatomic,retain)  UIView *showView;
@property (nonatomic,retain)  UIImageView *avatarView;

@property (nonatomic,assign)    BOOL touching;
@property (nonatomic,assign)    float offsetY;

@property (nonatomic,copy)    HandleRefreshEvent handleRefreshEvent;
@property (nonatomic,copy)    HandleTapGesture handleTapGesture;

-(void)stopRefresh;


@end
