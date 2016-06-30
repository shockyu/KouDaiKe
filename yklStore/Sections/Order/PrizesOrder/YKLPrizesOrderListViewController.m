//
//  YKLPrizesOrderListViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/16.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPrizesOrderListViewController.h"
#import "YKLPrizesOrderListView.h"
#import "TWTSideMenuViewController.h"
#import "YKLHighGoTokenViewController.h"

const float YKLPrizesOderListUpViewH = 40;

@interface YKLPrizesOrderListViewController ()<YKLPrizesOrderListViewDelegate>
@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UISegmentedControl *typeSegment2;
@property (nonatomic, strong) UISegmentedControl *typeSegment3;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIScrollView *upView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIWebView *callWebView;
@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
@property (nonatomic, assign) YKLOrderListType typer;
@end

@implementation YKLPrizesOrderListViewController


- (UIWebView *)callWebView {
    if (_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLPrizesOderListUpViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLPrizesOderListUpViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}


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
        
        self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLPrizesOderListUpViewH);
        [self.upView2 addSubview:self.typeSegment2];
    }
    return _typeSegment2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.orderName;
    
    self.upView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLPrizesOderListUpViewH)];
    self.upView2.scrollEnabled = YES;
    self.upView2.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView2];
    
    self.typeSegment2.frame = CGRectMake(0, 0, self.contentView.width, YKLPrizesOderListUpViewH);
    [self.upView2 addSubview:self.typeSegment2];
    
    //    self.typeSegment3.frame = CGRectMake(self.contentView.width, 0, self.contentView.width, YKLOderListUpViewH);
    //    [self.upView2 addSubview:self.typeSegment3];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLPrizesOderListUpViewH+64, self.contentView.width, self.contentView.height-YKLPrizesOderListUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueChanged:self.typeSegment];
}



//总选择器
- (void)typeSegmentValueChanged:(UISegmentedControl *)segment {
    YKLPrizesOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
    
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
        
        listView = [[YKLPrizesOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:self.orderID];
        listView.delegate = self;
        
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex*2]];
        
        [self createBgNoneView];
    }
}

//到店付
- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLPrizesOrderListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
            
            
        }
        
        listView = [[YKLPrizesOrderListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type orderID:self.orderID];
        listView.delegate = self;
        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}

- (void)consumerOrderListView:(YKLPrizesOrderListView *)listView didSelectOrder:(YKLHighGoOrderDetailModel *)model {
    
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
