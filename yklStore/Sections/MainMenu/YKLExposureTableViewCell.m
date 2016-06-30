//
//  YKLExposureTableViewCell.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/12.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLExposureTableViewCell.h"

@implementation YKLExposureTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10,self.width/2, 30)];
        self.createTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.createTimeLabel.text = @"";
        self.createTimeLabel.textColor = [UIColor lightGrayColor];
        self.createTimeLabel.font = [UIFont systemFontOfSize:14];
//        self.createTimeLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.createTimeLabel];
        
        self.exposureNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.createTimeLabel.right,10,self.width/2, 30)];
        self.exposureNumLabel.textAlignment = NSTextAlignmentCenter;
        self.exposureNumLabel.text = @"";
        self.exposureNumLabel.textColor = [UIColor flatLightBlueColor];
        self.exposureNumLabel.font = [UIFont systemFontOfSize:14];
//        self.exposureNumLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.exposureNumLabel];
        
    
    }
    return self;
}

@end
