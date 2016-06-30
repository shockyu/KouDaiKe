//
//  YKLWithDrawCashModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/30.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLWithDrawCashModel : YKLBaseModel

@property (nonatomic, strong) NSString *money;          //提现金额
@property (nonatomic, strong) NSString *status;         //提现状态 1.提现成功 2.提现中 3.拒绝提现（暂无此操作）
@property (nonatomic, strong) NSString *createTime;     //申请时间
@property (nonatomic, strong) NSString *payTime;        //转账时间
@property (nonatomic, strong) NSString *activityType;   //活动类型 1.大砍价 2.一元嗨 3.口袋红包 4.口袋夺宝
@property (nonatomic, strong) NSString *nickname;       //用户名
@property (nonatomic, strong) NSString *mobile;         //手机号码

//若作为收支明细时，desc为内容，status 1.收入 2.支出
@property (nonatomic, strong) NSString *desc;           //明细内容
@end
