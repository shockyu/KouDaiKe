//
//  YKLChildAccountPriceModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/6/16.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLChildAccountPriceModel : YKLBaseModel

@property (nonatomic, strong) NSString *price;           //价格
@property (nonatomic, strong) NSString *minNum;          //区间最小
@property (nonatomic, strong) NSString *maxNum;          //区间最大

@end
