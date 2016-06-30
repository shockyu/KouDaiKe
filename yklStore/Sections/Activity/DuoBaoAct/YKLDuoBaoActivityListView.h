//
//  YKLDuoBaoActivityListView.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/1.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "XHJDRefreshView.h"
//#import "YKLPrizesActivityListTableViewCell.h"
#import "YKLDuoBaoActivityListTableViewCell.h"

@class YKLDuoBaoActivityListView;
@protocol YKLDuoBaoActivityListViewDelegate <NSObject>

- (void)showDuoBaoActivityListTypeIngDetailView:(YKLDuoBaoActivityListView *)listView didSelectOrder:(YKLDuoBaoActivityListModel *)model;

- (void)showYKLDuoBaoActivityListTypeWaitDetailView:(YKLDuoBaoActivityListView *)listView didSelectOrder:(YKLDuoBaoActivityListModel *)model;

- (void)showYKLDuoBaoActivityListTypeEndDetailView:(YKLDuoBaoActivityListView *)listView didSelectOrder:(YKLDuoBaoActivityListModel *)model;

//跳转分享页面
- (void)showShareViewDidSelectDuoBaoOrder:(YKLDuoBaoActivityListModel *)model isPay:(NSString *)isPay;
//再次分享按钮
//- (void)againReleaseSelectOrder:(NSString *)activityID;

- (void)payViewDuoBaoDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID;

@end

@interface YKLDuoBaoActivityListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLDuoBaoActivityListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLActivityListType type;
@property (nonatomic, strong) YKLDuoBaoActivityListModel *model;
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

