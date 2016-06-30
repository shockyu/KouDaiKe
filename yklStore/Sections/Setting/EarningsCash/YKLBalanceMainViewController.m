//
//  YKLBalanceMainViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/14.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBalanceMainViewController.h"
#import "MUILoadMoreTableView.h"
//#import "YKLBalanceRecordListViewController.h"
#import "YKLBalanceDetailsListViewController.h"
#import "YKLIncomeListViewController.h"
#import "ViewController.h"
#import "YKLPushWebViewController.h"

@interface YKLBalanceMainViewController ()<UITextFieldDelegate>
{
    NSTimer *_timerBalance;
    
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *goldIamgeView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleNumLabel;

@property (nonatomic, strong) UIButton *logoutButton;   //充值按钮
@property (nonatomic, strong) UIButton *cashButton;     //提现按钮

@property (strong, nonatomic) UIView *maskCashView;
@property (strong, nonatomic) UIView *pickerBgCashView;

@property (strong, nonatomic) UITextField *cashField;       //提现金额
@property (strong, nonatomic) UILabel *cashInfoLabel;       //提现手续费


@property (strong, nonatomic) UIView *maskBankView;
@property (strong, nonatomic) UIView *pickerBgBankView;
@property (strong, nonatomic) UIButton *alipayBtn;          //支付宝选择按钮
@property (strong, nonatomic) UIButton *bankBtn;            //银行卡选择按钮

@property (strong, nonatomic) UILabel *numLabel;            //账户
@property (strong, nonatomic) UITextField *numField;
@property (strong, nonatomic) UILabel *bankSelect;          //银行选择
@property (strong, nonatomic) UILabel *showBankSelect;      //显示银行选择
@property (strong, nonatomic) UILabel *userLabel;           //开户人姓名
@property (strong, nonatomic) UITextField *userField;

@property (strong, nonatomic) UIView *codeBgView;           //验证码父视图
@property (strong, nonatomic) UILabel *mobleLabel;
@property (strong, nonatomic) UITextField *mobleLabelField;
@property (strong, nonatomic) UILabel *codeLabel;
@property (strong, nonatomic) UITextField *codeField;
@property (strong, nonatomic) UIButton *codeBtn;
@property (strong, nonatomic) UIButton *ensureBtn;

//充值弹框页面
@property (strong, nonatomic) UIView *AlertBgView;
@property (nonatomic, strong) CustomIOSAlertView *rechargeAlertView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *lineAlertView;
@property (nonatomic, strong) UILabel *rechargeAlertTitleLabel;
@property (nonatomic, strong) UILabel *rechargeAlertActivityLabel;
@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) UILabel *rechargeAlertActivityNubLabel;
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
//充值金额
//@property int moneyNub;
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

@property (nonatomic, strong) NSString *totleMoney;             //支付共计金额

@property (nonatomic, strong) YKLAccountCashModel *cashModel;
@property (nonatomic, strong) NSString *bankType;               //提现账户类型，1.支付宝 2.银行卡

@property (nonatomic, strong) NSString *accountID;              //提现账户ID
@property (nonatomic, strong) NSString *alipayAccountID;        //支付宝提现账户ID
@property (nonatomic, strong) NSString *bankAccountID;          //银行提现账户ID
@property (nonatomic, strong) NSString *alipayAccount;          //支付宝账号
@property (nonatomic, strong) NSString *alipayAccountHolder;    //支付宝开户人
@property (nonatomic, strong) NSString *bankAccount;            //银行账号
@property (nonatomic, strong) NSString *bankAccountHolder;      //银行开户人
@property (nonatomic, strong) NSString *bankName;               //银行选择名字

@end

@implementation YKLBalanceMainViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"口袋钱包";
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"收支明细" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked)];
        self.navigationItem.rightBarButtonItem = menuButton;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor flatLightBlueColor];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //我的收益
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer accountCashWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLAccountCashModel *cashModel)
     {
         
         self.cashModel = cashModel;
         
         [self initTableView];
         [self initCashView];
         [self initBankView];
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSError *error) {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [UIAlertView showInfoMsg:error.domain];
         
     }];
}


- (void)initTableView{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.goldIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 80, 80)];
    self.goldIamgeView.centerX = self.view.width/2;
    self.goldIamgeView.image = [UIImage imageNamed:@"金币"];
    [self.bgView addSubview:self.goldIamgeView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.goldIamgeView.bottom+10, 70, 15)];
    self.titleLabel.centerX = self.view.width/2;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.text = @"我的零钱";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
    
    self.titleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLabel.bottom+10, self.view.width, 30)];
    self.titleNumLabel.centerX = self.view.width/2;
    self.titleNumLabel.backgroundColor = [UIColor clearColor];
    self.titleNumLabel.font = [UIFont systemFontOfSize:34];
    self.titleNumLabel.text = [NSString stringWithFormat:@"¥%@",self.cashModel.money];
    self.titleNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleNumLabel];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.frame = CGRectMake(10,self.titleNumLabel.bottom+30,self.view.width-20,40);
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.logoutButton.layer.cornerRadius = 5;
    self.logoutButton.layer.masksToBounds = YES;
    [self.logoutButton setTitle:@"充值" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.logoutButton.backgroundColor = [UIColor colorWithHexString:@"08c630"];
    [self.bgView addSubview:self.logoutButton];
    
    self.cashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cashButton.frame = CGRectMake(10,self.logoutButton.bottom+10,self.view.width-20,40);
    self.cashButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.cashButton.layer setBorderWidth:0.5];//设置边界的宽度
    self.cashButton.layer.cornerRadius = 5;
    self.cashButton.layer.masksToBounds = YES;
    [self.cashButton setTitle:@"提现" forState:UIControlStateNormal];
    [self.cashButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cashButton addTarget:self action:@selector(showCashView:) forControlEvents:UIControlEventTouchUpInside];
    self.cashButton.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    [self.bgView addSubview:self.cashButton];
    
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.cashButton.bottom+20, 80, 18)];
//    titlelabel.backgroundColor = [UIColor redColor];
    titlelabel.text = @"我的提现账户";
    titlelabel.textColor = [UIColor blackColor];
    titlelabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:titlelabel];
    
    UILabel *nublabel = [[UILabel alloc]initWithFrame:CGRectMake(titlelabel.right, titlelabel.top, 180, 18)];
//    nublabel.backgroundColor = [UIColor redColor];
    
    NSString *bankAccount;
    
    if ([self.cashModel.type isEqual:@"1"]){
        self.bankType = @"支付宝";
        
        NSArray *array = [self.cashModel.bankAccount componentsSeparatedByString:@"@"];
        
        if (array.count == 2) {
            NSString *tempBankAccountStr = array[0];
            if (tempBankAccountStr.length>3) {
                bankAccount = [array[0] substringToIndex:3];
                bankAccount = [NSString stringWithFormat:@"%@***@%@",bankAccount,array[1]];
            }else{
                bankAccount = array[0];
                bankAccount = [NSString stringWithFormat:@"%@@%@",bankAccount,array[1]];
            }
            
        }else{
            
            NSString *tempBankAccountStr = array[0];
            if (tempBankAccountStr.length>7) {
                bankAccount = [array[0] substringToIndex:3];
                tempBankAccountStr = [array[0] substringFromIndex:tempBankAccountStr.length-4];
                bankAccount = [NSString stringWithFormat:@"%@****%@",bankAccount,tempBankAccountStr];
            }
            else if(tempBankAccountStr.length>3&&tempBankAccountStr.length<7){
                bankAccount = [array[0] substringToIndex:3];
                bankAccount = [NSString stringWithFormat:@"%@****",bankAccount];
            }
            else{
                bankAccount= array[0];
            }
        }
        
    }
    else if ([self.cashModel.type isEqual:@"2"]){
        self.bankType = @"银行卡";
        if (self.cashModel.bankAccount.length>11) {
            bankAccount = [self.cashModel.bankAccount substringFromIndex:11];
            bankAccount = [NSString stringWithFormat:@"***********%@",bankAccount];
        }else{
            bankAccount = self.cashModel.bankAccount;
            bankAccount = [NSString stringWithFormat:@"%@",bankAccount];
        }
        
        
    }
    else{
        bankAccount = @"暂无";
        self.bankType = @"其他";
    }
    nublabel.text = [NSString stringWithFormat:@"%@/%@",bankAccount,self.bankType];
    nublabel.textColor = [UIColor lightGrayColor];
    nublabel.font = [UIFont systemFontOfSize:12];
    nublabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:nublabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.bgView.width-10-50, titlelabel.top, 50, 18);
    [btn addTarget:self action:@selector(showBankView:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.bgView addSubview:btn];
    
    
    UIButton *descBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    descBtn.backgroundColor = [UIColor whiteColor];
    descBtn.frame = CGRectMake(0, self.view.height-100, 150, 10);
    descBtn.centerX = self.view.width/2;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"《口袋客零钱使用说明》使用必读"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName
                value:[UIColor flatLightBlueColor]
                range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [descBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    descBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [descBtn addTarget:self action:@selector(descBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:descBtn];
    
    UIImageView *descMoneyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(descBtn.right+5, descBtn.top, 10, 10)];
    [descMoneyImageView setImage:[UIImage imageNamed:@"moneyIcon"]];
    [self.view addSubview:descMoneyImageView];
    
}

//说明网页按钮点击
- (void)descBtnClicked{
    
    YKLPushWebViewController *webVC = [YKLPushWebViewController new];
    webVC.hidenBar = NO;
    webVC.webURL = @"http://www.01gou.cn/html/ktlq.html";
    webVC.webTitle = @"《口袋客零钱使用说明》";
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)rightItemClicked{
    
    [self hidenKeyboard];
    
    YKLBalanceDetailsListViewController *VC = [YKLBalanceDetailsListViewController new];
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - init view
- (void)initCashView {
    
    self.maskCashView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskCashView.backgroundColor = [UIColor blackColor];
    self.maskCashView.alpha = 0;
    
    [self.maskCashView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCashView)]];
    
    self.pickerBgCashView.width = ScreenWidth;
    
    self.pickerBgCashView = [[UIView alloc]initWithFrame: CGRectMake(0, 100, ScreenWidth, 220)];
    self.pickerBgCashView.backgroundColor = [UIColor whiteColor];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.pickerBgCashView addGestureRecognizer:gesture];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    titleLabel.text = @"申请提现";
    titleLabel.textColor = [UIColor flatLightBlueColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.pickerBgCashView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, self.pickerBgCashView.width-20, 1)];
    lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.pickerBgCashView addSubview:lineView];
    
    UILabel *cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lineView.bottom, 200, 40)];
    cashLabel.centerX = self.pickerBgCashView.width/2;
    cashLabel.text = @"输入提现金额";
    cashLabel.textColor = [UIColor grayColor];
    cashLabel.font = [UIFont systemFontOfSize:18];
    cashLabel.textAlignment = NSTextAlignmentCenter;
    [self.pickerBgCashView addSubview:cashLabel];
    
    self.cashField = [[UITextField alloc] initWithFrame:CGRectMake(0, cashLabel.bottom, 200, 30)];
    self.cashField.centerX = self.pickerBgCashView.width/2;
    self.cashField.keyboardType = UIKeyboardTypeDecimalPad;
    self.cashField.backgroundColor = [UIColor flatLightWhiteColor];
    self.cashField.delegate = self;
    self.cashField.font = [UIFont systemFontOfSize:14];
    self.cashField.returnKeyType = UIReturnKeyNext;
    self.cashField.layer.cornerRadius = 5;
    self.cashField.layer.masksToBounds = YES;
    self.cashField.textAlignment = NSTextAlignmentCenter;
    [self.pickerBgCashView addSubview:self.cashField];
    
    self.cashInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.cashField.bottom, 200, 30)];
    self.cashInfoLabel.centerX = self.pickerBgCashView.width/2;
    self.cashInfoLabel.font = [UIFont systemFontOfSize:12];
    self.cashInfoLabel.textColor = [UIColor grayColor];
    self.cashInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.cashInfoLabel.text = @"提现手续费率0.1%";
//    [self.pickerBgCashView addSubview:self.cashInfoLabel];
    
    UIButton *yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.cashInfoLabel.bottom, 200, 30)];
    yesBtn.centerX = self.pickerBgCashView.width/2;
    [yesBtn setBackgroundColor: [UIColor flatLightBlueColor]];
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [yesBtn addTarget:self action:@selector(cashEnsure:) forControlEvents:UIControlEventTouchUpInside];
    yesBtn.layer.cornerRadius = 5;
    yesBtn.layer.masksToBounds = YES;
    [self.pickerBgCashView addSubview:yesBtn];
    
}

- (void)initBankView {
    
    self.maskBankView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskBankView.backgroundColor = [UIColor blackColor];
    self.maskBankView.alpha = 0;
    [self.maskBankView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBankView)]];
    
    self.pickerBgBankView.width = ScreenWidth;
    
    self.pickerBgBankView = [[UIView alloc]initWithFrame: CGRectMake(0, 100, ScreenWidth, 300+40)];
    self.pickerBgBankView.backgroundColor = [UIColor whiteColor];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.pickerBgBankView addGestureRecognizer:gesture];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
    titleLabel.text = @"设置提现账户";
    titleLabel.textColor = [UIColor flatLightBlueColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.pickerBgBankView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, self.pickerBgCashView.width-20, 1)];
    lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.pickerBgBankView addSubview:lineView];
    
    self.alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.alipayBtn.frame = CGRectMake(lineView.left+20,lineView.bottom+10,15,15);
    [self.alipayBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.alipayBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.alipayBtn addTarget:self action:@selector(alipayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.alipayBtn.selected = YES;
    [self.pickerBgBankView addSubview:self.alipayBtn];
    
    UILabel *alipayLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.alipayBtn.right+10,0, 60, 20)];
    alipayLabel.centerY = self.alipayBtn.centerY;
    alipayLabel.backgroundColor = [UIColor clearColor];
    alipayLabel.font = [UIFont systemFontOfSize:16];
    alipayLabel.textColor = [UIColor flatLightBlueColor];
    alipayLabel.text = @"支付宝";
    [self.pickerBgBankView addSubview:alipayLabel];
    
    self.bankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bankBtn.frame = CGRectMake(alipayLabel.right+50,self.alipayBtn.top,15,15);
    [self.bankBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    [self.bankBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateSelected];
    [self.bankBtn addTarget:self action:@selector(bankBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgBankView addSubview:self.bankBtn];
    
    UILabel *bankLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.bankBtn.right+10,0, 60, 20)];
    bankLabel.centerY = self.bankBtn.centerY;
    bankLabel.backgroundColor = [UIColor clearColor];
    bankLabel.font = [UIFont systemFontOfSize:16];
    bankLabel.textColor = [UIColor flatLightBlueColor];
    bankLabel.text = @"银行卡";
    [self.pickerBgBankView addSubview:bankLabel];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineView.left, alipayLabel.bottom+20, 60, 20)];
    self.numLabel.text = @"账户";
    self.numLabel.font = [UIFont systemFontOfSize:16];
    self.numLabel.textColor = [UIColor grayColor];
    self.numLabel.backgroundColor = [UIColor clearColor];
    [self.pickerBgBankView addSubview:self.numLabel];
    
    self.numField = [[UITextField alloc] initWithFrame:CGRectMake(self.numLabel.right, 0, 200, 30)];
    self.numField.centerY = self.numLabel.centerY;
    self.numField.keyboardType = UIKeyboardTypeEmailAddress;
    self.numField.backgroundColor = [UIColor flatLightWhiteColor];
    self.numField.delegate = self;
    self.numField.font = [UIFont systemFontOfSize:14];
    self.numField.returnKeyType = UIReturnKeyNext;
    self.numField.layer.cornerRadius = 5;
    self.numField.layer.masksToBounds = YES;
    self.numField.textAlignment = NSTextAlignmentCenter;
    self.numField.delegate = self;
    [self.pickerBgBankView addSubview:self.numField];
    
    self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.numLabel.left, self.numLabel.bottom+20, 60, 20)];
    self.userLabel.text = @"开户人";
    self.userLabel.font = [UIFont systemFontOfSize:16];
    self.userLabel.textColor = [UIColor grayColor];
    self.userLabel.backgroundColor = [UIColor clearColor];
    [self.pickerBgBankView addSubview:self.userLabel];
    
    self.userField = [[UITextField alloc] initWithFrame:CGRectMake(self.userLabel.right, self.userLabel.top, 200, 30)];
    self.userField.centerY = self.userLabel.centerY;
    self.userField.keyboardType = UIKeyboardTypeDefault;
    self.userField.backgroundColor = [UIColor flatLightWhiteColor];
    self.userField.delegate = self;
    self.userField.font = [UIFont systemFontOfSize:14];
    self.userField.returnKeyType = UIReturnKeyNext;
    self.userField.layer.cornerRadius = 5;
    self.userField.layer.masksToBounds = YES;
    self.userField.text = @"";
    self.userField.textAlignment = NSTextAlignmentCenter;
    [self.pickerBgBankView addSubview:self.userField];
    
    
    self.bankSelect = [[UILabel alloc]initWithFrame:CGRectMake(self.userLabel.left, self.userLabel.bottom+20, 70, 20)];
    self.bankSelect.text = @"银行选择";
    self.bankSelect.font = [UIFont systemFontOfSize:16];
    self.bankSelect.textColor = [UIColor grayColor];
    self.bankSelect.backgroundColor = [UIColor clearColor];
    self.bankSelect.hidden = YES;
    [self.pickerBgBankView addSubview:self.bankSelect];
    
    self.showBankSelect = [[UILabel alloc]initWithFrame:CGRectMake(self.bankSelect.right, self.bankSelect.top, 230, 20)];
    self.showBankSelect.text = @"";
    self.showBankSelect.textAlignment = NSTextAlignmentCenter;
    self.showBankSelect.font = [UIFont systemFontOfSize:14];
    self.showBankSelect.textColor = [UIColor flatLightBlueColor];
    self.showBankSelect.backgroundColor = [UIColor clearColor];
    self.showBankSelect.hidden = YES;
    [self.pickerBgBankView addSubview:self.showBankSelect];
    
    self.codeBgView = [[UIView alloc]initWithFrame:CGRectMake(self.numLabel.left, self.numLabel.bottom+20, lineView.width, self.pickerBgBankView.height-self.numLabel.bottom-20-10)];
    NSLog(@"%f",self.codeBgView.centerY);
    self.codeBgView.centerY = 190+20+40;
    self.codeBgView.backgroundColor = [UIColor clearColor];
    //    self.codeBgView.hidden = YES;
    [self.pickerBgBankView addSubview:self.codeBgView];
    
    self.mobleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 20)];
    self.mobleLabel.text = @"手机号";
    self.mobleLabel.font = [UIFont systemFontOfSize:16];
    self.mobleLabel.textColor = [UIColor grayColor];
    self.mobleLabel.backgroundColor = [UIColor clearColor];
    [self.codeBgView addSubview:self.mobleLabel];
    
    self.mobleLabelField = [[UITextField alloc] initWithFrame:CGRectMake(self.mobleLabel.right, self.mobleLabel.top, 200, 30)];
    self.mobleLabelField.centerY = self.mobleLabel.centerY;
    self.mobleLabelField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobleLabelField.backgroundColor = [UIColor clearColor];
    self.mobleLabelField.delegate = self;
    self.mobleLabelField.font = [UIFont systemFontOfSize:14];
    self.mobleLabelField.returnKeyType = UIReturnKeyNext;
    self.mobleLabelField.layer.cornerRadius = 5;
    self.mobleLabelField.layer.masksToBounds = YES;
    self.mobleLabelField.text = [YKLLocalUserDefInfo defModel].mobile;
    //    self.mobleLabelField.textAlignment = NSTextAlignmentCenter;
    self.mobleLabelField.enabled = NO;
    [self.codeBgView addSubview:self.mobleLabelField];
    
    self.codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.mobleLabel.bottom+20, 60, 20)];
    self.codeLabel.text = @"验证码";
    self.codeLabel.font = [UIFont systemFontOfSize:16];
    self.codeLabel.textColor = [UIColor grayColor];
    self.codeLabel.backgroundColor = [UIColor clearColor];
    [self.codeBgView addSubview:self.codeLabel];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(self.codeLabel.right, self.codeLabel.top, 100, 30)];
    self.codeField.centerY = self.codeLabel.centerY;
    self.codeField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeField.backgroundColor = [UIColor flatLightWhiteColor];
    self.codeField.delegate = self;
    self.codeField.font = [UIFont systemFontOfSize:14];
    self.codeField.returnKeyType = UIReturnKeyNext;
    self.codeField.layer.cornerRadius = 5;
    self.codeField.layer.masksToBounds = YES;
    self.codeField.textAlignment = NSTextAlignmentCenter;
    [self.codeBgView addSubview:self.codeField];
    
    self.codeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.codeField.right+20, self.codeField.top, 80, 30)];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeBtn addTarget:self action:@selector(codeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeBtn setBackgroundColor: [UIColor flatLightGreenColor]];
    [self.codeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateHighlighted];
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self.codeBgView addSubview:self.codeBtn];
    
    self.ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.codeBgView.right-110, self.codeBtn.bottom+20, 200, 40)];
    self.ensureBtn.centerX = self.codeBgView.width/2;
    self.ensureBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.ensureBtn addTarget:self action:@selector(ensureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.ensureBtn setBackgroundColor: [UIColor flatLightBlueColor]];
    [self.ensureBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.ensureBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateHighlighted];
    self.ensureBtn.layer.cornerRadius = 5;
    self.ensureBtn.layer.masksToBounds = YES;
    [self.codeBgView addSubview:self.ensureBtn];
    
    
    [YKLNetworkingConsumer getBankAccountWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(NSArray *bankAccount) {
        
        if ([bankAccount isEqual:[NSNull null]]||[bankAccount isKindOfClass:[NSNull class]]||bankAccount==nil) {
            
        }else{
            
            for (int i = 0; i<bankAccount.count; i++) {
                
                NSDictionary *dict = bankAccount[i];
                NSString *type = [dict objectForKey:@"type"];
                NSString *account = [dict objectForKey:@"bank_account"];
                NSString *accountHolder = [dict objectForKey:@"account_holder"];
                NSString *bankName = [dict objectForKey:@"bank_name"];
                NSString *isDefault= [dict objectForKey:@"is_default"];
                
                if ([isDefault isEqual:@"1"]) {
                    
                    if ([type isEqual:@"1"]) {
                        
                        self.alipayAccountID = [dict objectForKey:@"id"];
                        self.alipayAccount = account;
                        self.alipayAccountHolder = accountHolder;
                        [self alipayBtnClicked];
                    }
                    else{
                        
                        self.bankAccountID = [dict objectForKey:@"id"];
                        self.bankAccount = account;
                        self.bankAccountHolder = accountHolder;
                        self.bankName = bankName;
                        [self bankBtnClicked];
                    }
                }
                else if ([isDefault isEqual:@"2"]){
                    
                    if ([type isEqual:@"1"]) {
                        
                        self.alipayAccountID = [dict objectForKey:@"id"];
                        self.alipayAccount = account;
                        self.alipayAccountHolder = accountHolder;
                    }
                    else{
                        
                        self.bankAccountID = [dict objectForKey:@"id"];
                        self.bankAccount = account;
                        self.bankAccountHolder = accountHolder;
                        self.bankName = bankName;
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.numField)
    {
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        
        if (proposedNewLength > 15 && proposedNewLength < 20){
            NSLog(@"%@",self.numField.text);
            self.showBankSelect.text = [self.numField.text isBankNumber];
            
        }
        if (proposedNewLength >19) {
            return NO;//限制长度
        }
        
    }
    else if (textField == self.cashField)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSLog(@"%@",text);
        
        if ([text floatValue]>200||[text floatValue]==200) {
            
            float cash =  [text floatValue]*0.001;
            
            NSString *cashStr = [NSString stringWithFormat:@"%f",cash];
            
            self.cashInfoLabel.text = [NSString stringWithFormat:@"额外扣除¥%@手续费",[cashStr getNSRoundPlain:2]];
        }
        else{
            self.cashInfoLabel.text = @"提现手续费率0.1%";
        }
        
    }
    return YES;
}

- (void)codeBtnClicked:(id)sender{
    
    [self hidenKeyboard];
    [YKLNetworkingConsumer getRegistVCodeWithMobile:self.mobleLabelField.text success:^(NSString *verificationCode) {
        
        [UIAlertView showInfoMsg:@"验证号已发送到指定手机，请耐心等待。"];
        
        _timerBalance = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [self timeFireMethod];
        
    } failure:^(NSError *error) {
        [UIAlertView showErrorMsg:error.domain];
        
    }];
}

int seconds = 60;
-(void)timeFireMethod{
    
    seconds--;
    
    NSString *str = [NSString stringWithFormat:@"%ds",seconds];
    [self.codeBtn setTitle:str forState:UIControlStateNormal];
    [self.codeBtn setBackgroundColor: [UIColor flatDarkGrayColor]];
    self.codeBtn.userInteractionEnabled=NO;
    
    if (seconds == 0) {
        
        [_timerBalance invalidate];
        
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.codeBtn setBackgroundColor: [UIColor flatLightGreenColor]];
        self.codeBtn.userInteractionEnabled=YES;
        seconds = 60;
    }
}

- (void)ensureBtnClicked:(id)sender{
    
    [self hidenKeyboard];
    
    if ([self.numField.text isBlankString]||[self.codeField.text isBlankString]||[self.userField.text isBlankString]) {
        
        [UIAlertView showInfoMsg:@"请填写完整信息"];
        return;
    }
    
    NSString *type;
    if (self.alipayBtn.selected) {
        type = @"1";
        self.showBankSelect.text = @"";

    }else if (self.bankBtn.selected){
        type = @"2";
        
        if ([self.showBankSelect.text isBlankString]) {
            [UIAlertView showInfoMsg:@"请填写完整信息"];
            return;
        }
        if (self.showBankSelect.text == nil) {
            [UIAlertView showInfoMsg:@"请填写正确的银行卡号"];
            return;
        }
    }
    
    if (self.accountID == nil) {
        self.accountID = @"";
    }
    
    [YKLNetworkingConsumer setBankAccountWithShopID:[YKLLocalUserDefInfo defModel].userID BankName:self.showBankSelect.text AccountHolder:self.userField.text BankAccount:self.numField.text Type:type IsDefault:@"1" Vcode:self.codeField.text BankAccountID:self.accountID Success:^(NSDictionary *dict) {
        
        [self hideBankView];
        
//        [UIAlertView showInfoMsg:@"设置成功"];

        //我的收益
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingConsumer accountCashWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLAccountCashModel *cashModel)
         {
             
             self.cashModel = cashModel;
             
             [self initTableView];
             [self initCashView];
             [self initBankView];
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         } failure:^(NSError *error) {
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [UIAlertView showInfoMsg:error.domain];
             
         }];
        
    } failure:^(NSError *error) {
        [UIAlertView showErrorMsg:error.domain];
    }];
    
}

//支付宝与银行卡选择
- (void)alipayBtnClicked{
    [self hidenKeyboard];
    
    //初始化数据和键盘
    self.accountID = self.alipayAccountID;
    self.numField.text = self.alipayAccount;
    self.userField.text = self.alipayAccountHolder;
    self.numField.keyboardType = UIKeyboardTypeEmailAddress;
    
    if(!self.alipayBtn.selected)
    {
        self.bankSelect.hidden = NO;
        self.showBankSelect.hidden = NO;
        self.codeBgView.centerY = 220+20+40;
        [self.alipayBtn setSelected:YES];
        [self.alipayBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.alipayBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    if(self.bankBtn.selected)
    {
        self.bankSelect.hidden = YES;
        self.showBankSelect.hidden = YES;
        self.codeBgView.centerY = 190+20+40;
        [self.bankBtn setSelected:NO];
        [self.bankBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.bankBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    self.bankBtn.selected = NO;
}

- (void)bankBtnClicked{
    [self hidenKeyboard];
    
    //初始化数据和键盘
    self.accountID = self.bankAccountID;
    self.numField.text = self.bankAccount;
    self.userField.text = self.bankAccountHolder;
    self.showBankSelect.text = self.bankName;
    self.numField.keyboardType = UIKeyboardTypeNumberPad;
    
    if(!self.bankBtn.selected)
    {
        self.bankSelect.hidden = YES;
        self.showBankSelect.hidden = YES;
        self.codeBgView.centerY = 190+20+40;
        [self.bankBtn setSelected:YES];
        [self.bankBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.bankBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    if(self.alipayBtn.selected)
    {
        self.bankSelect.hidden = NO;
        self.showBankSelect.hidden = NO;
        self.codeBgView.centerY = 220+20+40;
        [self.alipayBtn setSelected:NO];
        [self.alipayBtn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.alipayBtn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
}


- (void)logoutButtonClicked:(id)sender{
    NSLog(@"点击---充   值---");
    //    [self createAlertView:[self createSMSView]];
    
    self.AlertBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.AlertBgView.backgroundColor = [UIColor blackColor];
    self.AlertBgView.alpha = 0;
    
    [self.view addSubview:self.AlertBgView];
    [self.view addSubview:[self createSMSView]];
    self.AlertBgView.alpha = 0;
    self.pickerBgCashView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AlertBgView.alpha = 0.3;
        self.pickerBgCashView.bottom = self.view.height;
    }];
}

- (void)hideRechargeAlertBgView{
    [self hidenKeyboard];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.AlertBgView.alpha = 0;
        self.rechargeAlertBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.AlertBgView removeFromSuperview];
        [self.pickerBgCashView removeFromSuperview];
    }];
}

//显示提现弹窗
#pragma mark - private method
- (void)showCashView:(UIButton*)sender{
    NSLog(@"点击---申请提现---");
    NSLog(@"%ld",(long)sender.tag);
    
    float money = [self.cashModel.money floatValue];
    if (money < 200) {
        [UIAlertView showInfoMsg:@"提现金额不可低于200元"];
        return;
    }
    
    [self.view addSubview:self.maskCashView];
    [self.view addSubview:self.pickerBgCashView];
    self.maskCashView.alpha = 0;
    self.pickerBgCashView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskCashView.alpha = 0.3;
        self.pickerBgCashView.bottom = self.view.height;
    }];
}

- (void)hideCashView{
    [self hidenKeyboard];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskCashView.alpha = 0;
        self.pickerBgCashView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskCashView removeFromSuperview];
        [self.pickerBgCashView removeFromSuperview];
    }];
}

- (void)cashEnsure:(id)sender{
    NSLog(@"申请提现---确定按钮");
    [self hidenKeyboard];
    
    if ([self.cashField.text isBlankString])
    {
        [UIAlertView showInfoMsg:@"请设置提现金额"];
        return;
    }
    
    if (self.cashModel.accountHolder == NULL)
    {
        
        [UIAlertView showInfoMsg:@"请设置提现账户信息"];
        return;
    }
    
    if ([self.cashField.text floatValue]<200) {
        
        [UIAlertView showInfoMsg:@"至少提现200元"];
        return;
    }

    
    [YKLNetworkingConsumer withdrawCashWithShopID:[YKLLocalUserDefInfo defModel].userID Money:self.cashField.text BankAccount:self.cashModel.bankAccount AccountHolder:self.cashModel.accountHolder BankName:self.bankType Success:^(NSDictionary *dict) {
        
        [self hideCashView];
        [UIAlertView showInfoMsg:[NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]]];
        [self initTableView];
        
    } failure:^(NSError *error) {
        [UIAlertView showInfoMsg:error.domain];
    }];

}


#pragma mark - private method

//收益明细按钮
- (void)incomeListClick{
    
    YKLIncomeListViewController *VC = [YKLIncomeListViewController new];
    VC.money = self.cashModel.money;
    [self.navigationController pushViewController:VC animated:YES];
    
}

//显示银行卡弹窗
- (void)showBankView:(UIButton*)sender{
    NSLog(@"点击---修改提现---");
    NSLog(@"%ld",(long)sender.tag);
    
    [self.view addSubview:self.maskBankView];
    [self.view addSubview:self.pickerBgBankView];
    self.maskBankView.alpha = 0;
    self.pickerBgBankView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBankView.alpha = 0.3;
        self.pickerBgBankView.bottom = self.view.height;
    }];
}

- (void)hideBankView{
    [self hidenKeyboard];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskBankView.alpha = 0;
        self.pickerBgBankView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskBankView removeFromSuperview];
        [self.pickerBgBankView removeFromSuperview];
    }];
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
    CGRect rect=CGRectMake(0.0f,-212,width,height);
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
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.cashField resignFirstResponder];
    [self.codeField resignFirstResponder];
    [self.numField resignFirstResponder];
    [self.userField resignFirstResponder];
    [self.moneyField resignFirstResponder];
    
    [self resumeView];
}

//余额充值弹窗
- (UIView *)createSMSView
{
    
    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 264, 280)];
    self.rechargeAlertBgView.centerX = self.view.width/2;
    self.rechargeAlertBgView.backgroundColor = [UIColor whiteColor];
    self.rechargeAlertBgView.layer.cornerRadius = 7;
    self.rechargeAlertBgView.layer.masksToBounds = YES;
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.rechargeAlertBgView addGestureRecognizer:gesture];
    
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake(264-30-5,5,25,25);
    [self.closeBtn addTarget:self action:@selector(hideRechargeAlertBgView) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.closeBtn];
    
    self.rechargeAlertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.rechargeAlertTitleLabel.centerX = self.rechargeAlertBgView.width/2;
    self.rechargeAlertTitleLabel.font = [UIFont systemFontOfSize: 17.0];
    //        self.rechargeAlertTitleLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertTitleLabel.textColor = [UIColor blackColor];
    self.rechargeAlertTitleLabel.text = @"零钱充值";
    self.rechargeAlertTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.rechargeAlertBgView addSubview:self.rechargeAlertTitleLabel];
    
    self.lineAlertView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, self.rechargeAlertBgView.width-20, 1)];
    self.lineAlertView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.rechargeAlertBgView addSubview:self.lineAlertView];
    
    
    self.rechargeAlertActivityLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, self.lineAlertView.bottom+10,self.lineAlertView.width/2, 26)];
    self.rechargeAlertActivityLabel.font = [UIFont systemFontOfSize: 16.0];
    //    self.rechargeAlertActivityLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertActivityLabel.textColor = [UIColor blackColor];
    self.rechargeAlertActivityLabel.text = @"支付金额(元)";
    [self.rechargeAlertBgView addSubview:self.rechargeAlertActivityLabel];
    
    self.moneyField = [[UITextField alloc]initWithFrame:CGRectMake(self.rechargeAlertActivityLabel.right+10, self.rechargeAlertActivityLabel.top,100, 26)];
    //    self.moneyField.delegate = self;
    self.moneyField.font = [UIFont systemFontOfSize: 14.0];
    self.moneyField.backgroundColor = [UIColor flatLightWhiteColor];
    self.moneyField.textAlignment = NSTextAlignmentCenter;
    self.moneyField.keyboardType = UIKeyboardTypeNumberPad;
    self.moneyField.layer.cornerRadius = 5;
    self.moneyField.layer.masksToBounds = YES;
    [self.rechargeAlertBgView addSubview:self.moneyField];
    
    self.rechargeAlertMoneyLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, self.rechargeAlertActivityLabel.bottom+10,self.lineAlertView.width/2, 26)];
    self.rechargeAlertMoneyLabel.font = [UIFont systemFontOfSize: 16.0];
    //    self.rechargeAlertMoneyLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertMoneyLabel.textColor = [UIColor blackColor];
    self.rechargeAlertMoneyLabel.text = @"短信条数";
    //    [self.rechargeAlertBgView addSubview:self.rechargeAlertMoneyLabel];
    
    self.rechargeAlertMoneyNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.rechargeAlertMoneyLabel.top,80,26)];
    self.rechargeAlertMoneyNubLabel.right = self.lineAlertView.right;
    self.rechargeAlertMoneyNubLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertMoneyNubLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertMoneyNubLabel.textColor = [UIColor flatLightRedColor];
    self.rechargeAlertMoneyNubLabel.text = @"008";
    self.rechargeAlertMoneyNubLabel.textAlignment = NSTextAlignmentRight;
    //    [self.rechargeAlertBgView addSubview:self.rechargeAlertMoneyNubLabel];
    
    
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
    
    UIButton *rechargeAlertAlipayUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertAlipayUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertAlipayUpBtn.frame = CGRectMake(10, self.rechargeAlertMoneyLabel.bottom+15, self.view.width, 30);
    [rechargeAlertAlipayUpBtn addTarget:self action:@selector(alipayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: rechargeAlertAlipayUpBtn];
    
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
    
    UIButton *rechargeAlertWXUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeAlertWXUpBtn.backgroundColor = [UIColor clearColor];
    rechargeAlertWXUpBtn.frame = CGRectMake(10, self.rechargeAlertAlipayImageView.bottom+15, self.view.width, 30);
    [rechargeAlertWXUpBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: rechargeAlertWXUpBtn];
    
    self.rechargeAlertWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.rechargeAlertWXBtn.frame = CGRectMake(self.lineAlertView.width-26+10,self.rechargeAlertWXImageView.top,26,26);
    [self.rechargeAlertWXBtn addTarget:self action:@selector(wxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.rechargeAlertWXBtn];
    
    self.subOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.subOrderBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.subOrderBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.subOrderBtn.backgroundColor = [UIColor flatLightRedColor];
    self.subOrderBtn.layer.cornerRadius = 20;
    self.subOrderBtn.layer.masksToBounds = YES;
    self.subOrderBtn.frame = CGRectMake(0,self.rechargeAlertWXBtn.bottom+15,155,40);
    self.subOrderBtn.centerX = self.rechargeAlertBgView.width/2;
    [self.subOrderBtn addTarget:self action:@selector(subAuthorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.subOrderBtn];
    
    return self.rechargeAlertBgView;
}


//支付宝选择按钮
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
    [self.rechargeAlertWXBtn setSelected:NO];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertWXBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
}

//微信选择按钮
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
    
    [self.rechargeAlertAlipayBtn setSelected:NO];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateHighlighted];
    [self.rechargeAlertAlipayBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    
}

//授权支付按钮
- (void)subAuthorBtnClick:(id)sender{
    NSLog(@"——————————————点击提交授权支付订单——————————————");
    NSMutableDictionary *payDict = [NSMutableDictionary new];
    NSMutableArray *payOrderArray = [NSMutableArray array];
    
    if ([self.moneyField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请输入充值金额"];
        return;
    }
    if ([self.moneyField.text isEqual:@"0"]) {
        [UIAlertView showInfoMsg:@"充值金额不能为0"];
        return;
    }
    if (self.rechargeAlertAlipayBtn.selected==NO&&self.rechargeAlertWXBtn.selected==NO) {
        [UIAlertView showInfoMsg:@"请选择支付方式"];
        return;
    }
    
    [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    //点击充值隐藏支付框
    [self hideRechargeAlertBgView];
    
    //总金额为用户选择
    self.totleMoney =[NSString stringWithFormat:@"%@",self.moneyField.text];
    
    [payDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"buyer_id"];
    [payDict setObject:[YKLLocalUserDefInfo defModel].userName forKey:@"buyer_name"];
    [payDict setObject:self.totleMoney forKey:@"order_amount"];
    [payDict setObject:@"5"forKey:@"goods_type"];
    [payDict setObject:@"余额充值"forKey:@"goods_name"];
    
    if(self.rechargeAlertAlipayBtn.selected){
        
        [payDict setObject:@"1"forKey:@"payment_code"];//支付宝支付
    }
    else if(self.rechargeAlertWXBtn.selected){
        
        [payDict setObject:@"2"forKey:@"payment_code"];//微信支付
    }
    
    [payOrderArray addObject:payDict];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payOrderArray options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    
    if(self.rechargeAlertAlipayBtn.selected){
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在跳转支付页面";
        //点击支付按钮关闭弹出
        [self hideRechargeAlertBgView];
        
        
        [YKLNetworkingHighGo addOrderWithOrderJsonArray:str Success:^(NSDictionary *orderDict) {
            NSDictionary *tempOrderDict = [orderDict objectForKey:@"order"];
            NSString *orderNub = [tempOrderDict objectForKey:@"order_sn"];
            
            NSLog(@"%@",self.totleMoney);
            //支付费用假数据
            //            self.model.templatePrice= @"0.01";
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:orderNub productName:@"余额充值" productDescription:@"余额充值" amount:self.totleMoney notifyURL:kNotifyURL itBPay:@"30m"];
            
            Order *order = [Order order];
            order.partner = kPartnerID;
            order.seller = kSellerAccount;
            order.tradeNO = orderNub;
            order.productName = @"余额充值";
            order.productDescription = @"余额充值";
            order.amount = self.totleMoney;
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
                        
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        
                    }
                    else{
                        NSLog(@"失败%@",MerchantURL);
                        
                        [YKLLocalUserDefInfo defModel].payStatus = @"失败";
                        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                        //               MerchantURL
                        
                        
                    }
                }];
            }
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            [UIAlertView showInfoMsg:error.domain];
        }];
        
    }
    
    //选择微信支付按钮
    if (self.rechargeAlertWXBtn.selected){
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在跳转支付页面";
        //点击支付按钮关闭弹出
        [self hideRechargeAlertBgView];
        
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc] init];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        //}}}
        float price = [self.totleMoney floatValue];
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",price*100];
        
        [YKLNetworkingHighGo addOrderWithOrderJsonArray:str Success:^(NSDictionary *orderDict) {
            NSDictionary *tempOrderDict = [orderDict objectForKey:@"order"];
            NSString *orderNub = [tempOrderDict objectForKey:@"order_sn"];
            
            //获取到实际调起微信支付的参数后，在app端调起支付
            NSMutableDictionary *dict = [req sendPay_demo:@"余额充值" OrderPrice:priceStr OrderNub:orderNub NotifyURL:NOTIFY_URL];
            
            if(dict == nil){
                //错误提示
                NSString *debug = [req getDebugifo];
                
                [self alert:@"提示信息" msg:debug];
                
                NSLog(@"%@\n\n",debug);
            }else{
                NSLog(@"%@\n\n",[req getDebugifo]);
                //            [self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
                
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
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
        } failure:^(NSError *error) {
            [UIAlertView showInfoMsg:error.domain];
        }];
    }
}

- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
    
}

@end
