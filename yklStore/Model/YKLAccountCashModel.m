//
//  YKLAccountCashModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/22.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLAccountCashModel.h"

@implementation YKLAccountCashModel

+ (YKLAccountCashModel *)defAccountCashModel{
    static YKLAccountCashModel *CashModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CashModel = [[YKLAccountCashModel alloc] init];
    });
    return CashModel;
}

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    
    self.money = [dicData objectForKey:@"money"];
    self.totalRevenue = [dicData objectForKey:@"total_revenue"];
    self.txMoney = [dicData objectForKey:@"tx_money"];
    
    _tempDict = [dicData objectForKey:@"bank"];
    if ([_tempDict isEqual:@""]) {
        self.bankAccount = @"暂无";
        return self;
    }
    self.accountHolder = [_tempDict objectForKey:@"account_holder"];
    self.bankAccount = [_tempDict objectForKey:@"bank_account"];
    self.bankName = [_tempDict objectForKey:@"bank_name"];
    self.bankID = [_tempDict objectForKey:@"id"];
    self.isDefault = [_tempDict objectForKey:@"is_default"];
    self.type = [_tempDict objectForKey:@"type"];
    
    return self;
}
@end
