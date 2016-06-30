//
//  YKLActivityListDetailViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/28.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLActivityListDetailViewController.h"
#import "SJAvatarBrowser.h"
//#import "YKLShareContentModel.h"
//#import "YKLShareViewController.h"
#import "YKLTogetherShareViewController.h"
#import "QRCodeGenerator.h"
#import "YKLActivityFansListViewController.h"
#import "YKLActivityOnlyFansViewController.h"
#import "YKLEwmPosterViewController.h"
#import "YKLCommentViewController.h"

//侧滑控件
#import "TWTSideMenuViewController.h"
#import "TWTFansViewController.h"
#import "TWTMainViewController.h"

#import "YKLActManageView.h"
#import "YKLActManagePopupView.h"

@interface YKLActivityListDetailViewController ()<TWTSideMenuViewControllerDelegate,YKLActManageViewDelegate,YKLActManagePopupViewDelegate>

@property (nonatomic, strong) CustomIOSAlertView *rechargeAlertView;
@property (nonatomic, strong) UIView *rechargeAlertBgView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *qRBgView;
@property (nonatomic, strong) UILabel *rechargeAlertTitleLabel;
@property (nonatomic, strong) UIImageView *qRImageView;
@property (nonatomic, strong) UIButton *savaBtn;

//侧滑控件
@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, strong) TWTFansViewController *fansViewController;
@property (nonatomic, strong) TWTMainViewController *mainViewController;

@property (nonatomic, strong) NSString *coverImageURL;
@property (nonatomic, strong) NSString *bannerURL;

@property (nonatomic, strong) NSDictionary *actManageDict;
@property (nonatomic, strong) YKLActManagePopupView *actManagePopupView;

@end

@implementation YKLActivityListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动详情";
    
    self.actImageViewArr= [NSMutableArray array];
    self.imageViewArr = [NSArray array];
    
//    [self createView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer getActivityInfoWithActivityID:self.detailModel.activityID Success:^(NSDictionary *templateModel) {
        
        //活动说明
        self.actDesctextView = [[UITextView alloc] initWithFrame:self.bgView2.bounds];
        self.actDesctextView.keyboardType = UIKeyboardTypeDefault;
        self.actDesctextView.backgroundColor = [UIColor clearColor];
        self.actDesctextView.textColor = [UIColor grayColor];
        self.actDesctextView.font = [UIFont systemFontOfSize:11];
        self.actDesctextView.returnKeyType = UIReturnKeyNext;
        self.actDesctextView.text = [templateModel objectForKey:@"desc"];
        
        //转回<\n>
        self.actDesctextView.text =[self.actDesctextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        self.actDesctextView.editable = NO;
        [self.bgView2 addSubview:self.actDesctextView];
        
        
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [NSArray array];
        tempArray = [templateModel objectForKey:@"img"];
        if(IsEmpty(tempArray)){
            NSLog(@"图片数组为空");
        }else{
            for (int i = 0; i < tempArray.count; i++) {
                [self.actImageViewArr addObject:[tempArray[i] objectForKey:@"img_url"]];
                UIImageView *imageView = self.imageViewArr[i];
                //                self.imageViewArr[i].userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                [self.imageViewArr[i] addGestureRecognizer:singleTap];
                //                imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.actImageViewArr[i]]]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.actImageViewArr[i]] placeholderImage:[UIImage imageNamed:@"Demo"]];
            }
        }
        
        NSDictionary *dic = [templateModel objectForKey:@"template"];
        self.bannerURL = [dic objectForKey:@"banner"];
        
        self.coverImageURL = [templateModel objectForKey:@"cover_img"];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
//        [UIAlertView showInfoMsg:error.domain];
        
    }];
}

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

- (void)createView{
    [self createBgView];
    [self createContent];
    [self createImageView];

}


- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+10, self.view.width, self.view.height-64-10-110)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 518-64-10);
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 95)];//85+(self.view.width-60)/5+10
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
//    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.height/3, self.view.width, 1)];
//    self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
//    [self.bgView1 addSubview:self.lineView];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 140)];//88
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
    self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom, self.view.width, 50)];//58
    self.bgView3.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView3];
    
    
    self.bgView4 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView3.bottom, self.view.width, 140)];//135
    self.bgView4.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView4];
    
    
    NSLog(@"%@",self.detailModel.coverImg);
    
    YKLActManageView *actManageView = [[YKLActManageView alloc]initWithFrame:CGRectMake(0, self.scrollView.bottom+10, ScreenWidth, 100)];
    actManageView.delegate = self;
    
    _actManageDict = @{
                       @"img":@[
                               @{
                                   @"fileName":@"act_detail_ewm",
                                   @"title":@"生成二维码",
                                   @"tag":@1
                                   },
                               @{
                                   @"fileName":@"act_detail_actManage",
                                   @"title":@"订单管理",
                                   @"tag":@2
                                   },
                               @{
                                   @"fileName":@"act_detail_share",
                                   @"title":@"分享到微信",
                                   @"tag":@3
                                   },
                               @{
                                   @"fileName":@"act_detail_pinglun",
                                   @"title":@"评论管理",
                                   @"tag":@4
                                   },
                               @{
                                   @"fileName":@"act_detail_stop",
                                   @"title":@"停止活动",
                                   @"tag":@5
                                   },
                               @{
                                   @"fileName":@"act_detail_feige",
                                   @"title":@"飞鸽传书",
                                   @"tag":@6
                                   },
                               ],
                       
                       };

    
    [actManageView createView:_actManageDict];
    [self.view addSubview:actManageView];
    
    /*
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.backgroundColor = [UIColor whiteColor];
    commentButton.frame = CGRectMake(10,self.bgView4.bottom+10,self.view.width-20,40);
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
    [listButton addTarget:self action:@selector(listButtonBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [listButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    listButton.layer.cornerRadius = 10;
    listButton.layer.masksToBounds = YES;
    [self.scrollView addSubview: listButton];

    
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
    */
    
}

- (void)createContent{
    //字符串宽度
    float bgWidth = (self.view.width-40)/3;
    
    self.actTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    //    self.actTitleLabel.backgroundColor = [UIColor redColor];
    self.actTitleLabel.font = [UIFont systemFontOfSize:14];
    self.actTitleLabel.textColor = [UIColor blackColor];
    self.actTitleLabel.text = @"商品名称";
    [self.bgView1 addSubview:self.actTitleLabel];
    
    self.actTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actTitleLabel.right, 5, self.view.width-self.actTitleLabel.right-20, 20)];
    //    self.actTitleNameLabel.backgroundColor = [UIColor redColor];
    self.actTitleNameLabel.font = [UIFont systemFontOfSize:14];
    self.actTitleNameLabel.textColor = [UIColor grayColor];
    self.actTitleNameLabel.text = self.detailModel.title;
    [self.bgView1 addSubview:self.actTitleNameLabel];
    
//    //活动详情
//    self.actDescLabel = [[UILabel alloc] init];
//    self.actDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    self.actDescLabel.numberOfLines = 0;//上面两行设置多行显示
//    self.actDescLabel.frame = self.bgView2.bounds;
////    self.actDescLabel.backgroundColor = [UIColor redColor];
//    self.actDescLabel.font = [UIFont systemFontOfSize:14];
//    self.actDescLabel.textColor = [UIColor grayColor];
////    self.actDescLabel.text = self.detailModel.desc;
//    CGRect rect = [self.actDescLabel.text boundingRectWithSize:CGSizeMake(self.view.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.actDescLabel.font}  context:nil];
//    self.actDescLabel.frame = CGRectMake(10, 10, rect.size.width, rect.size.height);
//    [self.bgView2 addSubview:self.actDescLabel];
    
    self.priceNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, bgWidth, 20)];
    self.priceNubLabel.textAlignment = NSTextAlignmentCenter;
    self.priceNubLabel.font = [UIFont systemFontOfSize:14];
    self.priceNubLabel.textColor = [UIColor flatLightRedColor];
    self.priceNubLabel.text = [NSString stringWithFormat:@"¥%@",self.detailModel.originalPrice];
    [self.bgView3 addSubview:self.priceNubLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.priceNubLabel.bottom, bgWidth, 20)];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.priceLabel.textColor = [UIColor lightGrayColor];
    self.priceLabel.text = @"原价";
    [self.bgView3 addSubview:self.priceLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.priceLabel.right, 5, 1, 40)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:self.lineView];
    
    self.basePriceNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceNubLabel.right+10, 5, bgWidth, 20)];
    self.basePriceNubLabel.textAlignment = NSTextAlignmentCenter;
    self.basePriceNubLabel.font = [UIFont systemFontOfSize:14];
    self.basePriceNubLabel.textColor = [UIColor flatLightRedColor];
    self.basePriceNubLabel.text = [NSString stringWithFormat:@"¥%@",self.detailModel.basePrice];
    [self.bgView3 addSubview:self.basePriceNubLabel];
    
    self.basePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.priceNubLabel.right+10, self.basePriceNubLabel.bottom, bgWidth, 20)];
    self.basePriceLabel.textAlignment = NSTextAlignmentCenter;
    self.basePriceLabel.font = [UIFont systemFontOfSize:12];
    self.basePriceLabel.textColor = [UIColor lightGrayColor];
    self.basePriceLabel.text = @"最低砍到";
    [self.bgView3 addSubview:self.basePriceLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.basePriceLabel.right, 5, 1, 40)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:self.lineView];
    
    //若有砍价区间显示砍价区间，若无显示完成砍价所需人数
    if ([self.detailModel.playerNum isEqual:@"0"]||[self.detailModel.playerNum isBlankString]) {
        
        self.bargainNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.basePriceNubLabel.right+10, 5, bgWidth, 20)];
        self.bargainNubLabel.textAlignment = NSTextAlignmentCenter;
        self.bargainNubLabel.font = [UIFont systemFontOfSize:14];
        self.bargainNubLabel.textColor = [UIColor flatLightRedColor];
        self.bargainNubLabel.text = [NSString stringWithFormat:@"¥%@-%@",self.detailModel.startBargain,self.detailModel.endBargain];
        [self.bgView3 addSubview:self.bargainNubLabel];
        
        self.bargainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.basePriceNubLabel.right+10, self.basePriceNubLabel.bottom, bgWidth, 20)];
        self.bargainLabel.textAlignment = NSTextAlignmentCenter;
        self.bargainLabel.font = [UIFont systemFontOfSize:14];
        self.bargainLabel.textColor = [UIColor lightGrayColor];
        self.bargainLabel.text = @"每刀砍价区间";
        [self.bgView3 addSubview:self.bargainLabel];
        
    }else{
        
        self.bargainNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.basePriceNubLabel.right+10, 5, bgWidth, 20)];
        self.bargainNubLabel.textAlignment = NSTextAlignmentCenter;
        self.bargainNubLabel.font = [UIFont systemFontOfSize:14];
        self.bargainNubLabel.textColor = [UIColor flatLightRedColor];
        self.bargainNubLabel.text = [NSString stringWithFormat:@"%@",self.detailModel.playerNum];
        [self.bgView3 addSubview:self.bargainNubLabel];
        
        self.bargainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.basePriceNubLabel.right+10, self.basePriceNubLabel.bottom, bgWidth, 20)];
        self.bargainLabel.textAlignment = NSTextAlignmentCenter;
        self.bargainLabel.font = [UIFont systemFontOfSize:12];
        self.bargainLabel.textColor = [UIColor lightGrayColor];
        self.bargainLabel.text = @"砍价所需人数";
        [self.bgView3 addSubview:self.bargainLabel];

    }
    
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.text = @"产品总数";
    [self.bgView4 addSubview:self.numLabel];
    
    self.numShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.numLabel.right, self.numLabel.top, 100, 20)];
    self.numShowLabel.font = [UIFont systemFontOfSize:14];
    self.numShowLabel.text = [NSString stringWithFormat:@"%@个",self.detailModel.productNum];
    self.numShowLabel.textColor = [UIColor lightGrayColor];
    [self.bgView4 addSubview:self.numShowLabel];
    
    self.endTimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.numLabel.bottom+10, 100, 20)];
    self.endTimeTitleLabel.backgroundColor = [UIColor clearColor];
    self.endTimeTitleLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeTitleLabel.textColor = [UIColor blackColor];
    self.endTimeTitleLabel.text = @"活动截止时间";
    [self.bgView4 addSubview:self.endTimeTitleLabel];
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.endTimeTitleLabel.right, self.endTimeTitleLabel.top, 100, 20)];
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textColor = [UIColor grayColor];
    self.endTimeLabel.text = self.detailModel.activityEndTime;
    [self.bgView4 addSubview:self.endTimeLabel];
    
    self.securityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.endTimeLabel.bottom+10, 100, 20)];
    self.securityTitleLabel.backgroundColor = [UIColor clearColor];
    self.securityTitleLabel.font = [UIFont systemFontOfSize:14];
    self.securityTitleLabel.textColor = [UIColor blackColor];
    self.securityTitleLabel.text = @"现场兑奖码";
    [self.bgView4 addSubview:self.securityTitleLabel];
    
    self.securityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.securityTitleLabel.right, self.endTimeLabel.bottom+10, 100, 20)];
    self.securityLabel.backgroundColor = [UIColor clearColor];
    self.securityLabel.font = [UIFont systemFontOfSize:14];
    self.securityLabel.textColor = [UIColor grayColor];
    self.securityLabel.text = self.detailModel.rewardCode;
    [self.bgView4 addSubview:self.securityLabel];
    
    
    self.successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.successBtn.backgroundColor = [UIColor redColor];
    self.successBtn.frame = CGRectMake(10, self.securityLabel.bottom+10, bgWidth, 40);
    [self.successBtn addTarget:self action:@selector(successBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView4 addSubview:self.successBtn];
    
    
    self.participantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.participantBtn.backgroundColor = [UIColor yellowColor];
    self.participantBtn.frame = CGRectMake(self.successBtn.right+10, self.successBtn.top, bgWidth, self.successBtn.height);
    [self.participantBtn addTarget:self action:@selector(participantAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView4 addSubview:self.participantBtn];
    
    
    self.successNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.participantBtn.top,bgWidth,self.participantBtn.height/2)];
    self.successNubLabel.textAlignment = NSTextAlignmentCenter;
    self.successNubLabel.text = self.detailModel.playersOverNum;
    self.successNubLabel.textColor = [UIColor flatLightBlueColor];
    self.successNubLabel.font = [UIFont systemFontOfSize:14];
//            self.successNubLabel.backgroundColor = [UIColor blueColor];
    [self.bgView4 addSubview:self.successNubLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.successNubLabel.bottom, self.successNubLabel.width/2, 1)];
    self.lineView.centerX = self.successNubLabel.centerX;
    self.lineView.backgroundColor = [UIColor flatLightBlueColor];
    [self.bgView4 addSubview:self.lineView];
    
    self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.successNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.text = @"砍价成功人数";
    self.successLabel.textColor = [UIColor lightGrayColor];
    self.successLabel.font = [UIFont systemFontOfSize:12];
//            self.successLabel.backgroundColor = [UIColor redColor];
    [self.bgView4 addSubview:self.successLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.successLabel.right, self.participantBtn.top, 1, 35)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView4 addSubview:self.lineView];
    
    
    self.participantNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right+10,self.participantBtn.top,bgWidth,self.successNubLabel.height)];
    self.participantNubLabel.textAlignment = NSTextAlignmentCenter;
    self.participantNubLabel.text = self.detailModel.playersNum;
    self.participantNubLabel.textColor = [UIColor flatLightBlueColor];
    self.participantNubLabel.font = [UIFont systemFontOfSize:14];
    //            self.participantNubLabel.backgroundColor = [UIColor blueColor];
    [self.bgView4 addSubview:self.participantNubLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.participantNubLabel.bottom, self.participantNubLabel.width/2, 1)];
    self.lineView.centerX = self.participantNubLabel.centerX;
    self.lineView.backgroundColor = [UIColor flatLightBlueColor];
    [self.bgView4 addSubview:self.lineView];
    
    self.participantLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.successNubLabel.right+10,self.participantNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.participantLabel.textAlignment = NSTextAlignmentCenter;
    self.participantLabel.text = @"参与人数";
    self.participantLabel.textColor = [UIColor lightGrayColor];
    self.participantLabel.font = [UIFont systemFontOfSize:12];
    //            self.participantLabel.backgroundColor = [UIColor redColor];
    [self.bgView4 addSubview:self.participantLabel];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.participantLabel.right, self.participantBtn.top, 1, 35)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView4 addSubview:self.lineView];
    
    self.exposureNubLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right+10,self.participantBtn.top,bgWidth,self.successNubLabel.height)];
    self.exposureNubLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureNubLabel.text = self.detailModel.exposureNum;
    self.exposureNubLabel.textColor = [UIColor flatLightRedColor];
    self.exposureNubLabel.font = [UIFont systemFontOfSize:14];
    //            self.exposureNubLabel.backgroundColor = [UIColor blueColor];
    [self.bgView4 addSubview:self.exposureNubLabel];
    
    self.exposureLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.participantLabel.right+10,self.participantNubLabel.bottom,bgWidth,self.successNubLabel.height)];
    self.exposureLabel.textAlignment = NSTextAlignmentCenter;
    self.exposureLabel.text = @"访问量";
    self.exposureLabel.textColor = [UIColor lightGrayColor];
    self.exposureLabel.font = [UIFont systemFontOfSize:12];
    //           self.exposureLabel.backgroundColor = [UIColor redColor];
    [self.bgView4 addSubview:self.exposureLabel];
}

- (void)createImageView{
    
    self.actPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.actTitleLabel.bottom, 100, 20)];
    self.actPhotoLabel.backgroundColor = [UIColor clearColor];
    self.actPhotoLabel.font = [UIFont systemFontOfSize:14];
    self.actPhotoLabel.textColor = [UIColor blackColor];
    self.actPhotoLabel.text = @"活动照片";
    [self.bgView1 addSubview:self.actPhotoLabel];
    
    self.actImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10,self.actPhotoLabel.bottom+5,50,50)];
    self.actImageView1.backgroundColor = [UIColor whiteColor];
    self.actImageView1.userInteractionEnabled = YES;
    [self.bgView1 addSubview:self.actImageView1];
    
    self.actImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView1.right+5,self.actPhotoLabel.bottom+5,50,50)];
    self.actImageView2.backgroundColor = [UIColor whiteColor];
    self.actImageView2.userInteractionEnabled = YES;
    [self.bgView1 addSubview:self.actImageView2];
    
    self.actImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView2.right+5,self.actPhotoLabel.bottom+5,50,50)];
    self.actImageView3.backgroundColor = [UIColor whiteColor];
    self.actImageView3.userInteractionEnabled = YES;
    [self.bgView1 addSubview:self.actImageView3];
    
    self.actImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView3.right+10,self.actPhotoLabel.bottom+5,50,50)];
    self.actImageView4.backgroundColor = [UIColor whiteColor];
    self.actImageView4.userInteractionEnabled = YES;
    [self.bgView1 addSubview:self.actImageView4];
    
    self.actImageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView4.right+5,self.actPhotoLabel.bottom+5,50,50)];
    self.actImageView5.backgroundColor = [UIColor whiteColor];
    self.actImageView5.userInteractionEnabled = YES;
    [self.bgView1 addSubview:self.actImageView5];

    self.imageViewArr = @[self.actImageView1,self.actImageView2,self.actImageView3,self.actImageView4,self.actImageView5];
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
  
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (void)successBtnClicked{
    NSLog(@"成功砍价的人");
    
    YKLActivityOnlyFansViewController *fansListVC = [YKLActivityOnlyFansViewController new];
    fansListVC.actID = self.detailModel.activityID;
    fansListVC.userType = @"1";
    fansListVC.listTitle = @"成功砍价的人";
    [self.navigationController pushViewController:fansListVC animated:YES];
    
}

- (void)participantAllBtnClicked{
    NSLog(@"参与砍价的人");
    
    YKLActivityOnlyFansViewController *fansListVC = [YKLActivityOnlyFansViewController new];
    fansListVC.actID = self.detailModel.activityID;
    fansListVC.userType = @"";
    fansListVC.listTitle = @"参与的人";
    [self.navigationController pushViewController:fansListVC animated:YES];
    
}

- (void)commentButtonClicked{
    NSLog(@"评论管理");
    
    YKLCommentViewController *vc = [YKLCommentViewController new];
    vc.actType = @"全民砍价";
    vc.actID = self.detailModel.activityID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)listButtonBtnClicked{
    NSLog(@"活动订单");
    
    if ([self.detailModel.type isEqual:@"1"]) {
        
        YKLActivityFansListViewController *fansListVC = [YKLActivityFansListViewController new];
        fansListVC.activityID = self.detailModel.activityID;
        fansListVC.fansType = @"";//不传参数，全部人数
        fansListVC.listTitle = @"活动订单";
        fansListVC.payType = @"1";
        fansListVC.hideSideButton = YES;
        [self.navigationController pushViewController:fansListVC animated:YES];

    }
    else if ([self.detailModel.type isEqual:@"2"])
    {
        self.fansViewController = [[TWTFansViewController alloc] initWithNibName:nil bundle:nil];
        self.fansViewController.detailModel = self.detailModel;
        
        self.mainViewController = [[TWTMainViewController alloc] initWithNibName:nil bundle:nil];
        
        self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.fansViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.mainViewController]];
        
        //调用活动点击事件
        [self.fansViewController changeButtonPressed];
        [self.sideMenuViewController openMenuAnimated:NO completion:nil];
//        self.fansViewController.bargainImageView.image = [UIImage imageNamed:@"砍价侧边栏选中.png"];
//        [self.fansViewController.bargainBtn setTitleColor:[UIColor PosterOrangeColor] forState:UIControlStateNormal];
        [self.sideMenuViewController closeMenuAnimated:NO completion:nil];
        
        self.sideMenuViewController.shadowColor = [UIColor blackColor];
        self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
        self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
        self.sideMenuViewController.delegate = self;
        
        [self.navigationController pushViewController:self.sideMenuViewController animated:YES];
    }
}


- (void)shareBtnClick:(id)sender{
    NSLog(@"分享到微信");
    
    YKLTogetherShareViewController *VC = [YKLTogetherShareViewController new];
    VC.hidenBar = NO;
    VC.shareTitle = self.detailModel.title;
    VC.shareDesc = self.detailModel.shareDesc;
    VC.shareImg = self.detailModel.shareImage;
    VC.shareURL = self.detailModel.shareUrl;
    VC.actType = @"大砍价";
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)ewmBtnClick:(id)sender{
    NSLog(@"活动二维码");
    
    YKLEwmPosterViewController *postPreview = [YKLEwmPosterViewController new];
    
    postPreview.type = 1;
    
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

#pragma mark - 点击活动管理按钮 & YKLActManageViewDelegate & YKLActManagePopupViewDelegate

- (void)actManageDelegateClickedWithTag:(NSInteger)tag{

    switch (tag) {
        case 0:
            NSLog(@"更多");
            
            _actManagePopupView = [[YKLActManagePopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            _actManagePopupView.delegate = self;
            [_actManagePopupView createView:_actManageDict];
            [self.view addSubview:_actManagePopupView];
            
            break;
        case 1:
            NSLog(@"生成二维码");
            [self ewmBtnClick:nil];
            
            break;
        case 2:
            NSLog(@"订单管理");
            [self listButtonBtnClicked];
            
            break;
        case 3:
            NSLog(@"分享到微信");
            [self shareBtnClick:nil];
            
            break;
        case 4:
            NSLog(@"评论管理");
            [self commentButtonClicked];
            
            break;
        case 5:
            NSLog(@"停止活动");
            
            break;
        case 6:
            NSLog(@"飞鸽传书");
            
            break;
            
        default:
            break;
    }
}

- (void)didClickedWithTag:(NSInteger)tag{
    
    [self actManageDelegateClickedWithTag:tag];
}

- (void)actManagePopupViewDidClickedWithTag:(NSInteger)tag{
    
    [self actManageDelegateClickedWithTag:tag];
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
////    self.qRBgView.backgroundColor = [UIColor yellowColor];
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
////    self.rechargeAlertTitleLabel.backgroundColor = [UIColor redColor];
//    self.rechargeAlertTitleLabel.textColor = [UIColor grayColor];
//    self.rechargeAlertTitleLabel.text = [NSString stringWithFormat:@"商品名称:%@",self.detailModel.title];
//    self.rechargeAlertTitleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.qRBgView addSubview:self.rechargeAlertTitleLabel];
//    
//    self.qRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.rechargeAlertTitleLabel.bottom, 150, 150)];
////    self.qRImageView.backgroundColor = [UIColor blueColor];
//    self.qRImageView.image = [QRCodeGenerator qrImageForString:self.detailModel.shareUrl imageSize:self.qRImageView.bounds.size.width];
//    [self.qRBgView addSubview:self.qRImageView];
//    
//    return self.rechargeAlertBgView;
//}
//
//- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
//{
//    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
//    if (buttonIndex==1) {
//        NSLog(@"oooo");
//    }
//    [alertView close];
//}
//
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
//
//- (void)closeEwmAlertView{
//    [self customIOS7dialogButtonTouchUpInside:self.rechargeAlertView clickedButtonAtIndex:1];
//    
//}

#pragma mark - TWTSideMenuViewControllerDelegate

//- (UIStatusBarStyle)sideMenuViewController:(TWTSideMenuViewController *)sideMenuViewController statusBarStyleForViewController:(UIViewController *)viewController
//{
//    if (viewController == self.fansViewController) {
//        return UIStatusBarStyleLightContent;
//    } else {
//        return UIStatusBarStyleDefault;
//    }
//}

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

@end
