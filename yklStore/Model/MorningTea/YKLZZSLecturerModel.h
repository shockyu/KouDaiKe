//
//  YKLZZSLecturerModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/2/24.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLZZSLecturerModel : YKLBaseModel

@property (nonatomic, copy) NSString *LecturerID;               //讲师ID
@property (nonatomic, copy) NSString *lecturerName;             //讲师名
@property (nonatomic, copy) NSString *headImg;                  //讲师头像
@property (nonatomic, copy) NSString *addTime;                  //添加时间
@property (nonatomic, copy) NSString *updateTime;               //更新时间
@property (nonatomic, copy) NSString *status;                   //状态

@end
