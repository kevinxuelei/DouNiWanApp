//
//  DNWWedViewController.m
//  DouNiWan
//
//  Created by chenfengchang on 14-5-13.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWWedViewController.h"
#import "DNWThirdVideoSubclassViewController.h"
#import "DNWThirdData.h"
#import "DNWAppDelegate.h"

@interface DNWWedViewController ()
{
    UIWebView *_wedView;
}
@end

@implementation DNWWedViewController

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
    /**
     *  创建UIWedView
     */
    
    self.navigationController.title = @"网页播放";
    //  改变导航栏中间标题颜色
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
        
    _wedView = [[UIWebView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    _wedView.delegate = self;
    [_wedView loadRequest:request];
    _wedView.scalesPageToFit = YES;
    [self.view addSubview:_wedView];    
    [_wedView release];
    
    //  遮挡广告....
    UIImageView * _hideTopImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 67)];
    _hideTopImage.image = [UIImage imageNamed:@"banner"];
    [_wedView.scrollView addSubview:_hideTopImage];
    [_hideTopImage release];

  
    //返回
//    UIBarButtonItem *barButton= [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickWedBarButtonItemAction)];
//    self.navigationItem.rightBarButtonItem = barButton;
//    [barButton release];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((DNWAppDelegate *)[UIApplication sharedApplication].delegate).shouldAutorotate = NO;
}
//返回
//- (void)didClickWedBarButtonItemAction
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//释放
- (void)dealloc
{
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_WedThirdData);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
