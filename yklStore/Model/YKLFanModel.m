//
//  YKLFanModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/10/6.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLFanModel.h"

@implementation YKLFanModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
//    self.userId = [dicData objectForKey:@"user_id"];
//    self.sex = [dicData objectForKey:@"sex"];
//    self.province = [dicData objectForKey:@"province"];
//    self.city = [dicData objectForKey:@"city"];
    
    self.nickName = [dicData objectForKey:@"nickname"];
    self.mobile = [dicData objectForKey:@"mobile"];
    self.headImgUrl = [dicData objectForKey:@"headimgurl"];
    
    self.orderAmount = [dicData objectForKey:@"order_amount"];
    
    self.paymentTime = [dicData objectForKey:@"payment_time"];
    self.paymentTime = [self.paymentTime isEqual:@"0"] ? @"暂无" : [self.paymentTime timeNumber];
    
    self.finnshedTime = [dicData objectForKey:@"finnshed_time"];
    self.finnshedTime = [self.finnshedTime isEqual:@"0"] ? @"暂无" : [self.finnshedTime timeNumber];
    
    return self;
}
@end
