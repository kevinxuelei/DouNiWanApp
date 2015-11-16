//
//  DNWSecondViewController.m
//  DouNiWan
//
//  Created by apple on 14-5-17.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//
////  精华图片接口
//#define JingHuaURL  @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page=0&type=10&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
//#define FrontJingHuaString @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page="
//#define BackJingHuaString  @"&type=10&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
//
//  最新图片接口
//#define ZuiXinURL  @"http://api.budejie.com/api/api_open.php?c=data&a=newlist&from=ios&per=20&page=0&type=10&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
//#define FrontZuiXinString @"http://api.budejie.com/api/api_open.php?c=data&a=newlist&from=ios&per=20&page="
//#define BackZuiXinString  @"&type=10&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
//
////  穿越图片接口
//#define ChuanYueURL  @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page=0&type=10&order=timewarp&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
//#define FrontChuanYueString @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page="
//#define BackChuanYueString   @"&type=10&order=timewarp&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"



//  精华图片接口
#define JingHuaURL  @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page=0&type=10&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
#define FrontJingHuaString @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page="
#define BackJingHuaString  @"&type=10&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"

//  最新图片接口
#define ZuiXinURL  @"http://api.budejie.com/api/api_open.php?c=data&a=newlist&from=ios&per=20&page=0&type=10&maxtime=1401284445&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
#define FrontZuiXinString @"http://api.budejie.com/api/api_open.php?c=data&a=newlist&from=ios&per=20&page="
#define BackZuiXinString  @"&type=10&maxtime=1401284445&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"

//  穿越图片接口
#define ChuanYueURL  @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page=0&type=10&order=timewarp&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
#define FrontChuanYueString @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page="
#define BackChuanYueString   @"&type=10&order=timewarp&client=iphone&market=&ver=2.6&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=131ee15d28c0deb092739505d94cc1afc601eec8&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"


#import "DNWSecondViewController.h"
#import "SecondPictureView.h"
#import "DNWAllDataHandle.h"
#import "UIImageView+WebCache.h"
#import "PushedViewController.h"
#import "DNWWeatherData.h"
#import "DNWCustomWeatherView.h"


@interface DNWSecondViewController ()<UIViewControllerTransitioningDelegate>
{
    UISegmentedControl * _seg;
    int _pageCount;
    int _pageCount2;
    int _pageCount3;
    
    DNWCustomWeatherView * _weatherView;
    DNWWeatherData * _weatherData;
    NSTimer * _timer;

}
@end

@implementation DNWSecondViewController
-(void)dealloc
{
    RELEASE_SAFELY(_bottomImageView);
    RELEASE_SAFELY(_chuanYueTableView);
    RELEASE_SAFELY(_jinghuaTableView);
    RELEASE_SAFELY(_zuiXinTableView);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_weatherData);
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

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [_chuanYueTableView reloadData];
    [_jinghuaTableView reloadData];
    [_zuiXinTableView reloadData];
    
    [UIView animateWithDuration:0.18 animations:^{
        self.bottomImageView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
    } completion:^(BOOL finished) {
        
    }];


}

#pragma — 创建导航栏上的三个按钮
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    //    创建左侧导航栏按钮
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 35, 35)];
    iconImageView.image = [UIImage imageNamed:@"logo"];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:iconImageView]autorelease];
    [iconImageView release];
    
    //    创建分段控件，添加到导航栏的titleview
    _seg = [[UISegmentedControl alloc]initWithFrame:CGRectMake(100, 24, 120, 36)];
    [_seg insertSegmentWithTitle:@"火热" atIndex:0 animated:NO];
    [_seg insertSegmentWithTitle:@"最新" atIndex:1 animated:NO];
    [_seg insertSegmentWithTitle:@"穿越" atIndex:2 animated:NO];
    _seg.multipleTouchEnabled = NO;
    //_seg.tintColor = [UIColor colorWithRed:228/255.0 green:153/255.0 blue:39/255.0 alpha:1.0];
    _seg.tintColor = [UIColor whiteColor];
    _seg.backgroundColor = [UIColor brownColor];

    
    [_seg addTarget:self action:@selector(selectbutton:) forControlEvents:UIControlEventValueChanged];
    [_seg setSelectedSegmentIndex:0];
    
    self.navigationItem.titleView = _seg;
    [self createWeatherView];
       
    [self createRootScrollView];
    [self createJingHuaTableView];
    
}

#pragma mark - 创建并显示天气状况labelView
- (void)createWeatherView{
    
    _weatherView = [[DNWCustomWeatherView alloc] initWithFrame:CGRectMake(240, 0, 80, 44)];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_weatherView]autorelease];
    
    _weatherData = [[DNWWeatherData alloc] init];
   
    [_weatherData setPassWeatherData:^(DNWWeatherData * weatherData){
        
        // 显示数据到View上
        _weatherView.temperatureLabel.text = [[weatherData.temperatureLow stringByAppendingString:@"℃~"] stringByAppendingString:[weatherData.temperatureHeight stringByAppendingString:@"℃"]];
        _weatherView.loactionNameLabel.text = weatherData.cityName;
        [_weatherView.weatherImage1 setImageWithURL:weatherData.stateImageUrl1 placeholderImage:nil];
        [_weatherView.weatherImage2 setImageWithURL:weatherData.stateImageUrl2 placeholderImage:nil];
        
        // 加入渐隐渐入的效果
        [UIView animateWithDuration:5.0 animations:^{
            
            _weatherView.temperatureLabel.alpha = 1.0;
            _weatherView.loactionNameLabel.alpha = 1.0;
            _weatherView.weatherImage1.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            // 设置一个定时器,灵活的变换天气效果
            _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(goTime) userInfo:nil repeats:YES];
            [_timer fire];
            
        }];
    }];
    
    [_weatherView release];
    
}

#pragma mark 定时器响应方法
- (void)goTime{
    
    [UIView animateWithDuration:3 animations:^{
        
        if (_weatherView.weatherImage1.alpha == 1.0) {
            
            _weatherView.weatherImage2.alpha = 1.0;
            _weatherView.weatherImage1.alpha = 0.0;
            
        }else{
            
            _weatherView.weatherImage1.alpha = 1.0;
            _weatherView.weatherImage2.alpha = 0.0;
            
        }
    } completion:nil];
    
}

#pragma mark - 创建滚动效果视图
- (void)createRootScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView release];
    
}
#pragma mark - 结束滑动,用来同步改变_segmentView对应的selectedSegmentIndex,同时加载没有被加载的视图
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger nowIndex = scrollView.contentOffset.x / 320.0 ;
    _seg.selectedSegmentIndex = nowIndex;
    if (_seg.selectedSegmentIndex == 1) {
        if (!self.zuiXinTableView) {
            [self createZuiXinTableView];
        }
    }
    if (_seg.selectedSegmentIndex == 2) {
        
        if (!self.chuanYueTableView) {
            [self createChuanYueTableView];
        }
    }

    
}
#pragma mark - 创建精华tableView
- (void)createJingHuaTableView{
    
    self.jinghuaTableView = [[SecondPictureView alloc]
                            initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)
                                    style:UITableViewStylePlain
                                urlString:JingHuaURL];
    self.jinghuaTableView.frontString = FrontJingHuaString;
    self.jinghuaTableView.backString  = BackJingHuaString;
    __block DNWSecondViewController * newVc = self;
    [self.jinghuaTableView setPushedBlock:^(NSString * urlStr){
        PushedViewController * pushed = [[PushedViewController alloc]init];
        pushed.urlString = urlStr;
        
        [newVc.navigationController pushViewController:pushed animated:YES];
        
        [pushed release];
        
        [UIView animateWithDuration:0.18 animations:^{
            newVc.bottomImageView.frame = CGRectMake(0, ScreenHeight+10, ScreenWidth, 49);
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    [self.scrollView addSubview:self.jinghuaTableView];
    [self.jinghuaTableView release];
    
    
    
}
#pragma mark - 创建最新tableView
- (void)createZuiXinTableView{
    
    self.zuiXinTableView = [[SecondPictureView alloc]
                            initWithFrame:CGRectMake(320, 0, ScreenWidth, ScreenHeight)
                                    style:UITableViewStylePlain
                                urlString:ZuiXinURL];
    self.zuiXinTableView.frontString = FrontZuiXinString;
    self.zuiXinTableView.backString  = BackZuiXinString;
    __block DNWSecondViewController * newVc = self;
    [self.zuiXinTableView setPushedBlock:^(NSString * urlStr){
        PushedViewController * pushed = [[PushedViewController alloc]init];
        pushed.urlString = urlStr;
        [newVc.navigationController pushViewController:pushed animated:YES];
        
        [pushed release];
        
        [UIView animateWithDuration:0.18 animations:^{
            newVc.bottomImageView.frame = CGRectMake(0, ScreenHeight+10, ScreenWidth, 49);
        } completion:^(BOOL finished) {
            
        }];
    }];

    [self.scrollView addSubview:_zuiXinTableView];
    [_zuiXinTableView release];
    
    
    
}
#pragma mark - 创建穿越tableView
- (void)createChuanYueTableView{
    self.chuanYueTableView = [[SecondPictureView alloc]
                                initWithFrame:CGRectMake(640, 0, ScreenWidth, ScreenHeight)
                                        style:UITableViewStylePlain
                                    urlString:ChuanYueURL];
    self.chuanYueTableView.frontString = FrontChuanYueString;
    self.chuanYueTableView.backString  = BackChuanYueString;
    __block DNWSecondViewController * newVc = self;
    [self.chuanYueTableView setPushedBlock:^(NSString * urlStr){
        PushedViewController * pushed = [[PushedViewController alloc]init];
        pushed.urlString = urlStr;
        
        [newVc.navigationController pushViewController:pushed animated:YES];
        
        [pushed release];
        
        [UIView animateWithDuration:0.18 animations:^{
            newVc.bottomImageView.frame = CGRectMake(0, ScreenHeight+10, ScreenWidth, 49);
        } completion:^(BOOL finished) {
            
        }];
    }];
    [self.scrollView addSubview:_chuanYueTableView];
    [_chuanYueTableView release];
}

#pragma mark - 点击导航栏分段控件的方法
-(void)selectbutton:(UISegmentedControl*)sender
{
    //点击不同的分段控件按钮时，把不同的tableView赋值给当前tableViewcontrler的根视图
    if (sender.selectedSegmentIndex == 1) {
        if (!self.zuiXinTableView) {
            [self createZuiXinTableView];
        }
    }
    if (sender.selectedSegmentIndex == 2) {
        
        if (!self.chuanYueTableView) {
            [self createChuanYueTableView];
        }
    }
    // 同步_rootScrollView显示内容
    NSInteger index = sender.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];

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
