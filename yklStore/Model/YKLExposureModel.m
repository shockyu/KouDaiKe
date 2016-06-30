//
//  YKLExposureModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/12.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLExposureModel.h"

@implementation YKLExposureModel


- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.exposureNum = [dicData objectForKey:@"exposure_num"];
    self.createTime = [dicData objectForKey:@"create_time"];
    
    return self;
}

@end
