//
//  YKLHighGoActivityListDetailTableView.h
//  yklStore
//
//  Created by 肖震宇 on 15/12/4.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
//#import "YKLHighGOActivityListTableViewCell.h"
#import "YKLHighGoActivityListDetailTableViewCell.h"
#import "YKLShareContentModel.h"
#import "YKLShareViewController.h"

@class YKLHighGoActivityListDetailTableView;
@protocol YKLHighGoActivityListDetailTableViewDelegate <NSObject>

- (void)showUserListDetailView:(YKLHighGoActivityListDetailTableView *)listView didSelectOrder:(NSString *)goodID;

@end


@interface YKLHighGoActivityListDetailTableView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLHighGoActivityListDetailTableViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLActivityListType type;
@property (nonatomic, strong) NSString *actID;


- (instancetype)initWithFrame:(CGRect)frame ActID:(NSString *)actID;
@end
