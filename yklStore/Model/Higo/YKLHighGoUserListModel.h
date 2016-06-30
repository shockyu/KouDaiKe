//
//  YKLHighGoUserListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/6.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLHighGoUserListModel : YKLBaseModel

@property (nonatomic, copy) NSString *payPrice;                  //付款价格
@property (nonatomic, copy) NSString *mobile;                    //联系电话
@property (nonatomic, copy) NSString *nickName;                  //昵称
@property (nonatomic, copy) NSString *wxNickName;                  //昵称
@property (nonatomic, copy) NSString *prizeName;                 //奖品名

@property (nonatomic, copy) NSString *addTime;                   //添加时间
@property (nonatomic, copy) NSString *indianaName;               //奖品名

@property (nonatomic, copy) NSString *userType;                  //1.代金券 2.奖品
@property (nonatomic, copy) NSString *voucherValue;              //代金券金额

@end
