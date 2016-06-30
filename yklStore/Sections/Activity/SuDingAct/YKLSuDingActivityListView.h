//
//  YKLSuDingActivityListView.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/5.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUILoadMoreTableView.h"
#import "XHJDRefreshView.h"
//#import "YKLMiaoShaActivityListTableViewCell.h"
#import "YKLSuDingActivityListTableViewCell.h"

@class YKLSuDingActivityListView;
@protocol YKLSuDingActivityListViewDelegate <NSObject>

- (void)showSuDingActivityListTypeIngDetailView:(YKLSuDingActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model;

- (void)showYKLSuDingActivityListTypeWaitDetailView:(YKLSuDingActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model;

- (void)showYKLSuDingActivityListTypeEndDetailView:(YKLSuDingActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model;

//跳转分享页面
- (void)showShareViewDidSelectSuDingOrder:(YKLMiaoShaActivityListModel *)model isPay:(NSString *)isPay;
//再次分享按钮
//- (void)againReleaseSelectOrder:(NSString *)activityID;

- (void)payViewSuDingDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID;

- (void)cancer_YYSD_HB_ShareClicked;

@end

@interface YKLSuDingActivityListView : UIView<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, assign) id<YKLSuDingActivityListViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) UIButton *showShareButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) YKLActivityListType type;
@property (nonatomic, strong) YKLMiaoShaActivityListModel *model;

@property BOOL showBool;//是否合并分享
@property (nonatomic, strong) NSMutableDictionary *deleteDic;

@property (nonatomic, strong) NSString *deletActivityID;

//按月份展开的数据处理
@property (nonatomic, strong) NSMutableArray *doneData;     //所有月份字典的数组
@property (nonatomic, strong) NSMutableDictionary *dict;    //每个月份的字典
@property (nonatomic, strong) NSMutableArray *monthDateArr;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) XHJDRefreshView *refreshView;

@property (nonatomic, strong) UIView *actingNoneView;
@property (nonatomic, strong) UIView *actWaitNoneView;
@property (nonatomic, strong) UIView *actDoneNoneView;

- (instancetype)initWithFrame:(CGRect)frame orderType:(YKLActivityListType)type;
- (void)refreshList;


@end
