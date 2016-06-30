//
//  YKLHighGoOrderListView.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MUILoadMoreTableView.h"
#import "YKLHighGoOrderListTableViewCell.h"
#import "YKLHighGoOrderDetailModel.h"
#import "XHJDRefreshView.h"

@class YKLHighGoOrderListView;
@protocol YKLHighGoOrderListViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLHighGoOrderListView *)listView didSelectOrder:(YKLHighGoOrderDetailModel *)model;

@end
@interface YKLHighGoOrderListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLHighGoOrderListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic, strong) YKLHighGoOrderDetailModel *model;
@property (nonatomic,strong) NSString *orderID;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type orderID:(NSString *)orderID;
- (void)refreshList;

@end

