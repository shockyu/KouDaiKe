    //
//  YKLRedActivityListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/21.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLRedActivityListModel.h"

@implementation YKLRedActivityListModel
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
    
    NSDictionary *shareDict = [dicData objectForKey:@"template"];
    self.shareDesc = [shareDict objectForKey:@"share_desc"];
    NSString *strName = [YKLLocalUserDefInfo defModel].userName;
    self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
    self.shareImage = [shareDict objectForKey:@"share_img"];
    
    self.createTime = [dicData objectForKey:@"create_time"];
    
    self.flowCount = [dicData objectForKey:@"f_count"] == NULL? @"0":[dicData objectForKey:@"f_count"];
    self.prizesCount = [dicData objectForKey:@"p_count"] == NULL? @"0":[dicData objectForKey:@"p_count"];
    
    self.surplusFlowNum = [dicData objectForKey:@"surplus_f_num"] == NULL? @"0":[dicData objectForKey:@"surplus_f_num"];
    self.surplusPrizesNum = [dicData objectForKey:@"surplus_p_num"] == NULL? @"0":[dicData objectForKey:@"surplus_p_num"];

    
    self.playerNum = [dicData objectForKey:@"player_num"];
    
    return self;
}

@end
