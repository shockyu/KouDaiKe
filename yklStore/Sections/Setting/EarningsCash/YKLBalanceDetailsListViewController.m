//
//  YKLBalanceDetailsListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBalanceDetailsListViewController.h"
//#import "YKLDuoBaoOrderListView.h"
#import "YKLBalanceDetailsListView.h"
#import "YKLBalanceRecordListViewController.h"

const float YKLBalanceDetailsListUpViewH = 40;

@interface YKLBalanceDetailsListViewController ()//<YKLDuoBaoOrderListViewDelegate>

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UISegmentedControl *typeSegment2;
@property (nonatomic, strong) UISegmentedControl *typeSegment3;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *upView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;

@end

@implementation YKLBalanceDetailsListViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"收支明细";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"提现记录"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareRightItemClicked)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 45, 28);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;

    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLBalanceDetailsListUpViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLBalanceDetailsListUpViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}

- (UISegmentedControl *)typeSegment2 {
    if (_typeSegment2 == nil) {
        _typeSegment2 = [[UISegmentedControl alloc] initWithItems:@[@"全部", @"线上支付", @"线下支付"]];
        
        _typeSegment2.selectedSegmentIndex = 0;
        
        _typeSegment2.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment2 setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment2 setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment2 addTarget:self action:@selector(typeSegmentValueFaceChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _typeSegment2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.upView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLBalanceDetailsListUpViewH)];
    self.upView2.scrollEnabled = YES;
    self.upView2.contentSize = CGSizeMake(self.scrollView.width*3, self.scrollView.height);
    self.upView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView2];
    
    self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLBalanceDetailsListUpViewH);
    [self.upView2 addSubview:self.typeSegment2];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLBalanceDetailsListUpViewH+64, self.contentView.width, self.contentView.height-YKLBalanceDetailsListUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    
    [self typeSegmentValueFaceChanged:self.typeSegment];
}


- (void)shareRightItemClicked{
    
    YKLBalanceRecordListViewController *vc = [YKLBalanceRecordListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//到店付
- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLBalanceDetailsListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
        }
        else if (segment.selectedSegmentIndex == 2) {
            type = YKLLineReceiveStatusNotReceive;
        }
        
        
        listView = [[YKLBalanceDetailsListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:@"38"];
//        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}

//- (void)consumerOrderListView:(YKLDuoBaoOrderListView *)listView didSelectOrder:(YKLHighGoOrderDetailModel *)model {
//    
//    NSLog(@"%@",model);
//    
//}


@end
