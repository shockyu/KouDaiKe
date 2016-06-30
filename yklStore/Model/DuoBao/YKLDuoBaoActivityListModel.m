//
//  YKLDuoBaoActivityListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/7.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoActivityListModel.h"

@implementation YKLDuoBaoActivityListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.activityID = [dicData objectForKey:@"id"];
    self.title = [dicData objectForKey:@"indiana_title"];
    self.shopName = [dicData objectForKey:@"shop_name"];
    self.desc = [dicData objectForKey:@"indiana_desc"];
    
    NSString *str=[dicData objectForKey:@"end_time"];//时间戳
    self.activityEndTime = [str timeNumber];
    
    self.coverImg = [dicData objectForKey:@"indiana_photo"];

    self.rewardCode = [dicData objectForKey:@"reward_code"];
    self.status = [dicData objectForKey:@"status"];
    self.couponType = [dicData objectForKey:@"coupon_type"];
    self.couponBrand = [dicData objectForKey:@"coupon_brand"];
    self.createTime = [dicData objectForKey:@"add_time"];

    self.shareImage = [dicData objectForKey:@"share_img"];
    self.shareUrl = [dicData objectForKey:@"share_url"];
    self.shareDesc = [dicData objectForKey:@"share_desc"];
    NSString *strName = [YKLLocalUserDefInfo defModel].userName;
    self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
    
    self.successNum = [dicData objectForKey:@"success_num"] == NULL? @"0":[dicData objectForKey:@"success_num"];
    self.joinNum = [dicData objectForKey:@"join_num"] == NULL? @"0":[dicData objectForKey:@"join_num"];
    
    self.redeemed = [dicData objectForKey:@"redeemed"] == NULL? @"0":[dicData objectForKey:@"redeemed"];
    
    return self;
}

@end
