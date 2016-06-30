//
//  YKLBaseNavigationController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseNavigationController.h"

@interface YKLBaseNavigationController ()

@end

@implementation YKLBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage imageNamed:@"navbar_shadow"]];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor blackColor];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
}

@end
