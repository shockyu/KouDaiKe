//
//  YKLMiaoShaReleaseTemplateViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/4/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLTemplateModel.h"


@class YKLMiaoShaReleaseTemplateView;
@protocol YKLMiaoShaReleaseTemplateViewDelegate <NSObject>

- (void)consumerTemplateListView:(YKLMiaoShaReleaseTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model;

- (void)preViewTemplateListView:(NSString *)url;

- (void)noneTemplateListView;
- (void)TemplateListView;
@end

@interface YKLMiaoShaReleaseTemplateView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>
{
    UIImageView         *_emptyImageView;
}
@property (nonatomic, assign) id<YKLMiaoShaReleaseTemplateViewDelegate> delegate;

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

@interface YKLMiaoShaReleaseTemplateViewController : YKLUserBaseViewController

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode;

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) NSString *type;

@end
