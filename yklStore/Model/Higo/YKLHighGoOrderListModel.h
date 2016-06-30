//
//  YKLHighGoOrderListModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/10.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLHighGoOrderListModel : YKLBaseModel

@property (nonatomic, copy) NSString *orderID;                  //订单ID
@property (nonatomic, copy) NSString *title;                    //订单标题
@property (nonatomic, copy) NSString *goodsImg;                 //商品图片
@property (nonatomic, copy) NSString *shopName;                 //店铺名
@property (nonatomic, copy) NSString *joinNum;                  //参与人数
@property (nonatomic, copy) NSString *sucNum;                   //成功商品个数
@property (nonatomic, copy) NSString *createTime;               //创建时间

@property (nonatomic, copy) NSString *playerNum;                //总共参与人数
@property (nonatomic, copy) NSString *totalPrize;               //总共已发红包个数

@end
