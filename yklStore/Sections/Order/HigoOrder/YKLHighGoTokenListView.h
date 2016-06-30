//
//  YKLHighGoTokenListView.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/10.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "YKLHighGoGoodsRewardModel.h"
#import "XHJDRefreshView.h"

@interface YKLHighGoTokenListView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic,strong) NSString *goodsID;
@property (nonatomic,strong) NSString *goodsName;
@property (nonatomic, strong) YKLHighGoGoodsRewardModel *rewardModel;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLOrderListType)type goodsID:(NSString *)goodsID;
@end
