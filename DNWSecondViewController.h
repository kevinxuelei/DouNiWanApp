//
//  DNWSecondViewController.h
//  DouNiWan
//
//  Created by apple on 14-5-17.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondPictureView.h"

@interface DNWSecondViewController : UIViewController<UIScrollViewDelegate>
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)SecondPictureView *jinghuaTableView;
@property(nonatomic,retain)SecondPictureView *zuiXinTableView;
@property(nonatomic,retain)SecondPictureView *chuanYueTableView;

@property (nonatomic,retain)UIImageView * bottomImageView;
@end
