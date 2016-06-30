//
//  YKLHighGoOrderViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/19.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoOrderListViewController.h"
#import "YKLHighGoOrderListView.h"
#import "TWTSideMenuViewController.h"
#import "YKLHighGoTokenViewController.h"

const float YKLHighGoOderListUpViewH = 40;

@interface YKLHighGoOrderListViewController ()<YKLHighGoOrderListViewDelegate>
@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UISegmentedControl *typeSegment2;
@property (nonatomic, strong) UISegmentedControl *typeSegment3;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *upView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;

@end

@implementation YKLHighGoOrderListViewController

- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLHighGoOderListUpViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLHighGoOderListUpViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}

//- (UISegmentedControl *)typeSegment {
//    if (_typeSegment == nil) {
//
//        _typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"到店付", @"线上付"]];
//        _typeSegment.selectedSegmentIndex = 0;
//
//        _typeSegment.tintColor = [UIColor flatLightRedColor];
//        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
//        [_typeSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
//        [_typeSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
//
//        [_typeSegment addTarget:self action:@selector(typeSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _typeSegment;
//
//}

- (UISegmentedControl *)typeSegment2{
    if (_typeSegment2 == nil) {
        _typeSegment2 = [[UISegmentedControl alloc] initWithItems:@[@"待兑换", @"已兑换"]];
        _typeSegment2.selectedSegmentIndex = 0;
        
        _typeSegment2.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment2 setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment2 setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment2 addTarget:self action:@selector(typeSegmentValueFaceChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLHighGoOderListUpViewH);
        [self.upView2 addSubview:self.typeSegment2];
    }
    return _typeSegment2;
}

//- (UISegmentedControl *)typeSegment3{
//    if (_typeSegment3 == nil) {
//        _typeSegment3 = [[UISegmentedControl alloc] initWithItems:@[@"待发货", @"待收货",@"已完成"]];
//        _typeSegment3.selectedSegmentIndex = 0;
//
//        _typeSegment3.tintColor = [UIColor whiteColor];
//        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                                 NSForegroundColorAttributeName: [UIColor flatLightRedColor]};
//        [_typeSegment3 setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
//        [_typeSegment3 setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
//
//        [_typeSegment3 addTarget:self action:@selector(typeSegmentValueLineChanged:) forControlEvents:UIControlEventValueChanged];
//
//        self.typeSegment3.frame = CGRectMake(self.contentView.width, 0, self.contentView.width, YKLOderListUpViewH);
//        [self.upView2 addSubview:self.typeSegment3];
//    }
//    return _typeSegment3;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.orderName;
    
    //    self.upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLOderListUpViewH)];
    //    self.upView.backgroundColor = [UIColor flatLightWhiteColor];
    //    [self.view addSubview:self.upView];
    
    //    self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, YKLOderListUpViewH);
    //    [self.upView addSubview:self.typeSegment];
    
    self.upView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLHighGoOderListUpViewH)];
    self.upView2.scrollEnabled = YES;
    self.upView2.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView2];
    
    self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLHighGoOderListUpViewH);
    [self.upView2 addSubview:self.typeSegment2];
    
    //    self.typeSegment3.frame = CGRectMake(self.contentView.width, 0, self.contentView.width, YKLOderListUpViewH);
    //    [self.upView2 addSubview:self.typeSegment3];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLHighGoOderListUpViewH+64, self.contentView.width, self.contentView.height-YKLHighGoOderListUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueChanged:self.typeSegment];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:MPS_MSG_ORDER_STATUS_CHANGE object:nil];
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 20, 50);
//    leftButton.centerY = self.view.height/2;
//    [leftButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setImage:[UIImage imageNamed:@"leftButton1"] forState:UIControlStateNormal];
//    [self.view addSubview:leftButton];
    
}

//- (void)openButtonPressed
//{
//    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
//}


//- (void)refreshOrderList {
//
//    YKLOrderListView *waitList = [self.orderListDictionary objectForKey:@0];
//    [waitList refreshList];
//    YKLOrderListView *doneList = [self.orderListDictionary objectForKey:@1];
//    [doneList refreshList];
//}


//总选择器
- (void)typeSegmentValueChanged:(UISegmentedControl *)segment {
    YKLHighGoOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
    
    //还原选择器的原始位置
    self.typeSegment2.selectedSegmentIndex = 0;
    self.typeSegment3.selectedSegmentIndex = 0;
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0) animated:YES];
    [self.upView2 setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
            
            
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLLineReceiveStatusNotReceive;
            
            
        }
        
        listView = [[YKLHighGoOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:self.orderID];
        listView.delegate = self;
       
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
        
        [self createBgNoneView];
    }
}

//到店付
- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLHighGoOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
            
            
        }
        
        listView = [[YKLHighGoOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:self.orderID];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}
//
////线上付
//- (void)typeSegmentValueLineChanged:(UISegmentedControl *)segment {
//    
//    YKLHighGoOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex+2]];
//    
//    [self.scrollView setContentOffset:CGPointMake((segment.selectedSegmentIndex+2)*self.scrollView.width, 0) animated:YES];
//    
//    
//    if (listView == nil) {
//        YKLOrderListType type;
//        
//        if (segment.selectedSegmentIndex == 0) {
//            type = YKLLineReceiveStatusNotReceive;
//            
//        }
//        else if (segment.selectedSegmentIndex == 1) {
//            type = YKLLineReceiveStatusWaitReceived;
//            
//        }
//        else if (segment.selectedSegmentIndex == 2) {
//            type = YKLLineReceiveStatusDone;
//            
//        }
//        
//        listView = [[YKLHighGoOrderListView alloc] initWithFrame:CGRectMake((segment.selectedSegmentIndex+2)*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type];
//        listView.delegate = self;
//        [self.scrollView addSubview:listView];
//        
//        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex+2]];
//    }
//    
//}

- (void)consumerOrderListView:(YKLHighGoOrderListView *)listView didSelectOrder:(YKLHighGoOrderDetailModel *)model {
    
    NSLog(@"%@",model);
    YKLHighGoTokenViewController *tokenVC = [YKLHighGoTokenViewController new];
    tokenVC.goodsID = model.goodsID;
    tokenVC.goodsName = model.goodsName;
    [self.navigationController pushViewController:tokenVC animated:YES];
    
}

- (void)createBgNoneView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255, 225)];
    view.centerX = self.view.width/2;
    view.backgroundColor = [UIColor clearColor];
    view.hidden = YES;
    [self.scrollView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [view addSubview:imageView];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255, 225)];
    view2.centerX = self.scrollView.width+self.view.width/2;
    view2.backgroundColor = [UIColor clearColor];
    view2.hidden = YES;
    [self.scrollView addSubview:view2];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView2.frame = CGRectMake(0, 0, 255, 225);
    [view2 addSubview:imageView2];
}

@end
