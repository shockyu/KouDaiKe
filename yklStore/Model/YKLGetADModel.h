//
//  YKLGetADModel.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/28.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLGetADModel : YKLBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *adDesc;
@property (nonatomic, copy) NSString *adImg;
@property (nonatomic, copy) NSString *jumpType;//1.app内页面跳转  2.web

@end
