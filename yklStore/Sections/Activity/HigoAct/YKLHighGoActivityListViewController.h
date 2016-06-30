//
//  YKLHighGoActivityListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "YKLHighGoActivityListView.h"
#import "TWTSideMenuViewController.h"
#import "TWTMenuViewController.h"
#import "YKLHighGoActivitiyListDetailViewController.h"
//部分导入在YKLHighGoActivityListView


@protocol TWTHigHGoMenuViewControllerDelegate <NSObject>

- (void)changeRightItem:(BOOL)i;

@end

@interface YKLHighGoActivityListViewController : YKLUserBaseViewController
//{
//    NSString *_naviTitle;
//}
//@property(nonatomic,retain)NSString *naviTitle;

@property (nonatomic, assign) id<TWTHigHGoMenuViewControllerDelegate> menuDelegate;

@end
