//
//  YKLCashViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/17.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLCashViewController.h"
#import "YKLLoginViewController.h"

@interface YKLCashViewController ()<UITextFieldDelegate,CustomIOSAlertViewDelegate>

@property (nonatomic, strong) UILabel *moneyTextLael;
@property (nonatomic, strong) UIImageView *moneyTextBgImageView;
@property (nonatomic, strong) UILabel *moneyNubLabel;
@property (nonatomic, strong) UIImageView *moneyImageView;
@property (nonatomic, strong) UIButton *moneyBtn;
//提现
@property (nonatomic, strong) UIView *CashBgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *alipayLabel;
@property (nonatomic, strong) UILabel *alipayUserNameLabel;
@property (nonatomic, strong) UILabel *alipayAccountLabel;
@property (nonatomic, strong) UILabel *cashMoneyLabel;
@property (nonatomic, strong) UITextField *cashMoneyNubField;
@property (nonatomic, strong) UIButton *subMoneyBtn;
//充值cell
@property (nonatomic, strong) UIView *rechargeBgView;
@property (nonatomic, strong) UILabel *rechargeTextLael;
@property (nonatomic, strong) UILabel *rechargeNubLael;
@property (nonatomic, strong) UILabel *rechargeEXpLabel;
@property (nonatomic, strong) UIButton *rechargeBtn;

//充值弹框页面
@property (nonatomic, strong) CustomIOSAlertView *rechargeAlertView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIView *lineAlertView;
@property (nonatomic, strong) UILabel *rechargeAlertTitleLabel;
@property (nonatomic, strong) UILabel *rechargeAlertActivityLabel;
@property (nonatomic, strong) UILabel *rechargeAlertActivityNubLabel;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *rechargeAlertMoneyLabel;
@property (nonatomic, strong) UILabel *rechargeAlertMoneyNubLabel;
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

@property (nonatomic, strong) UIButton *subOrderBtn;

@end

@implementation YKLCashViewController
int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现界面";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"设置"] landscapeImagePhone:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStylePlain target:self action:@selector(manageBankCard)];
    
    [self createMoneyView];
    [self createCashMoneyView];
    [self createRechargeView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];

}

- (void)createMoneyView{

    self.moneyTextBgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"成交总额"]];
    self.moneyTextBgImageView.frame = CGRectMake(0, 0, 100, 30);
    self.moneyTextBgImageView.center = CGPointMake(self.view.width/2, 40+2+64);
    [self.view addSubview: self.moneyTextBgImageView];
    
    self.moneyTextLael = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    self.moneyTextLael.center = CGPointMake(self.view.width/2, 40+64);
    self.moneyTextLael.font = [UIFont systemFontOfSize: 14.0];
    self.moneyTextLael.textAlignment = NSTextAlignmentCenter;
    self.moneyTextLael.textColor = [UIColor whiteColor];
    self.moneyTextLael.text = @"总收入";
    [self.view addSubview:self.moneyTextLael];
    
    self.moneyNubLabel = [[UILabel alloc]init];
    self.moneyNubLabel.font = [UIFont systemFontOfSize: 30.0];
    //    self.moneyNubLabel.backgroundColor = [UIColor whiteColor];
    self.moneyNubLabel.textColor = [UIColor flatLightRedColor];
    self.moneyNubLabel.text = @"267,689.03";
    CGRect rect = [self.moneyNubLabel.text boundingRectWithSize:CGSizeMake(self.view.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.moneyNubLabel.font}  context:nil];
    self.moneyNubLabel.size = CGSizeMake(rect.size.width, rect.size.height);
    self.moneyNubLabel.center = CGPointMake(self.view.width/2, self.moneyTextLael.centerY+self.moneyTextLael.size.height/2+rect.size.height/2+20);
    [self.view addSubview:self.moneyNubLabel];
    
    self.moneyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"钱袋"]];
    self.moneyImageView.frame = CGRectMake(self.moneyNubLabel.origin.x-self.moneyImageView.image.size.width, self.moneyNubLabel.origin.y, self.moneyNubLabel.height, self.moneyNubLabel.height);
    [self.view addSubview: self.moneyImageView];
    
    self.moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moneyBtn setImage:[UIImage imageNamed:@"箭头红色"] forState:UIControlStateNormal];
    self.moneyBtn.frame = CGRectMake(self.moneyNubLabel.right, self.moneyNubLabel.origin.y, self.moneyNubLabel.height, self.moneyNubLabel.height);
    [self.moneyBtn addTarget:self action:@selector(cashMoneyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.moneyBtn];
    
}

- (void)createCashMoneyView{
    self.CashBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.moneyNubLabel.bottom+25, self.view.width, 105)];
    self.CashBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.CashBgView];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.width, 1)];
    self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.CashBgView addSubview:self.lineView];
    
    self.alipayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
//    self.alipayLabel.backgroundColor = [UIColor redColor];
    self.alipayLabel.font = [UIFont systemFontOfSize: 16.0];
    self.alipayLabel.textAlignment = NSTextAlignmentCenter;
    self.alipayLabel.textColor = [UIColor blackColor];
    self.alipayLabel.text = @"支付宝";
    [self.CashBgView addSubview:self.alipayLabel];
    
    self.alipayUserNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.alipayLabel.right+25, self.alipayLabel.top, self.view.width-self.alipayLabel.right-25, 20)];
//    self.alipayUserNameLabel.backgroundColor = [UIColor redColor];
    self.alipayUserNameLabel.font = [UIFont systemFontOfSize: 16.0];
    self.alipayUserNameLabel.textAlignment = NSTextAlignmentLeft;
    self.alipayUserNameLabel.textColor = [UIColor blackColor];
    self.alipayUserNameLabel.text = @"钉子科技";
    [self.CashBgView addSubview:self.alipayUserNameLabel];
    
    self.alipayAccountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.alipayLabel.right+25, self.alipayUserNameLabel.bottom, self.view.width-self.alipayLabel.right-25, 20)];
//    self.alipayAccountLabel.backgroundColor = [UIColor greenColor];
    self.alipayAccountLabel.font = [UIFont systemFontOfSize: 14.0];
    self.alipayAccountLabel.textAlignment = NSTextAlignmentLeft;
    self.alipayAccountLabel.textColor = [UIColor lightGrayColor];
    self.alipayAccountLabel.text = @"123456789@qq.com";
    [self.CashBgView addSubview:self.alipayAccountLabel];
    
    self.cashMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.lineView.bottom+10, 60, 20)];
//        self.cashMoneyLabel.backgroundColor = [UIColor redColor];
    self.cashMoneyLabel.font = [UIFont systemFontOfSize: 16.0];
    self.cashMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.cashMoneyLabel.textColor = [UIColor blackColor];
    self.cashMoneyLabel.text = @"金额(元)";
    [self.CashBgView addSubview:self.cashMoneyLabel];
    
    self.cashMoneyNubField = [[UITextField alloc] initWithFrame:CGRectMake(self.alipayUserNameLabel.left, self.cashMoneyLabel.top, self.view.width-self.cashMoneyLabel.right-25, 20)];
    self.cashMoneyNubField.keyboardType = UIKeyboardTypePhonePad;
//    self.cashMoneyNubField.backgroundColor = [UIColor redColor];
    self.cashMoneyNubField.delegate = self;
    self.cashMoneyNubField.font = [UIFont systemFontOfSize:14];
    self.cashMoneyNubField.returnKeyType = UIReturnKeyNext;
    [self.CashBgView addSubview:self.cashMoneyNubField];
    
    self.subMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.subMoneyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [self.subMoneyBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.subMoneyBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.subMoneyBtn.backgroundColor = [UIColor flatLightRedColor];
    self.subMoneyBtn.layer.cornerRadius = 20;
    self.subMoneyBtn.layer.masksToBounds = YES;
    self.subMoneyBtn.frame = CGRectMake(10,self.CashBgView.bottom+10,self.view.width-20,44);
    [self.subMoneyBtn addTarget:self action:@selector(subMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.subMoneyBtn];

}

- (void)createRechargeView{
    
    self.rechargeBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.subMoneyBtn.bottom+10, self.view.width, 60)];
    self.rechargeBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rechargeBgView];
    
    self.rechargeTextLael = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 140, 20)];
    self.rechargeTextLael.font = [UIFont systemFontOfSize: 17.0];
//    self.rechargeTextLael.backgroundColor = [UIColor redColor];
    self.rechargeTextLael.textColor = [UIColor blackColor];
    self.rechargeTextLael.text = @"可发布活动次数：";
    [self.rechargeBgView addSubview:self.rechargeTextLael];
    
    self.rechargeNubLael = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeTextLael.right, 10, 50, 20)];
    self.rechargeNubLael.font = [UIFont systemFontOfSize: 17.0];
//    self.rechargeNubLael.backgroundColor = [UIColor blueColor];
    self.rechargeNubLael.textColor = [UIColor redColor];
    self.rechargeNubLael.text = @"8";
    [self.rechargeBgView addSubview:self.rechargeNubLael];
    
    self.rechargeEXpLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rechargeTextLael.bottom, 130, 20)];
    self.rechargeEXpLabel.font = [UIFont systemFontOfSize: 14.0];
//    self.rechargeEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeEXpLabel.text = @"充值可获取更多次数";
    [self.rechargeBgView addSubview:self.rechargeEXpLabel];
    
    self.rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.rechargeBtn setTitleColor:[UIColor colorWithRed:84.0/255.0 green:188.0/255.0 blue:117.0/255.0 alpha:1]forState:UIControlStateHighlighted];
    self.rechargeBtn.backgroundColor = [UIColor flatLightGreenColor];
    self.rechargeBtn.layer.cornerRadius = 13;
    self.rechargeBtn.layer.masksToBounds = YES;
    self.rechargeBtn.frame = CGRectMake(self.view.width-65-10,15,65,30);
    [self.rechargeBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeBgView addSubview: self.rechargeBtn];
    
}
-(void)manageBankCard
{
    NSLog(@"点击了==--设置--==按钮");
    [self hidenKeyboard];
    YKLLoginViewController *loginVC = [YKLLoginViewController new];
    [loginVC registTitleBtnClicked];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (void)cashMoneyButtonClick:(id)sender{
    NSLog(@"点击了==--钱的右边--==按钮");
    [self hidenKeyboard];
    
}

- (void)subMoneyBtnClick:(id)sender{
    NSLog(@"点击了==--提交--==按钮");
    [self hidenKeyboard];
}

- (void)rechargeBtnClick:(id)sender{
    NSLog(@"点击了==--充值--==按钮");
    
    self.rechargeAlertView = [[CustomIOSAlertView alloc] init];
    [self.rechargeAlertView setContainerView:[self createDemoView]];
    [self.rechargeAlertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [self.rechargeAlertView setDelegate:self];
    [self.rechargeAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [self.rechargeAlertView setUseMotionEffects:true];
    [self.rechargeAlertView show];
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (buttonIndex==1) {
        NSLog(@"oooo");
    }
    [alertView close];
}

- (UIView *)createDemoView
{
    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 264, 280)];
    self.rechargeAlertBgView.backgroundColor = [UIColor whiteColor];
    self.rechargeAlertBgView.layer.cornerRadius = 7;
    self.rechargeAlertBgView.layer.masksToBounds = YES;
    
    self.rechargeAlertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.rechargeAlertTitleLabel.centerX = self.rechargeAlertBgView.width/2;
    self.rechargeAlertTitleLabel.font = [UIFont systemFontOfSize: 17.0];
//        self.rechargeAlertTitleLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertTitleLabel.textColor = [UIColor blackColor];
    self.rechargeAlertTitleLabel.text = @"开启活动";
    self.rechargeAlertTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.rechargeAlertBgView addSubview:self.rechargeAlertTitleLabel];
    
    self.lineAlertView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, self.rechargeAlertBgView.width-20, 1)];
    self.lineAlertView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.rechargeAlertBgView addSubview:self.lineAlertView];
    
    self.rechargeAlertActivityLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, self.lineAlertView.bottom,self.lineAlertView.width-20, 46)];
    self.rechargeAlertActivityLabel.numberOfLines = 0;
    [self.rechargeAlertActivityLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.rechargeAlertActivityLabel.textAlignment = NSTextAlignmentCenter;
    self.rechargeAlertActivityLabel.font = [UIFont systemFontOfSize: 12.0];
//    self.rechargeAlertActivityLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertActivityLabel.textColor = [UIColor blackColor];
//    self.rechargeAlertActivityLabel.text = @"您的赏钱是我们最大的动力，我们将为您奉献更多更好地活动模板";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertActivityLabel];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"加hover"] forState:UIControlStateHighlighted];
    self.addBtn.frame = CGRectMake(self.lineAlertView.width-30+10,self.rechargeAlertActivityLabel.top,30,26);
    [self.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.addBtn];
    
    self.rechargeAlertActivityNubLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.addBtn.left-30, self.rechargeAlertActivityLabel.top,30, 26)];
    self.rechargeAlertActivityNubLabel.font = [UIFont systemFontOfSize: 14.0];
//        self.rechargeAlertActivityNubLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertActivityNubLabel.textColor = [UIColor blackColor];
    self.rechargeAlertActivityNubLabel.text = [NSString stringWithFormat:@"%d",i];
    self.rechargeAlertActivityNubLabel.textAlignment = NSTextAlignmentCenter;
    [self.rechargeAlertBgView addSubview:self.rechargeAlertActivityNubLabel];
    
    self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusBtn setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"减hover"] forState:UIControlStateHighlighted];
    self.minusBtn.frame = CGRectMake(self.rechargeAlertActivityNubLabel.left-30,self.rechargeAlertActivityLabel.top,30,26);
    [self.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.minusBtn];
    
    self.rechargeAlertMoneyLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rechargeAlertActivityLabel.bottom,self.lineAlertView.width/2, 26)];
    self.rechargeAlertMoneyLabel.font = [UIFont systemFontOfSize: 16.0];
//        self.rechargeAlertMoneyLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertMoneyLabel.textColor = [UIColor blackColor];
    self.rechargeAlertMoneyLabel.text = @"模板使用费";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertMoneyLabel];
    
    self.rechargeAlertMoneyNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rechargeAlertMoneyLabel.top,60,26)];
    self.rechargeAlertMoneyNubLabel.right = self.lineAlertView.right;
    self.rechargeAlertMoneyNubLabel.font = [UIFont systemFontOfSize: 14.0];
//            self.rechargeAlertMoneyNubLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertMoneyNubLabel.textColor = [UIColor flatLightRedColor];
    self.rechargeAlertMoneyNubLabel.text = [NSString stringWithFormat:@"¥%d",i*10];
    self.rechargeAlertMoneyNubLabel.textAlignment = NSTextAlignmentRight;
    [self.rechargeAlertBgView addSubview:self.rechargeAlertMoneyNubLabel];
    
#pragma mark -支付宝支付选择
    self.rechargeAlertAlipayImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"支付宝"]];
    self.rechargeAlertAlipayImageView.frame = CGRectMake(10, self.rechargeAlertMoneyLabel.bottom+15, 30, 30);
    [self.rechargeAlertBgView addSubview:self.rechargeAlertAlipayImageView];
    
    self.rechargeAlertAlipayLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertAlipayImageView.right+5, self.rechargeAlertAlipayImageView.top,self.lineAlertView.width/2, 15)];
    self.rechargeAlertAlipayLabel.font = [UIFont systemFontOfSize: 14.0];
//    self.rechargeAlertAlipayLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertAlipayLabel.textColor = [UIColor blackColor];
    self.rechargeAlertAlipayLabel.text = @"支付宝";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertAlipayLabel];
    
    self.rechargeAlertAlipayEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertAlipayImageView.right+5, self.rechargeAlertAlipayLabel.bottom,self.lineAlertView.width/2, 15)];
    self.rechargeAlertAlipayEXpLabel.font = [UIFont systemFontOfSize: 12.0];
//    self.rechargeAlertAlipayEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertAlipayEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertAlipayEXpLabel.text = @"推荐支付宝用户使用";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertAlipayEXpLabel];
    
    self.rechargeAlertAlipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.rechargeAlertAlipayBtn.frame = CGRectMake(self.lineAlertView.width-26+10,self.rechargeAlertAlipayImageView.top,26,26);
    [self.rechargeAlertAlipayBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.rechargeAlertAlipayBtn];
    
#pragma mark -微信支付选择
    self.rechargeAlertWXImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信"]];
    self.rechargeAlertWXImageView.frame = CGRectMake(10, self.rechargeAlertAlipayImageView.bottom+15, 30, 30);
    [self.rechargeAlertBgView addSubview:self.rechargeAlertWXImageView];
    
    self.rechargeAlertWXLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertWXImageView.right+5, self.rechargeAlertWXImageView.top,self.lineAlertView.width/2, 15)];
    self.rechargeAlertWXLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertAlipayLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertWXLabel.textColor = [UIColor blackColor];
    self.rechargeAlertWXLabel.text = @"微信支付";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertWXLabel];
    
    self.rechargeAlertWXEXpLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.rechargeAlertWXImageView.right+5, self.rechargeAlertWXLabel.bottom,self.lineAlertView.width/2, 15)];
    self.rechargeAlertWXEXpLabel.font = [UIFont systemFontOfSize: 12.0];
    //    self.rechargeAlertAlipayEXpLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertWXEXpLabel.textColor = [UIColor lightGrayColor];
    self.rechargeAlertWXEXpLabel.text = @"推荐微信用户使用";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertWXEXpLabel];
    
    self.rechargeAlertWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.rechargeAlertWXBtn.frame = CGRectMake(self.lineAlertView.width-26+10,self.rechargeAlertWXImageView.top,26,26);
    [self.rechargeAlertWXBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.rechargeAlertWXBtn];

    self.subOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.subOrderBtn setImage:[UIImage imageNamed:@"确认支付"] forState:UIControlStateNormal];
//    [self.subOrderBtn setImage:[UIImage imageNamed:@"确认支付hover"] forState:UIControlStateHighlighted];
    self.subOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.subOrderBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.subOrderBtn.backgroundColor = [UIColor flatLightRedColor];
    self.subOrderBtn.layer.cornerRadius = 20;
    self.subOrderBtn.layer.masksToBounds = YES;
    self.subOrderBtn.frame = CGRectMake(0,self.rechargeAlertWXBtn.bottom+25,155,40);
    self.subOrderBtn.centerX = self.rechargeAlertBgView.width/2;
    [self.subOrderBtn addTarget:self action:@selector(subOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.subOrderBtn];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UILongPressGestureRecognizer *doubleTapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView)];
    
//    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.rechargeAlertView addGestureRecognizer:doubleTapGestureRecognizer];
    return self.rechargeAlertBgView;
}



- (void)minusBtnClick:(id)sender{
    NSLog(@"————————————————————————");
    if (i>1) {
        i--;
        self.rechargeAlertActivityNubLabel.text = [NSString stringWithFormat:@"%d",i];
        [self.rechargeAlertBgView addSubview:self.rechargeAlertActivityNubLabel];
        self.rechargeAlertMoneyNubLabel.text = [NSString stringWithFormat:@"¥%d",i*10];
        [self.rechargeAlertBgView addSubview:self.rechargeAlertMoneyNubLabel];
    }
    
}

- (void)addBtnClick:(id)sender{
    NSLog(@"++++++++++++++++++++++++");
    if (i<100) {
        i++;
        self.rechargeAlertActivityNubLabel.text = [NSString stringWithFormat:@"%d",i];
        [self.rechargeAlertBgView addSubview:self.rechargeAlertActivityNubLabel];
        self.rechargeAlertMoneyNubLabel.text = [NSString stringWithFormat:@"¥%d",i*10];
        [self.rechargeAlertBgView addSubview:self.rechargeAlertMoneyNubLabel];
    }
}

- (void)alipayBtnClick:(id)sender{
    if(self.rechargeAlertAlipayBtn.selected)
    {
        [self.rechargeAlertAlipayBtn setSelected:NO];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }else{
        [self.rechargeAlertAlipayBtn setSelected:YES];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    if(self.rechargeAlertWXBtn.selected)
    {
        [self.rechargeAlertWXBtn setSelected:NO];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
}

- (void)wxBtnClick:(id)sender{
    if(self.rechargeAlertWXBtn.selected)
    {
        [self.rechargeAlertWXBtn setSelected:NO];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }else{
        [self.rechargeAlertWXBtn setSelected:YES];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    if(self.rechargeAlertAlipayBtn.selected)
    {
        [self.rechargeAlertAlipayBtn setSelected:NO];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
        [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
}


- (void)subOrderBtnClick:(id)sender{
    NSLog(@"——————————————点击提交支付订单——————————————");
    if(self.rechargeAlertAlipayBtn.selected)
    {
    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[AlipayToolKit genTradeNoWithTime] productName:@"邮票" productDescription:@"全真邮票" amount:@"0.8" notifyURL:kNotifyURL itBPay:@"30m"];
    }
}

- (void)closeAlertView{
   
    [self customIOS7dialogButtonTouchUpInside:self.rechargeAlertView clickedButtonAtIndex:1];
    
}

#pragma mark - keyboard

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-20,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.cashMoneyNubField resignFirstResponder];
    
    [self resumeView];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        return NO;
//    }
//    return YES;
//}


@end
