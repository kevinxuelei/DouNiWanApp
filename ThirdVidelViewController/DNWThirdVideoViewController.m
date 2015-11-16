//
//  DNWThirdVideoViewController.m
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWThirdVideoViewController.h"
#import "DNWThirdCustomCell.h"
#import "DNWThirdVideoSubclassViewController.h"
#import "DNWAllDataHandle.h"
#import "DNWThirdData.h"
#import "UIImageView+WebCache.h"
#import "HMTMyCustomNetRequest.h"
#import "MJRefresh.h"
#import "DNWCollectDataHandle.h"
#import "Reachability.h"
#import "DNWWeatherData.h"
#import "DNWCustomWeatherView.h"
#import "DXAlertView.h"
#import "CustomAlertView.h"
#import  "MBProgressHUD.h"

#define VoidURL   @"http://xiaoliao.sinaapp.com/index.php/Api366/index/cid/video/p/1/markId/0/date/"
#define VoidURL2  @"http://xiaoliao.sinaapp.com/index.php/Api368/index/cid/video/lastTime/%@"

@interface DNWThirdVideoViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *footer;//设定上拉加载更多(使用第三方进行刷新)
    MJRefreshHeaderView *header;//设定下拉刷新(使用第三方MJ进行刷新)
    
    DNWCustomWeatherView * _weatherView;
    DNWWeatherData * _weatherData;
    NSTimer * _timer;
    MBProgressHUD * _HUD;

}

@property (nonatomic,retain)Reachability * reach;


@end

@implementation DNWThirdVideoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"视频";//设置title
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title"] forBarMetrics:UIBarMetricsDefault];

    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 35, 35)];
    iconImageView.image = [UIImage imageNamed:@"logo"];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:iconImageView]autorelease];
    [iconImageView release];
    
#pragma mark -初始化获取数据---
    
    __block DNWThirdVideoViewController * block = self;
    [[DNWAllDataHandle sharedInstance]getAllThirdDataWithUrl:VoidURL];
    [[DNWAllDataHandle sharedInstance]setReposeVideoDataBlock:^(NSMutableArray *allVideoDataArray){
        block.allVideoDataArray = allVideoDataArray; //用数组接收
        block.thirdDataCTime=[_allVideoDataArray objectAtIndex:14]; //获取数组中第十五个数据的cTime
        block.cTimeString = _thirdDataCTime.cTime;
        
        [block.tableView reloadData];//刷新页面展示到页面上
        
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
#pragma mark----上拉加载(初始化)---------
    footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    
#pragma mark----下拉刷新(初始化)---------
    header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    
    [self createWeatherView];
    
    [self refreshFromHeadViewOfBlock];
    [self refreshFromFootViewOfBlock];

    
}

#pragma mark - 下拉刷新
- (void)refreshFromHeadViewOfBlock{

    __block DNWThirdVideoViewController * otherSelf = self;
    [header setBeginRefreshingBlock:^(MJRefreshBaseView * refreshView){
        
        otherSelf.reach = [Reachability reachabilityWithHostName:HostName];
        if ([_reach currentReachabilityStatus] == NotReachable) {
            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^() {
            };
            [alert release];
            [refreshView endRefreshing];
        }
        
        [[DNWAllDataHandle sharedInstance]getAllThirdDataWithUrl:VoidURL];
        [[DNWAllDataHandle sharedInstance]setReposeVideoDataBlock:^(NSMutableArray *allVideoDataArray){
            
            otherSelf.allVideoDataArray = allVideoDataArray;
            otherSelf.thirdDataCTime=[_allVideoDataArray objectAtIndex:[_allVideoDataArray count]-1]; //获取数组中第十五个数据的cTime
            otherSelf.cTimeString = _thirdDataCTime.cTime;
            /**
             *  刷新页面
             *  结束刷新
             */
            [otherSelf.tableView reloadData];
            [refreshView endRefreshing];
            
            
        }];
        
    }];

}

#pragma mark - 上拉加载
- (void)refreshFromFootViewOfBlock{
    
    __block DNWThirdVideoViewController * otherSelf = self;
    [footer setBeginRefreshingBlock:^(MJRefreshBaseView * refreshView){
       
        //  检测网络状态
        otherSelf.reach = [Reachability reachabilityWithHostName:HostName];
        if ([_reach currentReachabilityStatus] == NotReachable) {
            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络不可用" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^() {
            };
            [alert release];
            [refreshView endRefreshing];
        }
        
        NSString *string =[NSString stringWithFormat:VoidURL2,_cTimeString];
        [[DNWAllDataHandle sharedInstance]getallThirdAddDataWithUrl:string];
        [[DNWAllDataHandle sharedInstance]setReposeThirdVideoAddDataBlock:^(NSMutableArray *allVideoDataArray){
            /**
             *  获取加载数据
             *  获得数据源中需要的数据
             *  把得到的数据存到数组中展示到页面上
             */
            otherSelf.array = allVideoDataArray;
            
            for (int i=0; i<[_array count]; i++) {
                [_allVideoDataArray addObject:[_array objectAtIndex:i]];
            }
            otherSelf.thirdDataCTime=[_allVideoDataArray objectAtIndex:[_allVideoDataArray count]-1];
            otherSelf.cTimeString = _thirdDataCTime.cTime;
            /**
             *  刷新页面
             *  结束刷新
             */
            [otherSelf.tableView reloadData];
            [refreshView endRefreshing];
        }];

        
    }];
    
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.18 animations:^{
        self.bottomImageView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -----显示有多少个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -----每个区有多少行--------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_allVideoDataArray count];
}

#pragma mark-----设置行高(自适应行高)----
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNWThirdData * thirdData = [_allVideoDataArray objectAtIndex:indexPath.row];
    return [DNWThirdCustomCell cellHight:thirdData];
}

#pragma mark-----创建cell--------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DNWThirdData *thirdData = [_allVideoDataArray objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"Cell";
    
    DNWThirdCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[DNWThirdCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    
    }

    cell.thirdData = thirdData;//给cell赋值显示在cell上
    cell.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:241/255.0 alpha:1.0];
    
    __block DNWThirdVideoViewController * otherSelf = self;
#pragma mark 实现举报
    [cell setReportBlock:^(){
        
        otherSelf.reach = [Reachability reachabilityWithHostName:HostName];
        if ([_reach currentReachabilityStatus] == NotReachable) {
            
            DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"当前网络未连接" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            alert.rightBlock = ^() {
            };
            [alert release];
            
        }else{
            
            CustomAlertView * alert = [[CustomAlertView alloc] initWithTitle:@"我要举报" cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
            [alert setOtherBlcok:^(){
                
                [otherSelf reportAlertView];
                
            }];
            [alert setCancelBlock:^(){
            }];
            [alert release];
        }
    }];

    
    if ([[DNWCollectDataHandle shareInstance] electThirdDataWithId:thirdData.Id]== YES) {
        
        [cell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        
    } else {
        [cell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
    }
    [cell setPassCollectBlock:^(){
        
        if ([[DNWCollectDataHandle shareInstance] electThirdDataWithId:thirdData.Id]== NO) {
            
            [self createBaseMBProgressHUDWithText:@"收藏成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
            [_HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_HUD removeFromSuperview];
                [_HUD release];
                _HUD = nil;
                [cell.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                [[DNWCollectDataHandle  shareInstance] insertNewDNWThirdData:thirdData];
            }];

        } else {
            [self createBaseMBProgressHUDWithText:@"取消成功" withMode:MBProgressHUDModeCustomView withImageName:@"37x-Checkmark"];
            [_HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [_HUD removeFromSuperview];
                [_HUD release];
                _HUD = nil;
                [[DNWCollectDataHandle shareInstance] deleteDNWThirdData:thirdData];
                [cell.collectButton setImage:[UIImage imageNamed:@"uncollect"] forState:UIControlStateNormal];
            }];
        }
        
    }];

    /**
     *  关闭cell的交互只能实现Button实现方法
     */
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
   
    /**
     *  Block的回调实现push出DNWThirdVideoSubclassViewController类
     */
    __block DNWThirdVideoViewController *myVC = self;
    [cell changBackGround:^{
        
        [myVC pushDNWThirdVideoSubclassViewController:indexPath];
        
    }];
    
    return cell;
}


#pragma mark-----推出DNWThirdVideoSubclassViewController实现过程----
- (void)pushDNWThirdVideoSubclassViewController:(NSIndexPath *)indesPath
{
    
    if (self.interfaceOrientation==UIDeviceOrientationPortrait) {
        
        DNWThirdVideoSubclassViewController *ThirdVideoSubclassVC = [[DNWThirdVideoSubclassViewController alloc]init];
      
        DNWThirdData *thirdData = [_allVideoDataArray objectAtIndex:indesPath.row];
       
        ThirdVideoSubclassVC.thirdData = thirdData ;
        
        [self.navigationController pushViewController:ThirdVideoSubclassVC animated:YES];
        [ThirdVideoSubclassVC release];
            
        [UIView animateWithDuration:0.18 animations:^{
            self.bottomImageView.frame = CGRectMake(0, ScreenHeight+10, ScreenWidth, 49);
        } completion:^(BOOL finished) {
            
        }];

    }
}

#pragma mark - 创建Base提示框
- (void)createBaseMBProgressHUDWithText:(NSString *)text withMode:(MBProgressHUDMode)mode withImageName:(NSString *)imageName{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
    _HUD.dimBackground = YES;
    //  提示文字
    _HUD.labelText = text;
    //  提示框类型
    _HUD.mode = mode;
    _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
}

#pragma mark - 本地举报提示
- (void)reportAlertView{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.labelText = @"正在举报";
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
        // 清除缓存
        
        
    } completionBlock:^{
        
        [_HUD removeFromSuperview];
        [_HUD release];
        _HUD = nil;
        
        _HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        [self.tableView addSubview:_HUD];
        _HUD.dimBackground = YES;
        _HUD.labelText = @"举报成功,谢谢您的参与";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] autorelease];
        [_HUD showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            
            [_HUD removeFromSuperview];
            [_HUD release];
            _HUD = nil;
        }];
    }];
    
}



/**
 *  释放
 */
- (void)dealloc
{
    [footer free];
    [header free];
    RELEASE_SAFELY(_bottomImageView);
    RELEASE_SAFELY(_weatherData);
    RELEASE_SAFELY(_array);
   
    RELEASE_SAFELY(_allVideoDataArray);
    RELEASE_SAFELY(_thirdDataCTime);
    RELEASE_SAFELY(_cTimeString);
    RELEASE_SAFELY(_reach);
    [super dealloc];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
