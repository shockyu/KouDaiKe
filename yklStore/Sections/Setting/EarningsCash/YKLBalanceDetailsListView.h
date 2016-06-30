//
//  YKLBalanceDetailsListView.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "XHJDRefreshView.h"
//#import "YKLPrizesOrderListTableViewCell.h"
//#import "YKLHighGoOrderDetailModel.h"

@class YKLBalanceDetailsListView;
@protocol YKLBalanceDetailsListViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLBalanceDetailsListView *)listView didSelectOrder:(YKLWithDrawCashModel *)model;

@end

@interface YKLBalanceDetailsListView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLBalanceDetailsListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) YKLWithDrawCashModel *recordModel;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic,strong) NSString *orderID;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
//按月份展开的数据处理
@property (nonatomic, strong) NSMutableArray *doneData;     //所有月份字典的数组
@property (nonatomic, strong) NSMutableDictionary *dict;    //每个月份的字典
@property (nonatomic, strong) NSMutableArray *monthDateArr;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;
@property (nonatomic, strong) UIView *actDoneNoneView;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type orderID:(NSString *)orderID;
- (void)refreshList;

@end
