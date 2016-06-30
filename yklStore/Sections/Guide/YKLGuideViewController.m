//
//  YKLGuideViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/18.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLGuideViewController.h"

@interface YKLGuideViewController ()//<UIWebViewDelegate>

//@property (nonatomic,strong)UIActivityIndicatorView *activityIndicator;

@end

@implementation YKLGuideViewController


- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"操作指南";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(webGoBack)];
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarItemClicked:)];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.guideWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.guideWeb.backgroundColor = [UIColor whiteColor];
//    self.guideWeb.delegate = self;
    
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        [self.guideWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.01gou.cn"]]];
        
//        [self.guideWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://kefu5.kuaishang.cn/bs/mim/66593/58010/683585.htm?ref=ykl.meipa.net"]]];
    }
    else{
        [self.guideWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wxcms.supmp.com/index.php?g=Wap&m=Index&a=index&token=imyzww1442109989&wecha_id=ouaNes2A2YqTEMdiyL1-AvhYhAZM&from=singlemessage&isappinstalled=0"]]];
    }

    [self.view addSubview:self.guideWeb];
    
//    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
//    [self.activityIndicator setCenter:self.view.center];
//    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:self.activityIndicator];
}

- (void)webGoBack{
    [self.guideWeb goBack];
}

////开始加载数据
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [self.activityIndicator startAnimating];
//}
//
////数据加载完
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self.activityIndicator stopAnimating];
//    
//}

@end
