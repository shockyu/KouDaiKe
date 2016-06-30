//
//  YKLHighGoOrderListModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/10.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoOrderListModel.h"

@implementation YKLHighGoOrderListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.orderID = [dicData objectForKey:@"id"];
    self.title = [dicData objectForKey:@"title"];
    self.goodsImg = [dicData objectForKey:@"goods_img"];
    self.shopName = [dicData objectForKey:@"shop_name"];
    self.joinNum = [dicData objectForKey:@"join_num"];
    self.sucNum = [dicData objectForKey:@"suc_num"];
    self.createTime = [[dicData objectForKey:@"create_time"]timeNumber];
    
    self.playerNum = [dicData objectForKey:@"player_num"];
    self.totalPrize = [dicData objectForKey:@"total_prize"];
    return self;
}
@end
