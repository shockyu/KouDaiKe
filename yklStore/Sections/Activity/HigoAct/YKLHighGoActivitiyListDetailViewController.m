//
//  YKLHighGoActivitiyListDetailViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/3.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivitiyListDetailViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLHighGoActivityUserListViewController.h"
#import "YKLEwmPosterViewController.h"
#import "YKLHighGoOrderListViewController.h"

@interface YKLHighGoActivitiyListDetailViewController ()<YKLHighGoActivityListDetailTableViewDelegate>

@property (nonatomic, strong) NSString *coverImageURL;
@property (nonatomic, strong) NSString *bannerURL;

@end

@implementation YKLHighGoActivitiyListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
//    [self createView];
    self.actGoodsArr = [NSMutableArray array];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingHighGo getActListWithActID:self.detailModel.activityID Success:^(NSDictionary *dict) {

        self.actGoodsArr = [dict objectForKey:@"goods"];
        self.actTitleNameLabel.text =[dict objectForKey:@"title"];
        self.actDesctextView.text = [dict objectForKey:@"desc"];
        
        //转换回"\n"
        self.actDesctextView.text =[self.actDesctextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        self.securityShowLabel.text = [dict objectForKey:@"reward_code"];
        
        if ([[dict objectForKey:@"join_num"]isEqual:[NSNull null]]||[[dict objectForKey:@"join_num"]isEqual:@""]) {
            self.successNubLabel.text = @"0";
        }else{
            self.successNubLabel.text = [dict objectForKey:@"join_num"];
        }
        
        self.exposureNubLabel.text = [dict objectForKey:@"exposure_num"];
        self.successGoodsNumLabel.text = [NSString stringWithFormat:@"%@个",[dict objectForKey:@"success_num"]];
      
        NSString *str=[dict objectForKey:@"end_time"];//时间戳
        self.endTimeShowLabel.text = [str timeNumber];
        
        
        NSArray *imageArr = [self.actGoodsArr[0] objectForKey:@"goods_img"];
        if (![imageArr isEqual: @[]]) {
            
            self.coverImageURL = imageArr[0];
        }
        self.bannerURL = [dict objectForKey:@"banner"];

        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSError *error) {
    
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
}

- (void)createView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 680);//+50+10
    [self.view addSubview:self.scrollView];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 360)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView];
    
    self.actTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    //    self.actTitleLabel.backgroundColor = [UIColor redColor];
    self.actTitleLabel.font = [UIFont systemFontOfSize:14];
    self.actTitleLabel.textColor = [UIColor blackColor];
    self.actTitleLabel.text = @"活动名:";
    [self.bgView addSubview:self.actTitleLabel];
    
    self.actTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actTitleLabel.right, 0, self.view.width-self.actTitleLabel.right-20, 40)];
    //    self.actTitleNameLabel.backgroundColor = [UIColor redColor];
    self.actTitleNameLabel.font = [UIFont systemFontOfSize:14];
    self.actTitleNameLabel.textColor = [UIColor grayColor];
//    self.actTitleNameLabel.text = @"XXXXXXXXXXXXXXXXX";
    [self.bgView addSubview:self.actTitleNameLabel];
    
    self.actDesctextView = [[UITextView alloc] initWithFrame:CGRectMake(10, self.actTitleLabel.bottom, self.view.width-20, 100)];
    self.actDesctextView.keyboardType = UIKeyboardTypeDefault;
    self.actDesctextView.backgroundColor = [UIColor clearColor];
    self.actDesctextView.textColor = [UIColor grayColor];
    self.actDesctextView.font = [UIFont systemFontOfSize:11];
    self.actDesctextView.returnKeyType = UIReturnKeyNext;
//    self.actDesctextView.text = @"活动规则：\n1.参与活动，输入手机号码，即可邀请好友帮忙；\n2.活动页面产品图片及信息仅供参照，产品以实物为准；\n3.参与活动成功后，会收到短信提醒，请在兑奖期内到本店兑换活动产品；活动未成功，也可以凭您的最终价格到本店购买。\n4.兑奖只以活动兑奖页面为准，截图或短信均为无效。\n5.活动期间奖品数量有限，先到先得，发完为止；\n6.活动开始后本声明将自动生效并表明参加者已接受；\n7.本活动最终解释权归钉子科技所有。";
    self.actDesctextView.editable = NO;
    [self.bgView addSubview:self.actDesctextView];
    
    //字符串宽度
    float bgWidth = (self.view.width-40)/3;
    
    self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.actDesctextView.bottom+5,bgWidth,20)];
    self.successNubLabel.centerX = self.view.width/4;
    self.successNubLabel.textAlignment = NSTextAlignmentCenter;
    self.successNubLabel.text = @"0";
    self.successNubLabel.textColor = [UIColor flatLightRedColor];
    self.successNubLabel.font = [UIFont systemFontOfSize:14];
//    self.successNubLabel.backgroundColor = [UIColor blueColor];
    [self.bgView addSubview:self.successNubLabel];
    
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.left,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.text = @"参与人数";
    self.successLabel.textColor = [UIColor lightGrayColor];
    self.successLabel.font = [UIFont systemFontOfSize:12];
    //            self.successLabel.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:self.successLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.bgView.width/2, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:lineView];
    
    self.exposureNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right+10,self.successNubLabel.top,bgWidth,self.successNubLabel.height)];
    self.exposureNubLabel.centerX = self.view.width/4*3;
    self.exposureNubLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureNubLabel.text = @"0";
    self.exposureNubLabel.textColor = [UIColor flatLightRedColor];
    self.exposureNubLabel.font = [UIFont systemFontOfSize:14];
//    self.exposureNubLabel.backgroundColor = [UIColor blueColor];
    [self.bgView addSubview:self.exposureNubLabel];
    
    self.exposureLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.exposureNubLabel.left,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.exposureLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureLabel.text = @"访问量";
    self.exposureLabel.textColor = [UIColor lightGrayColor];
    self.exposureLabel.font = [UIFont systemFontOfSize:12];
    //           self.exposureLabel.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:self.exposureLabel];
    
    self.actTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.successLabel.bottom, 100, 40)];
//    self.actTypeLabel.backgroundColor = [UIColor redColor];
    self.actTypeLabel.font = [UIFont systemFontOfSize:14];
    self.actTypeLabel.textColor = [UIColor blackColor];
    self.actTypeLabel.text = @"活动类型:";
    [self.bgView addSubview:self.actTypeLabel];
    
    self.actTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actTypeLabel.right, self.successLabel.bottom, 100, 40)];
    self.actTypeNameLabel.textAlignment = NSTextAlignmentRight;
//     self.actTypeNameLabel.backgroundColor = [UIColor redColor];
    self.actTypeNameLabel.font = [UIFont systemFontOfSize:14];
    self.actTypeNameLabel.textColor = [UIColor flatLightRedColor];
    self.actTypeNameLabel.text = @"一元抽奖";
    [self.bgView addSubview:self.actTypeNameLabel];
    
    self.successGoodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.actTypeLabel.bottom, 100, 40)];
//    self.successGoodsLabel.backgroundColor = [UIColor redColor];
    self.successGoodsLabel.font = [UIFont systemFontOfSize:14];
    self.successGoodsLabel.textColor = [UIColor blackColor];
    self.successGoodsLabel.text = @"成功产品数:";
    [self.bgView addSubview:self.successGoodsLabel];
    
    self.successGoodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.successGoodsLabel.right, self.actTypeLabel.bottom, 100, 40)];
    self.successGoodsNumLabel.textAlignment = NSTextAlignmentRight;
//    self.successGoodsNumLabel.backgroundColor = [UIColor redColor];
    self.successGoodsNumLabel.font = [UIFont systemFontOfSize:14];
    self.successGoodsNumLabel.textColor = [UIColor flatLightRedColor];
//    self.successGoodsNumLabel.text = @"X个";
    [self.bgView addSubview:self.successGoodsNumLabel];
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.successGoodsLabel.bottom, 100, 40)];
    //    self.successGoodsLabel.backgroundColor = [UIColor redColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textColor = [UIColor blackColor];
    self.endTimeLabel.text = @"活动截止时间:";
    [self.bgView addSubview:self.endTimeLabel];
    
    self.endTimeShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.endTimeLabel.right, self.successGoodsLabel.bottom, 100, 40)];
    self.endTimeShowLabel.textAlignment = NSTextAlignmentRight;
    //   self.endTimeShowLabel.backgroundColor = [UIColor redColor];
    self.endTimeShowLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeShowLabel.textColor = [UIColor grayColor];
//    self.endTimeShowLabel.text = @"2015-12-03";
    [self.bgView addSubview:self.endTimeShowLabel];
    
    self.securityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.endTimeLabel.bottom+10, 100, 20)];
    self.securityLabel.font = [UIFont systemFontOfSize:14];
    self.securityLabel.text = @"现场兑奖码：";
    [self.bgView addSubview:self.securityLabel];
    
    self.securityShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.securityLabel.right, self.securityLabel.top, 100, 20)];
    self.securityShowLabel.textAlignment = NSTextAlignmentRight;
    self.securityShowLabel.font = [UIFont systemFontOfSize:14];
//    self.securityShowLabel.text = @"0000";
    self.securityShowLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:self.securityShowLabel];

    
    YKLHighGoActivityListDetailTableView *listView = [[YKLHighGoActivityListDetailTableView alloc] initWithFrame:CGRectMake(0, self.bgView.bottom, self.view.width, 320-50)ActID:self.detailModel.activityID] ;
    listView.delegate = self;
    [self.scrollView addSubview:listView];
    
//    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [listButton setTitle:@"活动订单" forState:UIControlStateNormal];
//    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [listButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
//    listButton.backgroundColor = [UIColor flatLightBlueColor];
//    listButton.frame = CGRectMake(10,listView.bottom+10,self.view.width-20,40);
//    [listButton addTarget:self action:@selector(listButtonBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    listButton.layer.cornerRadius = 10;
//    listButton.layer.masksToBounds = YES;
//    [self.scrollView addSubview: listButton];
    
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

- (void)listButtonBtnClicked{
    NSLog(@"活动订单");
    
    YKLHighGoOrderListViewController *VC = [YKLHighGoOrderListViewController new];
    VC.orderID = self.detailModel.activityID;
    VC.orderName = @"活动订单";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)shareBtnClick:(id)sender{
    NSLog(@"分享到微信");
    
    YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
    VC.hidenBar = NO;
    VC.shareTitle = self.detailModel.title;
    VC.shareDesc = self.detailModel.shareDesc;
    VC.shareImg = self.detailModel.shareImage;
    VC.shareURL = self.detailModel.shareUrl;
    VC.actType = @"一元抽奖";
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)ewmBtnClick:(id)sender{
    NSLog(@"活动二维码");
    
    
    YKLEwmPosterViewController *postPreview = [YKLEwmPosterViewController new];
    
    postPreview.type = 2;
    
    [postPreview createBgView];
    
    postPreview.ewmImageView.image = [QRCodeGenerator qrImageForString:self.detailModel.shareUrl imageSize:150];
    
    if (![self.bannerURL isEqual:[NSNull null]]) {
        
         [postPreview.tempImage sd_setImageWithURL:[NSURL URLWithString:self.bannerURL] placeholderImage:[UIImage imageNamed:@"Demo"]];
    }
    [postPreview.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.coverImageURL] placeholderImage:[UIImage imageNamed:@"Demo"]];
   
    [self presentViewController:postPreview animated:YES completion:^{
        
    }];
    
    
//    self.rechargeAlertView = [[CustomIOSAlertView alloc] init];
//    [self.rechargeAlertView setContainerView:[self createQRView]];
//    [self.rechargeAlertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
//    [self.rechargeAlertView setDelegate:self];
//    
//    [self.rechargeAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//        [alertView close];
//    }];
//    
//    [self.rechargeAlertView setUseMotionEffects:true];
//    [self.rechargeAlertView show];
    
}

//- (UIView *)createQRView
//{
//    self.rechargeAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 270+25)];
//    self.rechargeAlertBgView.backgroundColor = [UIColor whiteColor];
//    self.rechargeAlertBgView.layer.cornerRadius = 7;
//    self.rechargeAlertBgView.layer.masksToBounds = YES;
//    
//    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.closeBtn setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
//    self.closeBtn.frame = CGRectMake(250-30-5,5,25,25);
//    [self.closeBtn addTarget:self action:@selector(closeEwmAlertView) forControlEvents:UIControlEventTouchUpInside];
//    [self.rechargeAlertBgView addSubview: self.closeBtn];
//    
//    self.qRBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.closeBtn.bottom, 250, 213)];
//    //    self.qRBgView.backgroundColor = [UIColor yellowColor];
//    self.qRBgView.layer.cornerRadius = 7;
//    self.qRBgView.layer.masksToBounds = YES;
//    [self.rechargeAlertBgView addSubview:self.qRBgView];
//    
//    self.savaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.savaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [self.savaBtn setTitle:@"保存图片" forState:UIControlStateNormal];
//    [self.savaBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [self.savaBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
//    self.savaBtn.backgroundColor = [UIColor flatLightRedColor];
//    self.savaBtn.layer.cornerRadius = 15;
//    self.savaBtn.layer.masksToBounds = YES;
//    self.savaBtn.frame = CGRectMake(50,self.qRBgView.bottom,150,40);
//    [self.savaBtn addTarget:self action:@selector(savaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rechargeAlertBgView addSubview: self.savaBtn];
//    
//    self.rechargeAlertTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.rechargeAlertBgView.width, 44)];
//    self.rechargeAlertTitleLabel.centerX = self.rechargeAlertBgView.width/2;
//    self.rechargeAlertTitleLabel.font = [UIFont systemFontOfSize: 14.0];
//    //    self.rechargeAlertTitleLabel.backgroundColor = [UIColor redColor];
//    self.rechargeAlertTitleLabel.textColor = [UIColor grayColor];
//    self.rechargeAlertTitleLabel.text = [NSString stringWithFormat:@"商品名称:%@",self.detailModel.title];
//    self.rechargeAlertTitleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.qRBgView addSubview:self.rechargeAlertTitleLabel];
//    
//    self.qRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.rechargeAlertTitleLabel.bottom, 150, 150)];
//    //    self.qRImageView.backgroundColor = [UIColor blueColor];
//    self.qRImageView.image = [QRCodeGenerator qrImageForString:self.detailModel.shareUrl imageSize:self.qRImageView.bounds.size.width];
//    [self.qRBgView addSubview:self.qRImageView];
//    
//    return self.rechargeAlertBgView;
//}

//- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
//{
//    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
//    if (buttonIndex==1) {
//        NSLog(@"oooo");
//    }
//    [alertView close];
//}

//- (void)savaBtnClick:(id)sender{
//    
//    UIGraphicsBeginImageContextWithOptions(self.qRBgView.frame.size, NO, 0.0);
//    [self.qRBgView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
//    
//    [UIAlertView showInfoMsg:@"存储照片成功"];
//    
//    [self closeEwmAlertView];
//}

//- (void)closeEwmAlertView{
//    
//    [self customIOS7dialogButtonTouchUpInside:self.rechargeAlertView clickedButtonAtIndex:1];
//    
//}

- (void)showUserListDetailView:(YKLHighGoActivityListDetailTableView *)listView didSelectOrder:(NSString *)goodID{
    NSLog(@"%@",goodID);
    
    YKLHighGoActivityUserListViewController *VC = [YKLHighGoActivityUserListViewController new];
    VC.goodID = goodID;
    [self.navigationController pushViewController:VC animated:YES];
    
}

@end
