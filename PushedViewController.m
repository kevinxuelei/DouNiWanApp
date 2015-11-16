//
//  PushedViewController.m
//  DouNiWan
//
//  Created by apple on 14-5-20.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "PushedViewController.h"
#import "MBProgressHUD.h"

@interface PushedViewController (){

    UIWebView * web;
    MBProgressHUD * _HUD;
    
}

@end

@implementation PushedViewController
-(void)dealloc
{
    RELEASE_SAFELY(web);
    RELEASE_SAFELY(_urlString);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    [self.view addSubview:web];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"评论";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeftButton)]autorelease];
    
    //  遮挡广告....
    UIImageView * _hideTopImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 67)];
    _hideTopImage.image = [UIImage imageNamed:@"banner"];
    [web.scrollView addSubview:_hideTopImage];
    [_hideTopImage release];

    // KVO
    [web.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == web.scrollView && [keyPath isEqualToString:@"contentSize"])
    {
        CGSize size = web.scrollView.contentSize;

        if (size.height > 568.0) {
            
            UIImageView * _hideBottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, size.height-67, ScreenWidth, 67)];
            _hideBottomImage.image = [UIImage imageNamed:@"banner"];
            [web.scrollView addSubview:_hideBottomImage];
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
        NSURL * url = [NSURL URLWithString:self.urlString];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [web loadRequest:request];
        
    } completionBlock:^{
        [_HUD removeFromSuperview];
        [_HUD release];
        _HUD = nil;
    }];
    
}


-(void)didClickLeftButton
{
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
