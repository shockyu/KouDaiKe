//
//  TWTMenuViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "TWTMenuViewController.h"
#import "TWTMainViewController.h"
#import "TWTSideMenuViewController.h"
#import "YKLActivityListViewController.h"
#import "YKLBaseNavigationController.h"
#import "YKLHighGoActivityListViewController.h"
#import "YKLPrizesActivityListViewController.h"
#import "YKLDuoBaoActivityListViewController.h"
#import "YKLMiaoShaActViewController.h"
#import "YKLSuDingActViewController.h"

@interface TWTMenuViewController ()<TWTMenuViewControllerDelegate,TWTHigHGoMenuViewControllerDelegate,TWTPrizesMenuViewControllerDelegate,TWTDuoBaoMenuViewControllerDelegate,TWTMiaoShaMenuViewControllerDelegate,TWTSuDingMenuViewControllerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@end

@implementation TWTMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    closeButton.frame = CGRectMake(0, 70.0f, 150.0f, 44.0f);
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
    self.selectedImage.frame = CGRectMake(0, 140, 200, 40);
    [self.view addSubview:self.selectedImage];
    
    self.bargainBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.bargainBtn.frame = CGRectMake(30, 140, 150, 40);
    [self.bargainBtn setTitle:@"大砍价" forState:UIControlStateNormal];
    [self.bargainBtn setBackgroundColor:[UIColor clearColor]];
    [self.bargainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bargainBtn addTarget:self action:@selector(changeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bargainBtn];
    
    self.bargainImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bargain_side_icon"]];
    self.bargainImageView.frame = CGRectMake(50, 140+10, 20, 20);
    [self.view addSubview:self.bargainImageView];
    
    self.highShopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.highShopBtn.frame = CGRectMake(30, 190, 150, 40);
    [self.highShopBtn setTitle:@"一元抽奖" forState:UIControlStateNormal];
    [self.highShopBtn setBackgroundColor:[UIColor clearColor]];
    [self.highShopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.highShopBtn addTarget:self action:@selector(changeButtonPressed2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.highShopBtn];
    
    self.highShopImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"higo_side_icon"]];
    self.highShopImageView.frame = CGRectMake(50, 190+10, 20, 20);
    [self.view addSubview:self.highShopImageView];
    
    self.prizesBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.prizesBtn.frame = CGRectMake(30, 240, 150, 40);
    [self.prizesBtn setTitle:@"口袋红包" forState:UIControlStateNormal];
    [self.prizesBtn setBackgroundColor:[UIColor clearColor]];
    [self.prizesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.prizesBtn addTarget:self action:@selector(changeButtonPressed3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.prizesBtn];
    
    self.prizesImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_side_icon"]];
    self.prizesImageView.frame = CGRectMake(50, 240+10, 20, 20);
    [self.view addSubview:self.prizesImageView];
    
    
    self.duoBaoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.duoBaoBtn.frame = CGRectMake(30, 290, 150, 40);
    [self.duoBaoBtn setTitle:@"口袋夺宝" forState:UIControlStateNormal];
    [self.duoBaoBtn setBackgroundColor:[UIColor clearColor]];
    [self.duoBaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.duoBaoBtn addTarget:self action:@selector(changeButtonPressed4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.duoBaoBtn];
    
    self.duoBaoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"duoBao_side_icon"]];
    self.duoBaoImageView.frame = CGRectMake(50, 290+10, 20, 20);
    [self.view addSubview:self.duoBaoImageView];
    
    
//    self.duoBaoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.duoBaoBtn.frame = CGRectMake(30, 340, 150, 40);
//    [self.duoBaoBtn setTitle:@"全民秒杀" forState:UIControlStateNormal];
//    [self.duoBaoBtn setBackgroundColor:[UIColor clearColor]];
//    [self.duoBaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.duoBaoBtn addTarget:self action:@selector(changeButtonPressed5) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.duoBaoBtn];
//    
//    self.duoBaoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"miaosha_side_icon"]];
//    self.duoBaoImageView.frame = CGRectMake(50, 340+10, 20, 20);
//    [self.view addSubview:self.duoBaoImageView];
    
    self.duoBaoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.duoBaoBtn.frame = CGRectMake(30, 340, 150, 40);
    [self.duoBaoBtn setTitle:@"一元速定" forState:UIControlStateNormal];
    [self.duoBaoBtn setBackgroundColor:[UIColor clearColor]];
    [self.duoBaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.duoBaoBtn addTarget:self action:@selector(changeButtonPressed6) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.duoBaoBtn];
    
    self.duoBaoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"suding_side_icon"]];
    self.duoBaoImageView.frame = CGRectMake(50, 340+10, 20, 20);
    [self.view addSubview:self.duoBaoImageView];
    
    
    _showBool = YES;
}

//进入活动列表后自动打开侧边栏
- (void)viewDidAppear:(BOOL)animated{
    
    if (self.showSideMenu == YES) {
        [self.sideMenuViewController openMenuAnimated:YES completion:nil];
        self.showSideMenu = NO;
    }
}

//- (void)closeAnimal{
//    YKLActivityListViewController *actVC = [YKLActivityListViewController new];
//    actVC.naviTitle = @"进行中";
//    actVC.menuDelegate = self;
//    
//    [actVC rightItemClicked];
//    
//    self.sideMenuViewController.title = @"大砍价";
//    
//    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
//    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
//}

//侧滑选择
- (void)changeButtonClicked{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 140, 200, 40);
    }];
    
    //    [self performSelector:@selector(closeAnimal) withObject:nil afterDelay:0.5];
    
    YKLActivityListViewController *actVC = [YKLActivityListViewController new];
    actVC.menuDelegate = self;
    
    [actVC rightItemClicked];
    self.sideMenuViewController.title = @"大砍价";
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

//菜单选择
- (void)changeButtonPressed:(NSString *)navTitle
{
    NSLog(@"%lu",(unsigned long)navTitle.length);
    self.showSideMenu = YES;
    
    YKLActivityListViewController *actVC = [YKLActivityListViewController new];
    
//    [YKLLocalUserDefInfo defModel].actType = navTitle;
//    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    self.sideMenuViewController.title = @"大砍价";
    actVC.menuDelegate = self;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (void)changeButtonPressed2
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 190, 200, 40);
    }];
    
    YKLHighGoActivityListViewController *actVC = [YKLHighGoActivityListViewController new];
    self.sideMenuViewController.title = @"一元抽奖";
    actVC.menuDelegate = self;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

- (void)changeButtonPressed3
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 240, 200, 40);
    }];
    
    YKLPrizesActivityListViewController *actVC = [YKLPrizesActivityListViewController new];
    self.sideMenuViewController.title = @"口袋红包";
    actVC.menuDelegate = self;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
    
}

-(void)changeButtonPressed4{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 290, 200, 40);
    }];
    
    YKLDuoBaoActivityListViewController *actVC = [YKLDuoBaoActivityListViewController new];
    self.sideMenuViewController.title = @"口袋夺宝";
    actVC.menuDelegate = self;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
    
}

- (void)changeButtonPressed5{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 340, 200, 40);
    }];
    
    YKLMiaoShaActViewController *actVC = [YKLMiaoShaActViewController new];
    self.sideMenuViewController.title = @"全民秒杀";
    actVC.menuDelegate = self;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];

}

- (void)changeButtonPressed6{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedImage.frame = CGRectMake(0, 340, 200, 40);
    }];
    
    YKLSuDingActViewController *actVC = [YKLSuDingActViewController new];
    self.sideMenuViewController.title = @"一元速定";
    actVC.menuDelegate = self;
    
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];

}


//代理控制显隐方法
- (void)changeRightItem:(BOOL)i{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"合并发布Icon"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeButtonBargain)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 35, 35);
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _barButtonItem = menuButton;
    
    if (i) {
        self.sideMenuViewController.navigationItem.rightBarButtonItem = _barButtonItem;
    }else{
        self.sideMenuViewController.navigationItem.rightBarButtonItem = nil;
    }
}

//代理控制显隐方法
- (void)changeRightItemHiden:(BOOL)hiden type:(NSString *)type{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"合并发布Icon"]
                      forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 35, 35);
    
    if ([type isEqual:@"秒杀"]) {
        
        [button addTarget:self action:@selector(changeButtonMiaoSha)
         forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if([type isEqual:@"速定"]){
        
        [button addTarget:self action:@selector(changeButtonSuDing)
         forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _barButtonItem = menuButton;
    
    if (hiden) {
        self.sideMenuViewController.navigationItem.rightBarButtonItem = _barButtonItem;
    }else{
        self.sideMenuViewController.navigationItem.rightBarButtonItem = nil;
    }
}

//大砍价合并发布选择
- (void)changeButtonBargain{
    
    YKLActivityListViewController *actVC = [YKLActivityListViewController new];
    
    [YKLLocalUserDefInfo defModel].actType = @"进行中";
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    actVC.menuDelegate = self;
    
    if (_showBool) {
        actVC.showBool = _showBool;
        _showBool = NO;
        
    }else{
        actVC.showBool = _showBool;
        _showBool = YES;
        
    }
    [actVC rightItemClicked];
    
    
    self.sideMenuViewController.title = @"大砍价";
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

//秒杀合并发布选择
- (void)changeButtonMiaoSha{
    
    YKLMiaoShaActViewController *actVC = [YKLMiaoShaActViewController new];
    
    [YKLLocalUserDefInfo defModel].actType = @"进行中";
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    actVC.menuDelegate = self;
    
    if (_showBool) {
        actVC.showBool = _showBool;
        _showBool = NO;
        
    }else{
        actVC.showBool = _showBool;
        _showBool = YES;
        
    }
    [actVC rightItemClicked];
    
    
    self.sideMenuViewController.title = @"全民秒杀";
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

//速定合并发布选择
- (void)changeButtonSuDing{
    
    YKLSuDingActViewController *actVC = [YKLSuDingActViewController new];
    
    [YKLLocalUserDefInfo defModel].actType = @"进行中";
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    actVC.menuDelegate = self;
    
    if (_showBool) {
        actVC.showBool = _showBool;
        _showBool = NO;
        
    }else{
        actVC.showBool = _showBool;
        _showBool = YES;
        
    }
    [actVC rightItemClicked];
    
    
    self.sideMenuViewController.title = @"一元速定";
    YKLBaseNavigationController *controller = [[YKLBaseNavigationController alloc] initWithRootViewController:actVC];
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
