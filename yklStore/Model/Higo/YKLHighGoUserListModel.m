//
//  YKLHighGoUserListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/6.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLHighGoUserListModel.h"

@implementation YKLHighGoUserListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
   
    self.mobile = [dicData objectForKey:@"mobile"];
    self.nickName = [dicData objectForKey:@"nickname"];
    self.wxNickName = [dicData objectForKey:@"wx_nickname"];
    
    self.payPrice = [dicData objectForKey:@"pay_price"];
    self.prizeName = [dicData objectForKey:@"prize_name"];
    self.addTime = [[dicData objectForKey:@"add_time"]timeNumber];
    self.indianaName = [dicData objectForKey:@"indiana_title"];
    self.voucherValue = [dicData objectForKey:@"voucher_value"]==NULL?@"":[dicData objectForKey:@"voucher_value"];
    self.userType = [dicData objectForKey:@"user_type"] == NULL ? @"":[dicData objectForKey:@"user_type"];

    return self;
}

@end
