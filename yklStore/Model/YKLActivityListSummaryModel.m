//
//  MPSConsumerOrderSummaryModel.m
//  MPStore
//
//  Created by apple on 14/12/6.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLActivityListSummaryModel.h"

@implementation YKLActivityListSummaryModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.activityID = [dicData objectForKey:@"id"];
    self.title = [dicData objectForKey:@"title"];
    self.desc = [dicData objectForKey:@"desc"];
    self.originalPrice = [dicData objectForKey:@"original_price"];
    self.basePrice = [dicData objectForKey:@"base_price"];
    self.productNum = [dicData objectForKey:@"product_num"];
    self.startBargain = [dicData objectForKey:@"start_bargain"];
    self.endBargain = [dicData objectForKey:@"end_bargain"];
    self.playerNum = [dicData objectForKey:@"player_num"];
    self.activityEndTime = [dicData objectForKey:@"activity_end_time"];
    self.coverImg = [dicData objectForKey:@"cover_img"];
    self.templateID = [dicData objectForKey:@"template_id"];
    self.rewardCode = [dicData objectForKey:@"reward_code"];
    
    self.status = [dicData objectForKey:@"status"];
    self.type = [dicData objectForKey:@"type"];
    self.playersNum = [dicData objectForKey:@"players_num"];
    self.playersOverNum = [dicData objectForKey:@"players_over_num"];
    self.exposureNum = [dicData objectForKey:@"exposure_num"];
    self.shareUrl = [dicData objectForKey:@"share_url"];
    self.shareDesc = [dicData objectForKey:@"share_desc"];
    
   
    NSString *strName = [YKLLocalUserDefInfo defModel].userName;
    self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
    

    self.shareImage = [dicData objectForKey:@"share_img"];
    
    self.orderVol = [dicData objectForKey:@"order_vol"];
    self.orderSale = [dicData objectForKey:@"order_sale"];
    
    self.templatePrice = [dicData objectForKey:@"price"];
    
    self.createTime = [dicData objectForKey:@"create_time"];
    self.tmallPrice = [dicData objectForKey:@"tmall_price"];
    self.onlinePayPrivilege = [dicData objectForKey:@"online_pay_privilege"];
    
    return self;
}

@end
