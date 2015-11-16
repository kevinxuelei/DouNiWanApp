//
//  DNWPaperData.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-10.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#import "DNWPaperData.h"

@implementation DNWPaperData

- (void)dealloc{

    RELEASE_SAFELY(_hostId);
    RELEASE_SAFELY(_hostImageUrl);
    RELEASE_SAFELY(_hostImage);
    RELEASE_SAFELY(_hostName);
    RELEASE_SAFELY(_passTime);
    RELEASE_SAFELY(_paperText);
    RELEASE_SAFELY(_favouriteNumber);
    RELEASE_SAFELY(_hateNumber);
    RELEASE_SAFELY(_shareNumber);
    RELEASE_SAFELY(_discussNumber);
    RELEASE_SAFELY(_commentUrl);
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dic{

    if (self = [super init]) {
        
        self.hostId          = [dic objectForKey:@"id"];
        self.hostImageUrl    = [dic objectForKey:@"profile_image"];
        self.hostName        = [dic objectForKey:@"name"];
        self.passTime        = [dic objectForKey:@"passtime"];
        self.paperText       = [dic objectForKey:@"text"];
        self.favouriteNumber = [dic objectForKey:@"love"];
        self.hateNumber      = [dic objectForKey:@"hate"];
        self.shareNumber     = [dic objectForKey:@"repost"];
        self.discussNumber   = [dic objectForKey:@"comment"];
        self.commentUrl      = [dic objectForKey:@"weixin_url"];
        self.isLoveOrHate    = YES;
    }
    
    return self;

}


@end
