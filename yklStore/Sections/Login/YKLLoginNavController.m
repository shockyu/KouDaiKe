//
//  YKLLoginNavController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLLoginNavController.h"

#import "YKLLoginViewController.h"
#import "YKLActivityListViewController.h"
#import "YKLMainMenuViewController.h"
@interface YKLLoginNavController ()

@end

@implementation YKLLoginNavController

- (instancetype)init {
    return [super initWithRootViewController:[[YKLLoginViewController alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"箭头"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setShadowImage:[UIImage imageNamed:@"箭头红色"]];

//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头红色"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];

   
}

- (void)doBack {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
