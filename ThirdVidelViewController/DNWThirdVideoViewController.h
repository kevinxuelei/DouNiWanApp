//
//  DNWThirdVideoViewController.h
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNWThirdData;
#import "MJRefresh.h"

@interface DNWThirdVideoViewController : UITableViewController<UICollectionViewDelegateFlowLayout>


@property (nonatomic,retain)NSMutableArray *allVideoDataArray;//用来接收初始化是网络请求的到得数组存储并给下面的展示接收数据放到该数组中

@property (nonatomic,copy)NSString *cTimeString;//用来接收cTime刷新时需要用来拼接网址

@property (nonatomic,retain)DNWThirdData *thirdDataCTime;//获取第十五个数据的cTime时需要用ThirdData接收

//用来实现下拉刷新(系统自带方法不全面)
//@property (nonatomic,retain) UIRefreshControl* refreshControl;

@property (nonatomic,retain)NSMutableArray *array;//

@property (nonatomic,retain)UIImageView * bottomImageView;


@end
