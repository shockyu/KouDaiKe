//
//  YKLChildActManageViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/20.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLChildActManageViewController.h"
#import "HMSegmentedControl.h"

#import "YKLActivityListViewController.h"
#import "YKLHighGoActivityListViewController.h"
#import "YKLPrizesActivityListViewController.h"
#import "YKLDuoBaoActivityListViewController.h"
#import "YKLMiaoShaActViewController.h"
#import "YKLSuDingActViewController.h"

#import "YKLBargainActListView.h"
#import "YKLActivityListDetailViewController.h"
#import "YKLReleaseViewController.h"
#import "YKLTogetherShareViewController.h"

#import "YKLHighGoActivityListView.h"
#import "YKLHighGoOrderListViewController.h"
#import "YKLHighGoActivitiyListDetailViewController.h"

#import "YKLSuDingActivityListView.h"
#import "YKLSuDingActivityListDetailViewController.h"
#import "YKLSuDingReleaseViewController.h"

#import "YKLDuoBaoActivityListView.h"
#import "YKLDuoBaoActivityListDetailViewController.h"
#import "YKLDuoBaoReleaseViewController.h"

#import "YKLPrizesActivityListView.h"
#import "YKLPrizesActivitiyListDetailViewController.h"
#import "YKLPrizesReleaseViewController.h"

#import "YKLMiaoShaActivityListView.h"
#import "YKLMiaoShaActivityListDetailViewController.h"
#import "YKLMiaoShaReleaseViewController.h"

@interface YKLChildActManageViewController ()<YKLBargainActListViewDelegate,YKLHighGoActivityListViewDelegate,YKLSuDingActivityListViewDelegate,YKLDuoBaoActivityListViewDelegate,YKLPrizesActivityListViewDelegate,YKLMiaoShaActivityListViewDelegate>
{
    HMSegmentedControl                      *_segmentedControl;
    
    YKLBargainActListView                   *_QMKJ_View;
    YKLHighGoActivityListView               *_YYCJ_View;
    YKLPrizesActivityListView               *_KDHB_View;
    YKLDuoBaoActivityListView               *_KDDB_View;
    YKLMiaoShaActivityListView              *_YYMS_View;
    YKLSuDingActivityListView               *_YYSD_View;
    
    UITabBar *_tabbar;
    
    NSDictionary *_shopDict;
}

@property (nonatomic, strong)YKLActivityListSummaryModel *activityListSummaryModel;
@property (nonatomic, strong)YKLHighGoActivityListModel *higoActivityListSummaryModel;
@property (nonatomic, strong)YKLMiaoShaActivityListModel *suDingActivityListSummaryModel;
@property (nonatomic, strong)YKLDuoBaoActivityListModel *duoBaoActivityListSummaryModel;
@property (nonatomic, strong)YKLRedActivityListModel *prizesActivityListSummaryModel;
@property (nonatomic, strong)YKLMiaoShaActivityListModel *miaoShaActivityListSummaryModel;

@property (nonatomic, strong) NSString *activityIngID;//进行中的活动ID

@end

@implementation YKLChildActManageViewController

- (instancetype)initWithShouldShowIndex:(NSInteger)shouldShowIndex type:(NSInteger)type shopDict:(NSDictionary *)shopDict{
    if (self = [super init]) {
        
        _shouldShowIndex = shouldShowIndex;
        _type = type;
        _shopDict = shopDict;
        
        self.view.backgroundColor = HEXCOLOR(0xebebeb);
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        [self createNavBarView];
        
        [self selectTabAtIndex:_shouldShowIndex];
        [_segmentedControl setSelectedSegmentIndex:_shouldShowIndex];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)createNavBarView
{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"  全民砍价  ", @"  一元秒杀  ", @"  一元速定  ", @"  口袋夺宝  ",@"  一元抽奖  ",@"  口袋红包  "]];
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                                              NSFontAttributeName : [UIFont systemFontOfSize:10]};
    _segmentedControl.selectedTitleTextAttributes =  @{NSForegroundColorAttributeName : YKLRedColor,
                                                        NSFontAttributeName : [UIFont systemFontOfSize:10]};
    _segmentedControl.frame = CGRectMake(0, 64+10, ScreenWidth-40, 30);
    _segmentedControl.selectionIndicatorHeight = 2.0f;
    _segmentedControl.selectionIndicatorColor = YKLRedColor;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //HMSegmentedControlSelectionStyleFullWidthStripe;
    
    [self.view addSubview:_segmentedControl];
    
    
    // 改变事件
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index)
     {
         [weakSelf selectTabAtIndex:index];
     }];
}


- (void)selectTabAtIndex: (NSInteger)index;
{
    switch (index)
    {
        case 0:
        {
            [self show_QMKJ_Ctl:NO];
        }
            break;
        case 1:
        {
            [self show_YYMS_Ctl:NO];
        }
            break;
        case 2:
        {
            [self show_YYSD_Ctl:NO];
        }
            break;
        case 3:
        {
            [self show_KDDB_Ctl];
        }
            break;
        case 4:
        {
            [self showYYCJ_Ctl];
        }
            break;
        case 5:
        {
            [self show_KDHB_Ctl];
        }
            break;
        default:
            break;
    }
    
    //取消合并状态
    [self.childDelegate cancerBtnChange];
}

//全民砍价
- (void)show_QMKJ_Ctl:(BOOL)showHBFB
{
    
    [YKLLocalUserDefInfo defModel].actType = @"0";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    
    _QMKJ_View = [[YKLBargainActListView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.width, ScreenHeight-64-40-50) orderType:_type shopDict:_shopDict];
    _QMKJ_View.delegate = self;
    
    //合并分享处理
    _QMKJ_View.showBool = showHBFB;
    [_QMKJ_View.tableView setEditing:showHBFB animated:YES];
    
    [self.view addSubview:_QMKJ_View];
    
}

- (void)show_YYMS_Ctl:(BOOL)showHBFB
{
    
    [YKLLocalUserDefInfo defModel].actType = @"1";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    
    _YYMS_View = [[YKLMiaoShaActivityListView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.width, ScreenHeight-64-40-50) orderType:_type];
    _YYMS_View.delegate = self;
    
    //合并分享处理
    _YYMS_View.showBool = showHBFB;
    [_YYMS_View.tableView setEditing:showHBFB animated:YES];

    [self.view addSubview:_YYMS_View];

}

//一元速定
- (void)show_YYSD_Ctl:(BOOL)showHBFB
{
    
    [YKLLocalUserDefInfo defModel].actType = @"2";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    
    _YYSD_View = [[YKLSuDingActivityListView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.width, ScreenHeight-64-40-50) orderType:_type];
    _YYSD_View.delegate = self;
    
    //合并分享处理
    _YYSD_View.showBool = showHBFB;
    [_YYSD_View.tableView setEditing:showHBFB animated:YES];
    
    [self.view addSubview:_YYSD_View];
}

//口袋夺宝
- (void)show_KDDB_Ctl
{
    [YKLLocalUserDefInfo defModel].actType = @"3";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    if (!_KDDB_View)
    {
        _KDDB_View = [[YKLDuoBaoActivityListView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.width, ScreenHeight-64-40-50) orderType:_type];
        _KDDB_View.delegate = self;
        
        [self.view addSubview:_KDDB_View];
    }
    
    [self.view bringSubviewToFront:_KDDB_View];
}

//一元抽奖
- (void)showYYCJ_Ctl
{
    [YKLLocalUserDefInfo defModel].actType = @"4";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    if (!_YYCJ_View)
    {
        _YYCJ_View = [[YKLHighGoActivityListView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.width, ScreenHeight-64-40-50) orderType:_type];
        _YYCJ_View.delegate = self;
        
        [self.view addSubview:_YYCJ_View];
    }
    
    [self.view bringSubviewToFront:_YYCJ_View];
}


//口袋红包
- (void)show_KDHB_Ctl{
    
    [YKLLocalUserDefInfo defModel].actType = @"5";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    if (!_KDHB_View)
    {
        _KDHB_View = [[YKLPrizesActivityListView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.width, ScreenHeight-64-40-50) orderType:_type];
        _KDHB_View.delegate = self;
        
        [self.view addSubview:_KDHB_View];
    }
    
    [self.view bringSubviewToFront:_KDHB_View];
}


#pragma mark - 全民砍价代理方法

- (void)showYKLActivityListTypeWaitDetailView:(YKLActivityListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model {
    
    YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
    NSLog(@"%@",model.activityID);
    releaseVC.activityID = model.activityID;
    releaseVC.typePushNub = model.type;
    releaseVC.activityIngHidden = YES;
    releaseVC.isEndActivity = YES;
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)showActivityListTypeIngDetailView:(YKLActivityListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model {
    
    YKLActivityListDetailViewController *vc = [YKLActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    vc.shareBtn.hidden = NO;
    vc.ewmBtn.hidden= NO;
    self.activityIngID = model.activityID;
    
    //    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改砍价区间" style:UIBarButtonItemStylePlain target:self action:@selector(releaseActivityClicked:)];
    
    if (!_QMKJ_View.showBool) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//修改砍价区间
- (void)releaseActivityClicked:(id)sender{
    YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
    releaseVC.activityID = self.activityIngID;
    releaseVC.activityIngHidden = NO;
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)showYKLActivityListTypeEndDetailView:(YKLActivityListView *)listView didSelectOrder:(YKLActivityListSummaryModel *)model {
    self.activityListSummaryModel = model;
    
    YKLActivityListDetailViewController *vc = [YKLActivityListDetailViewController new];
    
    vc.detailModel = model;
    [vc createView];
    vc.shareBtn.hidden = YES;
    vc.ewmBtn.hidden= YES;
    self.activityIngID = model.activityID;
    //    vc.participantBtn.hidden = YES;
    //    vc.successBtn.hidden = YES;
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,vc.scrollView.contentSize.height-50,vc.view.width-20,40);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"再次发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againRelease) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectOrder:(YKLActivityListSummaryModel *)model isPay:(NSString *)isPay
{
    
    if ([isPay isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
        [YKLLocalUserDefInfo defModel].shareURL = model.shareUrl;
        [YKLLocalUserDefInfo defModel].shareTitle = model.title;
        [YKLLocalUserDefInfo defModel].shareDesc = model.shareDesc;
        [YKLLocalUserDefInfo defModel].shareImage = model.shareImage;
        [YKLLocalUserDefInfo defModel].shareActType = @"大砍价";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    }
    
    if ([isPay isEqual:@"NO"]) {
        
        YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
        VC.hidenBar = NO;
        VC.shareTitle = model.title;
        VC.shareDesc = model.shareDesc;
        VC.shareImg = model.shareImage;
        VC.shareURL = model.shareUrl;
        VC.actType = @"大砍价";
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (void)payViewDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID{
    
    YKLPayViewController *payVC = [YKLPayViewController new];
    payVC.templateModel = templateModel;
    payVC.activityID = activityID;
    payVC.orderType = @"1";
    payVC.isListPop = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)againRelease{
    YKLReleaseViewController *releaseVC = [YKLReleaseViewController new];
    NSLog(@"%@",self.activityListSummaryModel.activityID);
    releaseVC.activityID = self.activityListSummaryModel.activityID;
    releaseVC.endActivityID = @"againRelease";
    releaseVC.activityIngHidden = YES;
    releaseVC.isEndActivity = YES;
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)cancer_QMKJ_HB_ShareClicked{
    
    [self.childDelegate cancerBtnChange];
}

- (void)allSelectdIs:(BOOL)all
{
    [self.childDelegate allSelectdIs:all];
}

#pragma mark - 一元抽奖代理

- (void)showYKLHigoActivityListTypeWaitDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model {
    
    YKLHighGoRealeaseMainViewController *vc = [YKLHighGoRealeaseMainViewController new];
    vc.activityID = model.activityID;
    vc.isWaitActivity = YES;
    vc.isFirstIn = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showHigoActivityListTypeIngDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model {
    
    YKLHighGoActivitiyListDetailViewController *vc = [YKLHighGoActivitiyListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)showYKLHigoActivityListTypeEndDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model {
    self.higoActivityListSummaryModel = model;
    
    YKLHighGoActivitiyListDetailViewController *vc = [YKLHighGoActivitiyListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    vc.shareBtn.hidden = YES;
    vc.ewmBtn.hidden= YES;
    vc.scrollView.contentSize = CGSizeMake(self.view.width, 680+50+10);
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton setTitle:@"活动订单" forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    listButton.backgroundColor = [UIColor flatLightBlueColor];
    listButton.frame = CGRectMake(10,vc.scrollView.contentSize.height-45-50,self.view.width-20,40);
    [listButton addTarget:self action:@selector(listButtonBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    listButton.layer.cornerRadius = 10;
    listButton.layer.masksToBounds = YES;
    [vc.scrollView addSubview: listButton];
    
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,vc.scrollView.contentSize.height-45,vc.view.width-20,40);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"再次发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againReleaseHigo) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectHigoOrder:(YKLHighGoActivityListModel *)model isPay:(NSString *)isPay
{
    if ([isPay isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
        [YKLLocalUserDefInfo defModel].shareURL = model.shareUrl;
        [YKLLocalUserDefInfo defModel].shareTitle = model.title;
        [YKLLocalUserDefInfo defModel].shareDesc = model.shareDesc;
        [YKLLocalUserDefInfo defModel].shareImage = model.shareImage;
        [YKLLocalUserDefInfo defModel].shareActType = @"一元抽奖";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    }
    
    if ([isPay isEqual:@"NO"]) {
        
        YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
        VC.hidenBar = NO;
        VC.shareTitle = model.title;
        VC.shareDesc = model.shareDesc;
        VC.shareImg = model.shareImage;
        VC.shareURL = model.shareUrl;
        VC.actType = @"一元抽奖";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)payViewHigoDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID
{
    YKLPayViewController *payVC = [YKLPayViewController new];
    payVC.templateModel = templateModel;
    payVC.activityID = activityID;
    payVC.orderType = @"2";
    payVC.isListPop = YES;
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)againReleaseHigo{
    
    
    YKLHighGoRealeaseMainViewController *vc = [YKLHighGoRealeaseMainViewController new];
    vc.activityID = self.higoActivityListSummaryModel.activityID;
    vc.isAgainRealease = YES;
    vc.isFirstIn=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)listButtonBtnClicked{
    NSLog(@"活动订单");
    
    YKLHighGoOrderListViewController *VC = [YKLHighGoOrderListViewController new];
    VC.orderID = self.higoActivityListSummaryModel.activityID;
    VC.orderName = @"活动订单";
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 一元速定代理

- (void)showYKLSuDingActivityListTypeWaitDetailView:(YKLSuDingActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    
    YKLSuDingReleaseViewController *vc = [YKLSuDingReleaseViewController new];
    vc.activityID = model.activityID;
    vc.isEndActivity = YES;
    vc.isWaitActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showSuDingActivityListTypeIngDetailView:(YKLSuDingActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    
    YKLSuDingActivityListDetailViewController *vc = [YKLSuDingActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    
    if (!_YYSD_View.showBool) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showYKLSuDingActivityListTypeEndDetailView:(YKLSuDingActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    self.suDingActivityListSummaryModel = model;
    
    YKLSuDingActivityListDetailViewController *vc = [YKLSuDingActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    vc.shareBtn.hidden = YES;
    vc.ewmBtn.hidden= YES;
    vc.scrollView.contentSize = CGSizeMake(self.view.width, 768-64-10-50);
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = vc.shareBtn.frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"再次发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againReleaseSuDing) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectSuDingOrder:(YKLRedActivityListModel *)model isPay:(NSString *)isPay
{
    if ([isPay isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
        [YKLLocalUserDefInfo defModel].shareURL = model.shareUrl;
        [YKLLocalUserDefInfo defModel].shareTitle = model.title;
        [YKLLocalUserDefInfo defModel].shareDesc = model.shareDesc;
        [YKLLocalUserDefInfo defModel].shareImage = model.shareImage;
        [YKLLocalUserDefInfo defModel].shareActType = @"一元速定";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    }
    
    if ([isPay isEqual:@"NO"]) {
        
        YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
        VC.hidenBar = NO;
        VC.shareTitle = model.title;
        VC.shareDesc = model.shareDesc;
        VC.shareImg = model.shareImage;
        VC.shareURL = model.shareUrl;
        VC.actType = @"一元速定";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)payViewSuDingDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID
{
    YKLPayViewController *payVC = [YKLPayViewController new];
    payVC.templateModel = templateModel;
    payVC.activityID = activityID;
    payVC.orderType = @"6";
    payVC.isListPop = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)againReleaseSuDing{
    
    YKLSuDingReleaseViewController *vc = [YKLSuDingReleaseViewController new];
    vc.activityID = self.suDingActivityListSummaryModel.activityID;
    vc.isEndActivity =YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)cancer_YYSD_HB_ShareClicked{
    
    [self.childDelegate cancerBtnChange];
}

#pragma mark - 一元秒杀

- (void)showYKLMiaoShaActivityListTypeWaitDetailView:(YKLMiaoShaActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    
    YKLMiaoShaReleaseViewController *vc = [YKLMiaoShaReleaseViewController new];
    vc.activityID = model.activityID;
    vc.isEndActivity = YES;
    vc.isWaitActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showMiaoShaActivityListTypeIngDetailView:(YKLMiaoShaActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    
    YKLMiaoShaActivityListDetailViewController *vc = [YKLMiaoShaActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    
    if (!_YYMS_View.showBool) {
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)showYKLMiaoShaActivityListTypeEndDetailView:(YKLMiaoShaActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    self.miaoShaActivityListSummaryModel = model;
    
    YKLMiaoShaActivityListDetailViewController *vc = [YKLMiaoShaActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    vc.shareBtn.hidden = YES;
    vc.ewmBtn.hidden= YES;
    vc.scrollView.contentSize = CGSizeMake(self.view.width, 768-64-10-50);
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = vc.shareBtn.frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"再次发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againReleaseMiaoSha) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectMiaoShaOrder:(YKLRedActivityListModel *)model isPay:(NSString *)isPay
{
    if ([isPay isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
        [YKLLocalUserDefInfo defModel].shareURL = model.shareUrl;
        [YKLLocalUserDefInfo defModel].shareTitle = model.title;
        [YKLLocalUserDefInfo defModel].shareDesc = model.shareDesc;
        [YKLLocalUserDefInfo defModel].shareImage = model.shareImage;
        [YKLLocalUserDefInfo defModel].shareActType = @"全民秒杀";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    }
    
    if ([isPay isEqual:@"NO"]) {
        
        YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
        VC.hidenBar = NO;
        VC.shareTitle = model.title;
        VC.shareDesc = model.shareDesc;
        VC.shareImg = model.shareImage;
        VC.shareURL = model.shareUrl;
        VC.actType = @"全民秒杀";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)payViewMiaoShaDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID
{
    YKLPayViewController *payVC = [YKLPayViewController new];
    payVC.templateModel = templateModel;
    payVC.activityID = activityID;
    payVC.orderType = @"5";
    payVC.isListPop = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)againReleaseMiaoSha{
    
    YKLMiaoShaReleaseViewController *vc = [YKLMiaoShaReleaseViewController new];
    vc.activityID = self.miaoShaActivityListSummaryModel.activityID;
    vc.isEndActivity =YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)cancer_YYMS_HB_ShareClicked{
    
    [self.childDelegate cancerBtnChange];
}

#pragma mark - 口袋夺宝代理

- (void)showYKLDuoBaoActivityListTypeWaitDetailView:(YKLDuoBaoActivityListView *)listView didSelectOrder:(YKLDuoBaoActivityListModel *)model {
    
    YKLDuoBaoReleaseViewController *vc = [YKLDuoBaoReleaseViewController new];
    vc.activityID = model.activityID;
    vc.detailModel = model;
    vc.isEndActivity = YES;
    vc.isWaitActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showDuoBaoActivityListTypeIngDetailView:(YKLDuoBaoActivityListView *)listView didSelectOrder:(YKLDuoBaoActivityListModel *)model {
    
    YKLDuoBaoActivityListDetailViewController *vc = [YKLDuoBaoActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)showYKLDuoBaoActivityListTypeEndDetailView:(YKLDuoBaoActivityListView *)listView didSelectOrder:(YKLDuoBaoActivityListModel *)model {
    self.duoBaoActivityListSummaryModel = model;
    
    YKLDuoBaoActivityListDetailViewController *vc = [YKLDuoBaoActivityListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    vc.shareBtn.hidden = YES;
    vc.ewmBtn.hidden= YES;
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,vc.scrollView.contentSize.height-45,vc.view.width-20,40);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"再次发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againReleaseDuoBao) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectDuoBaoOrder:(YKLRedActivityListModel *)model isPay:(NSString *)isPay
{
    if ([isPay isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
        [YKLLocalUserDefInfo defModel].shareURL = model.shareUrl;
        [YKLLocalUserDefInfo defModel].shareTitle = model.title;
        [YKLLocalUserDefInfo defModel].shareDesc = model.shareDesc;
        [YKLLocalUserDefInfo defModel].shareImage = model.shareImage;
        [YKLLocalUserDefInfo defModel].shareActType = @"口袋夺宝";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    }
    
    if ([isPay isEqual:@"NO"]) {
        
        YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
        VC.hidenBar = NO;
        VC.shareTitle = model.title;
        VC.shareDesc = model.shareDesc;
        VC.shareImg = model.shareImage;
        VC.shareURL = model.shareUrl;
        VC.actType = @"口袋夺宝";
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (void)payViewDuoBaoDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID
{
    YKLPayViewController *payVC = [YKLPayViewController new];
    payVC.templateModel = templateModel;
    payVC.activityID = activityID;
    payVC.orderType = @"4";
    payVC.isListPop = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

//- (void)againReleaseSelectOrder:(NSString *)activityID{
//
//    YKLDuoBaoReleaseViewController *vc = [YKLDuoBaoReleaseViewController new];
////    vc.activityID = activityID;
////    vc.isEndActivity = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}

- (void)againReleaseDuoBao{
    
    YKLDuoBaoReleaseViewController *vc = [YKLDuoBaoReleaseViewController new];
    vc.activityID = self.duoBaoActivityListSummaryModel.activityID;
    vc.isEndActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 口袋红包代理方法

- (void)showYKLPrizesActivityListTypeWaitDetailView:(YKLPrizesActivityListView *)listView didSelectOrder:(YKLRedActivityListModel *)model {
    
    YKLPrizesReleaseViewController *vc = [YKLPrizesReleaseViewController new];
    vc.activityID = model.activityID;
    vc.detailModel = model;
    vc.isEndActivity = YES;
    vc.isWaitActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showPrizesActivityListTypeIngDetailView:(YKLPrizesActivityListView *)listView didSelectOrder:(YKLRedActivityListModel *)model {
    
    YKLPrizesActivitiyListDetailViewController *vc = [YKLPrizesActivitiyListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)showYKLPrizesActivityListTypeEndDetailView:(YKLPrizesActivityListView *)listView didSelectOrder:(YKLRedActivityListModel *)model {
    self.prizesActivityListSummaryModel = model;
    
    YKLPrizesActivitiyListDetailViewController *vc = [YKLPrizesActivitiyListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    vc.shareBtn.hidden = YES;
    vc.ewmBtn.hidden= YES;
    
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,vc.scrollView.contentSize.height-45,vc.view.width-20,40);
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"再次发布" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againReleasePrizes) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectPrizesOrder:(YKLRedActivityListModel *)model isPay:(NSString *)isPay
{
    if ([isPay isEqual:@"YES"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
        [YKLLocalUserDefInfo defModel].shareURL = model.shareUrl;
        [YKLLocalUserDefInfo defModel].shareTitle = model.title;
        [YKLLocalUserDefInfo defModel].shareDesc = model.shareDesc;
        [YKLLocalUserDefInfo defModel].shareImage = model.shareImage;
        [YKLLocalUserDefInfo defModel].shareActType = @"口袋红包";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    }
    
    if ([isPay isEqual:@"NO"]) {
        
        YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
        VC.hidenBar = NO;
        VC.shareTitle = model.title;
        VC.shareDesc = model.shareDesc;
        VC.shareImg = model.shareImage;
        VC.shareURL = model.shareUrl;
        VC.actType = @"口袋红包";
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

- (void)payViewPrizeDidSelectOrder:(NSDictionary *)templateModel ActID:(NSString *)activityID
{
    YKLPayViewController *payVC = [YKLPayViewController new];
    payVC.templateModel = templateModel;
    payVC.activityID = activityID;
    payVC.orderType = @"3";
    payVC.isListPop = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)againReleaseSelectPrizesOrder:(NSString *)activityID{
    
    YKLPrizesReleaseViewController *vc = [YKLPrizesReleaseViewController new];
    vc.activityID = activityID;
    vc.isEndActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)againReleasePrizes{
    
    YKLPrizesReleaseViewController *vc = [YKLPrizesReleaseViewController new];
    vc.activityID = self.prizesActivityListSummaryModel.activityID;
    vc.isEndActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
