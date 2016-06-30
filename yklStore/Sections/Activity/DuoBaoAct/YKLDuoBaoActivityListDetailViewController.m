//
//  YKLDuoBaoActivityListDetailViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/1.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoActivityListDetailViewController.h"
#import "YKLTogetherShareViewController.h"
//#import "YKLHighGoActivityUserListViewController.h"
//#import "YKLPrizesActivityUserListViewController.h"
#import "YKLDuoBaoActivityUserListViewController.h"
#import "SJAvatarBrowser.h"
#import "YKLDuobaoOrderListViewController.h"
#import "QRCodeGenerator.h"

@interface YKLDuoBaoActivityListDetailViewController ()<CustomIOSAlertViewDelegate>

@end

@implementation YKLDuoBaoActivityListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"活动详情";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingDuoBao readIndianaInfoWithIndianaID:self.detailModel.activityID Success:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",dict);
        self.goodsName.text = [dict objectForKey:@"indiana_title"];
        self.descTextView.text = [dict objectForKey:@"indiana_desc"];
        self.numShowLabel.text = [NSString stringWithFormat:@"%@个",[dict objectForKey:@"award_num"]];
        
        //转换回"\n"
        self.descTextView.text =[self.descTextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"indiana_photo"]] placeholderImage:[UIImage imageNamed:@"Demo"]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
        [self.goodsImageView addGestureRecognizer:singleTap];
        [self.goodsImageView  sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"indiana_photo"]] placeholderImage:[UIImage imageNamed:@"Demo"]];
        
    
        self.endTimeShowLabel.text = [[dict objectForKey:@"end_time"]timeNumber];
        self.securityShowLabel.text = [dict objectForKey:@"reward_code"];
        
        self.successNubLabel.text = [dict objectForKey:@"join_num"];
        self.exposureNubLabel.text = [dict objectForKey:@"exposure_num"];
        self.participantNubLabel.text = [dict objectForKey:@"success_num"];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)createView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 568-64-10+50);
    [self.view addSubview:self.scrollView];
    
    self.goodsNameTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    self.goodsNameTitle.font = [UIFont systemFontOfSize:14];
    self.goodsNameTitle.text = @"产品名";
    [self.scrollView addSubview:self.goodsNameTitle];
    
    self.goodsName = [[UILabel alloc]initWithFrame:CGRectMake(self.goodsNameTitle.right, 5, 220, 20)];
//    self.goodsName.backgroundColor = [UIColor redColor];
    self.goodsName.font = [UIFont systemFontOfSize:14];
    self.goodsName.textColor = [UIColor lightGrayColor];
//    self.goodsName.text = @"xxxxx产品名";
    [self.scrollView addSubview:self.goodsName];
    
    self.goodsImageTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, self.goodsNameTitle.bottom+10, 60, 20)];
    self.goodsImageTitle.font = [UIFont systemFontOfSize:14];
    self.goodsImageTitle.text = @"产品图片";
    [self.scrollView addSubview:self.goodsImageTitle];
    
    self.goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Demo"]];
    self.goodsImageView.userInteractionEnabled = YES;
    self.goodsImageView.frame = CGRectMake(15, self.goodsImageTitle.bottom+10, 50, 50);
    [self.scrollView addSubview:self.goodsImageView];

    self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.goodsImageView.bottom+10, 65, 20)];
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.text = @"活动规则";
    [self.scrollView addSubview:self.descLabel];
    
    self.descTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, self.descLabel.bottom+5, 290, 160)];
    self.descTextView.font = [UIFont systemFontOfSize:14];
    self.descTextView.backgroundColor = [UIColor flatLightWhiteColor];
    self.descTextView.layer.cornerRadius = 5;
    self.descTextView.layer.masksToBounds = YES;
    self.descTextView.editable = NO;
    [self.scrollView addSubview:self.descTextView];
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.descTextView.bottom+10, 100, 20)];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.text = @"产品总数";
    [self.scrollView addSubview:self.numLabel];
    
    self.numShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.numLabel.right, self.numLabel.top, 100, 20)];
    self.numShowLabel.font = [UIFont systemFontOfSize:14];
//    self.numShowLabel.text = @"1个";
    self.numShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.numShowLabel];
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.numLabel.bottom+5, 100, 20)];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.text = @"截止日期";
    [self.scrollView addSubview:self.endTimeLabel];
    
    self.endTimeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, 100, 20)];
    self.endTimeShowLabel.font = [UIFont systemFontOfSize:14];
//    self.endTimeShowLabel.text = @"2016-01-01";
    self.endTimeShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.endTimeShowLabel];
    
    self.securityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.endTimeLabel.bottom+5, 100, 20)];
    self.securityLabel.font = [UIFont systemFontOfSize:14];
    self.securityLabel.text = @"兑奖码";
    [self.scrollView addSubview:self.securityLabel];
    
    self.securityShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.securityLabel.right, self.securityLabel.top, 100, 20)];
    self.securityShowLabel.font = [UIFont systemFontOfSize:14];
//    self.securityShowLabel.text = @"0000";
    self.securityShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.securityShowLabel];
    
    //字符串宽度
    float bgWidth = (self.view.width-40)/3;
    
    self.participantImageView = [[UIImageView alloc]init];
    self.participantImageView.frame = CGRectMake(10, self.securityLabel.bottom+5, bgWidth, 40);
    [self.scrollView addSubview:self.participantImageView];
    
    self.successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.successBtn.backgroundColor = [UIColor redColor];
    self.successBtn.frame = self.participantImageView.frame;
    [self.successBtn addTarget:self action:@selector(successBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.successBtn];
    
    self.successImageView = [[UIImageView alloc]init];
    self.successImageView.frame = CGRectMake(self.participantImageView.right+10, self.participantImageView.top, bgWidth, self.participantImageView.height);
    [self.scrollView addSubview:self.successImageView];
    
    self.participantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.participantBtn.backgroundColor = [UIColor yellowColor];
    self.participantBtn.frame = self.successImageView.frame;
    [self.participantBtn addTarget:self action:@selector(participantBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.participantBtn];
    
    self.exposureImageView = [[UIImageView alloc]init];
    self.exposureImageView.frame = CGRectMake(self.successImageView.right+10,self.participantImageView.top, bgWidth, self.participantImageView.height);
    [self.scrollView addSubview:self.exposureImageView];
    
    self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.successImageView.top,bgWidth,self.participantImageView.height/2)];
    self.successNubLabel.textAlignment = NSTextAlignmentCenter;
    self.successNubLabel.text = @"0";
    self.successNubLabel.textColor = [UIColor flatLightBlueColor];
    self.successNubLabel.font = [UIFont systemFontOfSize:14];
    //            self.successNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.successNubLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.successNubLabel.bottom, self.successNubLabel.width/2, 1)];
    lineView.centerX = self.successNubLabel.centerX;
    lineView.backgroundColor = [UIColor flatLightBlueColor];
    [self.scrollView addSubview:lineView];
    
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.text = @"参与人数";
    self.successLabel.textColor = [UIColor lightGrayColor];
    self.successLabel.font = [UIFont systemFontOfSize:12];
    //            self.successLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.successLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.successLabel.right, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    
    self.participantNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right+10,self.successImageView.top,bgWidth,self.successNubLabel.height)];
    self.participantNubLabel.textAlignment = NSTextAlignmentCenter;
    self.participantNubLabel.text = @"0";
    self.participantNubLabel.textColor = [UIColor flatLightBlueColor];
    self.participantNubLabel.font = [UIFont systemFontOfSize:14];
    //            self.participantNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.participantNubLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.participantNubLabel.bottom, self.participantNubLabel.width/2, 1)];
    lineView.centerX = self.participantNubLabel.centerX;
    lineView.backgroundColor = [UIColor flatLightBlueColor];
    [self.scrollView addSubview:lineView];
    
    self.participantLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right+10,self.participantNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.participantLabel.textAlignment = NSTextAlignmentCenter;
    self.participantLabel.text = @"获奖人数";
    self.participantLabel.textColor = [UIColor lightGrayColor];
    self.participantLabel.font = [UIFont systemFontOfSize:12];
    //            self.participantLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.participantLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.participantLabel.right, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    
    self.exposureNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right+10,self.successImageView.top,bgWidth,self.successNubLabel.height)];
    self.exposureNubLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureNubLabel.text = @"0";
    self.exposureNubLabel.textColor = [UIColor flatLightRedColor];
    self.exposureNubLabel.font = [UIFont systemFontOfSize:14];
    //            self.exposureNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.exposureNubLabel];
    
    self.exposureLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right+10,self.participantNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.exposureLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureLabel.text = @"访问量";
    self.exposureLabel.textColor = [UIColor lightGrayColor];
    self.exposureLabel.font = [UIFont systemFontOfSize:12];
    //           self.exposureLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.exposureLabel];

    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton setTitle:@"活动订单" forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    listButton.backgroundColor = [UIColor flatLightBlueColor];
    listButton.frame = CGRectMake(10,self.exposureLabel.bottom+10,self.view.width-20,40);
    [listButton addTarget:self action:@selector(listButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    listButton.layer.cornerRadius = 10;
    listButton.layer.masksToBounds = YES;
    [self.scrollView addSubview: listButton];
    
    //分享按钮&二维码
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.hidden = NO;
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.shareBtn setTitle:@"分享到微信" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.shareBtn.backgroundColor = [UIColor yellowColor];
    self.shareBtn.frame = CGRectMake(0,self.scrollView.contentSize.height-50,self.view.width/2,50);
    [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.scrollView addSubview: self.shareBtn];
    
    self.ewmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ewmBtn.hidden = NO;
    self.ewmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.ewmBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [self.ewmBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.ewmBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.ewmBtn.backgroundColor = [UIColor flatLightRedColor];
    self.ewmBtn.frame = CGRectMake(self.shareBtn.right,self.scrollView.contentSize.height-50,self.view.width/2,50);
    [self.ewmBtn addTarget:self action:@selector(ewmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: self.ewmBtn];
    
}


- (void)listButtonClicked{
    NSLog(@"点击活动订单");
    
    YKLDuobaoOrderListViewController *VC = [YKLDuobaoOrderListViewController new];
    VC.orderID = self.detailModel.activityID;
    VC.orderName = self.detailModel.title;
    [self.navigationController pushViewController:VC animated:YES];
    
}


- (void)successBtnClicked{
    NSLog(@"参与人数");
    
    YKLDuoBaoActivityUserListViewController *fansListVC = [YKLDuoBaoActivityUserListViewController new];
    fansListVC.goodID = self.detailModel.activityID;
    fansListVC.userType = @"参与人";
    [self.navigationController pushViewController:fansListVC animated:YES];
    
}

- (void)participantBtnClicked{
    NSLog(@"获奖人数");
    
    YKLDuoBaoActivityUserListViewController *fansListVC = [YKLDuoBaoActivityUserListViewController new];
    fansListVC.goodID = self.detailModel.activityID;
    fansListVC.userType = @"获奖人";
    [self.navigationController pushViewController:fansListVC animated:YES];

}

- (void)shareBtnClick:(id)sender{
    NSLog(@"分享到微信");
    
    YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
    VC.hidenBar = NO;
    VC.shareTitle = self.detailModel.title;
    VC.shareDesc = self.detailModel.shareDesc;
    VC.shareImg = self.detailModel.shareImage;
    VC.shareURL = self.detailModel.shareUrl;
    VC.actType = @"口袋夺宝";
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)ewmBtnClick:(id)sender{
    NSLog(@"活动二维码");
    
    self.rechargeAlertView = [[CustomIOSAlertView alloc] init];
    [self.rechargeAlertView setContainerView:[self createQRView]];
    [self.rechargeAlertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [self.rechargeAlertView setDelegate:self];
    
    [self.rechargeAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [self.rechargeAlertView setUseMotionEffects:true];
    [self.rechargeAlertView show];
    
}
- (UIView *)createQRView
{
    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 270+25)];
    self.rechargeAlertBgView.backgroundColor = [UIColor whiteColor];
    self.rechargeAlertBgView.layer.cornerRadius = 7;
    self.rechargeAlertBgView.layer.masksToBounds = YES;
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
    self.closeBtn.frame = CGRectMake(250-30-5,5,25,25);
    [self.closeBtn addTarget:self action:@selector(closeEwmAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.closeBtn];
    
    self.qRBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.closeBtn.bottom, 250, 213)];
    //    self.qRBgView.backgroundColor = [UIColor yellowColor];
    self.qRBgView.layer.cornerRadius = 7;
    self.qRBgView.layer.masksToBounds = YES;
    [self.rechargeAlertBgView addSubview:self.qRBgView];
    
    self.savaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.savaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.savaBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [self.savaBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.savaBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.savaBtn.backgroundColor = [UIColor flatLightRedColor];
    self.savaBtn.layer.cornerRadius = 15;
    self.savaBtn.layer.masksToBounds = YES;
    self.savaBtn.frame = CGRectMake(50,self.qRBgView.bottom,150,40);
    [self.savaBtn addTarget:self action:@selector(savaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rechargeAlertBgView addSubview: self.savaBtn];
    
    self.rechargeAlertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.rechargeAlertBgView.width, 44)];
    self.rechargeAlertTitleLabel.centerX = self.rechargeAlertBgView.width/2;
    self.rechargeAlertTitleLabel.font = [UIFont systemFontOfSize: 14.0];
    //    self.rechargeAlertTitleLabel.backgroundColor = [UIColor redColor];
    self.rechargeAlertTitleLabel.textColor = [UIColor grayColor];
    self.rechargeAlertTitleLabel.text = [NSString stringWithFormat:@"商品名称:%@",self.detailModel.title];
    self.rechargeAlertTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.qRBgView addSubview:self.rechargeAlertTitleLabel];
    
    self.qRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.rechargeAlertTitleLabel.bottom, 150, 150)];
    //    self.qRImageView.backgroundColor = [UIColor blueColor];
    self.qRImageView.image = [QRCodeGenerator qrImageForString:self.detailModel.shareUrl imageSize:self.qRImageView.bounds.size.width];
    [self.qRBgView addSubview:self.qRImageView];
    
    return self.rechargeAlertBgView;
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (buttonIndex==1) {
        NSLog(@"oooo");
    }
    [alertView close];
}

- (void)savaBtnClick:(id)sender{
    
    UIGraphicsBeginImageContextWithOptions(self.qRBgView.frame.size, NO, 0.0);
    [self.qRBgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    [UIAlertView showInfoMsg:@"存储照片成功"];
    
    [self closeEwmAlertView];
}

- (void)closeEwmAlertView{
    
    [self customIOS7dialogButtonTouchUpInside:self.rechargeAlertView clickedButtonAtIndex:1];
    
}

@end
