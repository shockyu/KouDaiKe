//
//  YKLBargainActListView.h
//  yklStore
//
//  Created by 肖震宇 on 16/6/20.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "YKLActivityListSummaryModel.h"
#import "TWTMenuViewController.h"
#import "TWTSideMenuViewController.h"
#import "XHJDRefreshView.h"

@class YKLBargainActListView;
@protocol YKLBargainActListViewDelegate <NSObject>

- (void)showActivityListTypeIngDetailView:(YKLBargainActListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model;

- (void)showYKLActivityListTypeWaitDetailView:(YKLBargainActListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model;
- (void)showYKLActivityListTypeEndDetailView:(YKLBargainActListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model;

//跳转分享页面
- (void)showShareViewDidSelectOrder:(YKLActivityListSummaryModel *)model isPay:(NSString *)isPay;

- (void)payViewDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID;

- (void)cancer_QMKJ_HB_ShareClicked;

- (void)allSelectdIs:(BOOL)all;

@end

@interface YKLBargainActListView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLBargainActListViewDelegate> delegate;

@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) UIButton *showShareButton;
@property (nonatomic, strong) UIButton *cancelButton;

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

@property (nonatomic, strong) NSDictionary *shopDict;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLActivityListType)type shopDict:(NSDictionary *)shopDict;
- (void)refreshList;


@end
