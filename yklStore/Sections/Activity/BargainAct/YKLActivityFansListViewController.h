//
//  YKLActivityFansListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/13.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"

@class YKLFunsListView;
@protocol YKLConsumerOrderListViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLFunsListView *)listView didSelectOrder:(YKLOrderListModel *)model;

@end

@interface YKLFunsListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLConsumerOrderListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic, strong) YKLOrderListModel *model;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, strong) UIWebView *callWebView;
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *fansType;
@property (nonatomic, strong) NSString *payType;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;

- (instancetype)initWithFrame:(CGRect)frame
                    orderType:(YKLOrderListType)type
                   ActivityID:(NSString *)activityID
                     FansType:(NSString *)fansType
                      PayType:(NSString *)payType;

- (void)refreshList;

@end

@interface YKLActivityFansListViewController : YKLUserBaseViewController

@property (nonatomic, strong) NSString *fansType;
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *listTitle;
@property (nonatomic, strong) NSString *payType;

@property BOOL hideSideButton;
@end
