//
//  YKLPrizesActivityListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/13.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"
#import "YKLPrizesActivityListView.h"
#import "YKLPrizesActivitiyListDetailViewController.h"
#import "YKLPrizesReleaseViewController.h"

@protocol TWTPrizesMenuViewControllerDelegate <NSObject>

- (void)changeRightItem:(BOOL)i;

@end

@interface YKLPrizesActivityListViewController : YKLUserBaseViewController

@property (nonatomic, assign) id<TWTPrizesMenuViewControllerDelegate> menuDelegate;

@property (nonatomic, strong)YKLRedActivityListModel *activityListSummaryModel;

@end
