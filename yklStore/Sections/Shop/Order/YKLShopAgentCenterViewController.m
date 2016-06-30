//
//  YKLShopAgentCenterViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopAgentCenterViewController.h"

@interface YKLShopAgentCenterViewController ()

@property (nonatomic, strong) UIImageView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;

/** 代理商头像 */
@property (nonatomic, strong) UIImageView *agentAvatar;
/** 代理商名字 */
@property (nonatomic, strong) UILabel *agentName;
/** 代理商电话 */
@property (nonatomic, strong) UIButton *agentTelBtn;
@property (nonatomic, strong) UIWebView *callWebView;
/** 代理商地址 */
@property (nonatomic, strong) UILabel *agentAddress;


@end

@implementation YKLShopAgentCenterViewController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"代理商中心";
        
        [self createBgView];
        [self createContent];
    }
    return self;
}

#pragma mark - 创建背景视图

- (void)createBgView{
    
    self.bgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 215)];
    self.bgView1.image = [UIImage imageNamed:@"fuwushangbaozhang"];
    [self.view addSubview:self.bgView1];
    
    if (ScreenHeight == 480) {
        
        self.bgView1.height = 160;
        
    }
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 90)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView2];
    
    self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+10, self.view.width, 115)];
    self.bgView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView3];
    
}


#pragma mark - 创建视图内容

- (void)createContent{
    
    //bgView2内容
    self.agentAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 65, 65)];
//    self.agentAvatar.backgroundColor = [UIColor greenColor];
    [self.agentAvatar sd_setImageWithURL:[NSURL URLWithString:[YKLLocalUserDefInfo defModel].agentHeaderURL] placeholderImage:[UIImage imageNamed:@"Demo"]];
    self.agentAvatar.layer.cornerRadius = 5;
    self.agentAvatar.layer.masksToBounds = YES;
    [self.bgView2 addSubview:self.agentAvatar];
    
    self.agentName = [[UILabel alloc]initWithFrame:CGRectMake(self.agentAvatar.right+10, self.agentAvatar.top, 220, 30)];
    self.agentName.font = [UIFont systemFontOfSize:14];
    self.agentName.text = [YKLLocalUserDefInfo defModel].agentName;
    [self.bgView2 addSubview:self.agentName];
    
    UILabel *TELLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.agentName.left, self.agentName.bottom, 48, 20)];
    TELLabel.font = [UIFont systemFontOfSize:12];
    TELLabel.textColor = [UIColor lightGrayColor];
    TELLabel.text = @"手机号：";
    [self.bgView2 addSubview:TELLabel];
    
    self.agentTelBtn = [[UIButton alloc]initWithFrame:CGRectMake(TELLabel.right, TELLabel.top, 85, 20)];
    self.agentTelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.agentTelBtn setTitle:[YKLLocalUserDefInfo defModel].mobile forState:UIControlStateNormal];
    [self.agentTelBtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    [self.agentTelBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    [self.agentTelBtn addTarget:self action:@selector(agentTelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview:self.agentTelBtn];
    
    //bgView3内容
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.width, 45)];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.text = @"湖南服务商地址";
    [self.bgView3 addSubview:addressLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(45, addressLabel.bottom, self.view.width-45, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:lineView];
    
    self.agentAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, self.view.width-20, 65)];
    self.agentAddress.textColor = [UIColor lightGrayColor];
    self.agentAddress.font = [UIFont systemFontOfSize:14];
    [self.agentAddress setNumberOfLines:0];
    self.agentAddress.text = [YKLLocalUserDefInfo defModel].agentAddress;
    [self.bgView3 addSubview:self.agentAddress];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

}

//拨打代理商电话
- (void)agentTelBtnClicked{
    
    NSLog(@"%@",self.agentTelBtn.titleLabel.text);
    
    NSURL* callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.agentTelBtn.titleLabel.text]];
    if (self.callWebView == nil) {
        self.callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.callWebView loadRequest:[NSURLRequest requestWithURL:callURL]];
}


@end
