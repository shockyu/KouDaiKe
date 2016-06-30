//
//  YKLHighGoOrderDetailModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoOrderDetailModel.h"

@implementation YKLHighGoOrderDetailModel
- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.goodsID = [dicData objectForKey:@"id"];
    self.goodsImg = [dicData objectForKey:@"goods_img"];
    self.goodsName = [dicData objectForKey:@"goods_name"];
    self.nickName = [dicData objectForKey:@"nickname"];
    self.joinNum = [dicData objectForKey:@"join_num"];
    self.mobile = [dicData objectForKey:@"mobile"];
  
    
    return self;
}
@end
