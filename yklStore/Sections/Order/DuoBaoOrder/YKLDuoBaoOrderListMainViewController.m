//
//  YKLDuoBaoOrderListMainViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/1.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoOrderListMainViewController.h"
//#import "YKLPrizesOrderListMainView.h"
//#import "YKLPrizesOrderListViewController.h"
#import "YKLDuoBaoOrderListMainView.h"
#import "YKLDuobaoOrderListViewController.h"
#import "TWTSideMenuViewController.h"

@interface YKLDuoBaoOrderListMainViewController ()<YKLDuoBaoOrderListMainViewDelegate>

@end

@implementation YKLDuoBaoOrderListMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    YKLDuoBaoOrderListMainView *listView = [[YKLDuoBaoOrderListMainView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, ScreenHeight-64)];
    
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

- (void)consumerOrderListView:(YKLDuoBaoOrderListMainView *)listView didSelectOrder:(YKLHighGoOrderListModel *)model {
    //[self.switchManager switchToNextViewWithType:MPSUserViewTypeOrderDetail userInfo:model];
    
    YKLDuobaoOrderListViewController *VC = [YKLDuobaoOrderListViewController new];
    VC.orderID = model.orderID;
    VC.orderName = model.title;
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end

