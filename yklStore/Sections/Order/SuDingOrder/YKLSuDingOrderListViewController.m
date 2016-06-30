//
//  YKLSuDingOrderListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/5.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLSuDingOrderListViewController.h"
#import "YKLSuDingOrderListView.h"

@interface YKLSuDingOrderListViewController ()<YKLSuDingOrderListViewDelegate>

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UIScrollView *upView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIWebView *callWebView;
@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;

@end

@implementation YKLSuDingOrderListViewController

- (UISegmentedControl *)typeSegment{
    if (_typeSegment == nil) {
        _typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"待兑换", @"已兑换"]];
        _typeSegment.selectedSegmentIndex = 0;
        
        _typeSegment.tintColor = [UIColor flatLightRedColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_typeSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [_typeSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        
        [_typeSegment addTarget:self action:@selector(typeSegmentValueFaceChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, 40);
        [self.upView addSubview:self.typeSegment];
    }
    return _typeSegment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.orderName;
    
    self.upView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, 40)];
    self.upView.scrollEnabled = YES;
    self.upView.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView];
    
    self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, 40);
    [self.upView addSubview:self.typeSegment];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+64, self.contentView.width, self.contentView.height-40)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueChanged:self.typeSegment];
    
}

//总选择器
- (void)typeSegmentValueChanged:(UISegmentedControl *)segment {
    
    YKLSuDingOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
    
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0) animated:YES];
    [self.upView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
            
            
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLLineReceiveStatusNotReceive;
            
            
        }
        
        listView = [[YKLSuDingOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:self.orderID];
        listView.delegate = self;
        
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
        
        [self createBgNoneView];
    }
}

//到店付
- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLSuDingOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
            
            
        }
        
        listView = [[YKLSuDingOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:self.orderID];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}


- (void)consumerOrderListView:(YKLSuDingOrderListView *)listView didSelectOrder:(YKLHighGoOrderDetailModel *)model {
    
    NSLog(@"%@-%@",model.nickName,model.mobile);
    
    if (model.mobile.length > 0) {
        NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", model.mobile]];
        if (self.callWebView == nil) {
            self.callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        }
        [self.callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
    }
    
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
