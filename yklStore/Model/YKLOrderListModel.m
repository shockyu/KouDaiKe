//
//  YKLOrderListModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLOrderListModel.h"

@implementation YKLOrderListModel
- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.activityID = [dicData objectForKey:@"activity_id"];
    self.buyerID = [dicData objectForKey:@"buyer_id"];
    self.mobile = [dicData objectForKey:@"mobile"];
    self.buyerName = [dicData objectForKey:@"buyer_name"];
    self.coverImg = [dicData objectForKey:@"cover_img"];
    self.goodsID = [dicData objectForKey:@"buyer_id"];
    self.goodsName = [dicData objectForKey:@"goods_name"];
    self.goodsBasePrice = [dicData objectForKey:@"goods_base_price"];
    self.goodsOriginalPrice = [dicData objectForKey:@"goods_original_price"];
    self.orderAmount = [dicData objectForKey:@"order_amount"];
    self.addTime = [[dicData objectForKey:@"add_time"] timeNumber];
    self.orderType = [dicData objectForKey:@"type"];
    
    return self;
}
@end
