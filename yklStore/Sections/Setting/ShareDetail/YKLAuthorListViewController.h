//
//  YKLAuthorListViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"

@class YKLAuthorListView;
@protocol YKLAuthorListViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLAuthorListView *)listView didSelectOrder:(YKLOrderListModel *)model;

@end

@interface YKLAuthorListView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLAuthorListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLOrderListType type;
@property (nonatomic, strong) YKLOrderListModel *model;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, strong) UIWebView *callWebView;

@property (nonatomic, strong) NSString *authorType;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;


- (instancetype)initWithFrame:(CGRect)frame
                   AuthorType:(NSString *)authorType;

- (void)refreshList;

@end

@interface YKLAuthorListViewController : YKLUserBaseViewController<YKLAuthorListViewDelegate>

@property (nonatomic, strong) NSString *authorType;

@end
