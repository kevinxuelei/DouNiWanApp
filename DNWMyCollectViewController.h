//
//  DNWMyCollectViewController.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-18.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNWThirdData;
typedef void(^PushCommitView)(NSString *);
typedef void(^PushViewControllerBlock)(NSString*);
@interface DNWMyCollectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

/**
 *  pushCommitView   block传值,封装后完成回调
 */
@property (nonatomic,copy)PushCommitView pushCommitView;

@property (nonatomic,copy) PushViewControllerBlock    pushedBlock;       //  图片block回调

/**
 *  paperArray  读取数据库中收藏的段子所在的数组
 */
@property (nonatomic,retain)NSMutableArray * paperArray;

@property(nonatomic,retain)NSMutableArray * imageArray;//图片数组

@property (nonatomic,retain)NSMutableArray *allThirdDataArray;
@end
