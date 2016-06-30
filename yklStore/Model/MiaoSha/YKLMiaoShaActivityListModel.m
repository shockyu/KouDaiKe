//
//  YKLMiaoShaActivityListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMiaoShaActivityListModel.h"

@implementation YKLMiaoShaActivityListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.activityID = [dicData objectForKey:@"id"];
    self.title = [dicData objectForKey:@"good_name"];
    self.seckillPrice = [dicData objectForKey:@"seckill_price"];
    self.goodsPrice = [dicData objectForKey:@"goods_price"];
    
    self.joinNum = [[dicData objectForKey:@"join_num"] isEqual:@""] ? @"0": [dicData objectForKey:@"join_num"];
    self.successNum = [[dicData objectForKey:@"success_num"] isEqual:@""] ? @"0": [dicData objectForKey:@"success_num"];
    self.exposureNum = [[dicData objectForKey:@"exposure_num"] isEqual:@""] ? @"0": [dicData objectForKey:@"exposure_num"];
    
    self.redeemed = [[dicData objectForKey:@"redeemed"] isEqual:@""] ? @"0": [dicData objectForKey:@"redeemed"];
    
    self.sortTime = [[dicData objectForKey:@"seckill_end"]timeNumber];
    self.continueTime = [dicData objectForKey:@"continue_time"];
    self.createTime = [NSString timeNumberHHmm:[dicData objectForKey:@"create_time"]];
    self.startTime = [NSString timeNumberHHmm:[dicData objectForKey:@"start_time"]];
    self.endTime = [NSString timeNumberHHmm:[dicData objectForKey:@"seckill_end"]];
    
//    NSInteger time = [[dicData objectForKey:@"start_time"] integerValue];
//    NSInteger continueTime = [self.continueTime integerValue];
//    NSInteger endTime = time+continueTime*60;
//    self.endTime = [NSString timeNumberHHmm:[NSString stringWithFormat:@"%ld",(long)endTime]];
    
    NSArray *imageArr = [NSArray arrayWithArray:[dicData objectForKey:@"head_img"]];
    if (![imageArr  isEqual: @[]]) {
        self.coverImg = imageArr[0];
    }else{
        self.coverImg = @"";
    }

    
    self.templateID = [dicData objectForKey:@"template_id"];
    self.shareUrl = [dicData objectForKey:@"share_url"];
    self.shareDesc = [dicData objectForKey:@"share_desc"];
    NSString *strName = [YKLLocalUserDefInfo defModel].userName;
    self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
    self.shareImage = [dicData objectForKey:@"share_img"];
    
    return self;
}
@end
