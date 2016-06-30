//
//  TWTOrderViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/18.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "TWTOrderViewController.h"
#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"

#import "YKLOrderListViewController.h"
//#import "YKLHighGoOrderListViewController.h"
#import "YKLHighGoOrderListMainViewController.h"
#import "YKLPrizesOrderListMainViewController.h"
#import "YKLBaseNavigationController.h"
#import "YKLDuoBaoOrderListMainViewController.h"

@interface TWTOrderViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation TWTOrderViewController

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
    [closeButton setTitle:@"所有活动" forState:UIControlStateNormal];
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
    self.bargainBtn.frame = CGRectMake(30, 200, 150, 44);
    [self.bargainBtn setTitle:@"大砍价" forState:UIControlStateNormal];
    [self.bargainBtn setBackgroundColor:[UIColor clearColor]];
    [self.bargainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bargainBtn addTarget:self action:@selector(changeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bargainBtn];
    
    self.bargainImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"砍价侧边栏图标.png"]];
    self.bargainImageView.frame = CGRectMake(50, 200+12, 20, 20);
    [self.view addSubview:self.bargainImageView];
    
    
    self.highShopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.highShopBtn.frame = CGRectMake(30, 260, 150, 44);
    [self.highShopBtn setTitle:@"一元抽奖" forState:UIControlStateNormal];
    [self.highShopBtn setBackgroundColor:[UIColor clearColor]];
    [self.highShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.highShopBtn addTarget:self action:@selector(changeButtonPressed2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.highShopBtn];
    
    self.highShopImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"一元嗨购侧边栏图标.png"]];
    self.highShopImageView.frame = CGRectMake(50, 260+12, 20, 20);
    [self.view addSubview:self.highShopImageView];
    
    self.prizesBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.prizesBtn.frame = CGRectMake(30, 320, 150, 44);
    [self.prizesBtn setTitle:@"口袋红包" forState:UIControlStateNormal];
    [self.prizesBtn setBackgroundColor:[UIColor clearColor]];
    [self.prizesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.prizesBtn addTarget:self action:@selector(changeButtonPressed3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.prizesBtn];
    
    self.prizesImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"红包侧边栏图标.png"]];
    self.prizesImageView.frame = CGRectMake(50, 320+12, 20, 20);
    [self.view addSubview:self.prizesImageView];
    
    self.duoBaoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.duoBaoBtn.frame = CGRectMake(30, 380, 150, 44);
    [self.duoBaoBtn setTitle:@"口袋夺宝" forState:UIControlStateNormal];
    [self.duoBaoBtn setBackgroundColor:[UIColor clearColor]];
    [self.duoBaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.duoBaoBtn addTarget:self action:@selector(changeButtonPressed4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.duoBaoBtn];
    
    self.duoBaoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"口袋夺宝侧边栏.png"]];
    self.duoBaoImageView.frame = CGRectMake(50, 380+12, 20, 20);
    [self.view addSubview:self.duoBaoImageView];

    
}

//进入活动列表后自动打开侧边栏
- (void)viewDidAppear:(BOOL)animated{
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}



- (void)changeButtonPressed{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 200, 200, 44);
    }];
    
    self.sideMenuViewController.title = @"大砍价";
    YKLOrderListViewController *vc = [YKLOrderListViewController new];
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:vc];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (void)changeButtonPressed2
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 260, 200, 44);
    }];
    
    self.sideMenuViewController.title = @"一元抽奖";
    YKLHighGoOrderListMainViewController *vc = [YKLHighGoOrderListMainViewController new];
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:vc];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
    
}

- (void)changeButtonPressed3
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 320, 200, 44);
    }];
    
    self.sideMenuViewController.title = @"口袋红包";
    YKLPrizesOrderListMainViewController *vc = [YKLPrizesOrderListMainViewController new];
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:vc];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

-(void)changeButtonPressed4{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 380, 200, 44);
    }];
    
    self.sideMenuViewController.title = @"口袋夺宝";
    YKLDuoBaoOrderListMainViewController *vc = [YKLDuoBaoOrderListMainViewController new];
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:vc];
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
