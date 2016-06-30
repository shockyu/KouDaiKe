//
//  YKLDuoBaoOrderListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/7.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoOrderListModel.h"

@implementation YKLDuoBaoOrderListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.orderID = [dicData objectForKey:@"id"];
    self.title = [dicData objectForKey:@"indiana_title"];
    self.goodsImg = [dicData objectForKey:@"indiana_photo"];
//    self.shopName = [dicData objectForKey:@"shop_name"];
    self.joinNum = [dicData objectForKey:@"join_num"];
    self.sucNum = [dicData objectForKey:@"success_num"];
    self.createTime = [[dicData objectForKey:@"add_time"]timeNumber];
    
//    self.playerNum = [dicData objectForKey:@"player_num"];
//    self.totalPrize = [dicData objectForKey:@"total_prize"];
    return self;
}

@end
