//
//  YKLMiaoShaActViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"

@protocol TWTMiaoShaMenuViewControllerDelegate <NSObject>

- (void)changeRightItem:(BOOL)i;

- (void)changeRightItemHiden:(BOOL)hiden type:(NSString *)type;

@end

@interface YKLMiaoShaActViewController : YKLUserBaseViewController

@property (nonatomic, assign) id<TWTMiaoShaMenuViewControllerDelegate> menuDelegate;

@property (nonatomic, strong)YKLMiaoShaActivityListModel *activityListSummaryModel;

@property BOOL showBool;

- (void)rightItemClicked;//点击合并分享

@end

