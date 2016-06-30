//
//  YKLActivityListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/16.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLActivityListSummaryModel.h"
#import "TWTMenuViewController.h"
#import "TWTSideMenuViewController.h"
#import "XHJDRefreshView.h"

@protocol TWTMenuViewControllerDelegate <NSObject>

- (void)changeRightItem:(BOOL)i;

@end


@class YKLActivityListView;
@protocol YKLActivityListViewDelegate <NSObject>

- (void)showActivityListTypeIngDetailView:(YKLActivityListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model;

- (void)showYKLActivityListTypeWaitDetailView:(YKLActivityListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model;
- (void)showYKLActivityListTypeEndDetailView:(YKLActivityListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model;

//跳转分享页面
- (void)showShareViewDidSelectOrder:(YKLActivityListSummaryModel *)model isPay:(NSString *)isPay;

- (void)payViewDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID;

@end

@interface YKLActivityListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLActivityListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) UIButton *showShareButton;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLActivityListType type;
@property (nonatomic, strong)YKLActivityListSummaryModel *model;
@property (nonatomic, strong) NSString *deletActivityID;

@property BOOL showBool;//是否合并分享
@property (nonatomic, strong) NSMutableDictionary *deleteDic;

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

@interface YKLActivityListViewController : YKLUserBaseViewController

@property (nonatomic, assign) id<TWTMenuViewControllerDelegate> menuDelegate;
@property BOOL showBool;

@property (nonatomic, strong) UIView *bgImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property int singelTap;

- (void)rightItemClicked;//点击合并分享


@end
