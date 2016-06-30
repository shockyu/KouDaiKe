//
//  YKLReleaseViewController.h
//  yklStore
//
//  Created by 肖震宇 on 15/9/20.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLReleaseViewController : YKLUserBaseViewController

@property BOOL isEndActivity;
@property BOOL activityIngHidden;//进行中活动修改砍价区间时的判断
@property (strong, nonatomic) NSString *endActivityID;
@property (strong, nonatomic) NSString *activityID;
@property (nonatomic, strong) NSMutableArray *actImageViewArr;

@property (strong, nonatomic) NSString *typePushStr;    //到店模式，促销模式
@property (strong, nonatomic) NSString *typePushNub;    //1,2
@property (strong, nonatomic) NSString *templateNub;
@property (strong, nonatomic) NSString *templatePrice;  //模板价格

@property (strong, nonatomic) NSString *shareTitle;     //分享标题
@property (strong, nonatomic) NSString *shareURL;       //分享URL
@property (strong, nonatomic) NSString *shareImage;     //分享图片
@property (strong, nonatomic) NSString *shareDesc;      //分享介绍

//@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;
@property (nonatomic, strong) UIView *bgView4;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *shareSaveBtn;//保存并分享到微信
@property (nonatomic, strong) UIButton *preViewBtn;//保存并分享到微信

@property (nonatomic, strong) UILabel *actTitleLabel;
@property (nonatomic, strong) UITextField *actTitleField;
@property (nonatomic, strong) UILabel *actPhotoLabel;
@property (nonatomic, strong) UIImageView *actImageView1;
@property (nonatomic, strong) UIImageView *actImageView2;
@property (nonatomic, strong) UIImageView *actImageView3;
@property (nonatomic, strong) UIImageView *actImageView4;
@property (nonatomic, strong) UIImageView *actImageView5;
@property (nonatomic, strong) UIButton *addImageBtn;

@property (nonatomic, strong) UILabel *actTemplateChangeLabel;
@property (nonatomic, strong) UIButton *actTemplateChangeBtn;
@property (nonatomic, strong) UILabel *actExpLabel;
@property (nonatomic, strong) UILabel *actExpTextLabel;
@property (nonatomic, strong) UILabel *actTemplateLabel;
@property (nonatomic, strong) UITextView *actIntroTextField;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UILabel *lowestPriceLabel;
@property (nonatomic, strong) UITextField *lowestPriceTextField;
@property (nonatomic, strong) UILabel *peducePriceLabel;
@property (nonatomic, strong) UILabel *peducePriceLabel2;
@property (nonatomic, strong) UITextField *startBargainTextField;
//@property (nonatomic, strong) UITextField *endBargainTextField;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UILabel *onlinePayLabel;
@property (nonatomic, strong) UITextField *onlinePayTextField;

@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UIButton *showEndTimebtn;
@property (nonatomic, strong) UILabel *securityLabel;
@property (nonatomic, strong) UITextField *securityTextField1;
@property (nonatomic, strong) UITextField *securityTextField2;
@property (nonatomic, strong) UITextField *securityTextField3;
@property (nonatomic, strong) UITextField *securityTextField4;
@property (nonatomic, strong) UILabel *isOverSmsLabel;
@property (nonatomic, strong) UIButton *selectYSMSBtn;
@property (nonatomic, strong) UIButton *selectNSMSBtn;

@property (nonatomic, strong) UILabel *showBasePrice;
@property (nonatomic, strong) UIButton *selectYPriceBtn;
@property (nonatomic, strong) UIButton *selectNPriceBtn;

@property (strong, nonatomic) NSArray *actIVs;
@property (strong, nonatomic) NSMutableArray *totle;
@property (strong, nonatomic) NSMutableArray *imageArr;

@property (strong, nonatomic) NSString *actImageView1_URL;

@property (nonatomic, strong) NSDate *selectedDate;



@end
