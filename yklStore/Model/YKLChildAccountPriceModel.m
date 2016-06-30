//
//  YKLChildAccountPriceModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/16.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLChildAccountPriceModel.h"

@implementation YKLChildAccountPriceModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.price = [dicData objectForKey:@"price"];
    self.minNum = [dicData objectForKey:@"min_num"];
    self.maxNum = [dicData objectForKey:@"max_num"];
    
    return self;
}

@end
