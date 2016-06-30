//
//  YKLTemplateModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLTemplateModel : YKLBaseModel

@property (nonatomic, copy) NSString *templateID;
@property (nonatomic, copy) NSString *templateName;
@property (nonatomic, copy) NSString *templateThumb;
@property (nonatomic, copy) NSString *templateImage;
@property (nonatomic, copy) NSString *bgImage;
@property (nonatomic, copy) NSString *templateDesc;
@property (nonatomic, copy) NSString *templateMoney;
@property (nonatomic, copy) NSString *templateStatus;
@property (nonatomic, copy) NSString *layout;           //产品排列参数
@property (nonatomic, copy) NSString *goodsNum;         //产品个数



@end
