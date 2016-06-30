//
//  YKLShopOrderManagerViewController.m
//  yklStore
//
//  Created by willbin on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopOrderManagerViewController.h"
#import "HMSegmentedControl.h"

#import "YKLShopOrderListViewController.h"

@interface YKLShopOrderManagerViewController ()
{
    HMSegmentedControl              *_segmentedControl;
    
    YKLShopOrderListViewController  *_DFKCtl;
    YKLShopOrderListViewController  *_DSHCtl;
    YKLShopOrderListViewController  *_YWCCtl;
    YKLShopOrderListViewController  *_TKCtl;
}
@end

@implementation YKLShopOrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单管理";
    self.view.backgroundColor = HEXCOLOR(0xebebeb);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createNavBarView];
    
    [self selectTabAtIndex:_shouldShowIndex];
    [_segmentedControl setSelectedSegmentIndex:_shouldShowIndex];
}

- (void)createNavBarView
{
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"待付款", @"待收货", @"已完成", @"  退款   "]];
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                                              NSFontAttributeName : [UIFont systemFontOfSize:13]};
    _segmentedControl.selectedTitleTextAttributes =  @{NSForegroundColorAttributeName : YKLRedColor,
                                                       NSFontAttributeName : [UIFont systemFontOfSize:13]};
    _segmentedControl.frame = CGRectMake(0, 0, ScreenWidth, 40);
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
            [self showDFKCtl];
        }
            break;
        case 1:
        {
            [self showDSHCtl];
        }
            break;
        case 2:
        {
            [self showYWCCtl];
        }
            break;
        case 3:
        {
            [self showTKCtl];
        }
            break;
        default:
            break;
    }
}

- (void)showDFKCtl
{
    if (!_DFKCtl)
    {
        _DFKCtl = [[YKLShopOrderListViewController alloc] init];
        _DFKCtl.orderType = YKLShopOrderStateTypeUnpay;
        [self addChildViewController:_DFKCtl];
        [self.view addSubview:_DFKCtl.view];
    }
    
    [self.view bringSubviewToFront:_DFKCtl.view];
}

- (void)showDSHCtl
{
    if (!_DSHCtl)
    {
        _DSHCtl = [[YKLShopOrderListViewController alloc] init];
        _DSHCtl.orderType = YKLShopOrderStateTypePayed;
        [self addChildViewController:_DSHCtl];
        [self.view addSubview:_DSHCtl.view];
    }
    
    [self.view bringSubviewToFront:_DSHCtl.view];
}

- (void)showYWCCtl
{
    if (!_YWCCtl)
    {
        _YWCCtl = [[YKLShopOrderListViewController alloc] init];
        _YWCCtl.orderType = YKLShopOrderStateTypeReceived;
        [self addChildViewController:_YWCCtl];
        [self.view addSubview:_YWCCtl.view];
    }
    
    [self.view bringSubviewToFront:_YWCCtl.view];
}

- (void)showTKCtl
{
    if (!_TKCtl)
    {
        _TKCtl = [[YKLShopOrderListViewController alloc] init];
        _TKCtl.orderType = YKLShopOrderStateTypeRefund;
        [self addChildViewController:_TKCtl];
        [self.view addSubview:_TKCtl.view];
    }
    
    [self.view bringSubviewToFront:_TKCtl.view];
}

@end
