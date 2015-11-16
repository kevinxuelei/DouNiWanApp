//
//  DNWVideoPlayView.m
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWVideoPlayView.h"
#import "DNWWedViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DNWVideoPlayView (){

    NSTimeInterval nowTime;
    NSTimeInterval lastTime;
    NSTimer * videoTime;
}

@end

@implementation DNWVideoPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self) {
  
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame url:(NSURL *)url string:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubviews];
#pragma mark---------视频创建-------
        self.url = url;
        self.string = string;
        [self playerVideo];
        self.videoDescribeLabel.text = string;
    
    }
    return self;

}

#pragma mark---------视频播放-------
- (void)playerVideo
{
    self.videoPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:_url];
    [_videoPlayer.view setFrame:CGRectMake(0, 0, 320, 250)];
   // [_videoPlayer.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_videoPlayer.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    _videoPlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [self addSubview:_videoPlayer.view];
    [_videoPlayer release];
    
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayertongzhi) name:UIApplicationWillEnterForegroundNotification object:nil];
    
//    videoTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(goTime) userInfo:nil repeats:YES];
//    [videoTime fire];

    
}

//- (void)goTime{
//
//    nowTime = _videoPlayer.moviePlayer.currentPlaybackTime;
//    NSLog(@"--%f",nowTime);
//    
//}

- (void)videoPlayertongzhi
{
    [_videoPlayer.moviePlayer play];
    //_videoPlayer.moviePlayer.initialPlaybackTime = lastTime;
}

-(void)myMovieFinishedCallback
{
    
//    if (nowTime > 0) {
//        lastTime = nowTime;
//    }
    [_videoPlayer.moviePlayer pause];
    
}

- (void)createSubviews
{
    
    self.videoDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 280, 280, 170)];
    _videoDescribeLabel.textColor =[UIColor orangeColor];
    //居中(字体排列)
    _videoDescribeLabel.textAlignment = NSTextAlignmentLeft;
    //字体大小
    _videoDescribeLabel.font = [UIFont systemFontOfSize:15];
    _videoDescribeLabel.numberOfLines = 0;
    _videoDescribeLabel.lineBreakMode =  NSLineBreakByWordWrapping;
    [self addSubview:_videoDescribeLabel];
    [_videoDescribeLabel release];
    
    
    self.patternButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _patternButton.frame = CGRectMake(250, 250, 70, 30);
    [_patternButton setTitle:@"网页模式" forState:UIControlStateNormal];
    [_patternButton addTarget:self action:@selector(didClickPatterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_patternButton];

}

#pragma mark---------点击推出页面-------
- (void)didClickPatterButtonAction
{
    _block();
}

- (void)changeViewBackGround:(ViewBlock)block
{
    self.block = block;
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    RELEASE_SAFELY(_videoDescribeLabel);
    RELEASE_SAFELY(_patternButton);
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_string);
    RELEASE_SAFELY(_thirdData);
    RELEASE_SAFELY(_videoPlayer);
    Block_release(_block);
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
