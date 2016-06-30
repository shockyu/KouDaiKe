//
//  YKLWebViewController.h
//  yklStore
//
//  Created by 王硕 on 16/5/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLWebViewController : YKLUserBaseViewController<UIWebViewDelegate>

@property(nonatomic, retain) NSString *lcUrl;

@end
