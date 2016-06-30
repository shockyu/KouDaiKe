//
//  YKLDuoBaoActivityListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/1.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"

#import "YKLDuoBaoActivityListView.h"
#import "YKLDuoBaoActivityListDetailViewController.h"
#import "YKLDuoBaoReleaseViewController.h"

@protocol TWTDuoBaoMenuViewControllerDelegate <NSObject>

- (void)changeRightItem:(BOOL)i;

@end

@interface YKLDuoBaoActivityListViewController : YKLUserBaseViewController

@property (nonatomic, assign) id<TWTDuoBaoMenuViewControllerDelegate> menuDelegate;

@property (nonatomic, strong)YKLDuoBaoActivityListModel *activityListSummaryModel;

@end
