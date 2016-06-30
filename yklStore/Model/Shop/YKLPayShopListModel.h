//
//  YKLPayShopListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLPayShopListModel : YKLBaseModel

@property (nonatomic, copy) NSString *buyerName;                //购买者姓名
@property (nonatomic, copy) NSString *addTime;                  //添加时间
@property (nonatomic, copy) NSString *goodsNum;                 //商品个数
@property (nonatomic, copy) NSString *headImg;                  //头像
@property (nonatomic, copy) NSString *units;                    //单位
@end
