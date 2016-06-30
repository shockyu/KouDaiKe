//
//  YKLHighGoActivityListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivityListViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLHighGoOrderListViewController.h"
//#import "YKLHighGoRealeaseViewController.h"

const float YKLHighGoActivityListUpViewH = 40;

@interface YKLHighGoActivityListViewController ()<YKLHighGoActivityListViewDelegate>
@property (nonatomic, strong)YKLHighGoActivityListModel *activityListSummaryModel;

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, strong) NSString *activityIngID;//进行中的活动ID
@end

@implementation YKLHighGoActivityListViewController
//@synthesize naviTitle =_naviTitle;

- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLHighGoActivityListUpViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLHighGoActivityListUpViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}

- (UISegmentedControl *)typeSegment {
    if (_typeSegment == nil) {
        _typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"进行中", @"待发布", @"已完成"]];
        
        if ([[YKLLocalUserDefInfo defModel].actType isEqualToString:@"进行中"]) {
            _typeSegment.selectedSegmentIndex = 0;
            [self.menuDelegate changeRightItem:YES];
        }
        else if([[YKLLocalUserDefInfo defModel].actType isEqualToString:@"待发布"]){
            _typeSegment.selectedSegmentIndex = 1;
            [self.menuDelegate changeRightItem:NO];
        }
        else if([[YKLLocalUserDefInfo defModel].actType isEqualToString:@"已完成"]){
            _typeSegment.selectedSegmentIndex = 2;
            [self.menuDelegate changeRightItem:NO];
        }
        
        _typeSegment.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment addTarget:self action:@selector(typeSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _typeSegment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLHighGoActivityListUpViewH)];
    self.upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView];
    
    self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, YKLHighGoActivityListUpViewH);
    [self.upView addSubview:self.typeSegment];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLHighGoActivityListUpViewH+64, self.contentView.width, self.contentView.height-YKLHighGoActivityListUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*3, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueChanged:self.typeSegment];
    
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
    YKLHighGoActivityListView *payingList = [self.orderListDictionary objectForKey:@0];
    [payingList refreshList];
    YKLHighGoActivityListView *waitList = [self.orderListDictionary objectForKey:@1];
    [waitList refreshList];
    YKLHighGoActivityListView *doneList = [self.orderListDictionary objectForKey:@2];
    [doneList refreshList];
}

- (void)typeSegmentValueChanged:(UISegmentedControl *)segment {
    
    YKLHighGoActivityListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    if (segment.selectedSegmentIndex == 0) {
        [self.menuDelegate changeRightItem:NO];
        [YKLLocalUserDefInfo defModel].actType = @"进行中";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    else if (segment.selectedSegmentIndex == 1) {
        [self.menuDelegate changeRightItem:NO];
        [YKLLocalUserDefInfo defModel].actType = @"待发布";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    else if (segment.selectedSegmentIndex == 2){
        [self.menuDelegate changeRightItem:NO];
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
        
        listView = [[YKLHighGoActivityListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
        
    }
}

- (void)showYKLActivityListTypeWaitDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model {
    
    YKLHighGoRealeaseMainViewController *vc = [YKLHighGoRealeaseMainViewController new];
    vc.activityID = model.activityID;
    vc.isWaitActivity = YES;
    vc.isFirstIn = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)showActivityListTypeIngDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model {
    
    YKLHighGoActivitiyListDetailViewController *vc = [YKLHighGoActivitiyListDetailViewController new];
    vc.detailModel = model;
    [vc createView];
    self.activityIngID = model.activityID;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)showYKLActivityListTypeEndDetailView:(YKLHighGoActivityListView *)listView didSelectOrder:(YKLHighGoActivityListModel *)model {
    self.activityListSummaryModel = model;
    
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
    [btn addTarget:self action:@selector(againRelease) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor flatLightRedColor];
    [vc.scrollView addSubview:btn];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showShareViewDidSelectOrder:(YKLHighGoActivityListModel *)model isPay:(NSString *)isPay
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

- (void)againRelease{

    
    YKLHighGoRealeaseMainViewController *vc = [YKLHighGoRealeaseMainViewController new];
    vc.activityID = self.activityListSummaryModel.activityID;
    vc.isAgainRealease = YES;
    vc.isFirstIn=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)listButtonBtnClicked{
    NSLog(@"活动订单");
    
    YKLHighGoOrderListViewController *VC = [YKLHighGoOrderListViewController new];
    VC.orderID = self.activityListSummaryModel.activityID;
    VC.orderName = @"活动订单";
    [self.navigationController pushViewController:VC animated:YES];
}

@end
