//
//  YKLUserBaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

//@interface YKLUserBaseViewController ()
//
//@end

@implementation YKLUserBaseViewController

- (instancetype)initWithUserInfo:(id)info {
    return [super init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height-navbarHeight)];
    self.contentView.layer.masksToBounds = YES;
    [self.view addSubview:self.contentView];
    
    self.backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
//    self.backBarItem.enabled = NO;
    [self.navigationItem setBackBarButtonItem:self.backBarItem];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 44, 44);
//    
//    [backBtn setImage:[UIImage imageNamed:@"箭头hover"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(leftBarItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (UIBarButtonItem *)leftBarItem {
    //    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(leftBarItemClicked:)];
    return self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked:)];
}

- (void)showWithUserInfo:(id)userInfo {
    [self show];
}

- (void)show {
    self.contentView.top = 0;
}

- (void)hide {
    self.contentView.top = self.contentView.height;
}

- (void)leftBarItemClicked:(UIBarButtonItem *)sender {
    
//    [self.delegate userCenterBaseViewLeftBarItemClicked:self];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (void)activityLeftBarItemClicked:(UIBarButtonItem *)sender {
////    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"您确定取消活动发布吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
////    
////    [alertView show];
//}

//#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//       
//        //发布活动键盘未收起推出时闪屏修改,延迟两个0.25来执行键盘收起的动画。
//        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
//        
//    }
//}

//- (void)popHidden{
////    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)hideNavBar {
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)showNavBar {
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)showEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
    
    _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 568)];
    _emptyImageView.image = [UIImage imageNamed:@"no_data"];
    [self.view addSubview:_emptyImageView];
}

- (void)removeEmptyView
{
    if (_emptyImageView)
    {
        [_emptyImageView removeFromSuperview];
        _emptyImageView = nil;
    }
}

#pragma mark - Loading

- (void)refrehBaseHUD
{
    if (_loadingHUD)
    {
        [_loadingHUD removeFromSuperview];
        _loadingHUD = nil;
    }
    
    if (!_loadingHUD)
    {
        _loadingHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _loadingHUD.minSize = CGSizeMake(60, 60);
        
        [self.view addSubview:_loadingHUD];
    }
}

- (void)showLoadingViewWithTitle:(NSString *)title
{
    [self refrehBaseHUD];
    
    _loadingHUD.labelText = title;
    [_loadingHUD show:YES];
}

- (void)showAlertMsg:(NSString *)infoStr;
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = infoStr;
    [hud hide:YES afterDelay:5.0];
    hud.backgroundColor = [UIColor blackColor];

}

- (void)showLoadingView
{
    [self refrehBaseHUD];
    
    [_loadingHUD show:YES];
}

- (void)hideLoadingView
{
    [_loadingHUD hide:YES];
}

@end
