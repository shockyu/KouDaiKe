//
//  YKLHighGoActivityListModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/6.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivityListModel.h"

@implementation YKLHighGoActivityListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.activityID = [dicData objectForKey:@"id"];
    self.title = [dicData objectForKey:@"title"];
    self.shopName = [dicData objectForKey:@"shop_name"];
    self.desc = [dicData objectForKey:@"desc"];
    
    NSString *str=[dicData objectForKey:@"end_time"];//时间戳
    self.activityEndTime = [str timeNumber];
    
    NSArray *goodsArr = [NSArray arrayWithArray:[dicData objectForKey:@"goods"]];
    if (![goodsArr  isEqual: @[]]) {
        
        NSDictionary *goodsDic = goodsArr[0];
        NSArray *imageArr = [NSArray arrayWithArray:[goodsDic objectForKey:@"goods_img"]];
        if (![imageArr  isEqual: @[]]) {
            self.coverImg = imageArr[0];
        }else{
            self.coverImg = @"";
        }
    }
    
    self.templateID = [dicData objectForKey:@"template_id"];
    self.rewardCode = [dicData objectForKey:@"reward_code"];
    self.status = [dicData objectForKey:@"status"];
    self.type = [dicData objectForKey:@"type"];
    self.shareUrl = [dicData objectForKey:@"share_url"];
    self.shareDesc = [dicData objectForKey:@"share_desc"];
    
    NSString *strName = [YKLLocalUserDefInfo defModel].userName;
    self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
    
    self.shareImage = [dicData objectForKey:@"share_img"];
    
    self.templatePrice = [dicData objectForKey:@"price"];
    
    self.createTime = [dicData objectForKey:@"create_time"];

    self.joinNum = [[dicData objectForKey:@"join_num"] isEqual:@""] ? @"0": [dicData objectForKey:@"join_num"];
    self.successNum = [dicData objectForKey:@"success_num"];
    
    return self;
}

@end
