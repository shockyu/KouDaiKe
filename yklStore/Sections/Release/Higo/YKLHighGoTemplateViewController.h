//
//  YKLHighGoTemplateViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLTemplateModel.h"

#pragma mark -

@class YKLHighGoTemplateView;
@protocol YKLHighGoTemplateViewDelegate <NSObject>

- (void)consumerTemplateListView:(YKLHighGoTemplateView *)listView didSelectOrder:(YKLTemplateModel *)model;

- (void)preViewTemplateListView:(NSString *)url;

- (void)noneTemplateListView;
- (void)TemplateListView;
@end

#pragma mark -

@interface YKLHighGoTemplateView : UIView <UITableViewDataSource, MUILoadMoreTableViewDelegate>
{
    UIImageView         *_emptyImageView;
}
@property (nonatomic, assign) id<YKLHighGoTemplateViewDelegate> delegate;
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

#pragma mark -

@interface YKLHighGoTemplateViewController : YKLUserBaseViewController

- (void)typeSegmentValueFaceChanged:(NSInteger)segment TempCode:(NSString *)tempCode;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) BOOL firstIn;//首次进入
@property (nonatomic, assign) NSString *layoutStr;
@property (nonatomic, assign) NSString *goodsNumStr;

@property (nonatomic, assign) YKLTemplateModel *model;

//发布排列弹框页面
@property (nonatomic, strong) CustomIOSAlertView *rechargeAlertView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *rechargeAlertTitleLabel;

@property (nonatomic, strong) UILabel *modelLayoutLabel;
//横向排列
@property (nonatomic, strong) UIButton *crossBtn;
@property (nonatomic, strong) UILabel *rechargeAlertCrossLabel;
@property (nonatomic, strong) UIImageView *crossImageView;
//纵向排列
@property (nonatomic, strong) UIButton *verticalBtn;
@property (nonatomic, strong) UILabel *rechargeAlertVerticalLabel;
@property (nonatomic, strong) UIImageView *verticalImageView;

//
@property (nonatomic, strong) UILabel *goodsNumLabel;

@property (nonatomic, strong) UIButton *goodsNumBtn1;
@property (nonatomic, strong) UILabel *goodsNumLabel1;
@property (nonatomic, strong) UIButton *goodsNumBtn2;
@property (nonatomic, strong) UILabel *goodsNumLabel2;
@property (nonatomic, strong) UIButton *goodsNumBtn4;
@property (nonatomic, strong) UILabel *goodsNumLabel4;
@property (nonatomic, strong) UIButton *goodsNumBtn6;
@property (nonatomic, strong) UILabel *goodsNumLabel6;

@property (nonatomic, strong) UIButton *subOrderBtn;
@end
