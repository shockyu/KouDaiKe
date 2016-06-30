//
//  YKLMiaoShaActivityListDetailViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/23.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMiaoShaActivityListDetailViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLMiaoShaActivityUserListViewController.h"
#import "YKLMiaoShaOrderListViewController.h"
#import "SJAvatarBrowser.h"
#import "QRCodeGenerator.h"
#import "YKLCommentViewController.h"
#import "YKLEwmPosterViewController.h"

@interface YKLMiaoShaActivityListDetailViewController ()

@property (nonatomic, strong) NSArray *imageViewArr;

@property (nonatomic, strong) UIImageView *actImageView1;
@property (nonatomic, strong) UIImageView *actImageView2;
@property (nonatomic, strong) UIImageView *actImageView3;

@property (nonatomic, strong) NSString *coverImageURL;
@property (nonatomic, strong) NSString *bannerURL;

@end

@implementation YKLMiaoShaActivityListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"秒杀详情";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingMiaoSha getActListWithActID:self.detailModel.activityID Success:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",dict);
        self.goodsName.text = [dict objectForKey:@"good_name"];
        self.descTextView.text = [dict objectForKey:@"rule_desc"];
        self.startTimeShowLabel.text = [NSString timeNumberHHmm:[dict objectForKey:@"start_time"]];
        self.endTimeShowLabel.text = [NSString timeNumberHHmm:[dict objectForKey:@"seckill_end"]];
        
        self.priceShowLabel.text = [NSString stringWithFormat:@"%@元",[dict objectForKey:@"goods_price"]];
        self.discounthowLabel.text = [NSString stringWithFormat:@"%@元",[dict objectForKey:@"seckill_price"]];
        
        //转换回"\n"
        self.descTextView.text =[self.descTextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [NSArray array];
        tempArray = [dict objectForKey:@"head_img"];
        if(IsEmpty(tempArray)){
            NSLog(@"图片数组为空");
        }
        else if(tempArray.count < 4){
            
            for (int i = 0; i < tempArray.count; i++) {
                
                UIImageView *imageView = self.imageViewArr[i];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                [self.imageViewArr[i] addGestureRecognizer:singleTap];
                [imageView sd_setImageWithURL:[NSURL URLWithString:tempArray[i]] placeholderImage:[UIImage imageNamed:@"Demo"]];
            }
        }
        
        
        self.securityShowLabel.text = [dict objectForKey:@"reward_code"];
        
        self.exposureNubLabel.text =  [[dict objectForKey:@"exposure_num"] isEqual:@""] ? @"0": [NSString stringWithFormat:@"%@",[dict objectForKey:@"exposure_num"]];
        
        self.participantNubLabel.text = [[dict objectForKey:@"success_num"] isEqual:@""] ? @"0": [NSString stringWithFormat:@"%@",[dict objectForKey:@"success_num"]];
        
        self.remainNubLabel.text = [[dict objectForKey:@"last_num"] isEqual:@""] ? @"0": [NSString stringWithFormat:@"%@",[dict objectForKey:@"last_num"]];
        
        self.successNubLabel.text = [[dict objectForKey:@"join_num"] isEqual:@""] ? @"0": [NSString stringWithFormat:@"%@",[dict objectForKey:@"join_num"]];
        
        self.bannerURL = [dict objectForKey:@"banner"];
        self.coverImageURL = tempArray[0];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
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
    self.scrollView.contentSize = CGSizeMake(self.view.width, 768-64-10);
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
    self.goodsImageTitle.text = @"首页图片";
    [self.scrollView addSubview:self.goodsImageTitle];
    
    self.goodsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Demo"]];
    self.goodsImageView.userInteractionEnabled = YES;
    self.goodsImageView.frame = CGRectMake(15, self.goodsImageTitle.bottom+10, 50, 50);
    [self.scrollView addSubview:self.goodsImageView];
    
    self.actImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.goodsImageTitle.bottom+10, 50, 50)];
    self.actImageView1.backgroundColor = [UIColor whiteColor];
    self.actImageView1.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.actImageView1];
    
    self.actImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView1.right+5,self.goodsImageTitle.bottom+10,50,50)];
    self.actImageView2.backgroundColor = [UIColor whiteColor];
    self.actImageView2.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.actImageView2];
    
    self.actImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView2.right+5,self.goodsImageTitle.bottom+10,50,50)];
    self.actImageView3.backgroundColor = [UIColor whiteColor];
    self.actImageView3.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.actImageView3];
    
    self.imageViewArr = @[self.actImageView1,self.actImageView2,self.actImageView3];
    
    
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
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.descTextView.bottom+10, 100, 20)];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.text = @"原价";
    [self.scrollView addSubview:self.priceLabel];
    
    self.priceShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.right, self.priceLabel.top, 100, 20)];
    self.priceShowLabel.font = [UIFont systemFontOfSize:14];
    self.priceShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.priceShowLabel];
    
    self.discountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.priceLabel.bottom+5, 100, 20)];
    self.discountLabel.font = [UIFont systemFontOfSize:14];
    self.discountLabel.text = @"秒杀价";
    [self.scrollView addSubview:self.discountLabel];
    
    self.discounthowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.discountLabel.right, self.discountLabel.top, 100, 20)];
    self.discounthowLabel.font = [UIFont systemFontOfSize:14];
    self.discounthowLabel.textColor = [UIColor lightGrayColor];
    self.discounthowLabel.text = @"1元";
    [self.scrollView addSubview:self.discounthowLabel];
    
    self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.discountLabel.bottom+5, 100, 20)];
    self.startTimeLabel.font = [UIFont systemFontOfSize:14];
    self.startTimeLabel.text = @"开始时间";
    [self.scrollView addSubview:self.startTimeLabel];
    
    self.startTimeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.startTimeLabel.right, self.startTimeLabel.top, 130, 20)];
    self.startTimeShowLabel.font = [UIFont systemFontOfSize:14];
//    self.startTimeShowLabel.text = @"2016-01-01";
    self.startTimeShowLabel.textColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:self.startTimeShowLabel];
    
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.startTimeLabel.bottom+5, 100, 20)];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.text = @"结束时间";
    [self.scrollView addSubview:self.endTimeLabel];
    
    self.endTimeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, 130, 20)];
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
    float bgWidth = self.view.width/4;
    
    self.participantImageView = [[UIImageView alloc]init];
    self.participantImageView.frame = CGRectMake(10, self.securityLabel.bottom+5, bgWidth, 40);
    [self.scrollView addSubview:self.participantImageView];
    
    self.successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.successBtn.backgroundColor = [UIColor redColor];
    self.successBtn.frame = self.participantImageView.frame;
    [self.successBtn addTarget:self action:@selector(successBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.successBtn];
    
    self.successImageView = [[UIImageView alloc]init];
    self.successImageView.frame = CGRectMake(self.participantImageView.right, self.participantImageView.top, bgWidth, self.participantImageView.height);
    [self.scrollView addSubview:self.successImageView];
    
    self.participantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.participantBtn.backgroundColor = [UIColor yellowColor];
    self.participantBtn.frame = self.successImageView.frame;
    [self.participantBtn addTarget:self action:@selector(participantBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.participantBtn];
    
    self.exposureImageView = [[UIImageView alloc]init];
    self.exposureImageView.frame = CGRectMake(self.successImageView.right,self.participantImageView.top, bgWidth, self.participantImageView.height);
    [self.scrollView addSubview:self.exposureImageView];
    
    self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.successImageView.top,bgWidth,self.participantImageView.height/2)];
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
    
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.text = @"报名人数";
    self.successLabel.textColor = [UIColor lightGrayColor];
    self.successLabel.font = [UIFont systemFontOfSize:12];
    //            self.successLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.successLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.successLabel.right, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    
    self.participantNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right,self.successImageView.top,bgWidth,self.successNubLabel.height)];
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
    
    self.participantLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right,self.participantNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.participantLabel.textAlignment = NSTextAlignmentCenter;
    self.participantLabel.text = @"成功秒杀人数";
    self.participantLabel.textColor = [UIColor lightGrayColor];
    self.participantLabel.font = [UIFont systemFontOfSize:12];
    //            self.participantLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.participantLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.participantLabel.right, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    
    self.remainNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.successImageView.top,bgWidth,self.successNubLabel.height)];
    self.remainNubLabel.textAlignment = NSTextAlignmentCenter;
    self.remainNubLabel.text = @"0";
    self.remainNubLabel.textColor = [UIColor flatLightRedColor];
    self.remainNubLabel.font = [UIFont systemFontOfSize:14];
    //           self.remainNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.remainNubLabel];
    
    self.remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right,self.participantNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.remainLabel.textAlignment = NSTextAlignmentCenter;
    self.remainLabel.text = @"剩余数量";
    self.remainLabel.textColor = [UIColor lightGrayColor];
    self.remainLabel.font = [UIFont systemFontOfSize:12];
    //           self.exposureLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.remainLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.remainLabel.right, self.successNubLabel.top+5, 1, 30)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    
    self.exposureNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.remainLabel.right,self.successImageView.top,bgWidth,self.successNubLabel.height)];
    self.exposureNubLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureNubLabel.text = @"0";
    self.exposureNubLabel.textColor = [UIColor flatLightRedColor];
    self.exposureNubLabel.font = [UIFont systemFontOfSize:14];
    //            self.exposureNubLabel.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:self.exposureNubLabel];
    
    self.exposureLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.remainLabel.right,self.exposureNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.exposureLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureLabel.text = @"访问人数";
    self.exposureLabel.textColor = [UIColor lightGrayColor];
    self.exposureLabel.font = [UIFont systemFontOfSize:12];
    //           self.exposureLabel.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.exposureLabel];

    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.backgroundColor = [UIColor whiteColor];
    commentButton.frame = CGRectMake(10,self.exposureLabel.bottom+10,self.view.width-20,40);
    [commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    commentButton.layer.cornerRadius = 10;
    commentButton.layer.masksToBounds = YES;
    commentButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentButton.layer.borderWidth = 1;
    [self.scrollView addSubview: commentButton];
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 60, 40)];
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.textColor = [UIColor blackColor];
    commentLabel.text = @"评论管理";
    [commentButton addSubview:commentLabel];
    
    if (![[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
        
        UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.right, 0, 20, 20)];
        commentImageView.image = [UIImage imageNamed:@"黄钻2"];
        commentImageView.centerY = 20;
        [commentButton addSubview:commentImageView];
        
        UILabel *commentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(commentImageView.right, 0, 65, 40)];
        commentLabel2.font = [UIFont systemFontOfSize:12];
        commentLabel2.textColor = [UIColor lightGrayColor];
        commentLabel2.text = @"(黄钻专属)";
        [commentButton addSubview:commentLabel2];
    
    }
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [listButton setTitle:@"活动订单" forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [listButton setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    listButton.backgroundColor = [UIColor flatLightBlueColor];
    listButton.frame = CGRectMake(10,commentButton.bottom+10,self.view.width-20,40);
    [listButton addTarget:self action:@selector(listButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    listButton.layer.cornerRadius = 10;
    listButton.layer.masksToBounds = YES;
    [self.scrollView addSubview: listButton];
    
    //分享按钮&二维码
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.hidden = NO;
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.shareBtn setTitle:@"分享到微信" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.shareBtn.backgroundColor = [UIColor colorWithHexString:@"08c630"];
    self.shareBtn.frame = CGRectMake(10,listButton.bottom+10,self.view.width-20,40);
    [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn.layer.cornerRadius = 10;
    self.shareBtn.layer.masksToBounds = YES;
    [self.scrollView addSubview: self.shareBtn];
    
    self.ewmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ewmBtn.hidden = NO;
    self.ewmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.ewmBtn setTitle:@"生成活动二维码" forState:UIControlStateNormal];
    [self.ewmBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.ewmBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.ewmBtn.backgroundColor = [UIColor flatLightRedColor];
    self.ewmBtn.frame = CGRectMake(10,self.shareBtn.bottom+10,self.view.width-20,40);
    [self.ewmBtn addTarget:self action:@selector(ewmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.ewmBtn.layer.cornerRadius = 10;
    self.ewmBtn.layer.masksToBounds = YES;
    [self.scrollView addSubview: self.ewmBtn];
    
}


- (void)commentButtonClicked{
    NSLog(@"评论管理");
    
    YKLCommentViewController *vc = [YKLCommentViewController new];
    vc.actType = @"全民秒杀";
    vc.actID = self.detailModel.activityID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)listButtonClicked{
    NSLog(@"点击活动订单");
    
    YKLMiaoShaOrderListViewController *VC = [YKLMiaoShaOrderListViewController new];
    VC.orderID = self.detailModel.activityID;
    VC.orderName = self.detailModel.title;
    [self.navigationController pushViewController:VC animated:YES];
    
}


- (void)successBtnClicked{
    NSLog(@"报名人数");
    
    YKLMiaoShaActivityUserListViewController *fansListVC = [YKLMiaoShaActivityUserListViewController new];
    fansListVC.goodID = self.detailModel.activityID;
    fansListVC.userType = @"报名人";
    [self.navigationController pushViewController:fansListVC animated:YES];
    
}

- (void)participantBtnClicked{
    NSLog(@"成功秒杀人数");
    
    YKLMiaoShaActivityUserListViewController *fansListVC = [YKLMiaoShaActivityUserListViewController new];
    fansListVC.goodID = self.detailModel.activityID;
    fansListVC.userType = @"成功秒杀人";
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
    VC.actType = @"全民秒杀";
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)ewmBtnClick:(id)sender{
    NSLog(@"活动二维码");

    YKLEwmPosterViewController *postPreview = [YKLEwmPosterViewController new];
    
    postPreview.type = 3;
    
    [postPreview createBgView];
    
    postPreview.ewmImageView.image = [QRCodeGenerator qrImageForString:self.detailModel.shareUrl imageSize:150];
    if (![self.bannerURL isEqual:[NSNull null]]) {
        
        [postPreview.tempImage sd_setImageWithURL:[NSURL URLWithString:self.bannerURL] placeholderImage:[UIImage imageNamed:@"Demo"]];
    }
    [postPreview.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.coverImageURL] placeholderImage:[UIImage imageNamed:@"Demo"]];
    
    
    [self presentViewController:postPreview animated:YES completion:^{
        
    }];
}


@end
