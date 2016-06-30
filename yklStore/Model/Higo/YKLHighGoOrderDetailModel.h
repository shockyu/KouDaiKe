//
//  YKLHighGoOrderDetailModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLHighGoOrderDetailModel : YKLBaseModel

@property (nonatomic, copy) NSString *goodsID;                  //商品ID
@property (nonatomic, copy) NSString *goodsImg;                 //商品图片
@property (nonatomic, copy) NSString *goodsName;                //商品名
@property (nonatomic, copy) NSString *joinNum;                  //参与人数
@property (nonatomic, copy) NSString *mobile;                   //手机号
@property (nonatomic, copy) NSString *nickName;                 //昵称

@end
