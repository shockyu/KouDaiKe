//
//  YKLPushWebViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/14.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLPushWebViewController.h"
#import "ViewController.h"

@interface YKLPushWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView *activityIndicator;

@end

@implementation YKLPushWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.webTitle;
    
    if (self.hidenBar) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(webGoBack)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarItemClicked:)];
    }
    
    self.pushWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.pushWeb.delegate = self;
    self.pushWeb.backgroundColor = [UIColor whiteColor];
    [self.pushWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
    
    //预览时调
    if (self.request) {
        [self.pushWeb loadRequest:self.request];
    }
    
    [self.pushWeb  setScalesPageToFit:YES];//自适应宽度
    [self.view addSubview:self.pushWeb];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(10, 30, 40, 30)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(webGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 30)];
    label.centerX = self.view.width/2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.webTitle;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [self.activityIndicator setCenter:self.view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];

}

- (void)webGoBack{
    [self presentViewController:[[ViewController alloc] init] animated:NO completion:nil];
}

//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
   
}

@end
