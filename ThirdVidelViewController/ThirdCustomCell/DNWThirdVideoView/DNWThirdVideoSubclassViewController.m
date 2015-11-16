//
//  DNWThirdVideoSubclassViewController.m
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWAppDelegate.h"
#import "DNWThirdVideoSubclassViewController.h"
#import "DNWVideoPlayView.h"
#import "DNWThirdData.h"
#import "HMTMyCustomNetRequest.h"
#import "DNWWedViewController.h"
#import "DNWMainViewController.h"

@interface DNWThirdVideoSubclassViewController ()
{
   // DNWVideoPlayView * _DNWVPV;
    BOOL _enterWebView;
    DNWMainViewController *dnwmin;
}
@end

@implementation DNWThirdVideoSubclassViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    _enterWebView = NO;
    //视频加载
    [_videoPlayView videoPlayer];
    //视频播放
    [_videoPlayView.videoPlayer.moviePlayer play];
    
    ((DNWAppDelegate *)[UIApplication sharedApplication].delegate).shouldAutorotate = YES;
    
    CGFloat delay = 0.1f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    });
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL * url = [NSURL URLWithString:_thirdData.mp4_url];
    self.videoPlayView = [[DNWVideoPlayView alloc]initWithFrame:[[UIScreen mainScreen] bounds] url:url string:_thirdData.title];
    //设置监听者(通知,把自己设为观察者)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    _videoPlayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_videoPlayView];
	[_videoPlayView release];
    
#pragma mark----创建UIBarButtonItem实现返回-------
    UIBarButtonItem *barButton= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickleftBarButtonItemAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = barButton;
    [barButton release];
    self.navigationItem.title = @"逗乐玩视频播放";

#pragma mark----使用block实现推出DNWWedViewController页面-------
    __block DNWThirdVideoSubclassViewController *Block = self;

    [_videoPlayView changeViewBackGround:^{
       
        [Block pushDNWWedViewController:Block.thirdData.web_url];
        
    }];
    
//    //监测屏幕方向
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginTouchDNWMainViewController) name: @"back" object:nil];
}
#pragma mark-----监测视频是否还没播放就推出下一页面---
- (void)test:(NSNotification *)notification
{
    if(_enterWebView == NO) return;
    MPMoviePlayerController *playerController = notification.object;
    [playerController pause];
}

#pragma mark------推出DNWWedViewController页面实现-------
- (void)pushDNWWedViewController:(NSString *)wed
{
    _enterWebView = YES;
    [_videoPlayView.videoPlayer.moviePlayer pause];
    
    DNWWedViewController *webViewController = [[DNWWedViewController alloc]init];
    
    NSURL * url = [NSURL URLWithString:_thirdData.web_url];
    webViewController.url = url;
    webViewController.WedThirdData=_thirdData;

    [self.navigationController pushViewController:webViewController animated:YES];

    [webViewController release];
    
}

#pragma mark------实现返回上个页面-------
- (void)didClickleftBarButtonItemAction
{
    [_videoPlayView.videoPlayer.moviePlayer pause];
    //_DNWVPV.videoPlayer=nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark----释放----
- (void)dealloc
{
    RELEASE_SAFELY(_thirdData);
    RELEASE_SAFELY(_videoPlayView);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----当屏幕旋转时调用方法--
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
        
     [_videoPlayView.videoPlayer.moviePlayer setFullscreen:YES animated:YES];
    //[self didBeginTouchDNWMainViewController];
    
}

@end
