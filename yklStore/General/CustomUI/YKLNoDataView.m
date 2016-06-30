//
//  YKLNoDataView.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/7.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLNoDataView.h"

@implementation YKLNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无数据"]];
        imageView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:imageView];
        
    }
    return self;
}

@end
