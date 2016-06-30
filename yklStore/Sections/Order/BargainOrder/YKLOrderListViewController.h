//
//  YKLOderListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLOrderListModel.h"
#import "XHJDRefreshView.h"

@class YKLOrderListView;
@protocol YKLConsumerOrderListViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLOrderListView *)listView didSelectOrder:(YKLOrderListModel *)model;

@end
@interface YKLOrderListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLConsumerOrderListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic, strong) YKLOrderListModel *model;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

//按月份展开的数据处理
@property (nonatomic, strong) NSMutableArray *doneData;     //所有月份字典的数组
@property (nonatomic, strong) NSMutableDictionary *dict;    //每个月份的字典
@property (nonatomic, strong) NSMutableArray *monthDateArr;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type;
- (void)refreshList;

@end

@interface YKLOrderListViewController : YKLUserBaseViewController

@end
