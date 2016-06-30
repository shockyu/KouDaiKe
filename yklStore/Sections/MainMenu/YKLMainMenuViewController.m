//
//  YKLMainMenuViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/14.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLMainMenuViewController.h"
#import "YKLMainMenuView.h"
#import "YKLLoginViewController.h"

#import "YKLActListTabBarViewController.h"
#import "YKLActivityListViewController.h"
#import "YKLSettingViewController.h"
#import "YKLGuideViewController.h"
#import "YKLReleaseTypeViewController.h"
#import "YKLExposureViewController.h"
#import "YKLActSelectViewController.h"
#import "YKLMainMenuHeaderView.h"
#import "YKLAboutUsViewController.h"
#import "YKLBalanceMainViewController.h"

#import "KDSListViewController.h"
#import "YKLWebViewController.h"
#import "YKLShopOrderCenterViewController.h"

//侧滑控件
#import "TWTMainViewController.h"
#import "TWTMenuViewController.h"
#import "TWTOrderViewController.h"
#import "TWTSideMenuViewController.h"

#import "YKLSpecialModelViewController.h"
#import "YKLVipPayIntroViewController.h"
#import "YKLPushWebViewController.h"
#import "WYScrollView.h"


float setCellHeight = 50.0;//设置页面cell的高度
int setCellNum = 3;        //设置页面cell的个数

@interface YKLMainMenuViewController ()<YKLMainMenuViewDelegate,UIApplicationDelegate, TWTSideMenuViewControllerDelegate,WYScrollViewLocalDelegate,WYScrollViewNetDelegate,UITabBarControllerDelegate>
{
    NSTimer *_timer;
}
//侧滑控件
@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) TWTMenuViewController *menuViewController;
@property (nonatomic, strong) TWTOrderViewController *orderViewController;
@property (nonatomic, strong) TWTMainViewController *mainViewController;

//充值金额
@property int moneyNub;

@property (nonatomic, strong) UIImageView *statusImageView;         //授权图片
@property (nonatomic, strong) UIImage *statusImage;
@property (nonatomic, strong) UILabel *statusLabel;                 //授权字段
@property (nonatomic, strong) UILabel *statusLabel2;                //授权字段
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UIButton *statusNoBtn;


@property (nonatomic, strong) UIView *statusBgView;
@property (nonatomic, strong) UIView *statusLine;

@property (nonatomic, strong) UILabel *smsTextLael;                 //短信字段
@property (nonatomic, strong) UILabel *smsNubLael;
@property (nonatomic, strong) UIButton *moneyBtn;

@property (nonatomic, strong) UILabel *moneyTextLael;               //曝光字段
@property (nonatomic, strong) UIImageView *moneyTextBgImageView;
@property (nonatomic, strong) UILabel *moneyNubLabel;
@property (nonatomic, strong) UIImageView *moneyImageView;
@property (nonatomic, strong) UIImageView *vipImageView;
@property (nonatomic, strong) UIButton *exposureBtn;

@property (nonatomic, strong) YKLMainMenuView *mainMenuView;
@property (nonatomic, strong) YKLMainMenuHeaderView *headerView;

//顶部视图
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *avatarBtn;  //个人中心
@property (nonatomic, strong) UIButton *serviceBtn; //客服
@property (nonatomic, strong) UIButton *settingBtn; //设置
@property (nonatomic, strong) UIView *settingView;  //设置页面
@property (nonatomic, strong) UIView *setBgView;
@property (nonatomic, strong) UIView *setBgView2;

//首次进入的帮助页面
@property (nonatomic, strong) UIView *bgImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property int singelTap;

@property (nonatomic, strong) YKLGetADModel *adModel;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *adModelArr;
@property (nonatomic, strong) WYScrollView *ADView;

@property (nonatomic, strong) NSString *downloadLink;
@end

@implementation YKLMainMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([[YKLLocalUserDefInfo defModel].QRcodeHelp isBlankString]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
//    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"主页背景.png"]];
//    bgImageView.frame = self.view.frame;
//    [self.view addSubview:bgImageView];
    
    
    self.headerView = [[YKLMainMenuHeaderView alloc]initWithFrame:CGRectMake(8, 70, 305, 86)];
    [self.view addSubview:self.headerView];
    
    //曝光详情按钮
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.backgroundColor = [UIColor clearColor];
    headerBtn.frame = CGRectMake(8, 70, 305, 86);
    [headerBtn addTarget:self action:@selector(exposureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headerBtn];
    
    self.mainMenuView = [[YKLMainMenuView alloc]initWithFrame:CGRectMake(100, 0, self.view.width, 0)];
    self.mainMenuView.alpha = 0;
    self.mainMenuView.alpha = 1.0;
    self.mainMenuView.delegate = self;
    self.mainMenuView.top = self.statusBgView.bottom+20;
    
    self.mainMenuView.top = 156+8;
    
    self.mainMenuView.height = ScreenHeight*0.58-10;
    [self.mainMenuView.releaseBtn addTarget:self action:@selector(releaseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainMenuView.orderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainMenuView];
    
    
    //    if (![[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
    //        [self createGuide];
    //    }
    
//    if (ScreenHeight == 480) {
//        
//        /** 设置网络scrollView的Frame及所需图片*/
//        self.ADView = [[WYScrollView alloc]initWithFrame:CGRectMake(8, self.mainMenuView.bottom, self.view.width-8-8, 45)];
//        
//    }else{
//        
//        /** 设置网络scrollView的Frame及所需图片*/
//        self.ADView = [[WYScrollView alloc]initWithFrame:CGRectMake(8, self.mainMenuView.bottom, self.view.width-8-8, 65)];
//    }
//    /** 添加到当前View上*/
//    [self.view addSubview:self.ADView];
    
//#pragma mark - 设置页创建必须在视图最上方
//    
//    [self createSettingView];
//    
//    [self createTopView];
}


#pragma mark - 版本更新

- (void)UpDate
{
    //type:1.安卓 2.iOS 现版本1.6.1
    [YKLNetworkingConsumer getVersionWithType:@"2" VersionNum:@"1.6.1" success:^(NSDictionary *dict) {
        
        NSLog(@"%@",dict);
        
        int flag  = [[dict objectForKey:@"flag"]intValue];
        if (flag == 1) {
            
            NSString *desc = [dict objectForKey:@"desc"];
            self.downloadLink = [dict objectForKey:@"download_link"];
            
            //线上1.6版本
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本更新" message:desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
            [alertView show];
            
        }
        else if (flag == 2){
            
            NSLog(@"暂无版本更新");
        }
        
    } failure:^(NSError *error) {
        
    }];
    
   
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //退出弹窗事件响应
    if (alertView.tag == 6000) {
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
            [YKLLocalUserDefInfo defModel].saveMiaoShaActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].saveSuDingActInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].shopPayInfoDict = [NSMutableDictionary new];
            [YKLLocalUserDefInfo defModel].address = @"";
            [YKLLocalUserDefInfo defModel].street = @"";
            [YKLLocalUserDefInfo defModel].shopQRCode = @"";
            
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
        }
        return;
    }
    
    if (buttonIndex == 0) {
        
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%d?mt=8",1050109408];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        exit(0);
    }
    else if (buttonIndex == 1){
        exit(0);
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
//    [self createMoneyView];
    
    [self createGuide];
    
    [self getSynchronization];
    
//    [self.ADView setUpTimer];
    
    [self UpDate];
    
//    if ([[YKLLocalUserDefInfo defModel].firstHelp isEqualToString:@"YES"]) {
//        self.singelTap = 0;
//        [self createFirstView];
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.ADView removeTimer];
    
    [self hidenSettingView:NO];
}

//创建设置视图
- (void)createSettingView{
    
    //设置页面下拉时的蒙版阴影图片
    self.setBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, self.view.width, ScreenHeight)];
    self.setBgView.backgroundColor = [UIColor colorWithR:0 G:0 B:0 A:0.5];
    self.setBgView.hidden = YES;
    [self.view addSubview:self.setBgView];
    
    //添加手势setBgView隐藏设置页面
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnClick)];
    gesture.numberOfTapsRequired = 1;
    [self.setBgView addGestureRecognizer:gesture];
    
    
    //设置页面创建
    self.settingView = [[UIView alloc]initWithFrame:CGRectMake(0, -ScreenHeight, self.view.width, setCellHeight*setCellNum)];
    self.settingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.settingView];
    
    
    UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guideBtn.frame = CGRectMake(0, 0, self.view.width, 50);
    guideBtn.backgroundColor = [UIColor whiteColor];
    [guideBtn addTarget:self action:@selector(guideBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:guideBtn];
    
    UILabel *guideLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 0, 70, 50)];
    guideLabel.font = [UIFont systemFontOfSize:14];
    guideLabel.text = @"操作指南";
    [guideBtn addSubview:guideLabel];
    
    UIImageView *guideImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 0, 17, 17)];
    guideImageView.image = [UIImage imageNamed:@"shezhi-caozuozhinan"];
    guideImageView.centerY = guideBtn.height/2;
//    guideImageView.backgroundColor = [UIColor flatLightRedColor];
    [guideBtn addSubview:guideImageView];
    
    UIButton *aboutUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutUsBtn.frame = CGRectMake(0, 50, self.view.width, setCellHeight);
    aboutUsBtn.backgroundColor = [UIColor whiteColor];
    [aboutUsBtn addTarget:self action:@selector(aboutUsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:aboutUsBtn];
    
    UILabel *aboutUsLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 0, 70, setCellHeight)];
    aboutUsLabel.font = [UIFont systemFontOfSize:14];
    aboutUsLabel.text = @"关于我们";
    [aboutUsBtn addSubview:aboutUsLabel];
    
    UIImageView *aboutUsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 0, 17, 17)];
    aboutUsImageView.image = [UIImage imageNamed:@"shezhi-guanyuwomen"];
    aboutUsImageView.centerY = aboutUsBtn.height/2;
//    aboutUsImageView.backgroundColor = [UIColor flatLightRedColor];
    [aboutUsBtn addSubview:aboutUsImageView];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(0, 100, self.view.width, setCellHeight);
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(exitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:exitBtn];
    
    UILabel *exitLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 0, 70, setCellHeight)];
    exitLabel.font = [UIFont systemFontOfSize:14];
    exitLabel.text = @"退出登录";
    [exitBtn addSubview:exitLabel];
    
    UIImageView *exitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 0, 17, 17)];
    exitImageView.image = [UIImage imageNamed:@"shezhi-tuichudenglu"];
    exitImageView.centerY = exitBtn.height/2;
//    exitImageView.backgroundColor = [UIColor flatLightRedColor];
    [exitBtn addSubview:exitImageView];
    
    
}

//创建顶部视图
- (void)createTopView{
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 62)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    self.avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarBtn.frame = CGRectMake(15, 20, 40, 40);
//    self.avatarBtn.backgroundColor = [UIColor flatLightRedColor];
    [self.avatarBtn addTarget:self action:@selector(moneyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarBtn setImage:[UIImage imageNamed:@"Demo"] forState:UIControlStateNormal];
    
    self.avatarBtn.layer.cornerRadius = 20;
    self.avatarBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.avatarBtn];
    
    self.serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.serviceBtn.frame = CGRectMake(235, 30, 25, 25);
    //    self.serviceBtn.backgroundColor = [UIColor flatLightRedColor];
    [self.serviceBtn addTarget:self action:@selector(serviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceBtn setImage:[UIImage imageNamed:@"shouye-kefu"] forState:UIControlStateNormal];
    [self.view addSubview:self.serviceBtn];
    
    
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn.frame = CGRectMake(self.serviceBtn.right+20, 30, 25, 25);
    //    self.settingBtn.backgroundColor = [UIColor flatLightRedColor];
    [self.settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.settingBtn setImage:[UIImage imageNamed:@"shouye-shezhi"] forState:UIControlStateNormal];
    self.settingBtn.selected = YES;
    [self.view addSubview:self.settingBtn];
    
}

#pragma mark - 同步用户信息

- (void)getSynchronization{
    
    //临时修改商户ID
//    [YKLLocalUserDefInfo defModel].userID = @"3662";
    
    [YKLNetworkingConsumer getSynchronizationWithUserID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLUserSynchronizationModel *userSynchronizationModel) {
        
        NSLog(@"------------------------商户ID：%@-----------------------",userSynchronizationModel.userID);
        NSLog(@"------------------------商户名：%@-----------------------",userSynchronizationModel.shopName);
        //新版本新增字段初始化

        if ([YKLLocalUserDefInfo defModel].shareURL == nil||[YKLLocalUserDefInfo defModel].shareTitle == nil||[YKLLocalUserDefInfo defModel].shareDesc == nil||[YKLLocalUserDefInfo defModel].shareImage == nil||[YKLLocalUserDefInfo defModel].shareActType == nil||[YKLLocalUserDefInfo defModel].isShowShare == nil){
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"";
            [YKLLocalUserDefInfo defModel].shareURL = @"";
            [YKLLocalUserDefInfo defModel].shareTitle = @"";
            [YKLLocalUserDefInfo defModel].shareDesc = @"";
            [YKLLocalUserDefInfo defModel].shareImage = @"";
            [YKLLocalUserDefInfo defModel].shareActType = @"";
        }
        
        if ([YKLLocalUserDefInfo defModel].address == nil||[YKLLocalUserDefInfo defModel].street == nil) {
            
            [YKLLocalUserDefInfo defModel].address = @"";
            [YKLLocalUserDefInfo defModel].street = @"";
        }
        
        if ([YKLLocalUserDefInfo defModel].saveActInfoDict == nil) {
            
            [YKLLocalUserDefInfo defModel].saveActInfoDict = [NSMutableDictionary new];
            
        }
        
        if ([YKLLocalUserDefInfo defModel].saveHighGoActInfoDict == nil) {
            
            [YKLLocalUserDefInfo defModel].saveHighGoActInfoDict = [NSMutableDictionary new];
        }
        
        if ([YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict == nil) {
            
            [YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict = [NSMutableDictionary new];
        }

        if ([userSynchronizationModel.smsNum isEqual:[NSNull null]]||[userSynchronizationModel.smsNum isKindOfClass:[NSNull class]]||userSynchronizationModel.smsNum==nil) {
            userSynchronizationModel.smsNum = @"0";
        }
        
        [YKLLocalUserDefInfo defModel].agentCode = userSynchronizationModel.registerAgentCode;
        
        //新增地址
        [YKLLocalUserDefInfo defModel].address = userSynchronizationModel.address;
        [YKLLocalUserDefInfo defModel].street = userSynchronizationModel.street;
        
        [YKLLocalUserDefInfo defModel].unpublishedNum = userSynchronizationModel.unpublishedNum;
        [YKLLocalUserDefInfo defModel].completeNum = userSynchronizationModel.completeNum;
        [YKLLocalUserDefInfo defModel].ongoingNum = userSynchronizationModel.ongoingNum;
        [YKLLocalUserDefInfo defModel].smsNum = userSynchronizationModel.smsNum;
        [YKLLocalUserDefInfo defModel].shopExposureNum = userSynchronizationModel.shopExposureNum;
        
        [YKLLocalUserDefInfo defModel].payStatus = @"默认支付状态";
        [YKLLocalUserDefInfo defModel].isFirst = @"";
        
        [YKLLocalUserDefInfo defModel].status = userSynchronizationModel.status;
        
        [YKLLocalUserDefInfo defModel].redFlowDesc = userSynchronizationModel.redFlowDesc;
        
        [YKLLocalUserDefInfo defModel].isVip = userSynchronizationModel.isVip;
        
        [YKLLocalUserDefInfo defModel].vipEnd = userSynchronizationModel.vipEnd;
        
        [YKLLocalUserDefInfo defModel].money = userSynchronizationModel.money;
        
        [YKLLocalUserDefInfo defModel].headImage = userSynchronizationModel.headImg;
        
        [YKLLocalUserDefInfo defModel].userID = userSynchronizationModel.userID;
        
        [YKLLocalUserDefInfo defModel].userName = userSynchronizationModel.shopName;
        
        [YKLLocalUserDefInfo defModel].agentName = userSynchronizationModel.agentName;
        [YKLLocalUserDefInfo defModel].agentMobile = userSynchronizationModel.agentMobile;
        [YKLLocalUserDefInfo defModel].agentAddress = userSynchronizationModel.agentAddress;
        [YKLLocalUserDefInfo defModel].agentHeaderURL = userSynchronizationModel.agentHeaderURL;
        
        [YKLLocalUserDefInfo defModel].purview = userSynchronizationModel.purview;
        
        [YKLLocalUserDefInfo defModel].shopQRCode = userSynchronizationModel.shopQRCode;
        
        [YKLLocalUserDefInfo defModel].servicTel = userSynchronizationModel.servicTel;
        
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        
        {
            
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i = 0; i<userSynchronizationModel.expoArray.count; i++) {
            [tempArray addObject:[userSynchronizationModel.expoArray[i] objectForKey:@"num"]];
        }
        
        [self.headerView reloadDataWithExpoArray:tempArray];
        
        float moneyNub = [userSynchronizationModel.shopExposureNum intValue];
        if (moneyNub>10000) {
            moneyNub = moneyNub/10000;
            self.moneyNubLabel.text = [NSString stringWithFormat:@"%.1f万",moneyNub];
            NSLog(@"%.1f",moneyNub);
            
            self.headerView.totleNumLabel.text = [NSString stringWithFormat:@"%.1f万",moneyNub];
            
        }else{
            self.moneyNubLabel.text = userSynchronizationModel.shopExposureNum;
            NSLog(@"%@",userSynchronizationModel.smsNum);
            
            self.headerView.totleNumLabel.text = userSynchronizationModel.shopExposureNum;
        }
        
        float todayNub = [userSynchronizationModel.todayExposure intValue];
        if (todayNub>10000) {
            todayNub = todayNub/10000;
            self.headerView.todayNumLabel.text = [NSString stringWithFormat:@"%.1f万",todayNub];
            
        }else{
            
            self.headerView.todayNumLabel.text = userSynchronizationModel.todayExposure;
        }
            
        }
        
        
        //设置头像
        UIImageView *avatar = [UIImageView new];
     
        [avatar sd_setImageWithURL:[NSURL URLWithString:[YKLLocalUserDefInfo defModel].headImage] placeholderImage:[UIImage imageNamed:@"Demo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [self.avatarBtn setImage:avatar.image forState:UIControlStateNormal];
        }];
        
       
//测试：未授权状态
//userSynchronizationModel.status = @"2";
        
        if ([userSynchronizationModel.status isEqualToString:@"1"]) {
        
            self.moneyNub = 100;
            
            [YKLLocalUserDefInfo defModel].isFirst = @"NO";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
            int smsNum = [userSynchronizationModel.smsNum intValue];
            
            if (smsNum > 500) {
                
                self.statusLabel.hidden = YES;
                self.statusLabel2.hidden = YES;
                self.smsNubLael.hidden = NO;
                self.smsNubLael.text = userSynchronizationModel.smsNum;
                self.moneyBtn.hidden =  NO;
                self.smsNubLael.textColor = [UIColor flatLightGreenColor];
                [self.moneyBtn setImage:[UIImage imageNamed:@"chong500"] forState:UIControlStateNormal];
                
            }
            
            if ((smsNum > 100 && smsNum < 500 )|| smsNum == 500|| smsNum == 100){
                self.statusLabel.hidden = YES;
                self.statusLabel2.hidden = YES;
                self.smsNubLael.hidden = NO;
                self.smsNubLael.text = userSynchronizationModel.smsNum;
                self.moneyBtn.hidden =  NO;
                self.smsNubLael.textColor = [UIColor flatOrangeColor];
                [self.moneyBtn setImage:[UIImage imageNamed:@"chong100_500"] forState:UIControlStateNormal];
            }
            
            if (smsNum < 100){
                self.statusLabel.hidden = YES;
                self.statusLabel2.hidden = YES;
                self.smsNubLael.hidden = NO;
                self.smsNubLael.text = userSynchronizationModel.smsNum;
                self.moneyBtn.hidden =  NO;
                
                self.smsNubLael.textColor = [UIColor flatLightRedColor];
                [self.moneyBtn setImage:[UIImage imageNamed:@"chong100"] forState:UIControlStateNormal];
            }
            
//            if (smsNum == 0) {
//                self.moneyNub = 200;
//                self.isFirst = YES;
//                
//                self.statusLabel.hidden = NO;
//                self.statusLabel2.hidden = NO;
//                self.statusBtn.hidden = NO;
//                self.smsNubLael.hidden = YES;
//                self.moneyBtn.hidden =  YES;
//            }
            
        }else{
        
//            self.moneyNub = 200;
            
            [YKLLocalUserDefInfo defModel].isFirst = @"YES";
           
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
            self.statusLabel.hidden = NO;
            self.statusLabel2.hidden = NO;
            self.statusBtn.hidden = YES;
            self.smsNubLael.hidden = YES;
            self.moneyBtn.hidden =  YES;
        }
        
        //支付授权按钮显示
        self.statusNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statusNoBtn.frame = CGRectMake(65, 15, self.smsTextLael.right-20, 55);
        self.statusNoBtn.backgroundColor = [UIColor clearColor];
        [self.statusNoBtn addTarget:self action:@selector(statusNoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"]&&[[YKLLocalUserDefInfo defModel].status isEqualToString:@"1"]) {
            
            self.statusNoBtn.hidden = YES;
            [self.statusBgView addSubview:self.statusNoBtn];
            
        }else{
        
            self.statusNoBtn.hidden = NO;
            [self.statusBgView addSubview:self.statusNoBtn];
        }
        
        if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
            self.vipImageView.hidden = NO;
            self.moneyImageView.image = [UIImage imageNamed:@"会员头像"];
            
            //VIP边框宽度
            [self.avatarBtn.layer setBorderWidth:2.0];
            self.avatarBtn.layer.borderColor=[UIColor colorWithHexString:@"ffde00"].CGColor;
            
        }else{
            self.vipImageView.hidden = YES;
            self.moneyImageView.image = [UIImage imageNamed:@"头像"];
        }
        
        if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
            
            self.vipImageView.hidden = YES;
            self.moneyImageView.image = [UIImage imageNamed:@"头像"];
            
            self.smsTextLael.text = [YKLLocalUserDefInfo defModel].userName;
            self.smsTextLael.size = CGSizeMake(120, 60);
            [self.smsTextLael setNumberOfLines:0];
            
            self.smsNubLael.hidden = YES;
            self.moneyBtn.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        
        [UIAlertView showInfoMsg:error.domain];
    }];
    
}

#pragma mark - 首次进入的帮助指导页面

- (void)createFirstView{
    
    self.bgImageView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImageView];
    
    self.firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页引导页1"]];
    self.firstImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.firstImageView];
    
    self.secondImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页引导页2"]];
    self.secondImageView.hidden = YES;
    self.secondImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.secondImageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
    [self.bgImageView addGestureRecognizer:singleTap];
}


- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    
    self.singelTap++;
    if (self.singelTap == 1) {
        self.secondImageView.hidden = NO;
    }
    if (self.singelTap == 2) {
        self.firstImageView.hidden = YES;
        self.secondImageView.hidden = YES;
        self.bgImageView.hidden = YES;
        [YKLLocalUserDefInfo defModel].firstHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

- (void)createMoneyView{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    self.statusBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 85)];
//    self.statusBgView.backgroundColor = [UIColor colorWithHexString:@"ffe9c3"];
    self.statusBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusBgView];
    
    self.moneyImageView = [[UIImageView alloc]init];
    self.moneyImageView.frame = CGRectMake(10, 0, 40, 50);
    self.moneyImageView.centerY = self.statusBgView.height/2;
    [self.statusBgView addSubview: self.moneyImageView];
    
    self.vipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VIP"]];
    self.vipImageView.hidden = YES;
    self.vipImageView.frame = CGRectMake(30, 0, 15, 15);
    [self.moneyImageView addSubview:self.vipImageView];
    
    self.statusLine = [[UIView alloc]initWithFrame:CGRectMake(self.moneyImageView.right+10, 15, 1, 55)];
    self.statusLine.backgroundColor = [UIColor flatLightWhiteColor];
    [self.statusBgView addSubview:self.statusLine];
    
    self.statusLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/3*2-1, 15, 1, 55)];
    self.statusLine.backgroundColor = [UIColor flatLightWhiteColor];
    [self.statusBgView addSubview:self.statusLine];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = self.moneyImageView.frame;
    setBtn.backgroundColor = [UIColor clearColor];
    [setBtn addTarget:self action:@selector(moneyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.statusBgView addSubview: setBtn];
    
    self.smsTextLael = [[UILabel alloc]initWithFrame:CGRectMake(self.moneyImageView.right+20, 15, 95, 20)];
    //    self.smsTextLael.backgroundColor = [UIColor redColor];
    self.smsTextLael.font = [UIFont systemFontOfSize: 14.0];
    self.smsTextLael.textAlignment = NSTextAlignmentLeft;
    self.smsTextLael.textColor = [UIColor blackColor];
    self.smsTextLael.text = @"短信剩余条数";
    [self.statusBgView addSubview:self.smsTextLael];
    
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.smsTextLael.left, self.smsTextLael.bottom+5, 100, 15)];
    //    self.statusLabel.backgroundColor = [UIColor redColor];
    self.statusLabel.font = [UIFont systemFontOfSize: 12.0];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.textColor = [UIColor lightGrayColor];
    self.statusLabel.text = @"暂未获得短信通道";
    [self.statusBgView addSubview:self.statusLabel];
    
    self.statusLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.smsTextLael.left, self.statusLabel.bottom, 100, 15)];
    //    self.statusLabel2.backgroundColor = [UIColor redColor];
    self.statusLabel2.font = [UIFont systemFontOfSize: 13.0];
    self.statusLabel2.textAlignment = NSTextAlignmentLeft;
    self.statusLabel2.textColor = [UIColor flatLightGreenColor];
    self.statusLabel2.text = @"立即开通";
    [self.statusBgView addSubview:self.statusLabel2];
    
    self.statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.statusBtn.frame = CGRectMake(0, 15, self.smsTextLael.right-10, 50);
    self.statusBtn.backgroundColor = [UIColor clearColor];
    [self.statusBtn addTarget:self action:@selector(moneyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.statusBgView addSubview:self.statusBtn];

    self.smsNubLael = [[UILabel alloc]init];
    self.smsNubLael.font = [UIFont systemFontOfSize: 27.0];
//    self.smsNubLael.backgroundColor = [UIColor blueColor];
//    self.smsNubLael.textColor = [UIColor flatLightRedColor];
    self.smsNubLael.frame = CGRectMake(self.moneyImageView.right+20, self.smsTextLael.bottom+10, 95, 20);
    [self.statusBgView addSubview:self.smsNubLael];
   
    self.moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moneyBtn.frame = CGRectMake(self.smsNubLael.right, self.smsNubLael.top, 20, 20);
    self.moneyBtn.backgroundColor = [UIColor clearColor];
    [self.moneyBtn addTarget:self action:@selector(statusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.moneyBtn setImage:[UIImage imageNamed:@"chong500"] forState:UIControlStateNormal];
    [self.statusBgView addSubview:self.moneyBtn];
    
    self.moneyTextLael = [[UILabel alloc]initWithFrame:CGRectMake(self.statusLine.right, 15, self.view.width/3, 20)];
//    self.moneyTextLael.backgroundColor = [UIColor redColor];
    self.moneyTextLael.font = [UIFont systemFontOfSize: 14.0];
    self.moneyTextLael.textAlignment = NSTextAlignmentLeft;
    self.moneyTextLael.textColor = [UIColor blackColor];
    self.moneyTextLael.text = @"访问量";
    self.moneyTextLael.textAlignment = NSTextAlignmentCenter;
    [self.statusBgView addSubview:self.moneyTextLael];
    
    self.moneyNubLabel = [[UILabel alloc]init];
    self.moneyNubLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyNubLabel.font = [UIFont systemFontOfSize: 27.0];
//    self.moneyNubLabel.backgroundColor = [UIColor blueColor];
    self.moneyNubLabel.textColor = [UIColor flatLightRedColor];
    self.moneyNubLabel.frame = CGRectMake(self.statusLine.right, self.moneyTextLael.bottom+10, self.view.width/3, 20);
    [self.statusBgView addSubview:self.moneyNubLabel];
    
    self.exposureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exposureBtn.frame = CGRectMake(self.statusLine.right, 15, self.view.width/3, 50);
    self.exposureBtn.backgroundColor = [UIColor clearColor];
    [self.exposureBtn addTarget:self action:@selector(exposureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.statusBgView addSubview:self.exposureBtn];

}


#pragma mark - 底部banner广告页

- (void)createGuide{
    
    if (ScreenHeight == 480) {
        
        /** 设置网络scrollView的Frame及所需图片*/
        self.ADView = [[WYScrollView alloc]initWithFrame:CGRectMake(8, self.mainMenuView.bottom, self.view.width-8-8, 45)];
        
    }else{
        
        /** 设置网络scrollView的Frame及所需图片*/
        self.ADView = [[WYScrollView alloc]initWithFrame:CGRectMake(8, self.mainMenuView.bottom, self.view.width-8-8, 65)];
    }
    /** 添加到当前View上*/
    [self.view addSubview:self.ADView];
    
#pragma mark - 设置页创建必须在视图最上方
    
    [self createSettingView];
    
    [self createTopView];
    
    /*
     ***加载的数据
     */
    self.imgArray = [NSMutableArray array];
    self.adModelArr = [NSMutableArray array];
    
    
    [YKLNetworkingConsumer getADWithName:@"index_footer" Type:@"1" Success:^(NSArray *fansModel) {
        self.adModelArr = [NSMutableArray arrayWithArray:fansModel];
        
        for (int i = 0; i < fansModel.count; i++) {
            self.adModel =fansModel[i];
            
            [self.imgArray addObject:self.adModel.adImg];
        }
        
        /** 创建网络滚动视图*/
        [self createNetScrollView];
        

    } failure:^(NSError *error) {
        
        
    }];

}

- (void)createNetScrollView
{
    
    [self.ADView reloadImageWith:self.imgArray];
    
    self.ADView.pageHide = YES;
    
    /** 设置滚动延时*/
    self.ADView.AutoScrollDelay = 4;
    
    /** 设置占位图*/
    self.ADView.placeholderImage = [UIImage imageNamed:@""];
    
    /** 获取网络图片的index*/
    self.ADView.netDelagate = self;
    
    
    
}

/** 获取网络图片的index */
- (void)didSelectedNetImageAtIndex:(NSInteger)index
{
    NSLog(@"点中网络图片的下标是:%ld",(long)index);
    
    if ([self.adModelArr isEqual:@[]]) {
        
        [UIAlertView showInfoMsg:@"网络不给力，请重新进入首页"];
        return;
    }
    YKLGetADModel *adModel = self.adModelArr[index];
    NSLog(@"%@，%@",adModel.title,adModel.link);
    
    if ([adModel.jumpType isEqual:@"2"]){
        
        YKLPushWebViewController *webVC = [YKLPushWebViewController new];
        webVC.hidenBar = NO;
        webVC.webURL = adModel.link;
        webVC.webTitle = adModel.title;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    else if([adModel.jumpType isEqual:@"1"]){
        
        if ([adModel.link isEqual:@"vip_pay"]) {
            
            YKLVipPayIntroViewController *vc = [YKLVipPayIntroViewController new];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}


#pragma mark - 按钮方法

- (void)exposureBtnClicked:(id)sender{
    NSLog(@"点击了==--曝光按钮--==");
    
    [self.navigationController pushViewController:[YKLExposureViewController new] animated:YES];
    
}

- (void)statusBtnClicked:(id)sender{
    NSLog(@"点击了==--短信充值--==按钮");
    
    [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    YKLPayViewController *vc = [YKLPayViewController new];
    vc.payType = @"短信充值";
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)statusNoBtnClicked:(id)sender{
    NSLog(@"点击了==--未授权按钮--==按钮");
    
    //先注册后授权
    if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
        if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
            
            YKLSettingViewController *setVC = [YKLSettingViewController new];
            [self.navigationController pushViewController:setVC animated:YES];
            
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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingConsumer getAuthorPriceSuccess:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
//            self.authorPrice = [dict objectForKey:@"author_price"];
//            [self createAlertView:[self createAuthorView]];
            
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
}


- (void)moneyButtonClick:(id)sender{
    NSLog(@"点击了==--个人中心--==按钮");
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        YKLSettingViewController *setVC = [YKLSettingViewController new];
        [self.navigationController pushViewController:setVC animated:YES];
    });

   
}

- (void)guideButtonClick:(id)sender{
    NSLog(@"点击了==--成为年费会员--==按钮");
    
    YKLVipPayIntroViewController *vc = [YKLVipPayIntroViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)releaseBtnClicked:(id)sender {
    NSLog(@"------发布按钮------");
    
    [self.navigationController pushViewController:[YKLActSelectViewController new] animated:YES];
}

- (void)orderBtnClicked:(id)sender
{
    KDSListViewController *vc = [KDSListViewController new];
    vc.listType = KDSListTypeNormal;
    [self.navigationController pushViewController:vc animated:YES];
    
/** 活动订单入口 */
//    self.orderViewController = [[TWTOrderViewController alloc] initWithNibName:nil bundle:nil];
//    self.mainViewController = [[TWTMainViewController alloc] initWithNibName:nil bundle:nil];
//    
//    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.orderViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.mainViewController]];
//    
//    //调用活动点击事件
//    [self.orderViewController changeButtonPressed];
    
    
//    self.sideMenuViewController.shadowColor = [UIColor blackColor];
//    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
//    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
//    self.sideMenuViewController.delegate = self;
//    
//    [self.navigationController pushViewController:self.sideMenuViewController animated:YES];
}

- (void)serviceBtnClick{
    NSLog(@"点击客户按钮");
    
    YKLPushWebViewController *webVC = [YKLPushWebViewController new];
    webVC.hidenBar = NO;
    webVC.webURL = @"http://kefu5.kuaishang.cn/bs/mim/66593/58010/683585.htm?ref=ykl.meipa.net";
    webVC.webTitle = @"在线客服";
    [self.navigationController pushViewController:webVC animated:YES];
    
}


- (void)settingBtnClick{
    NSLog(@"点击设置按钮");
    
    if(self.settingBtn.selected)
    {
        
        [self showSettingView:YES];
        
        [self.settingBtn.layer addAnimation:[self rotation:0.5 degree:(M_PI*(90)/180.0) direction:1 repeatCount:1] forKey:nil];
        
        
    }else{
        
        [self hidenSettingView:YES];
        
        [self.settingBtn.layer addAnimation:[self rotation:0.5 degree:(M_PI*(-90)/180.0) direction:1 repeatCount:1] forKey:nil];
        
        
    }
}

- (void)aboutUsBtnClicked{
    NSLog(@"点击关于我们");
    
    [self hidenSettingView:NO];
    YKLAboutUsViewController *aboutUsVC = [YKLAboutUsViewController new];
    [self.navigationController pushViewController:aboutUsVC animated:YES];

}



- (void)guideBtnClicked{
    NSLog(@"操作指南");
    
    [self hidenSettingView:NO];
    YKLGuideViewController *guideVC = [YKLGuideViewController new];
    [self.navigationController pushViewController:guideVC animated:YES];
    
}

- (void)exitBtnClicked{
    NSLog(@"点击退出登录");
    
    [self hidenSettingView:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确定退出登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    alertView.tag = 6000;
    [alertView show];
}

#pragma mark - YKLMainMenuViewDelegate

- (void)shareViewDidClickItemType:(YKLMainMenuType)type{
    
    switch (type) {
        case YKLMainMenuTypeActList:
        {
            NSLog(@"活动列表");
//            [self pushToActList:@"进行中"];
            
            YKLActListTabBarViewController *vc = [YKLActListTabBarViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case YKLMainMenuTypeBalance:
        {
            NSLog(@"口袋钱包");
            
            if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
                
                //操作指南
                [self guideBtnClicked];
            
            }
            else{
                
                //先授权
                if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
                    
                    [self.navigationController pushViewController:[YKLBalanceMainViewController new] animated:YES] ;
                    
                }else{
                    
                    [self statusNoBtnClicked];
                }
                
            }

            break;
        }
        case YKLMainMenuTypeShop:
        {
            NSLog(@"口袋联采");
            
            if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
                
                //关于我们
                [self aboutUsBtnClicked];
                
            }
            else{
                
                int purnum = [[[YKLLocalUserDefInfo defModel].purview substringWithRange:NSMakeRange(0,1)] intValue];
                
                if (purnum == 0) {
                    
                    [UIAlertView showInfoMsg:@"您所在的区域暂未开通口袋联采，如有疑问，请联系客服。0731-89790322"];
                    
                }
                else if (purnum == 1){
                    
                    YKLWebViewController *ctl = [[YKLWebViewController alloc] init];
                    ctl.lcUrl = @"http://ykl.meipa.net/admin.php/Bargain/lc_list";
                    [self.navigationController pushViewController:ctl animated:YES];
                }

            }
            
            
            break;
        }
        default:
            break;
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

- (void)pushToActList:(NSString *)naviTitle{
    
    self.menuViewController = [[TWTMenuViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController = [[TWTMainViewController alloc] initWithNibName:nil bundle:nil];
    
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.mainViewController]];
    
    [YKLLocalUserDefInfo defModel].actType = naviTitle;
    [[YKLLocalUserDefInfo defModel]saveToLocalFile];
    
    //调用活动点击事件
    [self.menuViewController changeButtonPressed:naviTitle];
    
    //    [self.sideMenuViewController openMenuAnimated:NO completion:nil];
    //    self.menuViewController.bargainImageView.image = [UIImage imageNamed:@"砍价侧边栏选中.png"];
    //    [self.menuViewController.bargainBtn setTitleColor:[UIColor PosterOrangeColor] forState:UIControlStateNormal];
    //    [self.sideMenuViewController closeMenuAnimated:NO completion:nil];
    
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    
    [self.navigationController pushViewController:self.sideMenuViewController animated:YES];
}

#pragma mark - 设置按钮旋转动画

- (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    
    return animation;
    
}

#pragma mark - 设置页显隐及动画

/*!
 * 设置页面隐藏
 */
- (void)hidenSettingView:(BOOL)animat{
    
    [self.settingBtn setSelected:YES];
    
    if (animat) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.settingView.top = -ScreenHeight;
            
            self.setBgView.hidden = YES;
            
        }completion:^(BOOL finished) {
            
            self.setBgView.top = -ScreenHeight;
            
        }];
    }else{
        self.settingView.top = -ScreenHeight;
        
        self.setBgView.hidden = YES;
        self.setBgView.top = -ScreenHeight;
    }
    

}

/*!
 * 设置页面显示
 */
- (void)showSettingView:(BOOL)animat{
    
    [self.settingBtn setSelected:NO];
    
    if (animat) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.settingView.top = self.topView.bottom;
            
            self.setBgView.top = self.topView.bottom;
            
        }completion:^(BOOL finished) {
            
            self.setBgView.hidden = NO;
        }];
        
    }else{
        self.settingView.top = self.topView.bottom;
        
        self.setBgView.top = self.topView.bottom;
        self.setBgView.hidden = NO;
    }
    

}


#pragma mark - TWTSideMenuViewControllerDelegate(侧边栏菜单)

- (UIStatusBarStyle)sideMenuViewController:(TWTSideMenuViewController *)sideMenuViewController statusBarStyleForViewController:(UIViewController *)viewController
{
    if (viewController == self.menuViewController) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)sideMenuViewControllerWillOpenMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"willOpenMenu");
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)sideMenuViewControllerDidOpenMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"didOpenMenu");
}

- (void)sideMenuViewControllerWillCloseMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"willCloseMenu");
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)sideMenuViewControllerDidCloseMenu:(TWTSideMenuViewController *)sender {
    NSLog(@"didCloseMenu");
    
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"clicked");
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    NSLog(@"%@",viewController.title);
    
    if ([viewController.title isEqual:@"进行中"]) {
       
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers{
    NSLog(@"will Customize");
}

-(void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    if (changed) {
        NSLog(@"changed!");
    }else{
        NSLog(@"not changed");
    }
    for (UIViewController *vcs in viewControllers) {
        NSLog(@"%@",vcs.title);
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController DidEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    
}


@end
