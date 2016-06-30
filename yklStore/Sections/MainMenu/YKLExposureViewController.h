//
//  YKLExposureViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/12.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLExposureViewController : YKLUserBaseViewController

@property (strong, nonatomic) NSString *shopID;

- (void)requestMoreProduct;

@end
