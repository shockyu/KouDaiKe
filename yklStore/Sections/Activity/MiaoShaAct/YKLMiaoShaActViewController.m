//
//  YKLMiaoShaActViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMiaoShaActViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLMiaoShaActivityListView.h"
#import "YKLMiaoShaActivityListDetailViewController.h"
#import "YKLMiaoShaReleaseViewController.h"

const float YKLMiaoShaActivityListUpViewH = 40;
@interface YKLMiaoShaActViewController ()<YKLMiaoShaActivityListViewDelegate>

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, strong) NSString *activityIngID;//进行中的活动ID

@end

@implementation YKLMiaoShaActViewController

- (UISegmentedControl *)typeSegment {
    if (_typeSegment == nil) {
        _typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"进行中", @"待发布", @"已完成"]];
        
        if ([[YKLLocalUserDefInfo defModel].actType isEqualToString:@"进行中"]) {
            _typeSegment.selectedSegmentIndex = 0;
            [self.menuDelegate changeRightItemHiden:YES type:@"秒杀"];
        }
        else if([[YKLLocalUserDefInfo defModel].actType isEqualToString:@"待发布"]){
            _typeSegment.selectedSegmentIndex = 1;
            [self.menuDelegate changeRightItemHiden:NO type:@"秒杀"];
        }
        else if([[YKLLocalUserDefInfo defModel].actType isEqualToString:@"已完成"]){
            _typeSegment.selectedSegmentIndex = 2;
            [self.menuDelegate changeRightItemHiden:NO type:@"秒杀"];
        }
        
        
        _typeSegment.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment addTarget:self action:@selector(typeSegmentValueChanged:Show:) forControlEvents:UIControlEventValueChanged];
    }
    return _typeSegment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLMiaoShaActivityListUpViewH)];
    self.upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView];
    
    self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, YKLMiaoShaActivityListUpViewH);
    [self.upView addSubview:self.typeSegment];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLMiaoShaActivityListUpViewH+64, self.contentView.width, self.contentView.height-YKLMiaoShaActivityListUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*3, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self rightItemClicked];
//    [self typeSegmentValueChanged:self.typeSegment Show:_showBool];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 50);
    leftButton.centerY = self.view.height/2;
    [leftButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"leftButton1"] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:MPS_MSG_ORDER_STATUS_CHANGE object:nil];
    
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationController setNavigationBarHidden:YES];
    
}

- (void)refreshOrderList {
    
    YKLMiaoShaActivityListView *payingList = [self.orderListDictionary objectForKey:@0];
    [payingList refreshList];
    YKLMiaoShaActivityListView *waitList = [self.orderListDictionary objectForKey:@1];
    [waitList refreshList];
    YKLMiaoShaActivityListView *doneList = [self.orderListDictionary objectForKey:@2];
    [doneList refreshList];
}

- (void)typeSegmentValueChanged:(UISegmentedControl *)segment
                           Show:(BOOL)showBool
{
    
    YKLMiaoShaActivityListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    if (segment.selectedSegmentIndex == 0) {
        [self.menuDelegate changeRightItemHiden:YES type:@"秒杀"];
        [YKLLocalUserDefInfo defModel].actType = @"进行中";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    else if (segment.selectedSegmentIndex == 1) {
        [self.menuDelegate changeRightItemHiden:NO type:@"秒杀"];
        [YKLLocalUserDefInfo defModel].actType = @"待发布";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    else if (segment.selectedSegmentIndex == 2){
        [self.menuDelegate changeRightItemHiden:NO type:@"秒杀"];
        [YKLLocalUserDefInfo defModel].actType = @"已完成";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    if (listView == nil) {
        YKLActivityListType type;
        if (segment.selectedSegmentIndex == 0) {
            type = YKLActivityListTypeIng;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLActivityListTypeWait;
        }
        else if (segment.selectedSegmentIndex == 2){
            type = YKLActivityListTypeDone;
        }
        
        listView = [[YKLMiaoShaActivityListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type];
        listView.delegate = self;
        
        //合并分享处理
        listView.showBool = showBool;
        [listView.tableView setEditing:showBool animated:YES];
        
        [self.scrollView addSubview:listView];
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
        
    }
}

//控制进行中活动多选
- (void)rightItemClicked{
    
    
    if (_showBool) {
        [self typeSegmentValueChanged:self.typeSegment Show:_showBool];
        
    }else{
        [self typeSegmentValueChanged:self.typeSegment Show:_showBool];
        
    }
    
}

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
    
    if (!_showBool) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showYKLMiaoShaActivityListTypeEndDetailView:(YKLMiaoShaActivityListView *)listView didSelectOrder:(YKLMiaoShaActivityListModel *)model {
    self.activityListSummaryModel = model;
    
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
    vc.activityID = self.activityListSummaryModel.activityID;
    vc.isEndActivity =YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
