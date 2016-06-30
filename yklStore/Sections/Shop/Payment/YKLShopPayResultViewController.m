//
//  YKLShopPayResultViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/12.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopPayResultViewController.h"
#import "YKLShopOrderManagerViewController.h"
#import "YKLBaseNavigationController.h"
#import "YKLWebViewController.h"

@interface YKLShopPayResultViewController ()

@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;

 //支付情况
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *goodNameLabel;
//交易类型
@property (nonatomic, strong) UILabel *payStatusLabel;
//交易方式
@property (nonatomic, strong) UILabel *payTypeLabel;
@property (nonatomic, strong) UILabel *payTimeLabel;
@property (nonatomic, strong) UILabel *payMoneyLabel;

@property (nonatomic, strong) NSMutableDictionary *payInfoDict;

@end

@implementation YKLShopPayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回首页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    _payInfoDict = [YKLLocalUserDefInfo defModel].shopPayInfoDict;
    
    [YKLLocalUserDefInfo defModel].shopPayInfoDict = [NSMutableDictionary new];
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    [self createBgView];
    [self createContent];
    
    if (_type == 1)
    {
        self.title = @"支付成功";
        self.typeLabel.text = @"支付成功";
        self.typeImageView.image = [UIImage imageNamed:@"zhifu_chengg"];
    }
    else if (_type == 2)
    {
        self.title = @"支付失败";
        self.typeLabel.text = @"支付失败";
        self.typeImageView.image = [UIImage imageNamed:@"zhifu_shibai"];
    }
}

- (void)createBgView
{
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.width, 140)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView1];
    
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60+40*i, self.view.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView1 addSubview:lineView];
    }
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 120)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView2];
    
    for (int i = 1; i < 3; i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*i, self.view.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.bgView2 addSubview:lineView];
    }
    
    self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+10, self.view.width, 105)];
    self.bgView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView3];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:lineView];
}

- (void)createContent
{
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(146, 0, 100, 60)];
    self.typeLabel.font = [UIFont systemFontOfSize:20];
    [self.bgView1 addSubview:self.typeLabel];
    
    self.typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.typeLabel.left-46, 12, 36, 36)];
    [self.bgView1 addSubview:self.typeImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 50, 40)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"店铺名称";
    [self.bgView1 addSubview:titleLabel];
    
    self.shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 60, self.view.width-50-10, 40)];
    self.shopNameLabel.textAlignment = NSTextAlignmentRight;
    self.shopNameLabel.font = [UIFont systemFontOfSize:12];
    self.shopNameLabel.textColor = [UIColor lightGrayColor];
    self.shopNameLabel.text = [YKLLocalUserDefInfo defModel].userName;
    [self.bgView1 addSubview:self.shopNameLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60+40, 50, 40)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"商品名称";
    [self.bgView1 addSubview:titleLabel];
    
    self.goodNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 60+40, self.view.width-50-10, 40)];
    self.goodNameLabel.textAlignment = NSTextAlignmentRight;
    self.goodNameLabel.font = [UIFont systemFontOfSize:12];
    self.goodNameLabel.textColor = [UIColor lightGrayColor];
    self.goodNameLabel.text = [_payInfoDict objectForKey:@"goods_name"];
    [self.bgView1 addSubview:self.goodNameLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"交易类型";
    [self.bgView2 addSubview:titleLabel];
    
    self.payStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.view.width-50-10, 40)];
    self.payStatusLabel.textAlignment = NSTextAlignmentRight;
    self.payStatusLabel.font = [UIFont systemFontOfSize:12];
    self.payStatusLabel.textColor = [UIColor lightGrayColor];
    self.payStatusLabel.text = @"全款";
    [self.bgView2 addSubview:self.payStatusLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 50, 40)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"交易方式";
    [self.bgView2 addSubview:titleLabel];
    
    self.payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, self.view.width-50-10, 40)];
    self.payTypeLabel.textAlignment = NSTextAlignmentRight;
    self.payTypeLabel.font = [UIFont systemFontOfSize:12];
    self.payTypeLabel.textColor = [UIColor lightGrayColor];
    self.payTypeLabel.text = [YKLLocalUserDefInfo defModel].payWay;
    [self.bgView2 addSubview:self.payTypeLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40*2, 50, 40)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"交易时间";
    [self.bgView2 addSubview:titleLabel];
    
    self.payTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40*2, self.view.width-50-10, 40)];
    self.payTimeLabel.textAlignment = NSTextAlignmentRight;
    self.payTimeLabel.font = [UIFont systemFontOfSize:12];
    self.payTimeLabel.textColor = [UIColor lightGrayColor];
    self.payTimeLabel.text = [_payInfoDict objectForKey:@"add_time"];
    [self.bgView2 addSubview:self.payTimeLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"交易金额";
    [self.bgView3 addSubview:titleLabel];
    
    self.payMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.view.width-50-10, 40)];
    self.payMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.payMoneyLabel.font = [UIFont systemFontOfSize:18];
    self.payMoneyLabel.textColor = [UIColor flatLightRedColor];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[_payInfoDict objectForKey:@"order_amount"]];
    [self.bgView3 addSubview:self.payMoneyLabel];
    
    UIButton *screenshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    screenshotButton.backgroundColor = [UIColor whiteColor];
    screenshotButton.frame = CGRectMake(10,50,(self.view.width-30)/2,40);
    screenshotButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [screenshotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [screenshotButton setTitle:@"截图到相册" forState:UIControlStateNormal];
    [screenshotButton addTarget:self action:@selector(screenshotButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    screenshotButton.layer.cornerRadius = 20;
    screenshotButton.layer.masksToBounds = YES;
    screenshotButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    screenshotButton.layer.borderWidth = 1;
    [self.bgView3 addSubview: screenshotButton];
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.backgroundColor = [UIColor flatLightRedColor];
    orderButton.frame = CGRectMake(screenshotButton.right+10,50,(self.view.width-30)/2,40);
    orderButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [orderButton setTitle:@"去订单中心查看" forState:UIControlStateNormal];
    [orderButton addTarget:self action:@selector(orderButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    orderButton.layer.cornerRadius = 20;
    orderButton.layer.masksToBounds = YES;
    [self.bgView3 addSubview: orderButton];
    
}

#pragma mark - 按钮点击方法

- (void)screenshotButtonClicked
{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 0.0);//全屏截图，包括window
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    [UIAlertView showInfoMsg:@"已成功保存到本地相册"];
}

- (void)orderButtonClicked
{
    
    YKLShopOrderManagerViewController  *vc = [YKLShopOrderManagerViewController new];
    
    if (_type == 1)
    {
        vc.shouldShowIndex = 1;
    }
    else if(_type == 2)
    {
        vc.shouldShowIndex = 0;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//返回首页
- (void)goBack
{
    ViewController *vc = [ViewController new];
    [self presentViewController:vc animated:NO completion:nil];
}
@end
