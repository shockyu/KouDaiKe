//
//  YKLTemplateModel.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLTemplateModel.h"

@implementation YKLTemplateModel


- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.templateID = [dicData objectForKey:@"id"];
    self.templateName = [dicData objectForKey:@"title"];
    self.templateThumb = [dicData objectForKey:@"thumb"];
    self.templateImage = [dicData objectForKey:@"share_img"];
    self.bgImage = [dicData objectForKey:@"banner"];
    self.templateDesc = [dicData objectForKey:@"desc"];
    self.templateMoney = [dicData objectForKey:@"price"];
    self.templateStatus = [dicData objectForKey:@"status"];
    self.layout = [dicData objectForKey:@"layout"];
    self.goodsNum = [dicData objectForKey:@"goods_num"];

    return self;
}

@end
