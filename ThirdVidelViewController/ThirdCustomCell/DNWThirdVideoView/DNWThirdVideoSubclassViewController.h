//
//  DNWThirdVideoSubclassViewController.h
//  DouNiWan
//
//  Created by chenfengchang on 14-5-9.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNWThirdData;
@class  DNWVideoPlayView;
#import "DNWMainViewController.h"

@interface DNWThirdVideoSubclassViewController : UIViewController<UITableViewDelegate>


@property (nonatomic,retain)DNWThirdData *thirdData;

@property (nonatomic,retain) DNWVideoPlayView * videoPlayView;

@end
