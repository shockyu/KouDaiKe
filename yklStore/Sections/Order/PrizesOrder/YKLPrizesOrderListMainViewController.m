//
//  YKLPrizesOrderListMainViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/15.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPrizesOrderListMainViewController.h"
#import "YKLPrizesOrderListMainView.h"
#import "YKLPrizesOrderListViewController.h"
#import "TWTSideMenuViewController.h"

@interface YKLPrizesOrderListMainViewController ()<YKLPrizesOrderListMainViewDelegate>

@end

@implementation YKLPrizesOrderListMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YKLPrizesOrderListMainView *listView = [[YKLPrizesOrderListMainView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, ScreenHeight-64)];
    
    listView.delegate = self;
    [self.view addSubview:listView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 50);
    leftButton.centerY = self.view.height/2;
    [leftButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"leftButton1"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationController setNavigationBarHidden:YES];
    
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)consumerOrderListView:(YKLPrizesOrderListMainView *)listView didSelectOrder:(YKLHighGoOrderListModel *)model {
    //        [self.switchManager switchToNextViewWithType:MPSUserViewTypeOrderDetail userInfo:model];
    
    YKLPrizesOrderListViewController *VC = [YKLPrizesOrderListViewController new];
    VC.orderID = model.orderID;
    VC.orderName = model.title;
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
