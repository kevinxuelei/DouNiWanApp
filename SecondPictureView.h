//
//  SecondPictureView.h
//  DouNiWan
//
//  Created by apple on 14-5-17.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"
#import "DNWOneCellDataForSecondView.h"

#import "DNWSecondViewTableViewCell.h"
@class MBProgressHUD;

typedef void(^PushViewControllerBlock)(NSString*);

@interface SecondPictureView : UITableView<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic,copy) PushViewControllerBlock    pushedBlock;       //  block回调

@property(nonatomic,retain)NSMutableArray  *receiveArray; //网络连接后接收生成的数组

@property(nonatomic,retain)NSMutableArray  *dataArray;    //tabelView上要用的数据

@property(nonatomic,retain)NSMutableData   *receiveData;  //网络请求结束后接受到的数据



@property(nonatomic,retain)MJRefreshHeaderView *header;

@property(nonatomic,retain)MJRefreshFooterView *footer;

@property(nonatomic,copy)NSString * urlStr;

@property(nonatomic,copy)NSString * frontString;//前半段

@property(nonatomic,copy)NSString * backString;//后半段


@property(nonatomic,retain)DNWOneCellDataForSecondView * cellData;

@property(nonatomic,retain)MBProgressHUD * HUD;  // 提示框


//@property(nonatomic,assign)id<NSURLConnectionDataDelegate>obj;

//-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style url:(NSString *)urlString;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style urlString:(NSString *)urlString;
@end
