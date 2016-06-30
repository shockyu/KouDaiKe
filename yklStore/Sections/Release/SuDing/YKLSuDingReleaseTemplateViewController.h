//
//  YKLSuDingReleaseTemplateViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/6.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLTemplateModel.h"


@class YKLSuDingReleaseTemplateView;
@protocol YKLSuDingReleaseTemplateViewDelegate <NSObject>

- (void)consumerTemplateListView:(YKLSuDingReleaseTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model;

- (void)preViewTemplateListView:(NSString *)url;

- (void)noneTemplateListView;
- (void)TemplateListView;
@end

@interface YKLSuDingReleaseTemplateView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>
{
    UIImageView         *_emptyImageView;
}
@property (nonatomic, assign) id<YKLSuDingReleaseTemplateViewDelegate> delegate;

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

@interface YKLSuDingReleaseTemplateViewController : YKLUserBaseViewController

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode;

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSString *type;


@end
