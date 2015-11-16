//
//  DNWEssenceTableView.h
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

/**
 *  封装一个类,继承自UITableView
 *
 *  @param  段子页面,UISegmentedControl下3个页面架构一样,我就构思封装一个tableView,只通过改变请求的接口网址,来实现完成所有页面重用
 *
 *  @return 自定义的tableView对象
 */

#import <UIKit/UIKit.h>

typedef void(^PushCommitView)(NSString *);

@interface DNWFirstPagesTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

/**
 *  allDataArray     段子对象的数组
 *  momentDataArray  临时对象数组,用于下拉刷新或者上拉加载
 */
@property (nonatomic,retain)NSMutableArray * allDataArray;
@property (nonatomic,retain)NSMutableArray * momentDataArray;

/**
 *  pushCommitView   block传值,封装后完成回调
 */
@property (nonatomic,copy)PushCommitView pushCommitView;

/**
 *  frontString  接口前半段
 *  backString   接口后半段
 */
@property (nonatomic,copy)NSString * frontString;
@property (nonatomic,copy)NSString * backString;

/**
 *  自定义初始化方法
 *
 *  @param frame     frame
 *  @param style     style
 *  @param urlString 需要显示内容的请求网址
 *
 *  @return 所需求的tableView对象
 */
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style urlString:(NSString *)urlString;

@end
