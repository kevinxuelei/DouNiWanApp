//
//  DNWAboutOursViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-19.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWAboutOursViewController.h"

@interface DNWAboutOursViewController ()

@end

@implementation DNWAboutOursViewController

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
    #pragma mark 导航栏配色设置
    self.navigationItem.title = @"关于我们";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    //  改变导航栏中间标题颜色
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"个人中心" style:UIBarButtonItemStylePlain target:self action:@selector(didLeftBarButtonItemAction:)]autorelease];
    
    UIImageView * headImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 5, 200, 200)];
    headImage.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:headImage];
    [headImage release];
    
    UILabel * iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 300, 30)];
    iconLabel.text = @"逗乐玩1.0";
    iconLabel.textColor = [UIColor colorWithRed:227/255.0 green:207/255.0 blue:87/255.0 alpha:1.0];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:iconLabel];
    [iconLabel release];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 60)];
    label.text = @"是的,我们一直走在为大家创造更多欢笑的路上,带给大家更好的体验与未来";
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label release];
    
    for (int i = 0; i < 2; i ++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 300+ 40*i, 300, 40)];
        label.tag = 100 + i;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1.0];
        [self.view addSubview:label];
        [label release];
    }
    
    ((UILabel *)[self.view viewWithTag:100]).text = @"欢迎与我们联系或者加入我们";
    ((UILabel *)[self.view viewWithTag:101]).text = @"UI设计:梁俊杰,谢颖,方文博";
//    ((UILabel *)[self.view viewWithTag:103]).text = @"联系邮箱:humingtao2014@gmail.com";
//    ((UILabel *)[self.view viewWithTag:103]).textColor = [UIColor grayColor];
//    
    
}

- (void)didLeftBarButtonItemAction:(UIBarButtonItem *)leftBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
