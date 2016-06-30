//
//  YKLPayViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLPayViewController.h"
#import "YKLVipPayIntroViewController.h"
#import "YKLTogetherShareViewController.h"

@interface YKLPayViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView1;                  //订单明细
@property (nonatomic, strong) UIView *bgView2;                  //支付方式

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *orderTitle;              //订单明细
@property (nonatomic, strong) UILabel *payWayTitle;             //支付方式

@property (nonatomic, strong) UIView *authorPayBgView;          //授权费背景视图
@property (nonatomic, strong) UILabel *authorPayTitle;          //首充：充值短信余额
@property (nonatomic, strong) UILabel *authorPayDetail;         //首充介绍
@property (nonatomic, strong) UILabel *authorPayMoney;          //首充金额
@property (nonatomic, strong) UILabel *authorPaySMS;            //首充短信数

@property (nonatomic, strong) UIView *diamondPayBgView;         //开通黄钻背景视图
@property (nonatomic, strong) UILabel *diamondPayTitle;         //开通黄钻功能
@property (nonatomic, strong) UILabel *diamondPayDetail;        //黄钻功能简介
@property (nonatomic, strong) UIButton *diamondPayDetailButton; //黄钻功能简介按钮
@property (nonatomic, strong) UILabel *diamondPayMoney;         //黄钻价格
@property (nonatomic, strong) UIButton *diamondPayButton;       //黄钻选择按钮

@property (nonatomic, strong) UIView *templateBgView;           //模板费用背景视图
@property (nonatomic, strong) UILabel *templateTitle;           //模板费用
@property (nonatomic, strong) UILabel *templateDetail;          //模板费用简介
@property (nonatomic, strong) UILabel *templateMoney;           //模板金额

@property (nonatomic, strong) UIView *flowBgView;               //流量费背景视图
@property (nonatomic, strong) UILabel *flowPayTitle;            //流量红包
@property (nonatomic, strong) UILabel *flowPayDetail;           //流量红包介绍
@property (nonatomic, strong) UILabel *flowPayMoney;            //流量充值金额
@property (nonatomic, strong) UILabel *flowPayNum;              //流量份数

@property (nonatomic, strong) UIView *childBgView;               //流量费背景视图
@property (nonatomic, strong) UILabel *childPayTitle;            //流量红包
@property (nonatomic, strong) UILabel *childPayNum;              //流量份数

@property (nonatomic, strong) UIView *totleBgView;              //总计背景视图
@property (nonatomic, strong) UILabel *totleTitle;              //总计：
@property (nonatomic, strong) UILabel *totleMoneyLabel;         //总计金额

@property (nonatomic, strong) UIView *SMSBgView;
@property (nonatomic, strong) UILabel *SMSTitle;
@property (nonatomic, strong) UILabel *SMSMoney;
@property (nonatomic, strong) UILabel *SMSNumTitle;
@property (nonatomic, strong) UILabel *SMSNum;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
//@property (nonatomic, strong) UILabel *discountLabel;           //折扣
//@property (nonatomic, strong) UILabel *discountNubLabel;

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
//余额支付
@property (nonatomic, strong) UIView *balanceBgview;
@property (nonatomic, strong) UIImageView *rechargeAlertBalanceImageView;
@property (nonatomic, strong) UILabel *rechargeAlertBalanceLabel;
@property (nonatomic, strong) UILabel *rechargeAlertBalanceEXpLabel;
@property (nonatomic, strong) UIButton *rechargeAlertBalanceBtn;
@property (nonatomic, strong) UIButton *subOrderBtn;
//其他支付方式背景视图
@property (nonatomic, strong) UIView *otherPayView;
@property (nonatomic, strong) UIButton *otherPayBtn;

@end

@implementation YKLPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.orderStatus == 12) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingConsumer getAuthorPriceSuccess:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.authorPrice = [dict objectForKey:@"author_price"];
            
            self.discount = [[dict objectForKey:@"discount"]floatValue];
            self.balance = [dict objectForKey:@"money"];
            self.vipPrice = [[dict objectForKey:@"vip_price"]floatValue];
            self.content = @"购买子账号费用";
            
            [self createBgView];
            [self createContent];
            //            [self otherPayBtnClick:nil];
            [self alipayBtnClick:nil];
            
            [self createChildPay];
            
            NSMutableDictionary *payDict = [NSMutableDictionary new];
            [payDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"buyer_id"];
            [payDict setObject:[YKLLocalUserDefInfo defModel].userName forKey:@"buyer_name"];
            [payDict setObject:[NSString stringWithFormat:@"%.2lf",self.totleMoneyNum] forKey:@"money"];
            [payDict setObject:@"8" forKey:@"type"];//1.短信 2.模板 3.授权 4.商品 5.余额 7.vip 8.购买子账号个数
            [payDict setObject:@"购买子账号费用" forKey:@"title"];
            [payDict setObject:@"2"forKey:@"pay_type"];//1.线下付  2.线上付
            [payDict setObject:@"1" forKey:@"order_type"];//1.大砍价 2.一起嗨 3.口袋红包 4.口袋夺宝
            [payDict setObject:@"" forKey:@"activity_id"];
            [payDict setObject:[NSString stringWithFormat:@"%d",_childNum] forKey:@"goods_num"];
            
            //默认传@“1”
            self.orderType = @"1";
            self.activityID = @"";
            
            self.payArray = [NSMutableArray arrayWithObject:payDict];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView showInfoMsg:error.domain];
        }];
        
        return;
    }

    if(self.orderStatus == 2) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingConsumer getAuthorPriceSuccess:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.authorPrice = [dict objectForKey:@"author_price"];
            
            self.discount = [[dict objectForKey:@"discount"]floatValue];
            self.balance = [dict objectForKey:@"money"];
            self.vipPrice = [[dict objectForKey:@"vip_price"]floatValue];
            self.content = @"授权费用";
            
            [self createBgView];
            [self createContent];
            //            [self otherPayBtnClick:nil];
            [self alipayBtnClick:nil];
            
            [self createAuthor];
            
            NSMutableDictionary *payDict = [NSMutableDictionary new];
            [payDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"buyer_id"];
            [payDict setObject:[YKLLocalUserDefInfo defModel].userName forKey:@"buyer_name"];
            [payDict setObject:[NSString stringWithFormat:@"%.2lf",self.authorMoneyNum] forKey:@"money"];
            [payDict setObject:@"3" forKey:@"type"];//1.短信 2.模板 3.授权 4.商品 5.余额 7.vip
            [payDict setObject:@"授权费用" forKey:@"title"];
            [payDict setObject:@"2"forKey:@"pay_type"];//1.线下付  2.线上付
            [payDict setObject:@"1" forKey:@"order_type"];//1.大砍价 2.一起嗨 3.口袋红包 4.口袋夺宝
            [payDict setObject:@"" forKey:@"activity_id"];
            
            //默认传@“1”
            self.orderType = @"1";
            self.activityID = @"";
            
            self.payArray = [NSMutableArray arrayWithObject:payDict];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView showInfoMsg:error.domain];
        }];
        
        return;
    }
    
    self.payArray = [NSMutableArray array];
    self.orderStatus = [[self.templateModel objectForKey:@"state"]integerValue];
    self.content = [self.templateModel objectForKey:@"content"];
    self.totleMoney = [self.templateModel objectForKey:@"totleMoney"];
    self.payArray = [self.templateModel objectForKey:@"pay"];
    
    
    if (![self.payArray isEqual:@[]]) {
        
        for (int i = 0; i < self.payArray.count; i++) {
            
            int type = [[self.payArray[i] objectForKey:@"type"]intValue];
            
            if (type == 1) {
                self.SMSMoneyNum = [[self.payArray[i] objectForKey:@"money"] floatValue];
            }
            else if (type == 2) {
                self.templateMoneyNum = [[self.payArray[i] objectForKey:@"money"] floatValue];
            }
            else if (type == 3) {
                self.authorMoneyNum = [[self.payArray[i] objectForKey:@"money"] floatValue];
            }
            else if (type == 6) {
                self.flowMoneyNum = [[self.payArray[i] objectForKey:@"money"] floatValue];
            }
        }
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer getAuthorPriceSuccess:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.authorPrice = [dict objectForKey:@"author_price"];
        self.discount = [[dict objectForKey:@"discount"]floatValue];
        self.balance = [dict objectForKey:@"money"];
        self.vipPrice = [[dict objectForKey:@"vip_price"]floatValue];
        
        [self createBgView];
        [self createContent];
        //        [self otherPayBtnClick:nil];
        
        if([self.payType isEqual:@"vip充值"]){
            
            self.content = @"vip充值";
            self.totleMoneyNum = self.vipPrice;
            [self createVipContent];
            //            [self otherPayBtnClick:nil];
            [self balanceBtnClick:0];
            
            self.diamondPayDetailButton.hidden = YES;
        }
        else if([self.payType isEqual:@"短信充值"]) {
            
            self.content = @"短信充值";
            self.moneyNub = 120;
            self.totleMoneyNum = self.moneyNub;
            [self createSMSContent];
            //            [self otherPayBtnClick:nil];
            [self balanceBtnClick:0];
            
            self.bgView1.height = 140;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.top = self.bgView2.bottom+30;
        }
        else {
            
            switch (self.orderStatus) {
                case 0:
                    NSLog(@"活动发布成功");
                    
                    if ([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"YES"]) {
                        
                        YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                        ShareVC.hidenBar = YES;
                        ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                        ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                        ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                        ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                        ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                        self.view.window.rootViewController = ShareVC;
                    }
                    
                    break;
                case 1:
                    NSLog(@"代理商未授权（尚未开始使用）");
                    break;
                case 2:
                    NSLog(@"第一次充值300，授权费用");
                    
                    self.content = @"授权费用";
                    [self createAuthor];
                    
                    break;
                case 3:
                    NSLog(@"有短信及模板需要购买");
                    
                    self.content = @"短信和模板费用";
                    [self createTemplateAndSMSPay];
                    break;
                case 4:
                    NSLog(@"只需要购买模板");
                    
                    self.content = @"模板费用";
                    [self createTemplatePay];
                    break;
                case 5:
                    NSLog(@"只需要购买模板，友情提示短信数量少");
                    break;
                case 6:
                    NSLog(@"只需要购买短信");
                    
                    self.content = @"短信充值";
                    self.moneyNub = 120;
                    self.totleMoneyNum = self.moneyNub;
                    [self createSMSContent];
                    [self balanceBtnClick:0];
                    self.bgView1.height = 140;
                    self.totleBgView.top = self.bgView1.height-36;
                    self.bgView2.top = self.bgView1.bottom+10;
                    self.subOrderBtn.top = self.bgView2.bottom+30;
                    break;
                case 7:
                    NSLog(@"发布成功");
                    break;
                case 8:
                    NSLog(@"发布成功，友情提示短信数量少");
                case 9:
                    NSLog(@"发布失败");
                    break;
                case 10:
                    NSLog(@"充值流量");
                    
                    self.content = @"流量费用";
                    [self createFlow];
                    break;
                case 11:
                    NSLog(@"流量&短信");
                    
                    self.content = @"流量和短信费用";
                    [self createFlowAndSMS];
                default:
                    break;
            }
        }
        
        if (self.orderStatus != 2) {
            
            float balance = [self.balance floatValue];
            if (balance < self.totleMoneyNum) {
                //                [self otherPayBtnClick:nil];
                [self alipayBtnClick:nil];
            }
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:error.domain];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.payType;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop  target:self action:@selector(activityLeftBarItemClicked:)];
    
    
}

- (void)activityLeftBarItemClicked:(UIBarButtonItem *)sender {
    
    if (self.activityID == NULL || [self.activityID isEqual:@""]) {
        
        NSString *message;
        
        if ([self.payType isEqual:@"vip充值"])
        {
            message = @"是否确定取消付款？开通黄钻免模板和活动发布费用哦";
        }
        else if ([self.payType isEqual:@"短信充值"])
        {
            message = @"是否确定取消付款？短信余额不足的话可能影响您发布的活动效果哦";
        }
        
        else if (self.orderStatus == 2)
        {
            message = @"是否确定取消付款？授权成功后即可马上发布活动哦";
        }
        
        else
        {
            message = @"是否确定取消付款？";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:message delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        [alertView show];
        
        
        
    }else{
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定取消付款？取消后活动将保存在待发布列表中。" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        [alertView show];
        
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        
    }else if (buttonIndex == 1){
        
    }
}

- (void)popHidden{
    
    if (self.activityID == NULL || [self.activityID isEqual:@""]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        if (self.isListPop == YES) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.isListDetailPop == YES){
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
            
        }
        else if([self.orderType isEqual:@"1"]||[self.orderType isEqual:@"2"]) {
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 4] animated:YES];
        }
        else if([self.orderType isEqual:@"3"]||[self.orderType isEqual:@"4"]||[self.orderType isEqual:@"5"]||[self.orderType isEqual:@"6"]){
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        }
        
    }
    
}



//模板付费页面
- (void)createTemplatePay{
    
    self.title = @"开启活动";
    self.totleMoneyNum = self.templateMoneyNum;
    
    if (![[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        
        [self createVipContent];
        self.bgView1.height = 180;
    }
    else
    {
        self.bgView1.height = 120;
    }
    [self createTemplateContent];
    //    [self otherPayBtnClick:nil];
    [self balanceBtnClick:0];
    self.diamondPayBgView.top = 23+60;
    self.diamondPayMoney.right = self.diamondPayDetailButton.right;
    self.diamondPayMoney.textAlignment = NSTextAlignmentRight;
    
    
    self.totleBgView.top = self.bgView1.height-36;
    self.bgView2.top = self.bgView1.bottom+10;
    self.subOrderBtn.top = self.bgView2.bottom+30;
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
    
    UIButton *rechargeAlertAlipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertAlipayUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertAlipayUpBtn.frame = CGRectMake(self.diamondPayBgView.width-100, 0, 100, self.diamondPayBgView.height);
    [rechargeAlertAlipayUpBtn addTarget:self action:@selector(diamondPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview: rechargeAlertAlipayUpBtn];
    
    self.diamondPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.diamondPayButton.frame = CGRectMake(self.view.width-20-38,0,20,20);
    self.diamondPayButton.centerY = self.diamondPayBgView.height/2;
    [self.diamondPayButton addTarget:self action:@selector(diamondPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview: self.diamondPayButton];
}

//模板和短信付费页面
- (void)createTemplateAndSMSPay{
    
    self.moneyNub = 120;
    self.totleMoneyNum = 120+self.templateMoneyNum;
    
    self.title = @"开启活动";
    
    if (![[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        
        [self createVipContent];
        self.bgView1.height = 270;
    }
    else{
        self.bgView1.height = 210;
    }
    
    [self createTemplateContent];
    [self createSMSContent];
    //    [self otherPayBtnClick:nil];
    [self balanceBtnClick:0];
    
    self.SMSBgView.top = 23+60;
    self.diamondPayBgView.top = 23+60+80;
    self.diamondPayMoney.right = self.diamondPayDetailButton.right;
    self.diamondPayMoney.textAlignment = NSTextAlignmentRight;
    
    
    self.totleBgView.top = self.bgView1.height-36;
    self.bgView2.top = self.bgView1.bottom+10;
    self.subOrderBtn.top = self.bgView2.bottom+30;
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
    
    UIButton *rechargeAlertAlipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertAlipayUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertAlipayUpBtn.frame = CGRectMake(self.diamondPayBgView.width-100, 0, 100, self.diamondPayBgView.height);
    [rechargeAlertAlipayUpBtn addTarget:self action:@selector(diamondPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview: rechargeAlertAlipayUpBtn];
    
    self.diamondPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.diamondPayButton.frame = CGRectMake(self.view.width-20-38,0,20,20);
    self.diamondPayButton.centerY = self.diamondPayBgView.height/2;
    [self.diamondPayButton addTarget:self action:@selector(diamondPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview: self.diamondPayButton];
    
}

//子账号费用
- (void)createChildPay{
    
    self.title = @"子账号费用";
    
    [self createChildContent];
    
    self.bgView1.height = 105;
    self.totleBgView.top = self.bgView1.height-36;
    self.bgView2.top = self.bgView1.bottom+10;
    self.subOrderBtn.top = self.bgView2.bottom+30;
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
}

//授权费用页面
- (void)createAuthor{
    
    self.totleMoneyNum = self.authorMoneyNum+self.templateMoneyNum+self.flowMoneyNum;
    
    self.title = @"开启活动";
    
    [self createAuthorContent];
    
    if (![[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        
        [self createVipContent];
        
        self.bgView1.height = 184;
        
        if (self.templateMoneyNum) {
            
            [self createTemplateContent];
            self.bgView1.height = 184+60;
            self.templateBgView.top = 23+65+60;
            
        }
        else if (self.flowMoneyNum){
            
            [self createFlowContent];
            self.bgView1.height = 184+80;
            self.flowBgView.top = 23+65+60;
        }
    }
    else{
        
        self.bgView1.height = 124;
        
        if (self.templateMoneyNum) {
            
            [self createTemplateContent];
            self.bgView1.height = 124+60;
            self.templateBgView.top = 23+65;
            
        }
        else if (self.flowMoneyNum){
            
            [self createFlowContent];
            self.bgView1.height = 124+80;
            self.flowBgView.top = 23+65;
        }
        
    }
    
    //隐藏余额支付
    [self alipayBtnClick:nil];
    
    self.bgView2.height = 140;
    self.otherPayView.top = 38;
    self.balanceBgview.hidden = YES;
    
    self.diamondPayBgView.top = 23+65;
    self.diamondPayMoney.right = self.diamondPayDetailButton.right;
    self.diamondPayMoney.textAlignment = NSTextAlignmentRight;
    
    self.totleBgView.top = self.bgView1.height-36;
    self.bgView2.top = self.bgView1.bottom+10;
    self.subOrderBtn.top = self.bgView2.bottom+30;
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
    
    UIButton *rechargeAlertAlipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertAlipayUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertAlipayUpBtn.frame = CGRectMake(self.diamondPayBgView.width-100, 0, 100, self.diamondPayBgView.height);
    [rechargeAlertAlipayUpBtn addTarget:self action:@selector(diamondPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview: rechargeAlertAlipayUpBtn];
    
    self.diamondPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.diamondPayButton.frame = CGRectMake(self.view.width-20-38,0,20,20);
    self.diamondPayButton.centerY = self.diamondPayBgView.height/2;
    [self.diamondPayButton addTarget:self action:@selector(diamondPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview: self.diamondPayButton];
    
    if (self.authorVIP) {
        [self diamondPayButtonClick:nil];
    }
    
}

//流量页面
- (void)createFlow{
    
    self.totleMoneyNum = self.flowMoneyNum;
    
    self.title = @"开启活动";
    //    [self otherPayBtnClick:nil];
    [self balanceBtnClick:0];
    [self createFlowContent];
    
    self.bgView1.height = 145;
    self.totleBgView.top = self.bgView1.height-36;
    self.bgView2.top = self.bgView1.bottom+10;
    self.subOrderBtn.top = self.bgView2.bottom+30;
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
}

//流量页面和短信付费页面
- (void)createFlowAndSMS{
    
    self.moneyNub = 120;
    self.totleMoneyNum = 120+self.flowMoneyNum;
    
    self.title = @"开启活动";
    
    [self createFlowContent];
    [self createSMSContent];
    //    [self otherPayBtnClick:nil];
    [self balanceBtnClick:0];
    
    self.SMSBgView.top = 23+80;
    self.bgView1.height = 225;
    self.totleBgView.top = self.bgView1.height-36;
    self.bgView2.top = self.bgView1.bottom+10;
    self.subOrderBtn.top = self.bgView2.bottom+30;
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
}

- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10)];
    //    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 140+75-20-15)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
    self.subOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.subOrderBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.subOrderBtn.backgroundColor = [UIColor flatLightRedColor];
    self.subOrderBtn.layer.cornerRadius = 20;
    self.subOrderBtn.layer.masksToBounds = YES;
    self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
    [self.subOrderBtn addTarget:self action:@selector(subAuthorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: self.subOrderBtn];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
    
}

- (void)createContent{
    
    self.orderTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 22)];
    self.orderTitle.font = [UIFont systemFontOfSize:16];
    self.orderTitle.text = @"订单明细";
    [self.bgView1 addSubview:self.orderTitle];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.orderTitle.bottom, self.view.width, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:self.lineView];
    
    self.totleBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.height-36, self.view.width, 36)];
    //    self.totleBgView.backgroundColor = [UIColor flatLightGreenColor];
    [self.bgView1 addSubview:self.totleBgView];
    
    self.totleTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 36)];
    self.totleTitle.font = [UIFont systemFontOfSize:14];
    self.totleTitle.text = @"总计：";
    [self.totleBgView addSubview:self.totleTitle];
    
    self.totleMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, 0,  95, 36)];
    self.totleMoneyLabel.font = [UIFont systemFontOfSize:14];
    self.totleMoneyLabel.textColor = [UIColor flatLightRedColor];
    self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%1.lf",self.vipPrice];
    [self.totleBgView addSubview:self.totleMoneyLabel];
    
    
    self.payWayTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 22)];
    self.payWayTitle.font = [UIFont systemFontOfSize:16];
    self.payWayTitle.text = @"支付方式";
    [self.bgView2 addSubview:self.payWayTitle];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.orderTitle.bottom, self.view.width, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:self.lineView];
    
#pragma mark - 余额支付选择
    
    self.balanceBgview = [[UIView alloc]initWithFrame:CGRectMake(0, self.lineView.bottom+15, self.view.width, 80-20-15)];
    [self.bgView2 addSubview:self.balanceBgview];
    
    self.rechargeAlertBalanceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"余额"]];
    self.rechargeAlertBalanceImageView.frame = CGRectMake(10, 0, 30, 30);
    [self.balanceBgview addSubview:self.rechargeAlertBalanceImageView];
    
    self.rechargeAlertBalanceLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertBalanceImageView.right+5, self.rechargeAlertBalanceImageView.top,60, 15)];
    self.rechargeAlertBalanceLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertBalanceLabel.backgroundColor = [UIColor yellowColor];
    self.rechargeAlertBalanceLabel.textColor = [UIColor blackColor];
    self.rechargeAlertBalanceLabel.text = @"余额支付";
    [self.balanceBgview addSubview:self.rechargeAlertBalanceLabel];
    
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertBalanceLabel.right, 0, 120, 15)];
    balanceLabel.bottom = self.rechargeAlertBalanceLabel.bottom;
    balanceLabel.font = [UIFont systemFontOfSize: 12.0];
    //    balanceLabel.backgroundColor = [UIColor redColor];
    balanceLabel.textColor = [UIColor blackColor];
    balanceLabel.text = [NSString stringWithFormat:@"(可用:%@元)",self.balance];
    [self.balanceBgview addSubview:balanceLabel];
    
    self.rechargeAlertBalanceEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertBalanceImageView.right+5, self.rechargeAlertBalanceLabel.bottom,self.lineView.width/2, 15)];
    self.rechargeAlertBalanceEXpLabel.font = [UIFont systemFontOfSize: 12.0];
    //        self.rechargeAlertBalanceEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertBalanceEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertBalanceEXpLabel.text = [NSString stringWithFormat:@"余额支付享受%.1f折",self.discount*10];
    [self.balanceBgview addSubview:self.rechargeAlertBalanceEXpLabel];
    
    UIButton *rechargeAlertBalanceUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertBalanceUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertBalanceUpBtn.frame = CGRectMake(10, 0, self.lineView.width, 30);
    [rechargeAlertBalanceUpBtn addTarget:self action:@selector(balanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.balanceBgview addSubview: rechargeAlertBalanceUpBtn];
    
    self.rechargeAlertBalanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateSelected];
    self.rechargeAlertBalanceBtn.frame = CGRectMake(self.view.width-20-38,self.rechargeAlertBalanceImageView.top,20,20);
    [self.rechargeAlertBalanceBtn addTarget:self action:@selector(balanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    //默认用余额支付
    //    self.rechargeAlertBalanceBtn.selected = YES;
    [self.balanceBgview addSubview: self.rechargeAlertBalanceBtn];
    
    
#pragma mark - 其他支付方式
    //
    //    UILabel *otherPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rechargeAlertBalanceImageView.bottom+15, 85, 20)];
    //    otherPayLabel.font = [UIFont systemFontOfSize: 14.0];
    //    otherPayLabel.text = @"其他付款方式";
    //    otherPayLabel.textColor = [UIColor blackColor];
    //    [self.balanceBgview addSubview:otherPayLabel];
    //
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(otherPayLabel.right+5, 0, 192, 1)];
    //    lineView.centerY = otherPayLabel.centerY;
    //    lineView.backgroundColor = [UIColor lightGrayColor];
    //    [self.balanceBgview addSubview:lineView];
    //
    //    UIButton *otherPayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    otherPayUpBtn.backgroundColor = [UIColor clearColor];
    //    otherPayUpBtn.frame = CGRectMake(0, otherPayLabel.top, self.view.width, 20);
    //    [otherPayUpBtn addTarget:self action:@selector(otherPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.balanceBgview addSubview: otherPayUpBtn];
    //
    //    self.otherPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
    //    [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向上"] forState:UIControlStateHighlighted];
    //    [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向上"] forState:UIControlStateSelected];
    //    self.otherPayBtn.frame = CGRectMake(lineView.right+5,otherPayLabel.top,20,20);
    //    [self.otherPayBtn addTarget:self action:@selector(otherPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.balanceBgview addSubview: self.otherPayBtn];
    
    
    self.otherPayView = [[UIView alloc]initWithFrame:CGRectMake(10, self.balanceBgview.bottom, self.lineView.width, 30+15+30)];
    //    self.otherPayView.hidden = YES;
    self.otherPayView.backgroundColor = [UIColor clearColor];
    [self.bgView2 addSubview:self.otherPayView];
    
    
#pragma mark - 支付宝支付选择
    
    self.rechargeAlertAlipayImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"支付宝"]];
    self.rechargeAlertAlipayImageView.frame = CGRectMake(0, 0, 30, 30);
    [self.otherPayView addSubview:self.rechargeAlertAlipayImageView];
    
    self.rechargeAlertAlipayLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertAlipayImageView.right+5, self.rechargeAlertAlipayImageView.top,self.lineView.width/2, 15)];
    self.rechargeAlertAlipayLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertAlipayLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertAlipayLabel.textColor = [UIColor blackColor];
    self.rechargeAlertAlipayLabel.text = @"支付宝";
    [self.otherPayView addSubview:self.rechargeAlertAlipayLabel];
    
    self.rechargeAlertAlipayEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertAlipayImageView.right+5, self.rechargeAlertAlipayLabel.bottom,self.lineView.width/2, 15)];
    self.rechargeAlertAlipayEXpLabel.font = [UIFont systemFontOfSize: 12.0];
    //    self.rechargeAlertAlipayEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertAlipayEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertAlipayEXpLabel.text = @"推荐支付宝用户使用";
    [self.otherPayView addSubview:self.rechargeAlertAlipayEXpLabel];
    
    UIButton *rechargeAlertAlipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertAlipayUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertAlipayUpBtn.frame = CGRectMake(0, 0, self.lineView.width, 30);
    [rechargeAlertAlipayUpBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherPayView addSubview: rechargeAlertAlipayUpBtn];
    
    self.rechargeAlertAlipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateSelected];
    self.rechargeAlertAlipayBtn.frame = CGRectMake(self.view.width-20-38-10,self.rechargeAlertAlipayImageView.top,20,20);
    [self.rechargeAlertAlipayBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherPayView addSubview: self.rechargeAlertAlipayBtn];
    
    
#pragma mark - 微信支付选择
    
    self.rechargeAlertWXImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信"]];
    self.rechargeAlertWXImageView.frame = CGRectMake(0, self.rechargeAlertAlipayImageView.bottom+15, 30, 30);
    [self.otherPayView addSubview:self.rechargeAlertWXImageView];
    
    self.rechargeAlertWXLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertWXImageView.right+5, self.rechargeAlertWXImageView.top,self.lineView.width/2, 15)];
    self.rechargeAlertWXLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertAlipayLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertWXLabel.textColor = [UIColor blackColor];
    self.rechargeAlertWXLabel.text = @"微信支付";
    [self.otherPayView addSubview:self.rechargeAlertWXLabel];
    
    self.rechargeAlertWXEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertWXImageView.right+5, self.rechargeAlertWXLabel.bottom,self.lineView.width/2, 15)];
    self.rechargeAlertWXEXpLabel.font = [UIFont systemFontOfSize: 12.0];
    //    self.rechargeAlertAlipayEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertWXEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertWXEXpLabel.text = @"推荐微信用户使用";
    [self.otherPayView addSubview:self.rechargeAlertWXEXpLabel];
    
    UIButton *rechargeAlertWXUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertWXUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertWXUpBtn.frame = CGRectMake(0, self.rechargeAlertWXImageView.top, self.lineView.width, 30);
    [rechargeAlertWXUpBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherPayView addSubview: rechargeAlertWXUpBtn];
    
    self.rechargeAlertWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateSelected];
    self.rechargeAlertWXBtn.frame = CGRectMake(self.view.width-20-38-10,self.rechargeAlertWXImageView.top,20,20);
    [self.rechargeAlertWXBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherPayView addSubview: self.rechargeAlertWXBtn];
}

//授权充值内容
- (void)createAuthorContent{
    
    self.authorPayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.width, 65)];
    [self.bgView1 addSubview:self.authorPayBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 64, self.view.width-20, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.authorPayBgView addSubview:self.lineView];
    
    self.authorPayTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 15)];
    self.authorPayTitle.font = [UIFont systemFontOfSize:14];
    self.authorPayTitle.textColor = [UIColor blackColor];
    self.authorPayTitle.text= @"充值短信余额";
    [self.authorPayBgView addSubview:self.authorPayTitle];
    
    self.authorPayDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, self.authorPayTitle.bottom+5, 200, 25)];
    self.authorPayDetail.font = [UIFont systemFontOfSize:10];
    self.authorPayDetail.textColor = [UIColor lightGrayColor];
    self.authorPayDetail.text = [NSString stringWithFormat:@"(您暂未开通短信通道,开通后才能充值黄钻,首次充值%@元获取2000条短信)",self.authorPrice];
    self.authorPayDetail.numberOfLines = 0;
    [self.authorPayBgView addSubview:self.authorPayDetail];
    
    self.authorPayMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, self.authorPayTitle.top, 95, 15)];
    self.authorPayMoney.font = [UIFont systemFontOfSize:14];
    self.authorPayMoney.textColor = [UIColor flatLightRedColor];
    self.authorPayMoney.text = [NSString stringWithFormat:@"¥%.2lf元",self.authorMoneyNum];
    [self.authorPayBgView addSubview:self.authorPayMoney];
    
    self.authorPaySMS = [[UILabel alloc]initWithFrame:CGRectMake(self.authorPayTitle.right+10, self.authorPayTitle.top, 50, 15)];
    self.authorPaySMS.font = [UIFont systemFontOfSize:14];
    self.authorPaySMS.textColor = [UIColor flatLightRedColor];
    self.authorPaySMS.text = @"2000条";
    [self.authorPayBgView addSubview:self.authorPaySMS];
}

//模板充值页面内容
- (void)createTemplateContent{
    
    self.templateBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.width, 60)];
    //    self.templateBgView.backgroundColor = [UIColor flatLightYellowColor];
    [self.bgView1 addSubview:self.templateBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, self.view.width-20, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.templateBgView addSubview:self.lineView];
    
    self.templateTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 15)];
    self.templateTitle.font = [UIFont systemFontOfSize:14];
    self.templateTitle.textColor = [UIColor blackColor];
    self.templateTitle.text= @"模板费用";
    [self.templateBgView addSubview:self.templateTitle];
    
    self.templateDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, self.templateTitle.bottom+5, 160, 10)];
    self.templateDetail.font = [UIFont systemFontOfSize:10];
    self.templateDetail.textColor = [UIColor lightGrayColor];
    self.templateDetail.text = @"(您需要购买本套模板)";
    [self.templateBgView addSubview:self.templateDetail];
    
    self.templateMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, self.templateTitle.top, 95, 15)];
    self.templateMoney.font = [UIFont systemFontOfSize:14];
    self.templateMoney.textColor = [UIColor flatLightRedColor];
    self.templateMoney.text = [NSString stringWithFormat:@"¥%.2lf元",self.templateMoneyNum];
    [self.templateBgView addSubview:self.templateMoney];
    
}

//VIP充值页面内容
- (void)createVipContent{
    
    self.diamondPayBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.width, 60)];
    //    self.diamondPayBgView.backgroundColor = [UIColor flatLightYellowColor];
    [self.bgView1 addSubview:self.diamondPayBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59, self.view.width-20, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.diamondPayBgView addSubview:self.lineView];
    
    self.diamondPayTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 15)];
    self.diamondPayTitle.font = [UIFont systemFontOfSize:14];
    self.diamondPayTitle.textColor = [UIColor blackColor];
    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:@"开通黄钻功能"];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1_1=[[hintString1 string]rangeOfString:@"黄钻"];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor flatLightRedColor] range:range1_1];
    self.diamondPayTitle.attributedText= hintString1;
    [self.diamondPayBgView addSubview:self.diamondPayTitle];
    
    self.diamondPayDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, self.diamondPayTitle.bottom+5, 160, 10)];
    self.diamondPayDetail.font = [UIFont systemFontOfSize:10];
    self.diamondPayDetail.textColor = [UIColor lightGrayColor];
    self.diamondPayDetail.text = @"(开通黄钻免模板和活动发布费用)";
    [self.diamondPayBgView addSubview:self.diamondPayDetail];
    
    self.diamondPayDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.diamondPayDetailButton.frame = CGRectMake(self.diamondPayDetail.right, self.diamondPayDetail.top, 40, 10);
    [self.diamondPayDetailButton setTitle:@"了解更多" forState:UIControlStateNormal];
    [self.diamondPayDetailButton setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
    [self.diamondPayDetailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.diamondPayDetailButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.diamondPayDetailButton addTarget:self action:@selector(diamondPayDetailButtonClicked)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.diamondPayBgView addSubview:self.diamondPayDetailButton];
    
    self.diamondPayMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, self.diamondPayTitle.top, 95, 15)];
    self.diamondPayMoney.font = [UIFont systemFontOfSize:14];
    self.diamondPayMoney.textColor = [UIColor flatLightRedColor];
    self.diamondPayMoney.text = [NSString stringWithFormat:@"¥%.lf/年",self.vipPrice];
    [self.diamondPayBgView addSubview:self.diamondPayMoney];
}

//短信充值页面内容
- (void)createSMSContent{
    
    self.SMSBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.width, 80)];
    //    self.SMSBgView.backgroundColor = [UIColor yellowColor];
    [self.bgView1 addSubview:self.SMSBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 79, self.view.width-20, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.SMSBgView addSubview:self.lineView];
    
    self.SMSTitle  = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 26)];
    self.SMSTitle.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertActivityLabel.backgroundColor = [UIColor redColor];
    self.SMSTitle.textColor = [UIColor blackColor];
    self.SMSTitle.text = @"充值短信余额";
    [self.SMSBgView addSubview:self.SMSTitle];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"加hover"] forState:UIControlStateHighlighted];
    self.addBtn.frame = CGRectMake(self.view.width-30-30,self.SMSTitle.top,30,26);
    [self.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.SMSBgView addSubview: self.addBtn];
    
    self.SMSMoney  = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.left-40, self.SMSTitle.top,40, 26)];
    self.SMSMoney.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertActivityNubLabel.backgroundColor = [UIColor redColor];
    self.SMSMoney.textColor = [UIColor blackColor];
    self.SMSMoney.text = [NSString stringWithFormat:@"%d",self.moneyNub];
    self.SMSMoney.textAlignment = NSTextAlignmentCenter;
    [self.SMSBgView addSubview:self.SMSMoney];
    
    self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusBtn setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"减hover"] forState:UIControlStateHighlighted];
    self.minusBtn.frame = CGRectMake(self.SMSMoney.left-30,self.SMSTitle.top,30,26);
    [self.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.SMSBgView addSubview: self.minusBtn];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.SMSTitle.bottom+5, 250, 10)];
    textLabel.font = [UIFont systemFontOfSize:10];
    textLabel.textColor = [UIColor lightGrayColor];
    textLabel.text = @"(您短信余额已不足，请尽快充值以免影响活动效果)";
    [self.SMSBgView addSubview:textLabel];
    
    self.SMSNumTitle  = [[UILabel alloc]initWithFrame:CGRectMake(10, textLabel.bottom+5,100, 26)];
    self.SMSNumTitle.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertMoneyLabel.backgroundColor = [UIColor redColor];
    self.SMSNumTitle.textColor = [UIColor blackColor];
    self.SMSNumTitle.text = @"短信条数";
    [self.SMSBgView addSubview:self.SMSNumTitle];
    
    self.SMSNum = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, self.SMSNumTitle.top,95,26)];
    self.SMSNum.right = self.view.right;
    self.SMSNum.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertMoneyNubLabel.backgroundColor = [UIColor redColor];
    self.SMSNum.textColor = [UIColor flatLightRedColor];
    self.SMSNum.text = [NSString stringWithFormat:@"%d条",self.moneyNub*2000/120];
    [self.SMSBgView addSubview:self.SMSNum];
    
}

//流量充值内容
- (void)createFlowContent{
    
    self.flowBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.width, 80)];
    [self.bgView1 addSubview:self.flowBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 79, self.view.width-20, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.flowBgView addSubview:self.lineView];
    
    self.flowPayTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 15)];
    self.flowPayTitle.font = [UIFont systemFontOfSize:14];
    self.flowPayTitle.textColor = [UIColor blackColor];
    self.flowPayTitle.text= @"流量红包";
    [self.flowBgView addSubview:self.flowPayTitle];
    
    self.flowPayDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, self.flowPayTitle.bottom+5, 230, 40)];
    self.flowPayDetail.font = [UIFont systemFontOfSize:10];
    self.flowPayDetail.textColor = [UIColor lightGrayColor];
    self.flowPayDetail.text = [YKLLocalUserDefInfo defModel].redFlowDesc;
    self.flowPayDetail.numberOfLines = 0;
    [self.flowBgView addSubview:self.flowPayDetail];
    
    self.flowPayMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, self.flowPayTitle.top, 95, 15)];
    self.flowPayMoney.font = [UIFont systemFontOfSize:14];
    self.flowPayMoney.textColor = [UIColor flatLightRedColor];
    self.flowPayMoney.text = [NSString stringWithFormat:@"¥%.2lf元",self.flowMoneyNum];
    [self.flowBgView addSubview:self.flowPayMoney];
    
    self.flowPayNum = [[UILabel alloc]initWithFrame:CGRectMake(self.flowPayTitle.right+10, self.flowPayTitle.top, 50, 15)];
    self.flowPayNum.font = [UIFont systemFontOfSize:14];
    self.flowPayNum.textColor = [UIColor flatLightRedColor];
    self.flowPayNum.text = [NSString stringWithFormat:@"%.lf份",self.flowMoneyNum/3.5];
    [self.flowBgView addSubview:self.flowPayNum];
}

//流量充值内容
- (void)createChildContent{
    
    self.childBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, self.view.width, 40)];
    [self.bgView1 addSubview:self.childBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 39, self.view.width-20, 0.5)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.childBgView addSubview:self.lineView];
    
    self.childPayTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 15)];
    self.childPayTitle.font = [UIFont systemFontOfSize:14];
    self.childPayTitle.textColor = [UIColor blackColor];
    self.childPayTitle.text= @"购买子账号个数";
    [self.childBgView addSubview:self.childPayTitle];
    
    self.childPayNum = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-95, self.childPayTitle.top, 50, 15)];
    self.childPayNum.font = [UIFont systemFontOfSize:14];
    self.childPayNum.textColor = [UIColor flatLightRedColor];
    self.childPayNum.text = [NSString stringWithFormat:@"%d",_childNum];
    [self.childBgView addSubview:self.childPayNum];
}


//了解更多按钮
- (void)diamondPayDetailButtonClicked{
    
    YKLVipPayIntroViewController *vc = [YKLVipPayIntroViewController new];
    vc.hidePay = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)minusBtnClick:(id)sender{
    NSLog(@"————————————————————————");
    
    if (self.moneyNub>120) {
        self.moneyNub-=120;
        
        if (self.rechargeAlertBalanceBtn.selected) {
            
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub*self.discount];
            [self.totleBgView addSubview:self.totleMoneyLabel];
            
            if (self.orderStatus == 3) {
                self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(self.moneyNub+self.templateMoneyNum)*self.discount];
                [self.totleBgView addSubview:self.totleMoneyLabel];
            }
            if (self.orderStatus == 11) {
                self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(self.moneyNub+self.flowMoneyNum)*self.discount];
                [self.totleBgView addSubview:self.totleMoneyLabel];
            }
            if (self.diamondPayButton.selected) {
                self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(self.moneyNub+self.vipPrice)*self.discount];
                [self.totleBgView addSubview:self.totleMoneyLabel];
            }
            
        }else{
            
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub*1.0];
            [self.totleBgView addSubview:self.totleMoneyLabel];
            
            if (self.orderStatus == 3) {
                self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%2.lf",self.moneyNub+self.templateMoneyNum];
                [self.totleBgView addSubview:self.totleMoneyLabel];
            }
            if (self.orderStatus == 11) {
                self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub+self.flowMoneyNum];
                [self.totleBgView addSubview:self.totleMoneyLabel];
            }
            if (self.diamondPayButton.selected) {
                self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub+self.vipPrice];
                [self.totleBgView addSubview:self.totleMoneyLabel];
            }
            
        }
        
        self.SMSMoney.text = [NSString stringWithFormat:@"%d",self.moneyNub];
        [self.SMSBgView addSubview:self.SMSMoney];
        self.SMSNum.text = [NSString stringWithFormat:@"%d条",self.moneyNub*2000/120];
        [self.SMSBgView addSubview:self.SMSNum];
    }
    
    self.totleMoneyNum = self.moneyNub+self.flowMoneyNum+self.templateMoneyNum;
    
}

- (void)addBtnClick:(id)sender{
    NSLog(@"++++++++++++++++++++++++");
    
    self.moneyNub+=120;
    
    if (self.rechargeAlertBalanceBtn.selected) {
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub*self.discount];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
        if (self.orderStatus == 3) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(self.moneyNub+self.templateMoneyNum)*self.discount];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        if (self.orderStatus == 11) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(self.moneyNub+self.flowMoneyNum)*self.discount];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        if (self.diamondPayButton.selected) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",(self.moneyNub+self.vipPrice)*self.discount];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        
    }else{
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub*1.0];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
        if (self.orderStatus == 3) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub+self.templateMoneyNum];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        if (self.orderStatus == 11) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub+self.flowMoneyNum];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        if (self.diamondPayButton.selected) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.moneyNub+self.vipPrice];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
    }
    
    self.SMSMoney.text = [NSString stringWithFormat:@"%d",self.moneyNub];
    [self.SMSBgView addSubview:self.SMSMoney];
    self.SMSNum.text = [NSString stringWithFormat:@"%d条",self.moneyNub*2000/120];
    [self.SMSBgView addSubview:self.SMSNum];
    
    self.totleMoneyNum = self.moneyNub+self.flowMoneyNum+self.templateMoneyNum;
    
}

//黄钻选择按钮
- (void)diamondPayButtonClick:(id)sender{
    
    if(self.diamondPayButton.selected)
    {
        if (self.orderStatus == 3) {
            
            self.templateBgView.hidden = NO;
            self.bgView1.height = 270;
            self.SMSBgView.top = 23+60;
            self.diamondPayBgView.top = 23+60+80;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
            
            self.totleMoneyNum = self.templateMoneyNum+self.moneyNub;
        }
        else if(self.orderStatus == 2){
            
            if (self.templateMoneyNum) {
                
                self.templateBgView.hidden = NO;
                self.bgView1.height = 184+60;
                
            }
            else if (self.flowMoneyNum){
                
                self.flowBgView.hidden = NO;
                self.bgView1.height = 184+80;
            }
            
            self.diamondPayBgView.top = 23+65;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
            
            self.totleMoneyNum = self.authorMoneyNum+self.templateMoneyNum+self.flowMoneyNum;
        }
        else{
            
            self.templateBgView.hidden = NO;
            self.bgView1.height = 180;
            self.diamondPayBgView.top = 23+60;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
            self.totleMoneyNum = self.templateMoneyNum;
        }
        
        [self.diamondPayButton setSelected:NO];
        [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.diamondPayButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        
    }else{
        if (self.orderStatus == 3) {
            
            self.templateBgView.hidden = YES;
            self.bgView1.height = 210;
            self.SMSBgView.top = 23;
            self.diamondPayBgView.top = 23+80;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
            
            self.totleMoneyNum = self.moneyNub+self.vipPrice;
            
        }
        else if(self.orderStatus == 2){
            
            if (self.templateMoneyNum) {
                
                self.templateBgView.hidden = YES;
                self.bgView1.height = 124+60;
                
            }
            else if (self.flowMoneyNum){
                
                self.flowBgView.hidden = YES;
                self.bgView1.height = 124+60;
            }
            
            self.diamondPayBgView.top = 23+65;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
            
            self.totleMoneyNum = self.authorMoneyNum+self.vipPrice+self.flowMoneyNum;
        }
        else{
            
            self.templateBgView.hidden = YES;
            self.bgView1.height = 120;
            self.diamondPayBgView.top = 23;
            self.totleBgView.top = self.bgView1.height-36;
            self.bgView2.top = self.bgView1.bottom+10;
            self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
            self.totleMoneyNum = self.vipPrice;
        }
        
        [self.diamondPayButton setSelected:YES];
        [self.diamondPayButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateHighlighted];
        [self.diamondPayButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }
    
    if (self.rechargeAlertBalanceBtn.selected) {
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[[NSString stringWithFormat:@"%.3lf",self.totleMoneyNum*self.discount*100.0/100.0] getNSRoundPlain:2]];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
    }else{
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.totleMoneyNum];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
    }
}


//其他付款方式按钮
//- (void)otherPayBtnClick:(id)sender{
//
//    if(self.otherPayBtn.selected)
//    {
//        self.otherPayView.hidden = NO;
//        self.bgView2.height = 140+75;
//        self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
//        self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
//        [self.otherPayBtn setSelected:NO];
//        [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向上"] forState:UIControlStateHighlighted];
//        [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
//
//    }else{
//
//        self.otherPayView.hidden = YES;
//        self.bgView2.height = 140;
//        self.subOrderBtn.frame = CGRectMake(20,self.bgView2.bottom+30,self.view.width-40,40);
//        self.scrollView.contentSize = CGSizeMake(self.view.width, self.subOrderBtn.bottom+10);
//        [self.otherPayBtn setSelected:YES];
//        [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向上"] forState:UIControlStateHighlighted];
//        [self.otherPayBtn setImage:[UIImage imageNamed:@"箭头向下"] forState:UIControlStateNormal];
//
//    }
//
//}



//支付宝选择按钮
- (void)alipayBtnClick:(id)sender{
    
    if(self.rechargeAlertAlipayBtn.selected)
    {
        //        [self.rechargeAlertAlipayBtn setSelected:NO];
        //        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
        //        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        
    }else{
        [self.rechargeAlertAlipayBtn setSelected:YES];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    [self.rechargeAlertWXBtn setSelected:NO];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    [self.rechargeAlertBalanceBtn setSelected:NO];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    
    if (self.rechargeAlertBalanceBtn.selected) {
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[[NSString stringWithFormat:@"%.3lf",self.totleMoneyNum*self.discount*100.0/100.0] getNSRoundPlain:2]];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
        if (self.orderStatus == 3) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[[NSString stringWithFormat:@"%.3lf",self.totleMoneyNum*self.discount*100.0/100.0] getNSRoundPlain:2]];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        
        
    }else{
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.totleMoneyNum];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
        if (self.orderStatus == 3) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.totleMoneyNum];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        
    }
    
}

//微信选择按钮
- (void)wxBtnClick:(id)sender{
    
    if(self.rechargeAlertWXBtn.selected)
    {
        //        [self.rechargeAlertWXBtn setSelected:NO];
        //        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
        //        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        
    }else{
        [self.rechargeAlertWXBtn setSelected:YES];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    
    [self.rechargeAlertAlipayBtn setSelected:NO];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    [self.rechargeAlertBalanceBtn setSelected:NO];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"Checked_green"] forState:UIControlStateHighlighted];
    [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    if (self.rechargeAlertBalanceBtn.selected) {
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[[NSString stringWithFormat:@"%.3lf",self.totleMoneyNum*self.discount*100.0/100.0] getNSRoundPlain:2]];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
        if (self.orderStatus == 3) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[[NSString stringWithFormat:@"%.3lf",self.totleMoneyNum*self.discount*100.0/100.0] getNSRoundPlain:2]];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        
    }else{
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.totleMoneyNum];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
        if (self.orderStatus == 3) {
            self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.totleMoneyNum];
            [self.totleBgView addSubview:self.totleMoneyLabel];
        }
        
    }
}

- (void)balanceBtnClick:(int)sender{
    
    if (sender != 0) {
        
        //    float totleMoney = [self.totleMoney floatValue];
        float balance = [self.balance floatValue];
        if (balance < self.totleMoneyNum) {
            [UIAlertView showInfoMsg:@"可用余额不足，请充值"];
            
            //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的可用余额不足，请充值" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            //        alert.tag = 6001;
            //        [alert show];
            
            return;
        }
    }
    
    if(self.rechargeAlertBalanceBtn.selected)
    {
        
    }else{
        [self.rechargeAlertBalanceBtn setSelected:YES];
        [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertBalanceBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    
    [self.rechargeAlertAlipayBtn setSelected:NO];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    [self.rechargeAlertWXBtn setSelected:NO];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
    if (self.rechargeAlertBalanceBtn.selected) {
        
        NSLog(@"%f",self.discount);
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[[NSString stringWithFormat:@"%.3lf",self.totleMoneyNum*self.discount*100.0/100.0] getNSRoundPlain:2]];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
    }else{
        
        self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",self.totleMoneyNum];
        [self.totleBgView addSubview:self.totleMoneyLabel];
        
    }
}

- (void)subAuthorBtnClick:(UIButton *)btn{
    NSLog(@"点击确定支付按钮");
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在跳转支付请稍等";
    
    NSMutableArray *payOrderArray = [NSMutableArray array];
    if (![self.payArray isEqual:@[]]) {
        for (int i = 0; i < self.payArray.count; i++) {
            
            NSMutableDictionary *payDict = [NSMutableDictionary new];
            [payDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"buyer_id"];
            [payDict setObject:[YKLLocalUserDefInfo defModel].userName forKey:@"buyer_name"];
            [payDict setObject:[self.payArray[i] objectForKey:@"money"] forKey:@"order_amount"];
            [payDict setObject:[self.payArray[i] objectForKey:@"type"]forKey:@"goods_type"];//1.短信 2.模板 3.授权 4.商品 5.余额 7.vip
            [payDict setObject:[self.payArray[i] objectForKey:@"title"]forKey:@"goods_name"];
            [payDict setObject:@"2"forKey:@"pay_type"];//1.线下付  2.线上付
            
            //1.大砍价 2.一起嗨 3.口袋红包 4.口袋夺宝 5.全民秒杀 6.一元速定
            [payDict setObject:self.orderType forKey:@"order_type"];
            
            [payDict setObject:self.activityID forKey:@"activity_id"];
            
            //有模板ID返回则传模板ID否则不传
            if ([self.payArray[i] objectForKey:@"t_id"]) {
                
                NSString *tID = [self.payArray[i] objectForKey:@"t_id"];
                if ([tID isEqual:[NSNull null]]) {
                    
                    tID = @"0";
                }
                
                [payDict setObject:tID forKey:@"goods_id"];
            }else{
                [payDict setObject:@"0" forKey:@"goods_id"];
            }
            
            if(self.rechargeAlertAlipayBtn.selected){
                
                [payDict setObject:@"1"forKey:@"payment_code"];//支付宝支付
            }
            else if(self.rechargeAlertWXBtn.selected){
                
                [payDict setObject:@"2"forKey:@"payment_code"];//微信支付
            }
            else  if (self.rechargeAlertBalanceBtn.selected){
                
                [payDict setObject:@"3"forKey:@"payment_code"];//余额支付
            }
            
            //            NSLog(@"%@",[payDict objectForKey:@"goods_type"]);
            //            NSLog(@"%@",[self.payArray[i] objectForKey:@"type"]);
            
            NSInteger goodsType = [[payDict objectForKey:@"goods_type"]integerValue];
            
            //选择黄钻 不传模板字典
            if (self.diamondPayButton.selected && goodsType == 2) {
                
                
            }else{
                
                //短信充值 不传短信字典
                if (goodsType != 1) {
                    [payOrderArray addObject:payDict];
                }
            }
            
        }
    }
    
    if (self.diamondPayButton.selected||[self.payType isEqual:@"vip充值"]) {
        
        if ([self.payType isEqual:@"vip充值"]) {
            
            self.orderType = @"1";
            self.activityID = @"";
            [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
        }
        self.activityID = self.activityID == NULL ? @"": self.activityID;
        
        NSMutableDictionary *payDict = [NSMutableDictionary new];
        [payDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"buyer_id"];
        [payDict setObject:[YKLLocalUserDefInfo defModel].userName forKey:@"buyer_name"];
        [payDict setObject:[NSString stringWithFormat:@"%.1lf",self.vipPrice] forKey:@"order_amount"];
        [payDict setObject:@"7"forKey:@"goods_type"];//1.短信 2.模板 3.授权 4.商品 5.余额 7.vip
        [payDict setObject:@"VIP充值"forKey:@"goods_name"];
        [payDict setObject:@"2"forKey:@"pay_type"];//1.线下付  2.线上付
        
        //1.大砍价 2.一起嗨 3.口袋红包 4.口袋夺宝 5.全民秒杀 6.一元速定
        [payDict setObject:self.orderType forKey:@"order_type"];
        
        [payDict setObject:self.activityID forKey:@"activity_id"];
        [payDict setObject:@"0" forKey:@"goods_id"];
        
        
        if(self.rechargeAlertAlipayBtn.selected){
            
            [payDict setObject:@"1"forKey:@"payment_code"];//支付宝支付
        }
        else if(self.rechargeAlertWXBtn.selected){
            
            [payDict setObject:@"2"forKey:@"payment_code"];//微信支付
        }
        else  if (self.rechargeAlertBalanceBtn.selected){
            
            [payDict setObject:@"3"forKey:@"payment_code"];//余额支付
        }
        
        [payOrderArray addObject:payDict];
    }
    
    if ([self.payType isEqual:@"短信充值"]||self.orderStatus == 3 ||self.orderStatus == 6 || self.orderStatus == 11) {
        
        if ([self.payType isEqual:@"短信充值"]) {
            
            self.orderType = @"1";
            self.activityID = @"";
            [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
        }
        
        NSMutableDictionary *payDict = [NSMutableDictionary new];
        [payDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"buyer_id"];
        [payDict setObject:[YKLLocalUserDefInfo defModel].userName forKey:@"buyer_name"];
        [payDict setObject:[NSString stringWithFormat:@"%d",self.moneyNub] forKey:@"order_amount"];
        [payDict setObject:@"1"forKey:@"goods_type"];//1.短信 2.模板 3.授权 4.商品 5.余额 7.vip
        [payDict setObject:@"短信充值"forKey:@"goods_name"];
        [payDict setObject:@"2"forKey:@"pay_type"];//1.线下付  2.线上付
        
        //1.大砍价 2.一起嗨 3.口袋红包 4.口袋夺宝 5.全民秒杀 6.一元速定
        [payDict setObject:self.orderType forKey:@"order_type"];
        
        [payDict setObject:self.activityID forKey:@"activity_id"];
        [payDict setObject:@"0" forKey:@"goods_id"];
        
        if(self.rechargeAlertAlipayBtn.selected){
            
            [payDict setObject:@"1"forKey:@"payment_code"];//支付宝支付
        }
        else if(self.rechargeAlertWXBtn.selected){
            
            [payDict setObject:@"2"forKey:@"payment_code"];//微信支付
        }
        else  if (self.rechargeAlertBalanceBtn.selected){
            
            [payDict setObject:@"3"forKey:@"payment_code"];//余额支付
        }
        
        [payOrderArray addObject:payDict];
    }
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payOrderArray options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"--------------%@",str);
    
    if(self.rechargeAlertAlipayBtn.selected){
        
        [YKLNetworkingHighGo addOrderWithOrderJsonArray:str Success:^(NSDictionary *orderDict) {
            NSDictionary *tempOrderDict = [orderDict objectForKey:@"order"];
            NSString *orderNub = [tempOrderDict objectForKey:@"order_sn"];
            
            NSLog(@"%@",self.totleMoney);
            
            //支付费用假数据
            //self.totleMoney= @"0.01";
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:orderNub productName:self.content productDescription:self.payType amount:[NSString stringWithFormat:@"%.2lf",self.totleMoneyNum] notifyURL:kNotifyURL itBPay:@"30m"];
            
            Order *order = [Order order];
            order.partner = kPartnerID;
            order.seller = kSellerAccount;
            order.tradeNO = orderNub;
            order.productName = self.content;
            order.productDescription = self.payType;
            order.amount = [NSString stringWithFormat:@"%.2lf",self.totleMoneyNum];
            order.notifyURL = kNotifyURL;
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
                    
                    if ([object isEqualToString:@"9000"]) {
                        NSLog(@"成功%@", CallBackURL);
                        
                        [YKLLocalUserDefInfo defModel].payStatus = @"成功";
                        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                        
                        if ([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"YES"]) {
                            
                            YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                            ShareVC.hidenBar = YES;
                            ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                            ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                            ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                            ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                            ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                            self.view.window.rootViewController = ShareVC;
                        }else{
                            
                            [self popRootView];
                        }
                        
                    }
                    else{
                        NSLog(@"失败%@",MerchantURL);
                        
                        [YKLLocalUserDefInfo defModel].payStatus = @"失败";
                        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                        
                        [self popRootView];
                        
                    }
                }];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView showInfoMsg:error.domain];
        }];
        
    }
    
    //选择微信支付按钮
    if (self.rechargeAlertWXBtn.selected){
        
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc] init];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",self.totleMoneyNum*100];
        
        [YKLNetworkingHighGo addOrderWithOrderJsonArray:str Success:^(NSDictionary *orderDict) {
            NSDictionary *tempOrderDict = [orderDict objectForKey:@"order"];
            NSString *orderNub = [tempOrderDict objectForKey:@"order_sn"];
            
            //获取到实际调起微信支付的参数后，在app端调起支付
            NSMutableDictionary *dict = [req sendPay_demo:self.content OrderPrice:priceStr OrderNub:orderNub NotifyURL:NOTIFY_URL];
            
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
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView showInfoMsg:error.domain];
        }];
    }
    
    //选择余额支付按钮
    if (self.rechargeAlertBalanceBtn.selected){
        
        [YKLNetworkingHighGo addOrderWithOrderJsonArray:str Success:^(NSDictionary *orderDict) {
            NSDictionary *tempOrderDict = [orderDict objectForKey:@"order"];
            NSString *orderNub = [tempOrderDict objectForKey:@"order_sn"];
            
            [YKLNetworkingConsumer accountPayWithOrderSN:orderNub TotalMoney:[NSString stringWithFormat:@"%.2lf",self.totleMoneyNum ]Success:^(NSDictionary *responseObject) {
                
                NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                
                //支付成功
                if (responseCode == 1) {
                    
                    [UIAlertView showInfoMsg:message];
                    
                    if ([[YKLLocalUserDefInfo defModel].isShowShare isEqual:@"YES"]) {
                        
                        YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                        ShareVC.hidenBar = YES;
                        ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                        ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                        ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                        ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                        ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                        self.view.window.rootViewController = ShareVC;
                    }else{
                        
                        [self popRootView];
                    }
                }
                //支付失败
                else {
                    [UIAlertView showInfoMsg:message];
                    [self popRootView];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [UIAlertView showInfoMsg:error.domain];
                
            }];
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView showInfoMsg:error.domain];
        }];
        
    }
    
}

- (void)popRootView{
    
    //点击支付按钮必须返回主页
    ViewController *firstVC = [[ViewController alloc] init];
    firstVC.isPay = YES;
    self.view.window.rootViewController = firstVC;
}

@end
