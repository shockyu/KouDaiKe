//
//  YKLPayShopListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLPayShopListModel.h"

@implementation YKLPayShopListModel


- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.buyerName = [dicData objectForKey:@"buyer_name"];
    self.addTime = [NSString timeNumberHHmm:[dicData objectForKey:@"add_time"]];
    self.goodsNum = [dicData objectForKey:@"goods_num"];
    self.headImg = [dicData objectForKey:@"head_img"];
    self.units = [dicData objectForKey:@"units"];
    
    return self;
}

@end
