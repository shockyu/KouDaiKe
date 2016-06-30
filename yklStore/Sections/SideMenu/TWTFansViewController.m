//
//  TWTFansViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "TWTFansViewController.h"
#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"

#import "YKLOrderListViewController.h"
#import "YKLHighGoOrderListMainViewController.h"
#import "YKLBaseNavigationController.h"

#import "YKLActivityFansListViewController.h"

@interface TWTFansViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation TWTFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor flatLightBlackColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"galaxy"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];
    
    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(0, 120.0f, 150.0f, 44.0f);
    [closeButton setBackgroundColor:[UIColor clearColor]];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"支付情况" forState:UIControlStateNormal];
    closeButton.titleLabel.font  = [UIFont systemFontOfSize:26];
    [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10.0f, closeButton.bottom+10, 200.0f, 1.0f)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    self.selectedImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"侧边栏选择按钮.png"]];
    self.selectedImage.frame = CGRectMake(0, 200, 200, 44);
    [self.view addSubview:self.selectedImage];

    self.bargainBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bargainBtn.frame = CGRectMake(10.0f, 200.0f, 150.0f, 44.0f);
    [self.bargainBtn setTitle:@"已在线支付" forState:UIControlStateNormal];
    [self.bargainBtn setBackgroundColor:[UIColor clearColor]];
    [self.bargainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bargainBtn addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bargainBtn];
    
    self.highShopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.highShopBtn.frame = CGRectMake(10.0f, 260.0f, 150.0f, 44.0f);
    [self.highShopBtn setTitle:@"未在线支付" forState:UIControlStateNormal];
    [self.highShopBtn setBackgroundColor:[UIColor clearColor]];
    [self.highShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.highShopBtn addTarget:self action:@selector(changeButtonPressed2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.highShopBtn];
    
}

//进入活动列表后自动打开侧边栏
- (void)viewDidAppear:(BOOL)animated{
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)changeButtonPressed{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 200, 200, 44);
    }];
    
    self.sideMenuViewController.title = @"已在线支付";
    
    YKLActivityFansListViewController *fansListVC = [YKLActivityFansListViewController new];
    fansListVC.activityID = self.detailModel.activityID;
    fansListVC.fansType = @"";//不传参数，全部人数
    fansListVC.payType = @"2";
    fansListVC.listTitle = @"已在线支付";
    fansListVC.hideSideButton = NO;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:fansListVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];

}

- (void)changeButtonPressed2
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 260, 200, 44);
    }];
    
    self.sideMenuViewController.title = @"未在线支付";
    
    YKLActivityFansListViewController *fansListVC = [YKLActivityFansListViewController new];
    fansListVC.activityID = self.detailModel.activityID;
    fansListVC.fansType = @"";//不传参数，全部人数
    fansListVC.payType = @"1";
    fansListVC.listTitle = @"未在线支付";
    fansListVC.hideSideButton = NO;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:fansListVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
    
}

- (void)openButtonPressed{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
    
}

- (void)closeButtonPressed
{
    [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
