//
//  YKLWebViewController.m
//  yklStore
//
//  Created by 王硕 on 16/5/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#import "YKLWebViewController.h"

#import "YKLShopOrderCenterViewController.h"

#import "YKLShopAgentCenterViewController.h"

#import "YKLShopBuyerListViewController.h"
#import "YKLShopOrderConfirmViewController.h"

@interface YKLWebViewController ()
{
    UIWebView            *_web;
    
    UIActivityIndicatorView *_activityIndicatorView;
    
    UIView *_errorView;

}

@end

@implementation YKLWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWebView];
    [self createErrorView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)initWebView{
    
    if (!_web)
    {
        _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - kStatusbarHeight)];
        //[self getUserAgent];
    }
    
    _web.delegate =self;
    [self.view addSubview:_web];
    
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_lcUrl]]];
    
    if (!_activityIndicatorView)
    {
        _activityIndicatorView =  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    _activityIndicatorView.frame = CGRectMake(MidX(self.view), MidY(self.view), 0, 0);
    _activityIndicatorView.color = [UIColor lightGrayColor];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];
    
}

- (void)webViewReload
{
    [_web reload];
}

- (void)setFeatureObject:(id)object
{
    if (object)
    {
        _lcUrl =[NSString stringWithFormat:@"%@",object];
    }
}

#pragma mark - Back

- (void)createBackBar
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backBarClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 30, 21);
    [btn setImage:[UIImage imageNamed:@"icon_back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_back_p"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)backBarClicked
{
    if([_web canGoBack])
    {
        
        [_web goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [_activityIndicatorView startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicatorView stopAnimating];
    
    NSLog(@"%d",[error code]);
    
    self.navigationController.navigationBarHidden = NO;
    _errorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [_activityIndicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    NSString *str =[url absoluteString];
    
    if ([str rangeOfString:@"webGetShopID" options:NSCaseInsensitiveSearch].length>0)
    {
        //NSLog(@"%@==%@",[url path],[url absoluteString]);
        
        NSString *callback = [[[url path]  componentsSeparatedByString:@"/"]objectAtIndex:1];
        [self getShopID:callback];
        return NO;
    }
    else if ([str rangeOfString:@"webGoOrder" options:NSCaseInsensitiveSearch].length>0)
    {
        [self goOrder];
        
        return NO;
    }
    else if ([str rangeOfString:@"webGetGoods" options:NSCaseInsensitiveSearch].length>0)
    {
        NSString *goodsInfo =[[url path] substringFromIndex:6];
        [self getGoodsInfo:goodsInfo];
        
        return NO;
    }
    else if ([str rangeOfString:@"webGoBack" options:NSCaseInsensitiveSearch].length>0)
    {
        [self backBarClicked];
        
        return NO;
    }
    else if ([str rangeOfString:@"webGoAgentCenter" options:NSCaseInsensitiveSearch].length>0)
    {
        [self goAgentCenter];
        
        return NO;
    }
    else if ([str rangeOfString:@"webGoBuyerList" options:NSCaseInsensitiveSearch].length>0)
    {
        NSString *goodsID = [[[url path]  componentsSeparatedByString:@"/"]objectAtIndex:1];
        [self goBuyerList:goodsID];
        
        return NO;
    }
    
    self.navigationController.navigationBarHidden = YES;
    _errorView.hidden = YES;
    
    return YES;
}

-(void)goOrder
{
    YKLShopOrderCenterViewController *ctl = [[YKLShopOrderCenterViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)getShopID:(NSString *)callback
{
    NSString *shopId = [YKLLocalUserDefInfo defModel].userID;
    if (shopId)
    {
        NSString * callbackFunction = [NSString stringWithFormat:@"%@('%@')",callback,shopId];
        
        [_web stringByEvaluatingJavaScriptFromString:callbackFunction];
    }
    
}

- (void)goAgentCenter
{
    YKLShopAgentCenterViewController *ctl = [[YKLShopAgentCenterViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)goBuyerList:(NSString *)goodsID
{
    YKLShopBuyerListViewController *ctl = [[YKLShopBuyerListViewController alloc] init];
    ctl.goodsID = goodsID;
    [self.navigationController pushViewController:ctl animated:YES];
}

//解析web端传过来的json
- (void)getGoodsInfo:(NSString *)goodsInfo
{
    NSData *jsonData = [goodsInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *sDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",sDict);
    YKLShopOrderConfirmViewController *ctl = [[YKLShopOrderConfirmViewController alloc] init];
    ctl.orderDict = sDict;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)createErrorView{
    
    _errorView = [[UIView alloc]initWithFrame:_web.frame];
    _errorView.backgroundColor = [UIColor clearColor];
    _errorView.hidden = YES;
    [self.view addSubview:_errorView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 100, 255, 225);
    imageView.centerX = self.view.width/2;
    [_errorView addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
