//
//  YKLPrizesActivitiyListDetailViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/15.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPrizesActivitiyListDetailViewController.h"
#import "YKLTogetherShareViewController.h"
//#import "YKLHighGoActivityUserListViewController.h"
#import "YKLPrizesActivityUserListViewController.h"
#import "YKLPrizesOrderListViewController.h"

@interface YKLPrizesActivitiyListDetailViewController ()<CustomIOSAlertViewDelegate>

@end

@implementation YKLPrizesActivitiyListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingPrizes readRedWithRID:self.detailModel.activityID Success:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",dict);
        
        self.descTextView.text = [dict objectForKey:@"desc"];
        //转换回"\n"
        self.descTextView.text =[self.descTextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        self.endTimeShowLabel.text = [[dict objectForKey:@"end_time"]timeNumber];
        self.securityShowLabel.text = [dict objectForKey:@"reward_code"];
        self.exposureNubLabel.text = [dict objectForKey:@"exposure_num"];
        self.successNubLabel.text = [dict objectForKey:@"player_num"];
        
        NSArray *prizesArr = [dict objectForKey:@"prize"];
        NSMutableArray *prizesMutableArr = [NSMutableArray array];
        
        if (![prizesArr isEqual:@[]]&&![prizesArr isEqual:@""]) {
            
            for (int i = 0; i < prizesArr.count; i++) {
                
                NSDictionary *tempDict = [[NSDictionary alloc]initWithDictionary:prizesArr[i]];
                NSString *prizeType = [tempDict objectForKey:@"prize_type"];
                
                if ([prizeType isEqual:@"2"]) {
                    self.flowBgView.hidden = NO;
                    
                    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"总流量：%@ 份",[tempDict objectForKey:@"prize_num"]]];
                    //获取要调整颜色的文字位置,调整颜色
                    NSRange range1_1=[[hintString1 string]rangeOfString:@"总流量："];
                    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1_1];
                    NSRange range1_2=[[hintString1 string]rangeOfString:@"份"];
                    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1_2];
                    self.flowTotleNumLabel.attributedText= hintString1;
                }
                if ([prizeType isEqual:@"1"]) {
                    [prizesMutableArr addObject:tempDict];
                }
            }   
        }
        
        if (![prizesMutableArr isEqual:@[]]) {
            
            for (int i = 0; i < prizesMutableArr.count; i++) {
                self.prizesBgView.hidden = NO;
                
                NSDictionary *tempDict = [[NSDictionary alloc]initWithDictionary:prizesMutableArr[i]];
                if (i == 0) {
                    self.prizesNameLabel1.hidden= NO;
                    self.prizesTotleNumLabel1.hidden= NO;
                    self.prizesWinNumLabel1.hidden= NO;
                    
                    self.prizesNameLabel1.text = [tempDict objectForKey:@"prize_name"];
                    self.prizesTotleNumLabel1.text = [NSString stringWithFormat:@"%@个",[tempDict objectForKey:@"prize_num"]];
                    self.prizesWinNumLabel1.text = [NSString stringWithFormat:@"%@个",[tempDict objectForKey:@"winner_num"]];
                }
                if (i == 1) {
                    self.prizesNameLabel2.hidden= NO;
                    self.prizesTotleNumLabel2.hidden= NO;
                    self.prizesWinNumLabel2.hidden= NO;
                    
                    self.prizesNameLabel2.text = [tempDict objectForKey:@"prize_name"];
                    self.prizesTotleNumLabel2.text = [NSString stringWithFormat:@"%@个",[tempDict objectForKey:@"prize_num"]];
                    self.prizesWinNumLabel2.text = [NSString stringWithFormat:@"%@个",[tempDict objectForKey:@"winner_num"]];
                }
                if (i == 2) {
                    self.prizesNameLabel3.hidden= NO;
                    self.prizesTotleNumLabel3.hidden= NO;
                    self.prizesWinNumLabel3.hidden= NO;
                    
                    self.prizesNameLabel3.text = [tempDict objectForKey:@"prize_name"];
                    self.prizesTotleNumLabel3.text = [NSString stringWithFormat:@"%@个",[tempDict objectForKey:@"prize_num"]];
                    self.prizesWinNumLabel3.text = [NSString stringWithFormat:@"%@个",[tempDict objectForKey:@"winner_num"]];
                    
                }
                
            }
        }
        
        //若奖品隐藏则流量位置上移
        if (self.prizesBgView.hidden) {
            self.flowBgView.top = 10;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)createView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 568-64-10+20);
    [self.view addSubview:self.scrollView];
    
    //奖品红包显示
    self.prizesBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.prizesBgView.backgroundColor = [UIColor clearColor];
    self.prizesBgView.hidden = YES;
    [self.scrollView addSubview:self.prizesBgView];
    
    self.prizesTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 65, 20)];
    self.prizesTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.prizesTitleLabel.text = @"奖品红包";
    [self.prizesBgView addSubview:self.prizesTitleLabel];
    
    self.prizesTotleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTitleLabel.right+60, self.prizesTitleLabel.top, 35, 20)];
    self.prizesTotleNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.prizesTotleNumLabel.text = @"数量";
    [self.prizesBgView addSubview:self.prizesTotleNumLabel];
    
    self.prizesWinNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTotleNumLabel.right+40, self.prizesTitleLabel.top, 65, 20)];
    self.prizesWinNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.prizesWinNumLabel.text = @"中奖人数";
    [self.prizesBgView addSubview:self.prizesWinNumLabel];
    
    //中奖名
    self.prizesNameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTitleLabel.left, self.prizesTitleLabel.bottom+10, 100, 15)];
    self.prizesNameLabel1.textColor = [UIColor lightGrayColor];
    self.prizesNameLabel1.font = [UIFont systemFontOfSize:12];
    self.prizesNameLabel1.text = @"xxxxxxxx奖品1";
    self.prizesNameLabel1.hidden = YES;
    [self.prizesBgView addSubview:self.prizesNameLabel1];
    
    self.prizesNameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTitleLabel.left, self.prizesNameLabel1.bottom, 100, 15)];
    self.prizesNameLabel2.textColor = [UIColor lightGrayColor];
    self.prizesNameLabel2.font = [UIFont systemFontOfSize:12];
    self.prizesNameLabel2.text = @"xxxxxxxx奖品2";
    self.prizesNameLabel2.hidden = YES;
    [self.prizesBgView addSubview:self.prizesNameLabel2];
    
    self.prizesNameLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTitleLabel.left, self.prizesNameLabel2.bottom, 100, 15)];
    self.prizesNameLabel3.textColor = [UIColor lightGrayColor];
    self.prizesNameLabel3.font = [UIFont systemFontOfSize:12];
    self.prizesNameLabel3.text = @"xxxxxxxx奖品3";
    self.prizesNameLabel3.hidden = YES;
    [self.prizesBgView addSubview:self.prizesNameLabel3];
    
    //奖品总数
    self.prizesTotleNumLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesNameLabel1.right, self.prizesTitleLabel.bottom+10, 90, 15)];
    self.prizesTotleNumLabel1.textAlignment = NSTextAlignmentCenter;
    self.prizesTotleNumLabel1.textColor = [UIColor flatLightRedColor];
    self.prizesTotleNumLabel1.font = [UIFont systemFontOfSize:12];
    self.prizesTotleNumLabel1.text = @"xxx个";
    self.prizesTotleNumLabel1.hidden = YES;
    [self.prizesBgView addSubview:self.prizesTotleNumLabel1];
    
    self.prizesTotleNumLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesNameLabel2.right, self.prizesTotleNumLabel1.bottom, 90, 15)];
    self.prizesTotleNumLabel2.textAlignment = NSTextAlignmentCenter;
    self.prizesTotleNumLabel2.textColor = [UIColor flatLightRedColor];
    self.prizesTotleNumLabel2.font = [UIFont systemFontOfSize:12];
    self.prizesTotleNumLabel2.text = @"xxx个";
    self.prizesTotleNumLabel2.hidden = YES;
    [self.prizesBgView addSubview:self.prizesTotleNumLabel2];
    
    self.prizesTotleNumLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesNameLabel3.right, self.prizesTotleNumLabel2.bottom, 90, 15)];
    self.prizesTotleNumLabel3.textAlignment = NSTextAlignmentCenter;
    self.prizesTotleNumLabel3.textColor = [UIColor flatLightRedColor];
    self.prizesTotleNumLabel3.font = [UIFont systemFontOfSize:12];
    self.prizesTotleNumLabel3.text = @"xxx个";
    self.prizesTotleNumLabel3.hidden = YES;
    [self.prizesBgView addSubview:self.prizesTotleNumLabel3];
    
    //中奖人数
    self.prizesWinNumLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTotleNumLabel1.right, self.prizesTitleLabel.bottom+10, 90, 15)];
    self.prizesWinNumLabel1.textAlignment = NSTextAlignmentCenter;
    self.prizesWinNumLabel1.textColor = [UIColor flatLightRedColor];
    self.prizesWinNumLabel1.font = [UIFont systemFontOfSize:12];
    self.prizesWinNumLabel1.text = @"xxx个";
    self.prizesWinNumLabel1.hidden = YES;
    [self.prizesBgView addSubview:self.prizesWinNumLabel1];
    
    self.prizesWinNumLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTotleNumLabel2.right, self.prizesWinNumLabel1.bottom, 90, 15)];
    self.prizesWinNumLabel2.textAlignment = NSTextAlignmentCenter;
    self.prizesWinNumLabel2.textColor = [UIColor flatLightRedColor];
    self.prizesWinNumLabel2.font = [UIFont systemFontOfSize:12];
    self.prizesWinNumLabel2.text = @"xxx个";
    self.prizesWinNumLabel2.hidden = YES;
    [self.prizesBgView addSubview:self.prizesWinNumLabel2];
    
    self.prizesWinNumLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesTotleNumLabel3.right, self.prizesWinNumLabel2.bottom, 90, 15)];
    self.prizesWinNumLabel3.textAlignment = NSTextAlignmentCenter;
    self.prizesWinNumLabel3.textColor = [UIColor flatLightRedColor];
    self.prizesWinNumLabel3.font = [UIFont systemFontOfSize:12];
    self.prizesWinNumLabel3.text = @"xxx个";
    self.prizesWinNumLabel3.hidden = YES;
    [self.prizesBgView addSubview:self.prizesWinNumLabel3];
    
    //流量红包显示
    self.flowBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.prizesBgView.bottom, self.view.width, 55)];
    self.flowBgView.backgroundColor = [UIColor clearColor];
    self.flowBgView.hidden = YES;
    [self.scrollView addSubview:self.flowBgView];
    
    self.flowTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 20)];
    self.flowTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.flowTitleLabel.text = @"流量红包";
    [self.flowBgView addSubview:self.flowTitleLabel];
    
    self.flowTotleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.flowTitleLabel.bottom+10, 200, 20)];
    self.flowTotleNumLabel.font = [UIFont systemFontOfSize:14];
    self.flowTotleNumLabel.textColor = [UIColor flatLightBlueColor];
    
//    self.flowTotleNumLabel.text = @"总流量：xxxxxxx份";
//    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:@"总流量：XXXXXM"];
//    //获取要调整颜色的文字位置,调整颜色
//    NSRange range1_1=[[hintString1 string]rangeOfString:@"总流量："];
//    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1_1];
//    NSRange range1_2=[[hintString1 string]rangeOfString:@"份"];
//    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1_2];
//    self.flowTotleNumLabel.attributedText= hintString1;

    [self.flowBgView addSubview:self.flowTotleNumLabel];
    
    self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.flowBgView.bottom+5, 65, 20)];
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.text = @"使用说明";
    [self.scrollView addSubview:self.descLabel];
    
    self.descTextView = [[UITextView alloc]initWithFrame:CGRectMake(15, self.descLabel.bottom+5, 270, 100)];
    self.descTextView.font = [UIFont systemFontOfSize:14];
    self.descTextView.backgroundColor = [UIColor flatLightWhiteColor];
    self.descTextView.layer.cornerRadius = 5;
    self.descTextView.layer.masksToBounds = YES;
    self.descTextView.editable = NO;
    [self.scrollView addSubview:self.descTextView];
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.descTextView.bottom+10, 65, 20)];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.text = @"截止日期";
    [self.scrollView addSubview:self.endTimeLabel];
    
    self.endTimeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, 100, 20)];
    self.endTimeShowLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeShowLabel.text = @"2016-01-01";
    self.endTimeShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.endTimeShowLabel];
    
    self.securityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.endTimeLabel.bottom+10, 65, 20)];
    self.securityLabel.font = [UIFont systemFontOfSize:14];
    self.securityLabel.text = @"兑奖码";
    [self.scrollView addSubview:self.securityLabel];
    
    self.securityShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.securityLabel.right, self.securityLabel.top, 100, 20)];
    self.securityShowLabel.font = [UIFont systemFontOfSize:14];
    self.securityShowLabel.text = @"0000";
    self.securityShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.securityShowLabel];

    //字符串宽度
    float bgWidth = (self.view.width-40)/3;
    
    self.successImageView = [[UIImageView alloc]init];
    self.successImageView.frame = CGRectMake(10, self.securityLabel.bottom+20, bgWidth, 40);
    self.successImageView.centerX = self.view.width/4;
    [self.scrollView addSubview:self.successImageView];
    
    self.successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.successBtn.backgroundColor = [UIColor redColor];
    self.successBtn.frame = self.successImageView.frame;
    [self.successBtn addTarget:self action:@selector(successBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.successBtn];
    
    self.exposureImageView = [[UIImageView alloc]init];
    self.exposureImageView.frame = CGRectMake(self.successImageView.right+10, self.successImageView.top, bgWidth, self.successImageView.height);
    self.exposureImageView.centerX = self.view.width/4*3;
    [self.scrollView addSubview:self.exposureImageView];
    
    self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successImageView.left,self.successImageView.top,bgWidth,self.successImageView.height/2)];
    self.successNubLabel.textAlignment = NSTextAlignmentCenter;
    self.successNubLabel.text = @"0";
    self.successNubLabel.textColor = [UIColor flatLightBlueColor];
    self.successNubLabel.font = [UIFont systemFontOfSize:14];
    //    self.successNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.successNubLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.successNubLabel.bottom, self.successNubLabel.width/2, 1)];
    lineView.centerX = self.successNubLabel.centerX;
    lineView.backgroundColor = [UIColor flatLightBlueColor];
    [self.scrollView addSubview:lineView];
    
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successImageView.left,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.text = @"参与人数";
    self.successLabel.textColor = [UIColor lightGrayColor];
    self.successLabel.font = [UIFont systemFontOfSize:12];
    //            self.successLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.successLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.scrollView.width/2, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    
    self.exposureNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.exposureImageView.left,self.successImageView.top,bgWidth,self.successNubLabel.height)];
    self.exposureNubLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureNubLabel.text = @"0";
    self.exposureNubLabel.textColor = [UIColor flatLightRedColor];
    self.exposureNubLabel.font = [UIFont systemFontOfSize:14];
    //    self.exposureNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.exposureNubLabel];
    
    self.exposureLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.exposureImageView.left,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
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
    
    YKLPrizesOrderListViewController *VC = [YKLPrizesOrderListViewController new];
    VC.orderID = self.detailModel.activityID;
    VC.orderName = self.detailModel.title;
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)successBtnClicked{
    NSLog(@"参与人");
    
    YKLPrizesActivityUserListViewController *fansListVC = [YKLPrizesActivityUserListViewController new];
    fansListVC.title = @"参与人";
    fansListVC.goodID = self.detailModel.activityID;
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
    VC.actType = @"口袋红包";
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
