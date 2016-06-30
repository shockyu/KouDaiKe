//
//  YKLPushWebViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/14.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLPushWebViewController : YKLUserBaseViewController

@property (nonatomic,strong) UIWebView *pushWeb;
@property (strong, nonatomic) NSString *webTitle;
@property (strong, nonatomic) NSString *webURL;
@property (strong, nonatomic) NSMutableURLRequest *request;

//是否隐藏BarButtonItem
@property BOOL hidenBar;

@end
