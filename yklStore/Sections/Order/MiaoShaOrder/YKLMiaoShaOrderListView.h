//
//  YKLMiaoShaOrderListView.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/27.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "YKLMiaoShaActivityUserListTableViewCell.h"
#import "YKLHighGoOrderDetailModel.h"
#import "XHJDRefreshView.h"

@class YKLMiaoShaOrderListView;
@protocol YKLMiaoShaOrderListViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLMiaoShaOrderListView *)listView didSelectOrder:(YKLHighGoOrderDetailModel *)model;

@end

@interface YKLMiaoShaOrderListView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLMiaoShaOrderListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic, strong) YKLHighGoUserListModel *model;
@property (nonatomic,strong) NSString *orderID;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type orderID:(NSString *)orderID;
- (void)refreshList;

@end
