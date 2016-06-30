//
//  YKLSuDingActViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/5.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"

@protocol TWTSuDingMenuViewControllerDelegate <NSObject>

- (void)changeRightItem:(BOOL)i;

- (void)changeRightItemHiden:(BOOL)hiden type:(NSString *)type;

@end

@interface YKLSuDingActViewController : YKLUserBaseViewController

@property (nonatomic, assign) id<TWTSuDingMenuViewControllerDelegate> menuDelegate;

@property (nonatomic, strong)YKLMiaoShaActivityListModel *activityListSummaryModel;

@property BOOL showBool;

- (void)rightItemClicked;//点击合并分享

@end
