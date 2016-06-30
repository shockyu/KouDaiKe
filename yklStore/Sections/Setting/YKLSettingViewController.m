//
//  YKLSettingViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/10/6.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLSettingViewController.h"
#import "YKLLoginViewController.h"
#import "YKLAboutUsViewController.h"
#import "YKLMyFansViewController.h"
#import "YKLChildUserFansListViewController.h"

#import "YKLExposureViewController.h"
#import "YKLCashViewController.h"
//#import "YKLEarningsCashViewController.h"
//#import "YKLBalanceViewController.h"
#import "YKLBalanceMainViewController.h"
//#import "YKLQRcodeViewController.h"
#import "YKLShareDetailViewController.h"
#import "YKLVipPayIntroViewController.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"

@interface YKLSettingCell : UITableViewCell

@property (nonatomic, strong) UIImageView *callImageView;
@property (nonatomic, strong) YKLFanModel *fanModel;

@end

@implementation YKLSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor blackColor];
        
//        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
//        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.callImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_user_default.jpg"]];
        [self.contentView addSubview:self.callImageView];
        
        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.callImageView.frame = CGRectMake(15, 15, 30, 30);
    self.callImageView.centerY = self.height/2;
    self.textLabel.frame = CGRectMake(self.callImageView.right+15, 15, 100, 18);
    self.textLabel.centerY = self.height/2;
    
    //    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom, self.textLabel.width, 16);
}
@end


@interface YKLSettingViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageCropViewControllerDelegate>
{
    UIWebView *callView;
    NSURL* callURL;
    UIImage *myImage;
    
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
/** 帮助页面 */
@property (nonatomic, strong) UIView *bgImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property int singelTap;

/** 头像URL */
@property (nonatomic, strong) NSString *headImage_URL;
/** 头像页面 */
@property (nonatomic, strong) UIView *singerView;
/** 头像按钮 */
@property (nonatomic, strong) UIButton *avatarButton;
/** 头像相机按钮 */
@property (nonatomic, strong) UIImageView *avatarIcon;
/** 店铺名 */
@property (nonatomic, strong) UILabel *shopNameLabel;
/** 当前状态 */
@property (nonatomic, strong) UILabel *statusTitleLabel;
/** vip状态显示图片 */
@property (nonatomic, strong) UIImageView *vipStatusImage;
/** 充值页面 */
@property (nonatomic, strong) UIView *balanceView;
/** 短信剩余 */
@property (nonatomic, strong) UILabel *SMSTitleLabel;
/** 短信剩余数量 */
@property (nonatomic, strong) UILabel *SMSNumLabel;
/** 点击充值短信 */
@property (nonatomic, strong) UILabel *SMSPayLabel;
/** 零钱余额 */
@property (nonatomic, strong) UILabel *balanceTitleLabel;
/** 零钱余额数量 */
@property (nonatomic, strong) UILabel *balanceNmuLabel;
/** 点击充值零钱 */
@property (nonatomic, strong) UILabel *balancePayLabel;

@property (strong, nonatomic) UIView *maskCashView;
@property (strong, nonatomic) UIView *pickerBgCashView;
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
@end

@implementation YKLSettingViewController


- (instancetype)init{
    if (self = [super init]) {
        
       
        self.title = @"个人中心";
        
        self.view.backgroundColor = [UIColor flatLightWhiteColor];
        
        [self createSingerView];
        
        if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
            
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.singerView.bottom, self.view.width, 220) style:UITableViewStyleGrouped];
            
            
        }else{
            
            [self createBalanceView];
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.balanceView.bottom, self.view.width, 220) style:UITableViewStyleGrouped];
            
        }
        
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 220) style:UITableViewStyleGrouped];
        
        self.tableView.scrollEnabled = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightWhiteColor];
        //    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        [self.tableView registerClass:[YKLSettingCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:self.tableView];
        
        
        if (![[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
            
            if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.height-40, self.view.width-30, 15)];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor flatLightRedColor];
                NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"*尊敬的黄钻会员，您会员到期时间为%@",[YKLLocalUserDefInfo defModel].vipEnd]];
                //获取要调整颜色的文字位置,调整颜色
                NSRange range1_1=[[hintString1 string]rangeOfString:@"*尊敬的黄钻会员，您会员到期时间为"];
                [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range1_1];
                label.attributedText= hintString1;
                [self.view addSubview:label];
                
                if ([[YKLLocalUserDefInfo defModel].settingHelp isEqualToString:@"YES"]&&![[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
                    label.top = self.view.height-40;
                }
            }
            else if([[YKLLocalUserDefInfo defModel].isVip isEqual:@"2"]) {
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.height-40, self.view.width-30, 15)];
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor lightGrayColor];
                label.text = @"*您还不是黄钻会员，建议您办理黄钻享受更多优惠";
                [self.view addSubview:label];
                
                if ([[YKLLocalUserDefInfo defModel].settingHelp isEqualToString:@"YES"]&&![[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
                    label.top = self.view.height-40;
                }
                
                UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(18, label.bottom, 80, 25)];
                //        moreButton.backgroundColor = [UIColor redColor];
                [moreButton setTitleColor:[UIColor flatLightBlueColor] forState:UIControlStateNormal];
                [moreButton setTitle:@"点我了解详情" forState:UIControlStateNormal];
                moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:moreButton];
                
            }
            
            if ([[YKLLocalUserDefInfo defModel].settingHelp isEqual:@"YES"]&&![[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
                
                self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
                self.topView.backgroundColor = [UIColor colorWithHexString:@"ff4848"];
                [self.view addSubview:self.topView];
                
                UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width-30, 35)];
                moreButton.backgroundColor = [UIColor clearColor];
                [moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.topView addSubview:moreButton];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 260, 35)];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [UIColor whiteColor];
                label.text = @"黄钻会员开通五重礼，全年模板免费用！";
                [self.topView addSubview:label];
                
                UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-30, 0, 15, 15)];
                XButton.centerY = self.topView.height/2;
                [XButton setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
                [XButton addTarget:self action:@selector(XButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.topView addSubview:XButton];
                
                self.singerView.top = 64+35;
                self.balanceView.top = self.singerView.bottom;
                self.tableView.top = self.balanceView.bottom;
                
            }

//            if ([[YKLLocalUserDefInfo defModel].settingHelp isEqualToString:@"YES"]) {
//                    self.singelTap = 0;
//                    [self createFirstView];
//            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)createSingerView{
    
    self.singerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, self.view.width, 95)];
    self.singerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.singerView];
    
    UIButton *sigerViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sigerViewBtn.frame = CGRectMake(0, 0, self.view.width, 95);
    sigerViewBtn.backgroundColor = [UIColor clearColor];
    [sigerViewBtn addTarget:self action:@selector(singerViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.singerView addSubview:sigerViewBtn];
    
    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarButton.frame = CGRectMake(20, 15, 60, 60);
//    self.avatarButton.backgroundColor = [UIColor flatLightGreenColor];
    [self.avatarButton addTarget:self action:@selector(avatarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    //设置头像
//    [self.avatarButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:[YKLLocalUserDefInfo defModel].headImage]]] forState:UIControlStateNormal];
    
    //设置头像
    UIImageView *avatar = [UIImageView new]; 
    [avatar sd_setImageWithURL:[NSURL URLWithString:[YKLLocalUserDefInfo defModel].headImage] placeholderImage:[UIImage imageNamed:@"Demo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.avatarButton setImage:avatar.image forState:UIControlStateNormal];
    }];
    
    self.avatarButton.layer.cornerRadius = 30;
    self.avatarButton.layer.masksToBounds = YES;
    [self.singerView addSubview:self.avatarButton];
    
    //默认头像设置初始头像
    myImage = self.avatarButton.imageView.image;
    
    self.avatarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.avatarButton.left+42, self.avatarButton.top+42, 15, 15)];
    self.avatarIcon.backgroundColor = [UIColor flatLightRedColor];
    self.avatarIcon.image = [UIImage imageNamed:@"gerenzhongxin-xiangji"];
    self.avatarIcon.layer.cornerRadius = 7.5;
    self.avatarIcon.layer.masksToBounds = YES;
    [self.singerView addSubview:self.avatarIcon];
    
    self.shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarButton.right+10, 27, 120, 15)];
    self.shopNameLabel.font = [UIFont systemFontOfSize:12];
    self.shopNameLabel.text = [YKLLocalUserDefInfo defModel].userName;
    [self.singerView addSubview:self.shopNameLabel];
    
    self.statusTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.shopNameLabel.left, self.shopNameLabel.bottom+12, 120, 15)];
    self.statusTitleLabel.font = [UIFont systemFontOfSize:12];
    self.statusTitleLabel.text = @"当前状态：";
    self.statusTitleLabel.textColor = [UIColor flatLightRedColor];
    
    NSString *status;
    if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
        status = @"已授权";
    }else{
        status = @"未授权";
    }
    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前状态：%@",status]];
    
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1_1=[[hintString1 string]rangeOfString:@"当前状态："];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1_1];
    self.statusTitleLabel.attributedText= hintString1;
    
    [self.singerView addSubview:self.statusTitleLabel];
    
    
    if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        
        self.vipStatusImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.shopNameLabel.right, 0, 66, 27)];
        self.vipStatusImage.centerY = self.singerView.height/2+2;
        self.vipStatusImage.image = [UIImage imageNamed:@"gerenzhongxin-huangzuan"];
        [self.singerView addSubview:self.vipStatusImage];
        
    }else{
        
        self.vipStatusImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.shopNameLabel.right+18, 0, 66-18, 20)];
        self.vipStatusImage.centerY = self.singerView.height/2;
        self.vipStatusImage.image = [UIImage imageNamed:@"gerenzhongxin_putonghuiyuan"];
        [self.singerView addSubview:self.vipStatusImage];
        
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
    imageView.frame = CGRectMake(self.singerView.width-10-20, 22.5, 10, 15);
    imageView.centerY = self.singerView.height/2;
    [self.singerView addSubview:imageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.singerView.height-1, self.view.width, 1)];
    lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.singerView addSubview:lineView];
    
}

- (void)createBalanceView{
    
    self.balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, self.singerView.bottom, self.view.width, 100)];
    self.balanceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.balanceView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/2-1, 10, 1, self.balanceView.height-20)];
    lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.balanceView addSubview:lineView];
    
    self.SMSTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.balanceView.width/2, 15)];
    //    self.SMSTitleLabel.backgroundColor = [UIColor greenColor];
    self.SMSTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.SMSTitleLabel.font = [UIFont systemFontOfSize:15];
    self.SMSTitleLabel.text = @"短信剩余";
    [self.balanceView addSubview:self.SMSTitleLabel];
    
    self.SMSNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.SMSTitleLabel.bottom+10, self.balanceView.width/2, 22)];
    //    self.SMSNumLabel.backgroundColor = [UIColor greenColor];
    self.SMSNumLabel.textColor = [UIColor flatLightRedColor];
    self.SMSNumLabel.textAlignment = NSTextAlignmentCenter;
    self.SMSNumLabel.font = [UIFont systemFontOfSize:26];
    self.SMSNumLabel.text = [YKLLocalUserDefInfo defModel].smsNum;
    [self.balanceView addSubview:self.SMSNumLabel];
    
    self.SMSPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.SMSNumLabel.bottom+10, self.balanceView.width/2, 12)];
    //    self.SMSPayLabel.backgroundColor = [UIColor greenColor];
    self.SMSPayLabel.textColor = [UIColor flatLightBlueColor];
    self.SMSPayLabel.textAlignment = NSTextAlignmentCenter;
    self.SMSPayLabel.font = [UIFont systemFontOfSize:12];
    self.SMSPayLabel.text = @"点击充值短信";
    [self.balanceView addSubview:self.SMSPayLabel];
    
    UIButton *SMSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SMSButton.backgroundColor = [UIColor clearColor];
    SMSButton.frame = CGRectMake(0, 0, self.balanceView.width/2, self.balanceView.height);
    [SMSButton addTarget:self action:@selector(moneyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.balanceView addSubview:SMSButton];
    
    
    self.balanceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.balanceView.width/2, 15, self.balanceView.width/2, 15)];
    //    self.SMSTitleLabel.backgroundColor = [UIColor greenColor];
    self.balanceTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.balanceTitleLabel.font = [UIFont systemFontOfSize:15];
    self.balanceTitleLabel.text = @"零钱余额";
    [self.balanceView addSubview:self.balanceTitleLabel];
    
    self.balanceNmuLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.balanceView.width/2, self.SMSTitleLabel.bottom+10, self.balanceView.width/2, 22)];
    //    self.SMSNumLabel.backgroundColor = [UIColor greenColor];
    self.balanceNmuLabel.textColor = [UIColor flatLightRedColor];
    self.balanceNmuLabel.textAlignment = NSTextAlignmentCenter;
    self.balanceNmuLabel.font = [UIFont systemFontOfSize:26];
    self.balanceNmuLabel.text = [YKLLocalUserDefInfo defModel].money;
    [self.balanceView addSubview:self.balanceNmuLabel];
    
    self.balancePayLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.balanceView.width/2, self.SMSNumLabel.bottom+10, self.balanceView.width/2, 12)];
    //    self.SMSPayLabel.backgroundColor = [UIColor greenColor];
    self.balancePayLabel.textColor = [UIColor flatLightBlueColor];
    self.balancePayLabel.textAlignment = NSTextAlignmentCenter;
    self.balancePayLabel.font = [UIFont systemFontOfSize:12];
    self.balancePayLabel.text = @"点击充值零钱";
    [self.balanceView addSubview:self.balancePayLabel];
    
    UIButton *balanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    balanceButton.backgroundColor = [UIColor clearColor];
    balanceButton.frame = CGRectMake(self.balanceView.width/2, 0, self.balanceView.width/2, self.balanceView.height);
    [balanceButton addTarget:self action:@selector(balanceButton) forControlEvents:UIControlEventTouchUpInside];
    [self.balanceView addSubview:balanceButton];

}


- (void)XButtonClicked{
    
    self.topView.hidden = YES;
    
    self.singerView.top = 64+10;
    self.balanceView.top = self.singerView.bottom;
    self.tableView.top = self.balanceView.bottom;
    
    [YKLLocalUserDefInfo defModel].settingHelp = @"NO";
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
}

- (void)moreButtonClicked{
    
    [self.navigationController pushViewController:[YKLVipPayIntroViewController new] animated:YES];
}

- (void)createFirstView{
    
    self.bgImageView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImageView];
    
    self.firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人中心1"]];
    self.firstImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.firstImageView];
    
    self.secondImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人中心2"]];
    self.secondImageView.hidden = YES;
    self.secondImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.secondImageView];
    
    self.thirdImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人中心3"]];
    self.thirdImageView.hidden = YES;
    self.thirdImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.thirdImageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.bgImageView addGestureRecognizer:singleTap];
}


- (void)singleTap:(UITapGestureRecognizer *)sender{
    
    self.singelTap++;
    if (self.singelTap == 1) {
        self.secondImageView.hidden = NO;
    }
    if (self.singelTap == 2) {
        self.thirdImageView.hidden = NO;
    }
    if (self.singelTap == 3) {
        self.firstImageView.hidden = YES;
        self.secondImageView.hidden = YES;
        self.thirdImageView.hidden = YES;
        self.bgImageView.hidden = YES;
        [YKLLocalUserDefInfo defModel].settingHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        return 1;
    }else{
        return 2;
    }
}

//每个分组上边预留的空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9; // you can have your own choice, of course
}

////每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        return 2;
    }else{
        
        if (section==0) {
            return 2;
        }else{
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YKLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
    
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的粉丝";
            //        cell.detailTextLabel.text = @"88";
            [cell.callImageView setImage:[UIImage imageNamed:@"我的粉丝"]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
            imageView.frame = CGRectMake(cell.width-30, 22.5, 10, 15);
            imageView.centerY = cell.height/2;
            [cell addSubview:imageView];
            
        }
        else if (indexPath.row == 1) {
            //        cell.textLabel.text = @"访问量";
            //        cell.detailTextLabel.text = @"1024";
            [cell.callImageView setImage:[UIImage imageNamed:@"总曝光次数"]];
            
            UILabel *mytextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+30+15, 10, 100, 18)];
            mytextLabel.font = [UIFont systemFontOfSize:14];
            mytextLabel.text = @"访问量";
            mytextLabel.textColor = [UIColor blackColor];
            [cell addSubview:mytextLabel];
            
            UILabel *myDetailTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(mytextLabel.left, mytextLabel.bottom, mytextLabel.width, 16)];
            myDetailTextLabel.font = [UIFont systemFontOfSize:12];
            myDetailTextLabel.textColor = [UIColor lightGrayColor];
            myDetailTextLabel.text = [YKLLocalUserDefInfo defModel].shopExposureNum;
            [cell addSubview:myDetailTextLabel];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
            imageView.frame = CGRectMake(cell.width-10-20, 22.5, 10, 15);
            imageView.centerY = cell.height/2;
            [cell addSubview:imageView];
        
        }
    }
    else{
        if (indexPath.section==0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"口袋钱包";
                //        cell.detailTextLabel.text = @"查看详情";
                [cell.callImageView setImage:[UIImage imageNamed:@"我的收益"]];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
                imageView.frame = CGRectMake(cell.width-30, 22.5, 10, 15);
                imageView.centerY = cell.height/2;
                [cell addSubview:imageView];
                
            }
            else if (indexPath.row == 1) {
                
                cell.textLabel.text = @"推荐有奖";
                //        cell.detailTextLabel.text = @"查看详情";
                [cell.callImageView setImage:[UIImage imageNamed:@"我的二维码"]];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
                imageView.frame = CGRectMake(cell.width-30, 22.5, 10, 15);
                imageView.centerY = cell.height/2;
                [cell addSubview:imageView];
                
            }
        }
        else if (indexPath.section==1) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"我的粉丝";
                //        cell.detailTextLabel.text = @"88";
                [cell.callImageView setImage:[UIImage imageNamed:@"我的粉丝"]];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
                imageView.frame = CGRectMake(cell.width-30, 22.5, 10, 15);
                imageView.centerY = cell.height/2;
                [cell addSubview:imageView];
                
                
            }else if (indexPath.row == 1) {
                
                //        cell.textLabel.text = @"访问量";
                //        cell.detailTextLabel.text = @"1024";
                [cell.callImageView setImage:[UIImage imageNamed:@"总曝光次数"]];
                
                
                UILabel *mytextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15+30+15, 10, 100, 18)];
                mytextLabel.font = [UIFont systemFontOfSize:14];
                mytextLabel.text = @"访问量明细";
                mytextLabel.textColor = [UIColor blackColor];
                [cell addSubview:mytextLabel];
                
                UILabel *myDetailTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(mytextLabel.left, mytextLabel.bottom, mytextLabel.width, 16)];
                myDetailTextLabel.font = [UIFont systemFontOfSize:12];
                myDetailTextLabel.textColor = [UIColor lightGrayColor];
                myDetailTextLabel.text = [YKLLocalUserDefInfo defModel].shopExposureNum;
                [cell addSubview:myDetailTextLabel];
                
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting箭头"]];
                imageView.frame = CGRectMake(cell.width-10-20, 22.5, 10, 15);
                imageView.centerY = cell.height/2;
                [cell addSubview:imageView];
    
            }
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        
        if (indexPath.row == 0) {
            
            YKLMyFansViewController *fansVC = [YKLMyFansViewController new];
            [self.navigationController pushViewController:fansVC animated:YES];
        }
        else if (indexPath.row == 1) {
            
            YKLExposureViewController *exposureVC = [YKLExposureViewController new];
            [self.navigationController pushViewController:exposureVC animated:YES];
        }
    }
    else{
   
        if (indexPath.section==0) {
            //口袋钱包
            if (indexPath.row == 0) {
                
                //先授权
                if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
                
                    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
                        
                        YKLBalanceMainViewController *vc = [YKLBalanceMainViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        if ([[YKLLocalUserDefInfo defModel].agentCode isEqual:@""]) {
                            
                            YKLLoginViewController *loginVC = [YKLLoginViewController new];
                            [loginVC registTitleBtnClicked];
                            loginVC.title = @"商户信息";
                            [self.navigationController pushViewController:loginVC animated:YES];
                            
                        }else{
                            
                            YKLLoginViewController *loginVC = [YKLLoginViewController new];
                            [loginVC registTitleBtnClicked];
                            loginVC.title = @"商户信息";
                            
                            loginVC.agentIDField.enabled = NO;
                            loginVC.agentIDField.text = [YKLLocalUserDefInfo defModel].agentCode;
                            loginVC.agentIDField.textColor = [UIColor lightGrayColor];
                            [self.navigationController pushViewController:loginVC animated:YES];
                        }
                        
                    }

                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"只有授权用户才能进入，是否进入授权页面？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
                    alertView.tag = 7000;
                    [alertView show];
                }
                
            }
            //推荐有奖
            else if (indexPath.row == 1) {
                
                //先授权
                if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
                    
                    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
                        
                        YKLShareDetailViewController *aboutUsVC = [YKLShareDetailViewController new];
                        [self.navigationController pushViewController:aboutUsVC animated:YES];
                        
                    }else{
                        
                        if ([[YKLLocalUserDefInfo defModel].agentCode isEqual:@""]) {
                            
                            YKLLoginViewController *loginVC = [YKLLoginViewController new];
                            [loginVC registTitleBtnClicked];
                            loginVC.title = @"商户信息";
                            [self.navigationController pushViewController:loginVC animated:YES];
                            
                        }else{
                            
                            YKLLoginViewController *loginVC = [YKLLoginViewController new];
                            [loginVC registTitleBtnClicked];
                            loginVC.title = @"商户信息";
                            
                            loginVC.agentIDField.enabled = NO;
                            loginVC.agentIDField.text = [YKLLocalUserDefInfo defModel].agentCode;
                            loginVC.agentIDField.textColor = [UIColor lightGrayColor];
                            [self.navigationController pushViewController:loginVC animated:YES];
                        }
                    }
                    
                }else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"只有授权用户可以进入，是否进入授权页面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
                    alertView.tag = 7000;
                    [alertView show];
                }
            }
        }
        else if (indexPath.section==1){
            
            //我的粉丝
            if (indexPath.row == 0) {
                
//                YKLMyFansViewController *fansVC = [YKLMyFansViewController new];
//                [self.navigationController pushViewController:fansVC animated:YES];
                
                YKLChildUserFansListViewController *vc = [YKLChildUserFansListViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            //曝光次数
            else if (indexPath.row == 1) {
                
                YKLExposureViewController *exposureVC = [YKLExposureViewController new];
                [self.navigationController pushViewController:exposureVC animated:YES];
                
            }
        }
    }
}

- (void)singerViewClicked{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载商户信息";
    
    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
        [YKLNetworkingConsumer getShopInfoWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLShopInfoModel *shopInfoDic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            
            //打开隐藏开关
            loginVC.upView.hidden = loginVC.registLabel.hidden = YES;
            loginVC.agentNameField.hidden = loginVC.agentMobileField.hidden = loginVC.agentNameLabel.hidden = loginVC.agentMobileLabel.hidden = NO;
            
            UIColor *unchangedColor = [UIColor lightGrayColor];
            loginVC.storeNameField.enabled = loginVC.streetAddressField.enabled = loginVC.addIDImageBtn.enabled = loginVC.agentIDField.enabled = loginVC.agentNameField.enabled = loginVC.agentMobileField.enabled = NO;
            
            loginVC.loginNum.text = shopInfoDic.mobile;
            loginVC.storeNameField.text = shopInfoDic.shopName;
            loginVC.storeNameField.textColor = unchangedColor;
            
            NSArray *addressArray = [shopInfoDic.address componentsSeparatedByString:@","];
            loginVC.locationBtn.hidden = YES;
            loginVC.provinceBtn.hidden = loginVC.cityBtn.hidden = loginVC.townBtn.hidden = NO;
            loginVC.provinceBtn.enabled = loginVC.cityBtn.enabled = loginVC.townBtn.enabled = NO;
            [loginVC.provinceBtn setTitleColor:unchangedColor forState:UIControlStateNormal];
            [loginVC.cityBtn setTitleColor:unchangedColor forState:UIControlStateNormal];
            [loginVC.townBtn setTitleColor:unchangedColor forState:UIControlStateNormal];
            [loginVC.provinceBtn setTitle:addressArray[0] forState:UIControlStateNormal];
            
            if (addressArray.count>1) {
                [loginVC.cityBtn setTitle:addressArray[1] forState:UIControlStateNormal];
            }else{
                loginVC.cityBtn.hidden = YES;
                loginVC.townBtn.hidden = YES;
            }
            if (addressArray.count>2) {
                [loginVC.townBtn setTitle:addressArray[2] forState:UIControlStateNormal];
            }else{
                loginVC.townBtn.hidden = YES;
            }
            
            loginVC.streetAddressField.text = shopInfoDic.street;
            loginVC.streetAddressField.textColor = unchangedColor;
            
            /*
             *可更改内容
             *************************************************/
            loginVC.teleField.text = shopInfoDic.servicTel;
            loginVC.contactsField.text = shopInfoDic.lianxiren;
            /**************************************************/
            
            loginVC.addIDImageBtn.hidden = YES;
            loginVC.addBusinessImageBtn.hidden = YES;
            [loginVC.addQRCodeImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [loginVC.idImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoDic.identityCard] placeholderImage:[UIImage imageNamed:@"Demo"]];
            [loginVC.businessImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoDic.license] placeholderImage:[UIImage imageNamed:@"Demo"]];
            
            if (![shopInfoDic.shopQRCode isBlankString]) {
                [loginVC.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoDic.shopQRCode] placeholderImage:[UIImage imageNamed:@"Demo"]];
            }else{
                [loginVC.addQRCodeImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            }
            
            loginVC.agentIDField.text = shopInfoDic.agentCode;
            loginVC.agentIDField.textColor = unchangedColor;
            
            loginVC.agentNameField.text = shopInfoDic.agentName;
            loginVC.agentNameField.textColor = unchangedColor;
            
            loginVC.agentMobileField.text = shopInfoDic.agentMobile;
            loginVC.agentMobileField.textColor = [UIColor flatLightBlueColor];
            
            callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",shopInfoDic.agentMobile]];
            
            UIButton *contactUs = [UIButton buttonWithType:UIButtonTypeCustom];
            contactUs.backgroundColor = [UIColor clearColor];
            contactUs.frame = loginVC.agentMobileField.frame;
            [contactUs addTarget:self action:@selector(contactUsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [loginVC.bgView addSubview:contactUs];
            
            [self.navigationController pushViewController:loginVC animated:YES];
            
        } failure:^(NSError *error) {
            
            [UIAlertView showErrorMsg:error.domain];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        
    }else{
        
        if ([[YKLLocalUserDefInfo defModel].agentCode isEqual:@""]) {
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }else{
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            
            loginVC.agentIDField.enabled = NO;
            loginVC.agentIDField.text = [YKLLocalUserDefInfo defModel].agentCode;
            loginVC.agentIDField.textColor = [UIColor lightGrayColor];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }

}

- (void)statusNoBtnClicked{
    NSLog(@"点击了==--未授权按钮--==按钮");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer getAuthorPriceSuccess:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
        
        YKLPayViewController *vc = [YKLPayViewController new];
        vc.orderStatus = 2;
        vc.authorMoneyNum = [[dict objectForKey:@"author_price"]floatValue];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:error.domain];
    }];

}


- (void)moneyBtnClicked:(id)button {
    NSLog(@"==--点击了充值按钮--==");
    
    //先授权
    if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
        
        YKLPayViewController *vc = [YKLPayViewController new];
        vc.payType = @"短信充值";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        [self statusNoBtnClicked];
    }
}

- (void)balanceButton{
 
    //先授权
    if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
        
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
        
    }else{
        
        [self statusNoBtnClicked];
    }
    
    
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

/** 点击头像按钮 */
- (void)avatarButtonClick{
    NSLog(@"点击头像按钮");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 ) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1) {
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        //        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.avatarButton setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];

    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //跳转裁剪页面
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:self.avatarButton.imageView.image];
    controller.type = 1;
    controller.delegate = self;
    controller.blurredBackground = YES;
    // set the cropped area
    // controller.cropArea = CGRectMake(0, 0, 100, 200);
    [[self navigationController] pushViewController:controller animated:YES];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark - DoImagePickerControllerDelegate

- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{

    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        [self.avatarButton setImage:aSelected[0] forState:UIControlStateNormal];
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        [self.avatarButton setImage:[ASSETHELPER getImageFromAsset:aSelected[0] type:ASSET_PHOTO_SCREEN_SIZE] forState:UIControlStateNormal];
        
        [ASSETHELPER clearData];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    //跳转裁剪页面
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:self.avatarButton.imageView.image];
    controller.delegate = self;
    controller.blurredBackground = YES;
    controller.type = 1;
    // set the cropped area
    // controller.cropArea = CGRectMake(0, 0, 100, 200);
    [[self navigationController] pushViewController:controller animated:YES];

}

#pragma mark - 裁剪功能协议

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    myImage = croppedImage;
    [self.avatarButton setImage:croppedImage forState:UIControlStateNormal];
   
//    CGRect cropArea = controller.cropArea;
    [[self navigationController] popViewControllerAnimated:YES];
    
    [self qiniuUpload:0];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    
    [self.avatarButton setImage:myImage forState:UIControlStateNormal];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Helpers &七牛
- (void)qiniuUpload:(int) index{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"图片上传中请稍等";
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSString *token = @"5_06q8nFxevqEx7XeBFn5VBRtwVySPeQg2UCDo0R:cCvb_Qn5ayw5ulB7dVbpS-HSCvM=:eyJzY29wZSI6InlrbC1tZWlwYS1uZXQiLCJkZWFkbGluZSI6MzA0Mjc2NzQxMn0=";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
    
    // ------------------- Test putData -------------------------
    
    NSData *data = [self.avatarButton.imageView.image resizedAndReturnData];
    
    QNUploadOption *option1 = [[QNUploadOption alloc]initWithProgessHandler:^(NSString *key, float percent) {
        NSLog(@"percent<%d>:%.2f",index,percent);
       
    }];
    
    [upManager putData:data
                   key:fileName
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  self.headImage_URL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                  
                  NSLog(@"%@",self.headImage_URL);
                  
                  
                  [YKLNetworkingConsumer saveHeadImgWithImageURL:self.headImage_URL success:^(NSDictionary *dict) {
                      
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      self.navigationItem.leftBarButtonItem.enabled = YES;
                      [UIAlertView showInfoMsg:@"成功上传头像！"];
                      
                    
                  } failure:^(NSError *error){
                      
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [UIAlertView showErrorMsg:error.domain];
                      
                  }];
                  
              }
     
                option:option1];
    
}

- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}



- (void)logoutButtonClicked:(id)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定退出登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 6001){
        return;
    }
    if (alertView.tag == 7000) {
        if (buttonIndex == 0) {
            [self statusNoBtnClicked];
        }
    }
    else{
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            /*
             ********注销时需要清空用户数据********
             */
            [YKLLocalUserDefInfo defModel].isRegister = @"";
            [YKLLocalUserDefInfo defModel].isLogin = @"";
            [YKLLocalUserDefInfo defModel].mobile = @"";
            [YKLLocalUserDefInfo defModel].userID = @"";
            [YKLLocalUserDefInfo defModel].userName = @"";
            [YKLLocalUserDefInfo defModel].status = @"";
            [YKLLocalUserDefInfo defModel].payStatus = @"";
            [YKLLocalUserDefInfo defModel].unpublishedNum = @"";
            [YKLLocalUserDefInfo defModel].completeNum = @"";
            [YKLLocalUserDefInfo defModel].ongoingNum = @"";
            [YKLLocalUserDefInfo defModel].smsNum = @"";
            [YKLLocalUserDefInfo defModel].isFirst = @"";
            [YKLLocalUserDefInfo defModel].shopExposureNum = @"";
            //        [YKLLocalUserDefInfo defModel].firstHelp = @"";
            //        [YKLLocalUserDefInfo defModel].secondHelp = @"";
            //        [YKLLocalUserDefInfo defModel].actTypeHelp = @"";
            //        [YKLLocalUserDefInfo defModel].settingHelp = @"";
            //        [YKLLocalUserDefInfo defModel].onlinePayHelp = @"";
            //        [YKLLocalUserDefInfo defModel].shareHelp = @"";
            //        [YKLLocalUserDefInfo defModel].QRcodeHelp = @"";
            [YKLLocalUserDefInfo defModel].saveActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].saveHighGoActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].savePrizesActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].address = @"";
            [YKLLocalUserDefInfo defModel].street = @"";
            
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
        }
    }
}

- (void)contactUsBtnClicked:(id)sender
{
    
    if (callView == nil) {
        callView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [callView loadRequest:[NSURLRequest requestWithURL:callURL]];
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
    [self.moneyField resignFirstResponder];
    
    [self resumeView];
}

@end
