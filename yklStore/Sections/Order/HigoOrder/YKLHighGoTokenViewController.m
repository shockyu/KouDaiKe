//
//  YKLHighGoTokenViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/10.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoTokenViewController.h"
//#import "YKLHighGoOrderListView.h"
#import "YKLHighGoTokenListView.h"

const float YKLHighGoTokenUpViewH = 40;

@interface YKLHighGoTokenViewController ()

@property (nonatomic, strong) UISegmentedControl *typeSegment;
@property (nonatomic, strong) UIScrollView *upView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableDictionary *orderListDictionary;
//@property (nonatomic, assign) YKLOrderListType typer;
@end

@implementation YKLHighGoTokenViewController


- (instancetype)initWithUserInfo:(id)info {
    if (self = [super initWithUserInfo:info]) {
        self.typeSegment.selectedSegmentIndex = [info integerValue];
    }
    return self;
}

- (float)rainshedLaceOffset {
    return YKLHighGoTokenUpViewH;
}

- (void)show {
    self.upView.top = 0;
    self.scrollView.top = YKLHighGoTokenUpViewH;
}

- (void)hide {
    self.upView.bottom = 0;
    self.scrollView.top = self.contentView.height;
}

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
        
        self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, YKLHighGoTokenUpViewH);
        [self.upView addSubview:self.typeSegment];
    }
    return _typeSegment;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.goodsName;
    
    self.upView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.contentView.width, YKLHighGoTokenUpViewH)];
    self.upView.scrollEnabled = YES;
    self.upView.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
    self.upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.upView];
    
    self.typeSegment.frame = CGRectMake(0, 0, self.contentView.width, YKLHighGoTokenUpViewH);
    [self.upView addSubview:self.typeSegment];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, YKLHighGoTokenUpViewH+64, self.contentView.width, self.contentView.height-YKLHighGoTokenUpViewH)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*5, self.scrollView.height);
    [self.view addSubview:self.scrollView];
    
    self.orderListDictionary = [NSMutableDictionary dictionary];
    [self typeSegmentValueFaceChanged:self.typeSegment];
    
}

- (void)typeSegmentValueFaceChanged:(UISegmentedControl *)segment {
    
    YKLHighGoTokenListView *listView = [self.orderListDictionary objectForKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(segment.selectedSegmentIndex*self.scrollView.width, 0) animated:YES];
    
    
    if (listView == nil) {
        YKLOrderListType type;
        
        if (segment.selectedSegmentIndex == 0) {
            type = YKLFaceExchangeStatusWait;
        }
        else if (segment.selectedSegmentIndex == 1) {
            type = YKLFaceExchangeStatusDone;
            
        }
        
        listView = [[YKLHighGoTokenListView alloc] initWithFrame:CGRectMake(segment.selectedSegmentIndex*self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) orderType:type goodsID:self.goodsID];
//        listView.delegate = self;

        [self.scrollView addSubview:listView];
        
        [self.orderListDictionary setObject:listView forKey:[NSNumber numberWithInteger:segment.selectedSegmentIndex]];
    }
    
    
}


@end
