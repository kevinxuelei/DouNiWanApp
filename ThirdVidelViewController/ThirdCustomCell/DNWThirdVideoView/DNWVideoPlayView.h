//
//  DNWVideoPlayView.h
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void(^ViewBlock)(void);
@class DNWThirdData;

@interface DNWVideoPlayView : UIView

@property (nonatomic,retain) UILabel *videoDescribeLabel;//视频注释

@property (nonatomic,retain) UIButton *patternButton;//推出网页模式的按钮

@property (nonatomic,copy)NSString *string;//接收视频注释

@property (nonatomic,retain)DNWThirdData *thirdData;

@property (nonatomic,retain)NSURL *url;//接收上个视图传过来的NSURL

@property (nonatomic,retain) MPMoviePlayerViewController *videoPlayer;//视频播放

@property (nonatomic,copy) ViewBlock block;

- (void)changeViewBackGround:(ViewBlock)block;

//初始化视图显示需要的数据
- (id)initWithFrame:(CGRect)frame url:(NSURL *)url string:(NSString *)string;

//视频播放
- (void)playerVideo;

@end
