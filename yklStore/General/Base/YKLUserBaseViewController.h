//
//  YKLUserBaseViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLBaseViewController.h"

static const float navbarHeight = 64;

@class YKLUserBaseViewController;

@protocol YKLUserBaseViewControllerSwitchDelegate <NSObject>

- (void)updateTitle:(NSString *)title;
- (void)hideNavBar;
- (void)showNavBar;

@end

@protocol YKLUserBaseViewControllerDelegate <NSObject>

- (void)userCenterBaseViewLeftBarItemClicked:(YKLUserBaseViewController *)userView;

@end

@interface YKLUserBaseViewController : YKLBaseViewController
{
    UIImageView         *_emptyImageView;
}

@property (nonatomic, strong) UIBarButtonItem *backBarItem;

@property (nonatomic, assign) YKLLoginViewType viewType;
@property (nonatomic, weak) id<YKLUserBaseViewControllerSwitchDelegate> switchManager;
@property (nonatomic, weak) id<YKLUserBaseViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, readonly) UIBarButtonItem *leftBarItem;
@property (nonatomic, readonly) NSArray *rightBarItems;
@property (nonatomic, readonly) float rainshedLaceOffset;
@property (nonatomic, readonly) float contentOffsetY;
@property (nonatomic, strong) MBProgressHUD  *loadingHUD;

- (instancetype)initWithUserInfo:(id)info;

- (void)showWithUserInfo:(id)userInfo;
- (void)show;
- (void)hide;

- (void)leftBarItemClicked:(UIBarButtonItem *)sender;
//- (void)activityLeftBarItemClicked:(UIBarButtonItem *)sender;

// 窗体处理
- (void)showEmptyView;
- (void)removeEmptyView;

//- (void)rightBarItemClicked:(UIBarButtonItem *)sender;


// loadingView
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)showAlertMsg:(NSString *)infoStr;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
