//
//  YKLShopPayViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopPayViewController.h"
#import "YKLShopPayResultViewController.h"
#import "YKLShopBuyerListViewController.h"
#import "YKLBaseNavigationController.h"

@interface YKLShopPayViewController ()
{
    UIWebView *callView;
}

@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;

@property (nonatomic, strong) UILabel *moneyLabel;

//其他支付方式背景视图
@property (nonatomic, strong) UIView *otherPayView;
//支付宝支付
@property (nonatomic, strong) UIImageView *rechargeAlertAlipayImageView;
@property (nonatomic, strong) UILabel *rechargeAlertAlipayLabel;
@property (nonatomic, strong) UILabel *rechargeAlertAlipayEXpLabel;
@property (nonatomic, strong) UIButton *rechargeAlertAlipayBtn;
//微信支付
@property (nonatomic, strong) UIImageView *rechargeAlertWXImageView;
@property (nonatomic, strong) UILabel *rechargeAlertWXLabel;
@property (nonatomic, strong) UILabel *rechargeAlertWXEXpLabel;
@property (nonatomic, strong) UIButton *rechargeAlertWXBtn;

@property float totleMoneyNum;
@property (nonatomic,strong) NSString *totleMoney;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *orderSN;

@end

@implementation YKLShopPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付订单";
    
    NSLog(@"%@",_payDict);
    
    _totleMoney = [_payDict objectForKey:@"order_amount"];
    _content = [_payDict objectForKey:@"goods_name"];
    _orderSN = [_payDict objectForKey:@"order_sn"];
    
    [self createBgView];
    [self createContent];
    [self alipayBtnClick:nil];
}

- (void)createBgView{
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.width, 95)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView1];

    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 180)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView2];

    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, self.bgView2.bottom, 130, 30)];
    detailLabel.font = [UIFont systemFontOfSize:9];
    detailLabel.text = @"支付遇到问题请联系口袋客客服:";
    [self.view addSubview:detailLabel];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(detailLabel.right, detailLabel.top, 75, 30);
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [phoneBtn setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
    [phoneBtn setTitle:@"0731-89790322" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
}

- (void)createContent{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 34)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"支付金额";
    [self.bgView1 addSubview:titleLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, self.view.width, 30)];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel.textColor = [UIColor flatLightRedColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:34];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",self.totleMoney];
    [self.bgView1 addSubview:self.moneyLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.moneyLabel.bottom, self.view.width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"此金额不含物流费，物流详情联系服务商";
    [self.bgView1 addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60*2, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];

    
#pragma mark - 支付宝支付选择
    
    self.rechargeAlertAlipayImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingdanzhifu_zhifubao"]];
    self.rechargeAlertAlipayImageView.frame = CGRectMake(12, 12, 36, 36);
    [self.bgView2 addSubview:self.rechargeAlertAlipayImageView];
    
    self.rechargeAlertAlipayLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertAlipayImageView.right+5, self.rechargeAlertAlipayImageView.top,self.view.width/2, 15)];
    self.rechargeAlertAlipayLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertAlipayLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertAlipayLabel.textColor = [UIColor blackColor];
    self.rechargeAlertAlipayLabel.text = @"支付宝支付";
    [self.bgView2 addSubview:self.rechargeAlertAlipayLabel];
    
    self.rechargeAlertAlipayEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertAlipayImageView.right+5, self.rechargeAlertAlipayLabel.bottom+5,200, 15)];
    self.rechargeAlertAlipayEXpLabel.font = [UIFont systemFontOfSize: 12];
    //    self.rechargeAlertAlipayEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertAlipayEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertAlipayEXpLabel.text = @"推荐有支付宝账号的用户使用";
    [self.bgView2 addSubview:self.rechargeAlertAlipayEXpLabel];
    
    UIButton *rechargeAlertAlipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertAlipayUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertAlipayUpBtn.frame = CGRectMake(12, 0, self.view.width, 60);
    [rechargeAlertAlipayUpBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: rechargeAlertAlipayUpBtn];
    
    self.rechargeAlertAlipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_daixuan"] forState:UIControlStateNormal];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateSelected];
    self.rechargeAlertAlipayBtn.frame = CGRectMake(self.view.width-34,20,20,20);
    [self.rechargeAlertAlipayBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: self.rechargeAlertAlipayBtn];
    
    
#pragma mark - 微信支付选择
    
    self.rechargeAlertWXImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dingdanzhifu_weixin"]];
    self.rechargeAlertWXImageView.frame = CGRectMake(12, self.rechargeAlertAlipayImageView.bottom+24, 36, 36);
    [self.bgView2 addSubview:self.rechargeAlertWXImageView];
    
    self.rechargeAlertWXLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertWXImageView.right+5, self.rechargeAlertWXImageView.top,self.view.width/2, 15)];
    self.rechargeAlertWXLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertAlipayLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertWXLabel.textColor = [UIColor blackColor];
    self.rechargeAlertWXLabel.text = @"微信支付";
    [self.bgView2 addSubview:self.rechargeAlertWXLabel];
    
    self.rechargeAlertWXEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertWXImageView.right+5, self.rechargeAlertWXLabel.bottom+5,200, 15)];
    self.rechargeAlertWXEXpLabel.font = [UIFont systemFontOfSize: 12];
    //    self.rechargeAlertAlipayEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertWXEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertWXEXpLabel.text = @"推荐安装微信5.0以上版本的用户使用";
    [self.bgView2 addSubview:self.rechargeAlertWXEXpLabel];
    
    UIButton *rechargeAlertWXUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertWXUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertWXUpBtn.frame = CGRectMake(12, 60, self.view.width, 60);
    [rechargeAlertWXUpBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: rechargeAlertWXUpBtn];
    
    self.rechargeAlertWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_daixuan"] forState:UIControlStateNormal];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateSelected];
    self.rechargeAlertWXBtn.frame = CGRectMake(self.view.width-34,80,20,20);
    [self.rechargeAlertWXBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: self.rechargeAlertWXBtn];
    
    
    UIButton *subOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [subOrderBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [subOrderBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [subOrderBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    subOrderBtn.backgroundColor = [UIColor flatLightRedColor];
    subOrderBtn.layer.cornerRadius = 20;
    subOrderBtn.layer.masksToBounds = YES;
    subOrderBtn.frame = CGRectMake(12,120+8,self.view.width-24,40);
    [subOrderBtn addTarget:self action:@selector(subAuthorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: subOrderBtn];

}

#pragma mark - 按钮点击方法

- (void)phoneBtnClicked{
    
    NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://0731-89790322"]];
    if (callView == nil) {
        callView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [callView loadRequest:[NSURLRequest requestWithURL:callURL]];
}

//支付宝选择按钮
- (void)alipayBtnClick:(id)sender{
    
    if(self.rechargeAlertAlipayBtn.selected)
    {
                
    }else{
        [self.rechargeAlertAlipayBtn setSelected:YES];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateHighlighted];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_daixuan"] forState:UIControlStateNormal];
    }
    [self.rechargeAlertWXBtn setSelected:NO];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_daixuan"] forState:UIControlStateNormal];
    
}

//微信选择按钮
- (void)wxBtnClick:(id)sender{
    
    if(self.rechargeAlertWXBtn.selected)
    {
        
    }else{
        [self.rechargeAlertWXBtn setSelected:YES];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateHighlighted];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"dizhiguanli_daixuan"] forState:UIControlStateNormal];
    }
    
    [self.rechargeAlertAlipayBtn setSelected:NO];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_queren"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"dizhiguanli_daixuan"] forState:UIControlStateNormal];
}

//确认支付
- (void)subAuthorBtnClick:(id)sender{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在跳转支付请稍等";
    
    
    [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
 
    if(self.rechargeAlertAlipayBtn.selected)
    {
        [YKLLocalUserDefInfo defModel].payWay = @"支付宝支付";
    }
    else if (self.rechargeAlertWXBtn.selected)
    {
        [YKLLocalUserDefInfo defModel].payWay = @"微信支付";
    }
    
    [YKLLocalUserDefInfo defModel].shopPayInfoDict = _payDict;
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    if(self.rechargeAlertAlipayBtn.selected){
        
        NSLog(@"%@",self.totleMoney);
        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:_orderSN productName:_content productDescription:@"口袋联采" amount:_totleMoney notifyURL:shopNotifyURL itBPay:@"30m"];
        
        Order *order = [Order order];
        order.partner = kPartnerID;
        order.seller = kSellerAccount;
        order.tradeNO = _orderSN;
        order.productName = _content;
        order.productDescription = @"口袋联采";
        order.amount = _totleMoney;
        order.notifyURL = shopNotifyURL;
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"UTF-8";
        order.itBPay = @"30m";
        
        // 将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        
        // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
        
        NSString *signedString = [AlipayRequestConfig genSignedStringWithPrivateKey:kPrivateKey OrderSpec:orderSpec];
        
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
            
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
                
                NSLog(@"reslut = %@",resultDic);
                
                NSString *object=[resultDic objectForKey:@"resultStatus"];
                NSLog(@"%@",object);
                
                if ([object isEqualToString:@"9000"])
                {
                    NSLog(@"成功%@", CallBackURL);
                    
                    [YKLLocalUserDefInfo defModel].payStatus = @"成功";
                    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                    
                    if ([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"YES"])
                    {
                        

                    }
                    else
                    {
                        if (![[YKLLocalUserDefInfo defModel].shopPayInfoDict isEqual:@{}]) {
                            
                            YKLShopPayResultViewController *vc = [YKLShopPayResultViewController new];
                            vc.type = 1;
                            
                            YKLBaseNavigationController *naVC = [[YKLBaseNavigationController alloc]initWithRootViewController:vc];
                            super.view.window.rootViewController = naVC;
                        }
                    }
                    
                }
                else{
                    NSLog(@"失败%@",MerchantURL);
                    
                    [YKLLocalUserDefInfo defModel].payStatus = @"失败";
                    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                    
                    if (![[YKLLocalUserDefInfo defModel].shopPayInfoDict isEqual:@{}]) {
                        
                        YKLShopPayResultViewController *vc = [YKLShopPayResultViewController new];
                        vc.type = 2;
                        
                        YKLBaseNavigationController *naVC = [[YKLBaseNavigationController alloc]initWithRootViewController:vc];
                        super.view.window.rootViewController = naVC;
                    }
                    
                }
            }];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    
    //选择微信支付按钮
    if (self.rechargeAlertWXBtn.selected){
        
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc] init];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        float tempMoney =[_totleMoney floatValue];
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",tempMoney*100];
        
        //获取到实际调起微信支付的参数后，在app端调起支付
        NSMutableDictionary *dict = [req sendPay_demo:self.content OrderPrice:priceStr OrderNub:_orderSN NotifyURL:SHOP_NOTIFY_URL];
        
        if(dict == nil){
            //错误提示
            NSString *debug = [req getDebugifo];
            
            //[self alert:@"提示信息" msg:debug];
            
            NSLog(@"%@\n\n",debug);
        }else{
            NSLog(@"%@\n\n",[req getDebugifo]);
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:req];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }

}



@end
