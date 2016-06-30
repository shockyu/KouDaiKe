//
//  YKLAuthorFansModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLAuthorFansModel.h"

@implementation YKLAuthorFansModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.userId = [dicData objectForKey:@"id"];
    self.nickName = [dicData objectForKey:@"lianxiren"];
    self.mobile = [dicData objectForKey:@"mobile"];
    self.shopName = [dicData objectForKey:@"shop_name"];
    self.address = [dicData objectForKey:@"address"];
    self.street = [dicData objectForKey:@"street"];
    self.authorizationTime = [dicData objectForKey:@"authorization_time"];
    
    return self;
}

@end
