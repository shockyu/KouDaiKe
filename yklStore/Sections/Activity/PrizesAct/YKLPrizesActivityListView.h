//
//  YKLPrizesActivityListView.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/15.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "XHJDRefreshView.h"
#import "YKLPrizesActivityListTableViewCell.h"

@class YKLPrizesActivityListView;
@protocol YKLPrizesActivityListViewDelegate <NSObject>

- (void)showPrizesActivityListTypeIngDetailView:(YKLPrizesActivityListView *)listView didSelectOrder:(YKLRedActivityListModel *)model;

- (void)showYKLPrizesActivityListTypeWaitDetailView:(YKLPrizesActivityListView *)listView didSelectOrder:(YKLRedActivityListModel *)model;
- (void)showYKLPrizesActivityListTypeEndDetailView:(YKLPrizesActivityListView *)listView didSelectOrder:(YKLRedActivityListModel *)model;

//跳转分享页面
- (void)showShareViewDidSelectPrizesOrder:(YKLRedActivityListModel *)model isPay:(NSString *)isPay;
//再次分享按钮
- (void)againReleaseSelectPrizesOrder:(NSString *)activityID;


- (void)payViewPrizeDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID;

@end

@interface YKLPrizesActivityListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLPrizesActivityListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLActivityListType type;
@property (nonatomic, strong) YKLRedActivityListModel *model;
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
