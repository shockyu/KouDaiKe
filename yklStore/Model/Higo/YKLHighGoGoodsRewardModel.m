//
//  YKLHighGoGoodsRewardModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoGoodsRewardModel.h"

@implementation YKLHighGoGoodsRewardModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];

    self.goodsName = [dicData objectForKey:@"goods_name"];
    self.nickName = [dicData objectForKey:@"nickname"];
    self.reward = [dicData objectForKey:@"reward"];
    self.mobile = [dicData objectForKey:@"mobile"];
    
    return self;
}

@end
