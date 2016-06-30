//
//  YKLPrizesOrderListMainView.h
//  yklStore
//
//  Created by 肖震宇 on 16/1/16.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "YKLHighGoOrderListTableViewCell.h"
#import "XHJDRefreshView.h"

@class YKLPrizesOrderListMainView;
@protocol YKLPrizesOrderListMainViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLPrizesOrderListMainView *)listView didSelectOrder:(YKLHighGoOrderListModel *)model;

@end

@interface YKLPrizesOrderListMainView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLPrizesOrderListMainViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;

@property (nonatomic, strong) YKLHighGoOrderListModel *model;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

//按月份展开的数据处理
@property (nonatomic, strong) NSMutableArray *doneData;     //所有月份字典的数组
@property (nonatomic, strong) NSMutableDictionary *dict;    //每个月份的字典
@property (nonatomic, strong) NSMutableArray *monthDateArr;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)refreshList;

@end
