//
//  YKLGetADModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/28.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLGetADModel.h"

@implementation YKLGetADModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.title = [dicData objectForKey:@"title"];
    self.link = [dicData objectForKey:@"link"];
    self.adDesc = [dicData objectForKey:@"ad_desc"];
    self.adImg = [dicData objectForKey:@"ad_img"];
    self.jumpType = [dicData objectForKey:@"jump_type"];
    
    return self;
}

@end
