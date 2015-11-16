//
//  DNWCommitViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-12.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWCommitViewController.h"
#import "HMTMyCustomNetRequest.h"
#import "MBProgressHUD.h"

@interface DNWCommitViewController (){

    MBProgressHUD * _HUD;
    UIWebView * _webView;
    UIImageView * _hideTopImage;      //  遮挡顶部视图
    UIImageView * _hideBottomImage;   //  遮挡底部视图
}

@end

@implementation DNWCommitViewController

- (void)dealloc{

    RELEASE_SAFELY(_getCommitUrl);
    [super dealloc];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"评论";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //  改变导航栏中间标题颜色
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    // 自动队页面进行缩放以适应屏幕
    //_webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.opaque = YES;
    [self.view addSubview:_webView];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftBarButtonAction:)] autorelease];
    
    //  遮挡广告....
    _hideTopImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 67)];
    _hideTopImage.image = [UIImage imageNamed:@"banner"];
    [_webView.scrollView addSubview:_hideTopImage];
    [_hideTopImage release];
    
    // KVO
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _webView.scrollView && [keyPath isEqualToString:@"contentSize"])
    {
       
        CGSize size = _webView.scrollView.contentSize;
      
        if (size.height > 568.0) {
            
            _hideBottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, size.height-67, ScreenWidth, 67)];
            _hideBottomImage.image = [UIImage imageNamed:@"banner"];
            [_webView.scrollView addSubview:_hideBottomImage];
            [_hideBottomImage release];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewWillAppear:(BOOL)animated{

    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.labelText = @"正在加载";
    //设置模式为进度框形的
    _HUD.mode = MBProgressHUDModeDeterminate;
    [_HUD showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            _HUD.progress = progress;
            usleep(10000);
        }
        NSURL * url = [NSURL URLWithString:_getCommitUrl];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];

    } completionBlock:^{
        [_HUD removeFromSuperview];
        [_HUD release];
        _HUD = nil;
    }];

}

- (void)didClickLeftBarButtonAction:(UIBarButtonItem *)leftButton{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
