//
//  DNWAppDelegate.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWAppDelegate.h"
#import "DNWMainViewController.h"
#import "WeiboApi.h"
#import <QQConnection/QQConnection.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <MessageUI/MessageUI.h>


#import "Reachability.h"
#import "DXAlertView.h"

@interface DNWAppDelegate (){

    UIScrollView * _introduceView;
    UIImageView  * _firImageView;
    UIImageView  * _secImageView;
    UIImageView  * _thirdImageView;
//    UIView       * _stopView;
//    UIImageView  * _imageView;

}

@end

@implementation DNWAppDelegate

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    RELEASE_SAFELY(_window);
    RELEASE_SAFELY(hostReach);
    [super dealloc];

}

#pragma mark - 全局的网络监测
- (void)reachabilityChanged:(NSNotification *)note {

    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        
        //  断网提示图片
//        if (_imageView == nil && _stopView == nil) {
//            
//            _stopView = [[UIView alloc]initWithFrame:[self.window bounds]];
//            _stopView.backgroundColor = [UIColor blackColor];
//            _stopView.alpha = 0.5;
//            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-49-64)];
//            _imageView.image = [UIImage imageNamed:@"pic1"];
//            [self.window addSubview:_stopView];
//            [self.window addSubview:_imageView];
//            [_stopView release];
//            [_imageView release];
//        }
        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"网络未连接" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
        };
        [alert release];

        
    }else if (status == ReachableViaWWAN){
    
//        if (_imageView != nil && _stopView != nil) {
//            
//            [_imageView removeFromSuperview];
//            [_stopView removeFromSuperview];
//            _imageView = nil;
//            _stopView = nil;
//        }

        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您正在使用手机流量上网" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        alert.rightBlock = ^() {
        };
        [alert release];
        
    
    }
    
//        if (_imageView != nil && _stopView != nil) {
//            
//            [_imageView removeFromSuperview];
//            [_stopView removeFromSuperview];
//            _imageView = nil;
//            _stopView = nil;
//            
//            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"网络重新连接,请下拉刷新" leftButtonTitle:nil rightButtonTitle:@"确定"];
//            [alert show];
//            alert.rightBlock = ^() {
//            };
//            [alert release];
//
//        }
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    DNWMainViewController * mainVC = [[DNWMainViewController alloc] init];
    self.window.rootViewController = mainVC;
    [mainVC release];

    [self.window makeKeyAndVisible];
    
    #pragma mark  window在执行完上面那句话之后才会产生,切记!切记!
    [self onlyOneAddIntroduceView];
    
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"1ca61a7b6a22"];
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    //    [ShareSDK registerApp:@"iosv1101" useAppTrusteeship:YES];
    
    [self shareMyAppToFashionPlatforms];
    //如果使用服务器中配置的app信息，请把初始化平台代码改为下面的方法
    //    [self initializePlatForTrusteeship];

    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:HostName] retain];
    //hostReach = [[Reachability reachabilityForLocalWiFi] retain];
    [hostReach startNotifier];
    
    //  改变状态栏颜色
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    
    return YES;
}


#pragma mark - 初始化分享平台
- (void)shareMyAppToFashionPlatforms{

    #pragma mark  新浪
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"2836674504"
//                               appSecret:@"b2b13d939ed728b999c60c3e8c12d3ac"
//                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
//
//    #pragma mark  豆瓣
//    /**
//     连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
//     http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
//     **/
    [ShareSDK connectDoubanWithAppKey:@"096f2fd01e6267241c4d8f705b27356c"
                            appSecret:@"32f25de63eb77731"
                          redirectUri:@"http://blog.csdn.net/hmt20130412"];
    
    #pragma mark  腾讯微博
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
//    [ShareSDK connectTencentWeiboWithAppKey:@"801506676"
//                                  appSecret:@"cb9d6d2b9bc3703106b3304a2b590ff1"
//                                redirectUri:@"http://blog.csdn.net/hmt20130412"
//                                   wbApiCls:[WeiboApi class]];
    
    #pragma mark  QQ
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
//    if ([QQApi isQQInstalled] ) {
//        
//        [ShareSDK connectQQWithQZoneAppKey:@"101091082"
//                         qqApiInterfaceCls:[QQApiInterface class]
//                           tencentOAuthCls:[TencentOAuth class]];
//    }
    

    #pragma mark  QQ空间
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
//    [ShareSDK connectQZoneWithAppKey:@"101091082"
//                           appSecret:@"6ac52df947e8c64a41b85d1f6af8c02f"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
    
    
    #pragma mark  微信
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
//    if ([WXApi isWXAppInstalled]) {
//        
//        [ShareSDK connectWeChatWithAppId:@"wx746cd01bb051f206" wechatCls:[WXApi class]];
//    }
    
//    #pragma mark  连接短信分享
//    [ShareSDK connectSMS];
//    
//    #pragma mark  邮件分享
//    [ShareSDK connectMail];
    
    [Parse setApplicationId:@"0wtrMX9i7FM5nG64tEC2mMNrFr96EFgyfPDwlaMq" clientKey:@"QTmCex6t1jyIH4tREGPPsTFMb09u3I4KMyGq4J7N"];
    

}


#pragma mark - 返回一些回调信息
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

#pragma mark - 引导页只执行一次
- (void)onlyOneAddIntroduceView{

    //  读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = @"is_first";
    NSString *value = [settings1 objectForKey:key1];
    //  如果没有数据
    if (!value)
    {
        //  加入引导页
        [self addIntroduceView];
        //  写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = @"is_first";
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }

}


#pragma mark - 添加引导页效果
- (void)addIntroduceView{
    
    _introduceView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _introduceView.showsHorizontalScrollIndicator = NO;
    _introduceView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _introduceView.pagingEnabled = YES;
    _introduceView.bounces = NO;
    _introduceView.delegate = self;
    [self.window addSubview:_introduceView];
    [_introduceView release];
        
    _thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, ScreenWidth, ScreenHeight)];
    _thirdImageView.image = [UIImage imageNamed:@"yindao3"];
    _thirdImageView.userInteractionEnabled = YES;
    [_introduceView addSubview:_thirdImageView];
    [_thirdImageView release];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [_thirdImageView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    _secImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, ScreenWidth, ScreenHeight)];
    _secImageView.image = [UIImage imageNamed:@"yindao2"];
    _secImageView.alpha = 1.0;
    [_introduceView addSubview:_secImageView];
    [_secImageView release];
    
    _firImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _firImageView.image = [UIImage imageNamed:@"yindao1"];
    [_introduceView addSubview:_firImageView];
    [_firImageView release];
    
    
}

- (void)gestureRecognizerHandle:(UITapGestureRecognizer *)gesture{

    [UIView animateWithDuration:3.0 animations:^{
        
        _thirdImageView.alpha = 0.0;
        _thirdImageView.transform = CGAffineTransformScale(_thirdImageView.transform, 0, 0);
    } completion:^(BOOL finished) {
        
        [_introduceView removeFromSuperview];
        
    }];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
