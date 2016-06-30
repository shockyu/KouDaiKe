//
//  YKLShopAdressListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/12.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLShopAdressListModel : YKLBaseModel

@property (nonatomic, copy) NSString *addressID;               //地址ID
@property (nonatomic, copy) NSString *shopID;                  //商户ID
@property (nonatomic, copy) NSString *province;                //省
@property (nonatomic, copy) NSString *city;                    //市
@property (nonatomic, copy) NSString *area;                    //区
@property (nonatomic, copy) NSString *address;                 //街道地址

@property (nonatomic, copy) NSString *isDefault;               //是否为默认地址 1.是 2.不是
@property (nonatomic, copy) NSString *addTime;                 //添加时间
@property (nonatomic, copy) NSString *consigneeName;           //收件人姓名
@property (nonatomic, copy) NSString *consigneeMobile;         //收件人电话

@end
