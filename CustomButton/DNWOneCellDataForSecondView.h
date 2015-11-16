//
//  DNWOneCellDataForSecondView.h
//  DouNiWan
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNWOneCellDataForSecondView : NSObject
@property(nonatomic,copy)NSString * hostId;
@property(nonatomic,copy)NSString * iconImageUrl;
@property(nonatomic,copy)NSString * nameString;
@property(nonatomic,copy)NSString * timeString;
@property(nonatomic,copy)NSString * titleString;
@property(nonatomic,copy)NSString * mainImageUrl;
@property(nonatomic,copy)NSString * agreeCount;
@property(nonatomic,copy)NSString * disagreeCount;
@property(nonatomic,copy)NSString * shareCount;
@property(nonatomic,copy)NSString * discussCount;
@property(nonatomic,copy)NSString * mainImageHigh;
@property(nonatomic,copy)NSString * mainImageWidth;
@property(nonatomic,copy)NSString * shareUrl;
@property(nonatomic,assign)BOOL k;
-(id)initWithDictionary:(NSDictionary*)dic;


@end
