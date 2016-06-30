//
//  YKLZZSLecturerModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/2/24.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLZZSLecturerModel.h"

@implementation YKLZZSLecturerModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.LecturerID = [dicData objectForKey:@"id"];
    self.lecturerName = [dicData objectForKey:@"lecturer_name"];
    self.headImg = [dicData objectForKey:@"head_img"];
    self.addTime = [[dicData objectForKey:@"add_time"]timeNumber];
    self.updateTime = [dicData objectForKey:@"update_time"];
    self.status = [dicData objectForKey:@"status"];
    
    return self;
}

@end
