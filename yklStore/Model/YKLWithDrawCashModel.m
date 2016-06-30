//
//  YKLWithDrawCashModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/30.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLWithDrawCashModel.h"

@implementation YKLWithDrawCashModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.money = [dicData objectForKey:@"money"];
    self.status = [dicData objectForKey:@"status"];
    self.createTime = [dicData objectForKey:@"create_time"];
    self.payTime = [dicData objectForKey:@"pay_time"];
    self.activityType = [dicData objectForKey:@"activity_type"];
    self.nickname = [dicData objectForKey:@"nickname"];
    self.mobile = [dicData objectForKey:@"mobile"];
    
    self.desc = [dicData objectForKey:@"body"];
    return self;
}

@end
