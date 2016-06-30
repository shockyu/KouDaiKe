//
//  YKLShareDetailViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLShareDetailViewController.h"
#import "YKLQRcodeViewController.h"
#import "YKLShareContentModel.h"
#import "YKLShareViewController.h"
#import "YKLAuthorListViewController.h"
#import "YKLTogetherShareViewController.h"

@interface YKLShareDetailViewController ()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *lineView1;
@property (nonatomic,strong) UIView *lineView2;
@property (nonatomic,strong) UIView *lineView3;
@property (nonatomic,strong) UIView *lineView4;

@property (nonatomic,strong) UIImageView *cashImageView;
@property (nonatomic,strong) UIImageView *shopShareImageView;
@property (nonatomic,strong) UIImageView *timeShareImageView;

@property (nonatomic,strong) UILabel *cashLabel;
@property (nonatomic,strong) UILabel *cashNumLabel;
@property (nonatomic,strong) UILabel *smsLabel;
@property (nonatomic,strong) UILabel *smsNumLabel;

@property (nonatomic,strong) UILabel *shopShareLabel;
@property (nonatomic,strong) UILabel *timeShareLabel;
@property (nonatomic,strong) UIImageView *progressImageView;
@property (nonatomic,strong) UILabel *timeDescLabel1;
@property (nonatomic,strong) UILabel *timeDescLabel2;
@property (nonatomic,strong) UILabel *timeDescLabel3;

@property (nonatomic,strong) UILabel *authorized;
@property (nonatomic,strong) UILabel *authorize;

@property (nonatomic,strong) NSString *shareURL;
@end

@implementation YKLShareDetailViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"推荐有奖";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"分享按钮"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareRightItemClicked)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 35, 35);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       
    [self createBgView];
    [self createImage];
    [self createContent];
    
    UIButton *QRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    QRCodeBtn.frame = CGRectMake(20, self.bgView.bottom+10, self.view.width-40, 40);
    QRCodeBtn.backgroundColor = [UIColor flatLightGreenColor];
    [QRCodeBtn setTitle:@"面对面分享二维码" forState:UIControlStateNormal];
    [QRCodeBtn addTarget:self action:@selector(QRCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    QRCodeBtn.layer.cornerRadius = 5;
    QRCodeBtn.layer.masksToBounds = YES;
    [self.view addSubview:QRCodeBtn];
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载页面数据";
   
    [YKLNetworkingConsumer shopRecommendWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLShopRecommendModel *shopModel) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.shareURL = shopModel.URL;
        
        //计算数据
        int authorizationNum = [shopModel.tjAuthorizationNum intValue];
        int total = [shopModel.tjShopTotal intValue];
        int author = [shopModel.tjAuthorizationNum intValue];
        NSString *unAuthor = [NSString stringWithFormat:@"%d",(total- author)];
        
        int more;//还需要几家
        int status;//第几个状态

        if (authorizationNum > 5 || authorizationNum == 5) {
            status = authorizationNum%5;
            more = 5 - status;
            NSLog(@"m%d-s%d",more,status);
        }else{
            status = authorizationNum;
            more = 5 - authorizationNum;
            NSLog(@"m%d-s%d",more,status);
        }
      
        
        switch (status) {
            case 0:
                self.progressImageView.image = [UIImage imageNamed:@"进度条00"];
                break;
            case 1:
                self.progressImageView.image = [UIImage imageNamed:@"进度条01"];
                break;
            case 2:
                self.progressImageView.image = [UIImage imageNamed:@"进度条02"];
                break;
            case 3:
                self.progressImageView.image = [UIImage imageNamed:@"进度条03"];
                break;
            case 4:
                self.progressImageView.image = [UIImage imageNamed:@"进度条04"];
                break;
                
            default:
                break;
        }
        
        self.cashNumLabel.text = shopModel.bonus;
        self.smsNumLabel.text = shopModel.tjSMSNum;
        
        NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共为 %@ 家门店推荐了解口袋客",shopModel.tjShopTotal]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1_1=[[hintString1 string]rangeOfString:@"共为"];
        [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor flatOrangeColor] range:range1_1];
        NSRange range1_2=[[hintString1 string]rangeOfString:@"家门店推荐了解口袋客"];
        [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor flatOrangeColor] range:range1_2];
        self.shopShareLabel.attributedText= hintString1;
        
        NSMutableAttributedString *hintString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"只需要再授权 %d 家，就可以把奖金装进口袋里。",more]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range2_1=[[hintString2 string]rangeOfString:@"只需要再授权"];
        [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_1];
        NSRange range2_2=[[hintString2 string]rangeOfString:@"家，就可以把奖金装进口袋里。"];
        [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_2];
        self.timeShareLabel.attributedText= hintString2;
        
        NSMutableAttributedString *hintString3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已授权： %d",authorizationNum]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range3_1=[[hintString3 string]rangeOfString:@"已授权："];
        [hintString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3_1];
        self.authorized.attributedText = hintString3;
        
        
        NSMutableAttributedString *hintString4=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"未授权： %@",unAuthor]];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range4_1=[[hintString4 string]rangeOfString:@"未授权："];
        [hintString4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range4_1];
        self.authorize.attributedText = hintString4;
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)createBgView{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 285)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    self.lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, 70, self.view.width-20, 1)];
    self.lineView1.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView addSubview:self.lineView1];
    
    self.lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, self.lineView1.bottom+50, self.view.width-20, 1)];
    self.lineView2.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView addSubview:self.lineView2];
    
    self.lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.lineView2.bottom+125, self.view.width, 1)];
    self.lineView3.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView addSubview:self.lineView3];
    
    self.lineView4 = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/2, self.lineView3.bottom+1, 1, 35)];
    self.lineView4.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView addSubview:self.lineView4];
}

- (void)createImage{
    
    self.cashImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cashMoney.png"]];
    self.cashImageView.frame = CGRectMake(20, 20, 25, 30);
    [self.bgView addSubview:self.cashImageView];
    
    self.shopShareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shopShare.png"]];
    self.shopShareImageView.frame = CGRectMake(20, self.lineView1.bottom+15, 25, 20);
    [self.bgView addSubview:self.shopShareImageView];
    
    self.timeShareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeShare.png"]];
    self.timeShareImageView.frame = CGRectMake(20, self.lineView2.bottom+30, 25, 25);
    [self.bgView addSubview:self.timeShareImageView];
}

- (void)createContent{
    self.cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 70, 25)];
    //    self.cashLabel.backgroundColor = [UIColor redColor];
    self.cashLabel.textAlignment = NSTextAlignmentCenter;
    self.cashLabel.textColor = [UIColor flatOrangeColor];
    self.cashLabel.font = [UIFont systemFontOfSize:16];
    self.cashLabel.text = @"现金奖励";
    [self.bgView addSubview:self.cashLabel];
    
    self.cashNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cashLabel.left, self.cashLabel.bottom, 70, 25)];
    //    self.cashNumLabel.backgroundColor = [UIColor redColor];
    self.cashNumLabel.textAlignment = NSTextAlignmentCenter;
    self.cashNumLabel.textColor = [UIColor flatLightGreenColor];
    self.cashNumLabel.font = [UIFont systemFontOfSize:16];
//    self.cashNumLabel.text = @"200";
    [self.bgView addSubview:self.cashNumLabel];
    
    self.smsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.cashLabel.right+70, 10, 70, 25)];
    //    self.smsLabel.backgroundColor = [UIColor redColor];
    self.smsLabel.textAlignment = NSTextAlignmentCenter;
    self.smsLabel.textColor = [UIColor flatOrangeColor];
    self.smsLabel.font = [UIFont systemFontOfSize:16];
    self.smsLabel.text = @"短信奖励";
    [self.bgView addSubview:self.smsLabel];
    
    self.smsNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.smsLabel.left, self.cashLabel.bottom, 70, 25)];
    //    self.smsNumLabel.backgroundColor = [UIColor redColor];
    self.smsNumLabel.textAlignment = NSTextAlignmentCenter;
    self.smsNumLabel.textColor = [UIColor flatLightGreenColor];
    self.smsNumLabel.font = [UIFont systemFontOfSize:16];
//    self.smsNumLabel.text = @"1200";
    [self.bgView addSubview:self.smsNumLabel];
    
    
    self.shopShareLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, self.lineView1.bottom, self.bgView.width-65, 50)];
    self.shopShareLabel.font = [UIFont systemFontOfSize:16];
    //    self.shopShareLabel.textAlignment = NSTextAlignmentCenter;
    self.shopShareLabel.backgroundColor = [UIColor whiteColor];
    self.shopShareLabel.textColor = [UIColor flatLightGreenColor];
    
//    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前共为 %@ 家门店推荐了口袋客",@"16"]];
//    //获取要调整颜色的文字位置,调整颜色
//    NSRange range1_1=[[hintString1 string]rangeOfString:@"当前共为"];
//    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor flatOrangeColor] range:range1_1];
//    NSRange range1_2=[[hintString1 string]rangeOfString:@"家门店推荐了口袋客"];
//    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor flatOrangeColor] range:range1_2];
//    self.shopShareLabel.attributedText= hintString1;
    
    [self.bgView addSubview:self.shopShareLabel];
    
    
    self.timeShareLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, self.lineView2.bottom, self.bgView.width-65, 30)];
    self.timeShareLabel.font = [UIFont systemFontOfSize:11];
    //    self.shopShareLabel.textAlignment = NSTextAlignmentCenter;
    self.timeShareLabel.backgroundColor = [UIColor whiteColor];
    self.timeShareLabel.textColor = [UIColor flatLightGreenColor];
    
//    NSMutableAttributedString *hintString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"只需要再推荐 %@ 家，就可以把奖金装进口袋里。",@"2"]];
//    //获取要调整颜色的文字位置,调整颜色
//    NSRange range2_1=[[hintString2 string]rangeOfString:@"只需要再推荐"];
//    [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_1];
//    NSRange range2_2=[[hintString2 string]rangeOfString:@"家，就可以把奖金装进口袋里。"];
//    [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_2];
//    self.timeShareLabel.attributedText= hintString2;
    
    [self.bgView addSubview:self.timeShareLabel];
    
    
    self.progressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.progressImageView.backgroundColor = [UIColor clearColor];
    self.progressImageView.frame = CGRectMake(self.timeShareLabel.left, self.timeShareLabel.bottom, 225, 30);
    [self.bgView addSubview:self.progressImageView];
    
    UIView *timeView1 = [[UIView alloc]initWithFrame:CGRectMake(self.timeShareLabel.left, self.progressImageView.bottom+10+2+5, 6, 6)];
    timeView1.backgroundColor = [UIColor flatLightGreenColor];
    timeView1.layer.cornerRadius = 3;
    timeView1.layer.masksToBounds = YES;
    [self.bgView addSubview:timeView1];
    
    self.timeDescLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(timeView1.right+5, self.progressImageView.bottom+10+5, self.bgView.width-timeView1.left-5, 10)];
    self.timeDescLabel1.textColor = [UIColor lightGrayColor];
    self.timeDescLabel1.font = [UIFont systemFontOfSize:10];
    self.timeDescLabel1.text = @"每推荐一家门店并开通授权,即可获得200条短信奖励。";
    [self.bgView addSubview:self.timeDescLabel1];
    
    UIView *timeView2 = [[UIView alloc]initWithFrame:CGRectMake(self.timeShareLabel.left, timeView1.bottom+10-1, 6, 6)];
    timeView2.backgroundColor = [UIColor flatLightGreenColor];
    timeView2.layer.cornerRadius = 3;
    timeView2.layer.masksToBounds = YES;
    [self.bgView addSubview:timeView2];

    self.timeDescLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(timeView2.right+5, self.timeDescLabel1.bottom+5, self.timeDescLabel1.width, 10)];
    self.timeDescLabel2.textColor = [UIColor lightGrayColor];
    self.timeDescLabel2.font = [UIFont systemFontOfSize:10];
    self.timeDescLabel2.text = @"每成功授权5家门店,额外奖励200元现金。";
    [self.bgView addSubview:self.timeDescLabel2];
    
    UIView *timeView3 = [[UIView alloc]initWithFrame:CGRectMake(self.timeShareLabel.left, timeView2.bottom+10-1, 6, 6)];
    timeView3.backgroundColor = [UIColor flatLightGreenColor];
    timeView3.layer.cornerRadius = 3;
    timeView3.layer.masksToBounds = YES;
    [self.bgView addSubview:timeView3];
    
    self.timeDescLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(timeView3.right+5, self.timeDescLabel2.bottom+5, self.timeDescLabel1.width, 10)];
    self.timeDescLabel3.textColor = [UIColor lightGrayColor];
    self.timeDescLabel3.font = [UIFont systemFontOfSize:10];
    self.timeDescLabel3.text = @"现金以及短信奖励直接计入到口袋钱包和短信余额。";
    [self.bgView addSubview:self.timeDescLabel3];
    
    self.authorized = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lineView3.bottom, self.bgView.width/2, 35)];
    self.authorized.font = [UIFont systemFontOfSize:14];
    self.authorized.textAlignment = NSTextAlignmentCenter;
    self.authorized.backgroundColor = [UIColor whiteColor];
    self.authorized.textColor = [UIColor flatOrangeColor];
    
//    NSMutableAttributedString *hintString3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已授权： %@",@"6"]];
//    //获取要调整颜色的文字位置,调整颜色
//    NSRange range3_1=[[hintString3 string]rangeOfString:@"已授权："];
//    [hintString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3_1];
//    
//    self.authorized.attributedText= hintString3;
    
    [self.bgView addSubview:self.authorized];
    
    UIButton *authorizedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authorizedBtn.frame = self.authorized.frame;
    [authorizedBtn addTarget:self action:@selector(authorizedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    authorizedBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:authorizedBtn];

    self.authorize = [[UILabel alloc]initWithFrame:CGRectMake(self.lineView4.right, self.lineView3.bottom, self.bgView.width/2, 35)];
    self.authorize.font = [UIFont systemFontOfSize:14];
    self.authorize.textAlignment = NSTextAlignmentCenter;
    self.authorize.backgroundColor = [UIColor whiteColor];
    self.authorize.textColor = [UIColor flatOrangeColor];
    
//    NSMutableAttributedString *hintString4=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"未授权： %@",@"6"]];
//    //获取要调整颜色的文字位置,调整颜色
//    NSRange range4_1=[[hintString4 string]rangeOfString:@"未授权："];
//    [hintString4 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range4_1];
//    
//    self.authorize.attributedText= hintString4;
    
    [self.bgView addSubview:self.authorize];
    
    UIButton *authorizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authorizeBtn.frame = self.authorize.frame;
    [authorizeBtn addTarget:self action:@selector(authorizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    authorizeBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:authorizeBtn];
    
}
- (void)authorizedBtnClicked{
    NSLog(@"1,已授权");
    
    YKLAuthorListViewController *VC = [YKLAuthorListViewController new];
    VC.authorType = @"1";
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)authorizeBtnClicked{
    NSLog(@"2，未授权");
    
    YKLAuthorListViewController *VC = [YKLAuthorListViewController new];
    VC.authorType = @"2";
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)QRCodeBtnClicked:(id)sender{
    YKLQRcodeViewController *vc = [YKLQRcodeViewController new];
    vc.shareURL = self.shareURL;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareRightItemClicked{
    NSLog(@"点击右键分享按钮");
    
    YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
    VC.hidenBar = NO;
    VC.shareTitle = @"推荐您使用口袋客为门店聚客";
    VC.shareDesc = [NSString stringWithFormat:@"我们%@用口袋客给店里带来了不少新客人，你也赶紧注册口袋客为门店聚客推广！",[YKLLocalUserDefInfo defModel].userName];
    VC.shareImg = @"logo";
    VC.shareURL = self.shareURL;
    VC.actType = @"店铺推荐";
    [self.navigationController pushViewController:VC animated:YES];
    
}
@end
