//
//  YKLReleaseModelViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLTemplateModel.h"

@class YKLReleaseModelView;
@protocol YKLReleaseModelViewDelegate <NSObject>

- (void)consumerOrderListView:(YKLReleaseModelView *)listView didSelectOrder:(YKLTemplateModel *)model;

@end

@interface YKLReleaseModelView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLReleaseModelViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;


@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;

- (instancetype)initWithFrame:(CGRect)frame ;
- (void)refreshList;

@end

@interface YKLReleaseModelViewController : YKLUserBaseViewController <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) UIImage *modelImage;

@end
