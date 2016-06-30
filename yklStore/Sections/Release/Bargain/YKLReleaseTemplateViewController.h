//
//  YKLReleaseTemplateViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/29.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//
#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLTemplateModel.h"


@class YKLReleaseTemplateView;
@protocol YKLReleaseTemplateViewDelegate <NSObject>

- (void)consumerTemplateListView:(YKLReleaseTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model;

- (void)preViewTemplateListView:(NSString *)url;

- (void)noneTemplateListView;
- (void)TemplateListView;
@end

@interface YKLReleaseTemplateView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>
{
    UIImageView         *_emptyImageView;
}
@property (nonatomic, assign) id<YKLReleaseTemplateViewDelegate> delegate;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *TemplateArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, strong) YKLTemplateModel *templateModel;
@property (nonatomic, strong) NSString *tempCode;
@property (nonatomic, strong) NSString *tempCateIDStr;

- (instancetype)initWithFrame:(CGRect)frame
                     TempCode:(NSString *)tempCode;
- (void)refreshList;

@end

@interface YKLReleaseTemplateViewController : YKLUserBaseViewController

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode;

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSString *type;

@end
