//
//  YKLShopOrderCenterViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopOrderCenterViewController.h"
#import "YKLShopAgentCenterViewController.h"
#import "YKLShopOrderManagerViewController.h"
#import "YKLShopAddressManageViewController.h"
#import "YKLShopPayViewController.h"
#import "YKLWebViewController.h"

@interface YKLShopOrderCenterViewController ()

@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;

@property (nonatomic, strong) UIButton *DFKBtn;
@property (nonatomic, strong) UIButton *DSHBtn;
@property (nonatomic, strong) UIButton *YWCBtn;
@property (nonatomic, strong) UIButton *TKBtn;

@property (nonatomic, strong) UIView *DFKInfoView;
@property (nonatomic, strong) UIView *DSHInfoView;
@property (nonatomic, strong) UIView *TKInfoView;

@property (nonatomic, strong) UILabel *addresseeName;
@property (nonatomic, strong) UILabel *addresseeMobile;
@property (nonatomic, strong) UILabel *address;

@end

@implementation YKLShopOrderCenterViewController

- (instancetype)init{
    if (self = [super init]) {

        self.title = @"订单中心";
        
        [self createBgView];
        [self createOrderContent];
        [self createAdressContent];
        [self createAgentContent];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetWorkingShop getDefaultAddressWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([dict isEqual:@[]]) {
            
            _addresseeName.text = @"暂未设置";
            _addresseeMobile.text = @"暂未设置";
            _address.text = @"暂未设置";
        }
        else
        {
            _addresseeName.text = [dict objectForKey:@"consignee_name"];
            _addresseeMobile.text =[dict objectForKey:@"consignee_mobile"];
            _address.text = [NSString stringWithFormat:@"%@%@%@%@",[dict objectForKey:@"province"],[dict objectForKey:@"city"],[dict objectForKey:@"area"],[dict objectForKey:@"address"]];
        }

        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
    [YKLNetWorkingShop getorderCenterNumWithShopID:@"29" Success:^(NSDictionary *dict) {
        
        NSLog(@"%@",dict);
        
        //待支付
        if (![dict[@"dsh_num"] isEqual:@"0"])
        {
            _DSHInfoView.hidden = NO;
        }
        else
        {
            _DSHInfoView.hidden = YES;
        }
        
        //待付款
        if (![dict[@"wzf_num"] isEqual:@"0"])
        {
            _DFKInfoView.hidden = NO;
        }
        else
        {
            _DFKInfoView.hidden = YES;
        }
        
        //退款
        if (![dict[@"tk_num"] isEqual:@"0"])
        {
            _TKInfoView.hidden = NO;
        }
        else
        {
            _TKInfoView.hidden = YES;
        }
        
        
    } failure:^(NSError *error) {
        
    }];

}



#pragma mark - 创建背景视图

- (void)createBgView{
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, self.view.width, 115)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView1];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = self.bgView1.frame;
    orderBtn.height = 45;
    orderBtn.backgroundColor = [UIColor clearColor];
    orderBtn.tag = 6000;
    [orderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 130)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView2];
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = self.bgView2.frame;
    addressBtn.backgroundColor = [UIColor clearColor];
    [addressBtn addTarget:self action:@selector(addressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressBtn];

    self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+10, self.view.width, 45)];
    self.bgView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView3];
    
    UIButton *agentCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agentCenterBtn.frame = self.bgView3.frame;
    agentCenterBtn.backgroundColor = [UIColor clearColor];
    [agentCenterBtn addTarget:self action:@selector(agentCenterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agentCenterBtn];

}


#pragma mark - 创建视图 内容

- (void)createOrderContent{
    
    //全部订单
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 9, 27, 27)];
    iconImg.image = [UIImage imageNamed:@"dingdanzhongxin_quanbudingdan"];
    [self.bgView1 addSubview:iconImg];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+12,15,70,15)];
    titleName.font = [UIFont systemFontOfSize:16];
    titleName.text = @"全部订单";
    [self.bgView1 addSubview:titleName];
    
    UILabel *detailTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-30-90,15,90,15)];
    detailTitle.textAlignment = NSTextAlignmentRight;
    detailTitle.textColor = [UIColor lightGrayColor];
    detailTitle.font = [UIFont systemFontOfSize:14];
    detailTitle.text = @"查看全部订单";
    [self.bgView1 addSubview:detailTitle];
    
    UIImageView *arrowsIcon = [[UIImageView alloc]initWithFrame:CGRectMake(detailTitle.right+9, 15, 10, 15)];
    arrowsIcon.image = [UIImage imageNamed:@"dingdanzhongxin_jiantou"];
    [self.bgView1 addSubview:arrowsIcon];
    
    //待付款
    _DFKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _DFKBtn.frame = CGRectMake(0, lineView.bottom, self.view.width/4, 70);
    _DFKBtn.backgroundColor = [UIColor clearColor];
    _DFKBtn.tag = 6001;
    [_DFKBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView1 addSubview:_DFKBtn];
    
    UIImageView *DFKIcon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 15, 22, 22)];
    DFKIcon.image = [UIImage imageNamed:@"dingdanzhongxin_daifukuan"];
    [_DFKBtn addSubview:DFKIcon];
    
    UILabel *DFKLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, DFKIcon.bottom, _DFKBtn.width, 32)];
    DFKLabel.textAlignment = NSTextAlignmentCenter;
    DFKLabel.textColor = [UIColor lightGrayColor];
    DFKLabel.font = [UIFont systemFontOfSize:13];
    DFKLabel.text = @"待付款";
    [_DFKBtn addSubview:DFKLabel];
    
    _DFKInfoView = [[UIView alloc]initWithFrame:CGRectMake(_DFKBtn.width-20, 10, 8, 8)];
    _DFKInfoView.backgroundColor = [UIColor flatLightRedColor];
    _DFKInfoView.layer.cornerRadius = 4;
    _DFKInfoView.layer.masksToBounds = YES;
    _DFKInfoView.hidden = YES;
    [_DFKBtn addSubview:_DFKInfoView];

    //待收货
    _DSHBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _DSHBtn.frame = CGRectMake(_DFKBtn.right, lineView.bottom, self.view.width/4,70);
    _DSHBtn.backgroundColor = [UIColor clearColor];
    _DSHBtn.tag = 6002;
    [_DSHBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView1 addSubview:_DSHBtn];
    
    UIImageView *DSHIcon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 15, 22, 22)];
    DSHIcon.image = [UIImage imageNamed:@"dingdanzhongxin_daishouhuo"];
    [_DSHBtn addSubview:DSHIcon];
    
    UILabel *DSHLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, DSHIcon.bottom, _DSHBtn.width, 32)];
    DSHLabel.textAlignment = NSTextAlignmentCenter;
    DSHLabel.textColor = [UIColor lightGrayColor];
    DSHLabel.font = [UIFont systemFontOfSize:13];
    DSHLabel.text = @"待收货";
    [_DSHBtn addSubview:DSHLabel];
    
    _DSHInfoView = [[UIView alloc]initWithFrame:CGRectMake(_DSHBtn.width-20, 10, 8, 8)];
    _DSHInfoView.backgroundColor = [UIColor flatLightRedColor];
    _DSHInfoView.layer.cornerRadius = 4;
    _DSHInfoView.layer.masksToBounds = YES;
    _DSHInfoView.hidden = YES;
    [_DSHBtn addSubview:_DSHInfoView];

    
    //已完成
    _YWCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _YWCBtn.frame = CGRectMake(_DSHBtn.right, lineView.bottom, self.view.width/4,70);
    _YWCBtn.backgroundColor = [UIColor clearColor];
    _YWCBtn.tag = 6003;
    [_YWCBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView1 addSubview:_YWCBtn];
    
    UIImageView *YWCIcon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 15, 22, 22)];
    YWCIcon.image = [UIImage imageNamed:@"dingdanzhongxin_yiwancheng"];
    [_YWCBtn addSubview:YWCIcon];
    
    UILabel *YWCLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, YWCIcon.bottom, _YWCBtn.width, 32)];
    YWCLabel.textAlignment = NSTextAlignmentCenter;
    YWCLabel.textColor = [UIColor lightGrayColor];
    YWCLabel.font = [UIFont systemFontOfSize:13];
    YWCLabel.text = @"已完成";
    [_YWCBtn addSubview:YWCLabel];
    
    //退款
    _TKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _TKBtn.frame = CGRectMake(_YWCBtn.right, lineView.bottom, self.view.width/4,70);
    _TKBtn.backgroundColor = [UIColor clearColor];
    _TKBtn.tag = 6004;
    [_TKBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView1 addSubview:_TKBtn];

    UIImageView *TKIcon = [[UIImageView alloc]initWithFrame:CGRectMake(28, 15, 22, 22)];
    TKIcon.image = [UIImage imageNamed:@"dingdanzhongxin_tuikuan"];
    [_TKBtn addSubview:TKIcon];
    
    UILabel *TKLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TKIcon.bottom, _TKBtn.width, 32)];
    TKLabel.textAlignment = NSTextAlignmentCenter;
    TKLabel.textColor = [UIColor lightGrayColor];
    TKLabel.font = [UIFont systemFontOfSize:13];
    TKLabel.text = @"退款/售后";
    [_TKBtn addSubview:TKLabel];
    
    _TKInfoView = [[UIView alloc]initWithFrame:CGRectMake(_TKBtn.width-20, 10, 8, 8)];
    _TKInfoView.backgroundColor = [UIColor flatLightRedColor];
    _TKInfoView.layer.cornerRadius = 4;
    _TKInfoView.layer.masksToBounds = YES;
    _TKInfoView.hidden = YES;
    [_TKBtn addSubview:_TKInfoView];
    
}

//创建地址内容
- (void)createAdressContent{
    
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 9, 27, 27)];
    iconImg.image = [UIImage imageNamed:@"dingdanzhongxin_shouhuodizhi"];
    [self.bgView2 addSubview:iconImg];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+12,15, 100,15)];
    titleName.font = [UIFont systemFontOfSize:16];
    titleName.text = @"管理收获地址";
    [self.bgView2 addSubview:titleName];
    
    UILabel *detailTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-30-90,15,90,15)];
    detailTitle.textAlignment = NSTextAlignmentRight;
    detailTitle.textColor = [UIColor lightGrayColor];
    detailTitle.font = [UIFont systemFontOfSize:14];
    detailTitle.text = @"查看全部地址";
    [self.bgView2 addSubview:detailTitle];
    
    UIImageView *arrowsIcon = [[UIImageView alloc]initWithFrame:CGRectMake(detailTitle.right+9, 15, 10, 15)];
    arrowsIcon.image = [UIImage imageNamed:@"dingdanzhongxin_jiantou"];
    [self.bgView2 addSubview:arrowsIcon];
    
    _addresseeName = [[UILabel alloc]initWithFrame:CGRectMake(12, lineView.bottom, 105, 42)];
//    _addresseeName.backgroundColor = [UIColor redColor];
    _addresseeName.font = [UIFont systemFontOfSize:13];
    _addresseeName.textColor = [UIColor grayColor];
//    _addresseeName.text = @"XXX";
    [self.bgView2 addSubview:_addresseeName];
    
    _addresseeMobile = [[UILabel alloc]initWithFrame:CGRectMake(_addresseeName.right, lineView.bottom, 130, 42)];
//    _addresseeMobile.backgroundColor = [UIColor greenColor];
    _addresseeMobile.font = [UIFont systemFontOfSize:13];
    _addresseeMobile.textColor = [UIColor grayColor];
//    _addresseeMobile.text = @"18887878787";
    [self.bgView2 addSubview:_addresseeMobile];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addresseeMobile.right, lineView.bottom, 55, 42)];
//    statusLabel.backgroundColor = [UIColor lightGrayColor];
    statusLabel.font = [UIFont systemFontOfSize:13];
    statusLabel.textColor = [UIColor flatLightBlueColor];
    statusLabel.text = @"默认地址";
    [self.bgView2 addSubview:statusLabel];
    
    _address = [[UILabel alloc]initWithFrame:CGRectMake(12, _addresseeMobile.bottom, self.view.width-24, 35)];
//    _address.backgroundColor = [UIColor yellowColor];
    _address.font = [UIFont systemFontOfSize:13];
    _address.textColor = [UIColor grayColor];
    [_address setNumberOfLines:0];
//    _address.text = @"湖南省长沙市天心区城南路贺龙体育馆旁摩天一号A座1208钉子科技";
    [self.bgView2 addSubview:_address];
    
}

//创建服务商内容
- (void)createAgentContent{
    
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 9, 27, 27)];
    iconImg.image = [UIImage imageNamed:@"dingdanzhongxin_fuwushang"];
    [self.bgView3 addSubview:iconImg];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:lineView];
    
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+12,15, 130,15)];
    titleName.font = [UIFont systemFontOfSize:16];
    titleName.text = @"当地口袋客服务商";
    [self.bgView3 addSubview:titleName];
    
    UIImageView *arrowsIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30+9, 15, 10, 15)];
    arrowsIcon.image = [UIImage imageNamed:@"dingdanzhongxin_jiantou"];
    [self.bgView3 addSubview:arrowsIcon];

}

#pragma mark - 按钮点击方法

/*
 *查看全部订单
 */
- (void)orderBtnClicked:(UIButton *)sender
{
    YKLShopOrderManagerViewController  *vc = [YKLShopOrderManagerViewController new];
    NSInteger aIndex = 0;
    switch (sender.tag)
    {
        //全部
        case 6000:
            aIndex = 0;
            break;
        //待付款
        case 6001:
            aIndex = 0;
            break;
        //待收货
        case 6002:
            aIndex = 1;
            break;
        //已完成
        case 6003:
            aIndex = 2;
            break;
        //退货
        case 6004:
            aIndex = 3;
            break;
        default:
            break;
    }

    vc.shouldShowIndex = aIndex;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 *查看全部地址
 */
- (void)addressBtnClicked
{
    YKLShopAddressManageViewController *vc = [YKLShopAddressManageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 *查看服务商
 */
- (void)agentCenterBtnClicked
{
    YKLShopAgentCenterViewController *vc = [YKLShopAgentCenterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
