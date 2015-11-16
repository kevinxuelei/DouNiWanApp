//
//  DNWOneCellDataForSecondView.m
//  DouNiWan
//
//  Created by apple on 14-5-12.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWOneCellDataForSecondView.h"

@implementation DNWOneCellDataForSecondView
-(void)dealloc
{
    RELEASE_SAFELY(_hostId);
    RELEASE_SAFELY(_iconImageUrl);
    RELEASE_SAFELY(_nameString);
    RELEASE_SAFELY(_timeString);
    RELEASE_SAFELY(_titleString);
    RELEASE_SAFELY(_mainImageUrl);
    RELEASE_SAFELY(_agreeCount);
    RELEASE_SAFELY(_disagreeCount);
    RELEASE_SAFELY(_shareCount);
    RELEASE_SAFELY(_discussCount);
    RELEASE_SAFELY(_mainImageHigh);
    RELEASE_SAFELY(_mainImageWidth);
    RELEASE_SAFELY(_shareUrl);
    [super dealloc];
}
-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.hostId  = [dic objectForKey:@"id"];
        self.iconImageUrl  = [dic objectForKey:@"profile_image"];
        self.nameString    = [dic objectForKey:@"screen_name"];
        self.timeString    = [dic objectForKey:@"created_at"];
        self.titleString   = [dic objectForKey:@"text"];
        self.mainImageUrl  = [dic objectForKey:@"image2"];
        self.agreeCount    = [dic objectForKey:@"love"];
        self.disagreeCount = [dic objectForKey:@"hate"];
        self.shareCount    = [dic objectForKey:@"forward"];
        self.discussCount  = [dic objectForKey:@"comment"];
        self.mainImageHigh = [dic objectForKey:@"height"];
        self.mainImageWidth= [dic objectForKey:@"width"];
        self.shareUrl = [dic objectForKey:@"weixin_url"];
        self.k = YES;
        
    }
    return self;
}

@end
