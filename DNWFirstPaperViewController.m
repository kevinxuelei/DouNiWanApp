//
//  DNWFirstPapersViewController.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

//  火热段子接口
#define EssencePaperURL  @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page=1&type=29&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
#define FrontEssencePaperString @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page="
#define BackEssencePaperString  @"&type=29&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"

//  最新段子接口
#define BestNewPaperURL  @"http://api.budejie.com/api/api_open.php?c=data&a=newlist&from=ios&per=20&page=0&type=29&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
#define FrontBestNewPaperString @"http://api.budejie.com/api/api_open.php?c=data&a=newlist&from=ios&per=20&page="
#define BackBestNewPaperString  @"&type=29&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"

//  穿越段子接口
#define ArcrandomPaperURL  @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page=0&type=29&order=timewarp&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"
#define FrontArcrandomPaperString @"http://api.budejie.com/api/api_open.php?c=data&a=list&from=ios&per=20&page="
#define BackArcandomPaperString   @"&type=29&order=timewarp&client=iphone&market=&ver=2.7&device=iPhone%205&uid=&sex=&udid=&mac=02:00:00:00:00:00&openudid=6d71aee970f8ea09602b0b08d914f5e3bddd031e&asid=67E2FAF1-18A3-423E-9BF8-4248922D30BA&jbk=0&appname=baisibudejie"


#import "DNWFirstPaperViewController.h"
#import "DNWCustomWeatherView.h"
#import "DNWFirstPagesTableView.h"
#import "DNWAllDataHandle.h"
#import "DNWCommitViewController.h"
#import "DNWWeatherData.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface DNWFirstPaperViewController (){

    UISegmentedControl * _segmentView;
    UIScrollView * _rootScrollView;
    DNWCustomWeatherView * _weatherView;
    DNWWeatherData * _weatherData;
    NSTimer * _timer;
    
    BOOL isCreateBestView;      //  标志是否已经创建最新视图
    BOOL isCreateAndomView;     //  标志是否已经创建随机视图
    
    MBProgressHUD * _HUD;
    DNWFirstPagesTableView * _pagesTableView;
}

@end

@implementation DNWFirstPaperViewController

- (void)dealloc{

    //  Block_release(_pushWeatherData);
    RELEASE_SAFELY(_bottomImageView);
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
    
    // 解决收藏中段子被取消收藏后,主页面段子依旧是被收藏的状态的Bug
    [_pagesTableView reloadData];
    
    [UIView animateWithDuration:0.18 animations:^{
        self.bottomImageView.frame = CGRectMake(0, ScreenHeight -49, ScreenWidth, 49);
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];
    
    [self createNavigationBarLeftView];
    
    [self createRootScrollView];
    
    [self createWeatherView];
    
    [self createSegmentedControlView];
    
    //  默认是火热tableView(仔细观察发现,在viewDidLoad里面创建和在外部创建,所起的Y坐标是不一样的)
    [self createEssenceTableView];
    
}

#pragma mark - 创建左侧图标
- (void)createNavigationBarLeftView{

    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 35, 35)];
    iconImageView.image = [UIImage imageNamed:@"logo"];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:iconImageView]autorelease];
    [iconImageView release];}

#pragma mark - segmentedControl分页控制器
- (void)createSegmentedControlView{

    NSArray * segmentArray = @[@"火热",@"最新",@"穿越"];
    _segmentView = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentView.frame = CGRectMake(100, 24, 120, 36);
    _segmentView.momentary = NO;
    _segmentView.selectedSegmentIndex = 0;
    //_segmentView.tintColor = [UIColor colorWithRed:228/255.0 green:153/255.0 blue:39/255.0 alpha:1.0];
    _segmentView.tintColor = [UIColor whiteColor];
    //_segmentView.backgroundColor = [UIColor colorWithRed:228/255.0 green:153/255.0 blue:39/255.0 alpha:1.0];
    ////[_segmentView setImage:[UIImage imageNamed:@"title_btnleft"] forSegmentAtIndex:0];
    _segmentView.backgroundColor = [UIColor brownColor];
    [_segmentView addTarget:self action:@selector(didClickSegmentView:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentView;
    [_segmentView release];
}

#pragma mark - 创建并显示天气状况labelView
- (void)createWeatherView{

    _weatherView = [[DNWCustomWeatherView alloc] initWithFrame:CGRectMake(240, 0, 80, 44)];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_weatherView]autorelease];
    
    _weatherData = [[DNWWeatherData alloc] init];
    
    [_weatherData setPassWeatherData:^(DNWWeatherData * weatherData){
        
        // 传递请求到的天气给其他界面
//        if (_pushWeatherData) {
//            _pushWeatherData(weatherData);
//        }
        
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

    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.delegate = self;
    _rootScrollView.scrollsToTop = NO;
    
    [self.view addSubview:_rootScrollView];
    [_rootScrollView release];

}

#pragma mark - 创建要显示的tableView-Modal
- (void)createBaseTableViewWithRect:(CGRect)frame UrlString:(NSString *)urlString FrontString:(NSString *)frontString BackString:(NSString *)backString{
    
      _pagesTableView = [[DNWFirstPagesTableView alloc] initWithFrame:frame style:UITableViewStylePlain urlString:urlString];
    _pagesTableView.frontString = frontString;
    _pagesTableView.backString = backString;
    [_rootScrollView addSubview:_pagesTableView];
    [_pagesTableView release];
    
    // 防止循环引用,预防内存泄露
    __block DNWFirstPaperViewController * otherSelf = self;
    [_pagesTableView setPushCommitView:^(NSString * url){
        
        DNWCommitViewController * commitVC = [[DNWCommitViewController alloc] init];
        commitVC.getCommitUrl = url;
        [otherSelf.navigationController pushViewController:commitVC animated:YES];
        [commitVC release];
        
        [UIView animateWithDuration:0.18 animations:^{
            otherSelf.bottomImageView.frame = CGRectMake(0, ScreenHeight+10, ScreenWidth, 49);
        } completion:^(BOOL finished) {
            
        }];
        
    }];

}
#pragma mark - 创建精华tableView
- (void)createEssenceTableView{
    
    [self createBaseTableViewWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight) UrlString:EssencePaperURL FrontString:FrontEssencePaperString BackString:BackEssencePaperString];
}

#pragma mark - 创建最新tableView
- (void)createBestNewTableView{
    
    [self createBaseTableViewWithRect:CGRectMake(320, 0, ScreenWidth, ScreenHeight) UrlString:BestNewPaperURL FrontString:FrontBestNewPaperString BackString:BackBestNewPaperString];
}

#pragma mark - 创建随机穿越tableView
- (void)createArcrandomTableView{

    [self createBaseTableViewWithRect:CGRectMake(640, 0, ScreenWidth, ScreenHeight) UrlString:ArcrandomPaperURL FrontString:FrontArcrandomPaperString BackString:BackArcandomPaperString];

}


#pragma mark - 点击segmentIndex
- (void)didClickSegmentView:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex == 1) {
        
        if (isCreateBestView == NO) {
            [self createBestNewTableView];
            isCreateBestView = YES;
        }else{
        }
    }
    
    if (seg.selectedSegmentIndex == 2) {
        
        if (isCreateAndomView == NO) {
            [self createArcrandomTableView];
            isCreateAndomView = YES;
        }
    }
    
    // 同步_rootScrollView显示内容
    NSInteger index = seg.selectedSegmentIndex;
    [_rootScrollView setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
    
}

#pragma mark - 开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    #pragma mark 嵌套判断是因为只用了同一个TableView类,网络请求有延迟,可能第二个还没请求完就被第三个覆盖掉了
    if (isCreateBestView == NO) {
        
        [self createBestNewTableView];
        isCreateBestView = YES;
    }else{
       
        if (isCreateAndomView == NO) {
            [self createArcrandomTableView];
            isCreateAndomView = YES;
        }else{
          
        }
        
    }
//    [UIView animateWithDuration:0.18 animations:^{
//        self.bottomImageView.frame = CGRectMake(0, ScreenHeight +10, ScreenWidth, 49);
//    } completion:^(BOOL finished) {
//        
//    }];

}

#pragma mark - 结束滑动,用来同步改变_segmentView对应的selectedSegmentIndex
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger nowIndex = scrollView.contentOffset.x / 320.0 ;
    _segmentView.selectedSegmentIndex = nowIndex;
//    [UIView animateWithDuration:0.18 animations:^{
//        self.bottomImageView.frame = CGRectMake(0, ScreenHeight -49, ScreenWidth, 49);
//    } completion:^(BOOL finished) {
//        
//    }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end