//
//  YKLHighGoOrderListMainView.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/2.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
//#import "YKLOrderListModel.h"
//#import "YKLOrderListTableViewCell.h"
#import "YKLHighGoOrderListModel.h"
#import "YKLHighGoOrderListTableViewCell.h"
#import "XHJDRefreshView.h"

@class YKLHighGoOrderListMainView;
@protocol YKLHighGoOrderListMainViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLHighGoOrderListMainView *)listView didSelectOrder:(YKLHighGoOrderListModel *)model;

@end

@interface YKLHighGoOrderListMainView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLHighGoOrderListMainViewDelegate> delegate;
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
