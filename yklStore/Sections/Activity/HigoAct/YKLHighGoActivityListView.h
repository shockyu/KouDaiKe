//
//  YKLHighGoActivityListView.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "YKLActivityListSummaryModel.h"
#import "YKLHighGoActivityListModel.h"
#import "YKLHighGOActivityListTableViewCell.h"
#import "YKLShareContentModel.h"
#import "YKLShareViewController.h"
#import "YKLActivityListDetailViewController.h"
//#import "YKLReleaseViewController.h"
//#import "YKLHighGoRealeaseViewController.h"
#import "YKLHighGoRealeaseMainViewController.h"
#import "YKLLoginViewController.h"
#import "XHJDRefreshView.h"


@class YKLHighGoActivityListView;
@protocol YKLHighGoActivityListViewDelegate <NSObject>

- (void)showHigoActivityListTypeIngDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model;

- (void)showYKLHigoActivityListTypeWaitDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model;
- (void)showYKLHigoActivityListTypeEndDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model;

//跳转分享页面
- (void)showShareViewDidSelectHigoOrder:(YKLHighGoActivityListModel *)model isPay:(NSString *)isPay;

- (void)payViewHigoDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID;
@end


@interface YKLHighGoActivityListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLHighGoActivityListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLActivityListType type;
@property (nonatomic, strong) YKLHighGoActivityListModel *model;
@property (nonatomic, strong) NSString *deletActivityID;

//按月份展开的数据处理
@property (nonatomic, strong) NSMutableArray *doneData;     //所有月份字典的数组
@property (nonatomic, strong) NSMutableDictionary *dict;    //每个月份的字典
@property (nonatomic, strong) NSMutableArray *monthDateArr;


@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;
@property (nonatomic, strong) UIView *actDoneNoneView;


- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLActivityListType)type;
- (void)refreshList;

@end

