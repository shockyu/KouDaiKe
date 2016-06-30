//
//  YKLVipPayIntroViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/22.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLVipPayIntroViewController.h"

@interface YKLVipPayIntroViewController ()

@property (nonatomic, strong) UIView *bgView1;                  //充值背景
@property (nonatomic, strong) UIView *bgView2;                  //介绍背景
@property (nonatomic, strong) UIImageView *diamondImage;        //黄钻图片
@property (nonatomic, strong) UILabel *diamondTitle;            //黄钻标题
@property (nonatomic, strong) UILabel *diamondIntro;            //黄钻介绍
@property (nonatomic, strong) UIButton *diamondPayButton;       //黄钻购买

@property (nonatomic, strong) UIImageView *vipIntroImage;       //会员介绍图标
@property (nonatomic, strong) UILabel *vipIntroTitle;           //会员介绍
@property (nonatomic, strong) UIImageView *gouImage;            //勾

@end

@implementation YKLVipPayIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"会员充值中心";
    
    [self createBgView];
    [self createContent];
    
    if ([[YKLLocalUserDefInfo defModel].isVip isEqual:@"1"]) {
        self.diamondPayButton.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip已开通"]];
        imageView.frame = CGRectMake(self.diamondPayButton.left, 0, 37, 42);
        imageView.centerY = self.bgView1.height/2;
        [self.bgView1 addSubview:imageView];
    }
    
}

- (void)createBgView{
    
    UIImageView *topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_banner"]];
    topImageView.frame = CGRectMake(0, 64+10, self.view.width, self.view.width/2);
    [self.view addSubview:topImageView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, topImageView.bottom+5, self.view.width, 53)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView1];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+5, self.view.width, 180+18+10)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView2];
    
}

- (void)createContent{

    self.diamondImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"黄钻2"]];
    self.diamondImage.frame = CGRectMake(0, 0, 53, 53);
    [self.bgView1 addSubview:self.diamondImage];
    
    self.diamondTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.diamondImage.right, 10, 70, 20)];
//    self.diamondTitle.backgroundColor = [UIColor yellowColor];
    self.diamondTitle.font = [UIFont systemFontOfSize:17];
    self.diamondTitle.text = @"黄钻会员";
    [self.bgView1 addSubview:self.diamondTitle];
    
    self.diamondIntro = [[UILabel alloc]initWithFrame:CGRectMake(self.diamondTitle.right, 0, 115, 10)];
    self.diamondIntro.bottom = self.diamondTitle.bottom-2;
//    self.diamondIntro.backgroundColor = [UIColor greenColor];
    self.diamondIntro.textColor = [UIColor flatLightRedColor];
    self.diamondIntro.font = [UIFont systemFontOfSize:9];
    self.diamondIntro.text = @"90%的老板都已经开通黄钻";
    [self.bgView1 addSubview:self.diamondIntro];
    
    self.diamondPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.diamondPayButton.frame = CGRectMake(self.diamondIntro.right+10, self.diamondTitle.top, 60, 30);
    self.diamondPayButton.backgroundColor = [UIColor flatLightGreenColor];
    [self.diamondPayButton setTitle:@"开通" forState:UIControlStateNormal];
    [self.diamondPayButton addTarget:self action:@selector(diamondPayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.diamondPayButton.layer.cornerRadius = 10;
    self.diamondPayButton.layer.masksToBounds = YES;
    self.diamondPayButton.hidden = self.hidePay;
    [self.bgView1 addSubview:self.diamondPayButton];
    
    
    self.diamondIntro = [[UILabel alloc]initWithFrame:CGRectMake(self.diamondTitle.left, self.diamondTitle.bottom, 115, 15)];
//    self.diamondIntro.backgroundColor = [UIColor greenColor];
    self.diamondIntro.textColor = [UIColor lightGrayColor];
    self.diamondIntro.font = [UIFont systemFontOfSize:12];
    self.diamondIntro.text = @"全年模板无限次使用";
    [self.bgView1 addSubview:self.diamondIntro];
    
  
    self.diamondTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 95, 20)];
    //    self.diamondTitle.backgroundColor = [UIColor yellowColor];
    self.diamondTitle.font = [UIFont systemFontOfSize:15];
    self.diamondTitle.text = @"黄钻会员权益";
    [self.bgView2 addSubview:self.diamondTitle];
    
    
    self.vipIntroImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"模板免费"]];
    self.vipIntroImage.frame = CGRectMake(20, self.diamondTitle.bottom+10, 13, 20);
    [self.bgView2 addSubview:self.vipIntroImage];
    
    self.vipIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.vipIntroImage.right+5, 0, 100, 15)];
    self.vipIntroTitle.centerY = self.vipIntroImage.centerY;
    self.vipIntroTitle.font = [UIFont systemFontOfSize:12];
    self.vipIntroTitle.text = @"模板费用全免";
    [self.bgView2 addSubview:self.vipIntroTitle];
    
    self.gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"勾"]];
    self.gouImage.frame = CGRectMake(self.diamondPayButton.left, 0, 17, 18);
    self.gouImage.centerY = self.vipIntroImage.centerY;
    [self.bgView2 addSubview:self.gouImage];
    
    self.vipIntroImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"活动发布"]];
    self.vipIntroImage.frame = CGRectMake(15, self.diamondTitle.bottom+10+20+10, 18, 18);
    [self.bgView2 addSubview:self.vipIntroImage];
    
    self.vipIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.vipIntroImage.right+5, 0, 100, 15)];
    self.vipIntroTitle.centerY = self.vipIntroImage.centerY;
    self.vipIntroTitle.font = [UIFont systemFontOfSize:12];
    self.vipIntroTitle.text = @"活动发布全免";
    [self.bgView2 addSubview:self.vipIntroTitle];
    
    self.gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"勾"]];
    self.gouImage.frame = CGRectMake(self.diamondPayButton.left, 0, 17, 18);
    self.gouImage.centerY = self.vipIntroImage.centerY;
    [self.bgView2 addSubview:self.gouImage];
    
    self.vipIntroImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新活动发布"]];
    self.vipIntroImage.frame = CGRectMake(15, self.diamondTitle.bottom+10+20+10+18+10, 18, 18);
    [self.bgView2 addSubview:self.vipIntroImage];
    
    self.vipIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.vipIntroImage.right+5, 0, 100, 15)];
    self.vipIntroTitle.centerY = self.vipIntroImage.centerY;
    self.vipIntroTitle.font = [UIFont systemFontOfSize:12];
    self.vipIntroTitle.text = @"新活动全免";
    [self.bgView2 addSubview:self.vipIntroTitle];
    
    self.gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"勾"]];
    self.gouImage.frame = CGRectMake(self.diamondPayButton.left, 0, 17, 18);
    self.gouImage.centerY = self.vipIntroImage.centerY;
    [self.bgView2 addSubview:self.gouImage];
    
    self.vipIntroImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"评论管理"]];
    self.vipIntroImage.frame = CGRectMake(15, self.diamondTitle.bottom+10+20+10+18+10+18+10, 18, 18);
    [self.bgView2 addSubview:self.vipIntroImage];
    
    self.vipIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.vipIntroImage.right+5, 0, 100, 15)];
    self.vipIntroTitle.centerY = self.vipIntroImage.centerY;
    self.vipIntroTitle.font = [UIFont systemFontOfSize:12];
    self.vipIntroTitle.text = @"评论管理";
    [self.bgView2 addSubview:self.vipIntroTitle];
    
    self.gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"勾"]];
    self.gouImage.frame = CGRectMake(self.diamondPayButton.left, 0, 17, 18);
    self.gouImage.centerY = self.vipIntroImage.centerY;
    [self.bgView2 addSubview:self.gouImage];
    
    self.vipIntroImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"口袋说"]];
    self.vipIntroImage.frame = CGRectMake(15, self.diamondTitle.bottom+10+20+10+18+10+18+10+18+10, 18, 18);
    [self.bgView2 addSubview:self.vipIntroImage];
    
    self.vipIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.vipIntroImage.right+5, 0, 80, 15)];
    self.vipIntroTitle.centerY = self.vipIntroImage.centerY;
    self.vipIntroTitle.font = [UIFont systemFontOfSize:12];
    self.vipIntroTitle.text = @"口袋说免费听";
    [self.bgView2 addSubview:self.vipIntroTitle];
    
    self.gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"勾"]];
    self.gouImage.frame = CGRectMake(self.diamondPayButton.left, 0, 17, 18);
    self.gouImage.centerY = self.vipIntroImage.centerY;
    [self.bgView2 addSubview:self.gouImage];
    
    self.vipIntroImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"子账号"]];
    self.vipIntroImage.frame = CGRectMake(15, self.diamondTitle.bottom+10+20+10+18+10+18+10+18+10+18+10, 18, 18);
    [self.bgView2 addSubview:self.vipIntroImage];
    
    self.vipIntroTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.vipIntroImage.right+5, 0, 80, 15)];
    self.vipIntroTitle.centerY = self.vipIntroImage.centerY;
    self.vipIntroTitle.font = [UIFont systemFontOfSize:12];
    self.vipIntroTitle.text = @"添加子账号";
    [self.bgView2 addSubview:self.vipIntroTitle];
    
    self.gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"勾"]];
    self.gouImage.frame = CGRectMake(self.diamondPayButton.left, 0, 17, 18);
    self.gouImage.centerY = self.vipIntroImage.centerY;
    [self.bgView2 addSubview:self.gouImage];
    
    

}

- (void)diamondPayButtonClicked:(UIButton *)btn{
    NSLog(@"点击购买按钮");
    
    if(btn.selected) return;
    btn.selected=YES;
    [self performSelector:@selector(timeEnough) withObject:nil afterDelay:1.0]; //使用延时进行限制。
    
    //先注册后授权
    if ([[YKLLocalUserDefInfo defModel].status isEqual:@"1"]) {
        
        [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
        [[YKLLocalUserDefInfo defModel]saveToLocalFile];
        YKLPayViewController *vc = [YKLPayViewController new];
        vc.payType = @"vip充值";
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingConsumer getAuthorPriceSuccess:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"NO";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
            YKLPayViewController *vc = [YKLPayViewController new];
            vc.orderStatus = 2;
            vc.authorMoneyNum = [[dict objectForKey:@"author_price"]floatValue];
            vc.authorVIP = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIAlertView showInfoMsg:error.domain];
        }];
    }
}

//延迟支付按钮
- (void)timeEnough
{
    
    self.diamondPayButton.selected=NO;
    
}

    

@end
