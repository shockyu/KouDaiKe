//
//  YKLHighGoGoodsRewardModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLHighGoGoodsRewardModel : YKLBaseModel

@property (nonatomic, copy) NSString *goodsName;                //商品名
@property (nonatomic, copy) NSString *reward;                   //代金券金额
@property (nonatomic, copy) NSString *nickName;                 //昵称
@property (nonatomic, copy) NSString *mobile;                   //手机号码

@end
