//
//  YKLReleaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/20.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLReleaseViewController.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"
#import "YKLMainMenuViewController.h"
#import "YKLReleaseTemplateViewController.h"
#import "SJAvatarBrowser.h"
#import "YKLLoginViewController.h"
//#import "YKLShareContentModel.h"
//#import "YKLShareViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLPushWebViewController.h"

#import "YKLPopupView.h"

@interface YKLReleaseViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>


@property int moneyNub;                                     //短信充值金额
@property  NSInteger orderStatus;                           //订单状态
@property (nonatomic, strong) NSString *content;            //支付内容
@property (nonatomic, strong) NSString *totleMoney;         //支付共计金额
@property (nonatomic, strong) NSMutableArray *payArray;     //支付返回pay数组
@property (nonatomic, strong) NSString *discount;           //折扣率
@property (nonatomic, strong) NSString *authorPrice;        //授权金额
@property (nonatomic, strong) NSString *balance;            //余额支付余额

@property (strong, nonatomic) NSArray *nubArray;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *pickerBgView;
@property (strong, nonatomic) UIPickerView *myPicker;

@property (strong, nonatomic) UIView *maskTimeView;
@property (strong, nonatomic) UIView *pickerBgTimeView;
@property (strong, nonatomic) UIDatePicker *myTimePicker;

@property (nonatomic, strong) UIView *bgImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;

@property int singelTap;

@property (nonatomic, strong) UIView *bgImageView2;
@property (nonatomic, strong) UIImageView *firstImageView2;
@property int singelTap2;

//是否为预览
@property BOOL preView;

//图片缓存，避免重复上传图片
@property (nonatomic, strong) NSString *imageJson;

@property (nonatomic, strong) YKLPopupView *PopupView;

@end

@implementation YKLReleaseViewController
bool hidAddImageBtn = NO;
NSInteger selectNub;        //上传图片总数
float myPercent;            //进度百分百
int HUDIndex;               //弹窗进度个数
bool isPhoto;               //是否先读取相册

- (instancetype)init{
    if (self = [super init]) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop  target:self action:@selector(activityLeftBarItemClicked:)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"question"]
                          forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showHelpView)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 25, 25);
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.totle = [[NSMutableArray alloc]init];
    
    self.actImageViewArr= [NSMutableArray array];
    self.imageArr = [NSMutableArray array];
    _imageJson = @"";
    
    hidAddImageBtn = NO;
    
    
    [self createBgView];
    [self initView];
    [self showTime];
    
    [self createContents];
    [self reloadImageView];
    
    _PopupView = [[YKLPopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
//    //未授权首次进入的帮助页面
//    if ([self.typePushNub isEqual:@"1"]) {
//        if ([[YKLLocalUserDefInfo defModel].secondHelp isEqualToString:@"YES"]) {
//            self.singelTap = 0;
//            [self createFirstView];
//        }
//    }else if ([self.typePushNub isEqual:@"2"]){
//        if ([[YKLLocalUserDefInfo defModel].onlinePayHelp isEqualToString:@"YES"]) {
//            self.singelTap2 = 0;
//            [self createFirstView2];
//        }
//    }
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    NSLog(@"%@",self.activityID);
    if (!(self.activityID == NULL)) {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"加载活动信息中";
        
        [YKLNetworkingConsumer getActivityInfoWithActivityID:self.activityID Success:^(NSDictionary *templateModel) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.onlinePayTextField.text = [templateModel objectForKey:@"online_pay_privilege"];
            
            self.actTitleField.text = [templateModel objectForKey:@"title"];
            
            self.actIntroTextField.text = [templateModel objectForKey:@"desc"];
            self.actIntroTextField.text =[self.actIntroTextField.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            
            self.priceTextField.text = [templateModel objectForKey:@"original_price"];
            self.lowestPriceTextField.text = [templateModel objectForKey:@"base_price"];
            self.startBargainTextField.text = [templateModel objectForKey:@"player_num"];
//            self.endBargainTextField.text = [templateModel objectForKey:@"end_bargain"];
            self.numberTextField.text = [templateModel objectForKey:@"product_num"];
            
            if (!(self.activityIngHidden)) {
                self.showEndTimebtn.titleLabel.text = [templateModel objectForKey:@"activity_end_time"];
            }
            
            //分解现场兑奖码
            NSString *rewardCodeStr = [templateModel objectForKey:@"reward_code"];
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
            
            self.actTemplateLabel.text = [[templateModel objectForKey:@"type"]isEqualToString:@"1"]?@"到店模式":@"促销模式";
            self.templateNub = [templateModel objectForKey:@"template_id"];
            self.typePushNub = [templateModel objectForKey:@"type"];
            self.shareURL = [templateModel objectForKey:@"share_url"];
            
            NSString *selectSMS = [templateModel objectForKey:@"is_over_sms"];
            NSString *selectPrice = [templateModel objectForKey:@"show_base_price"];
            if ([selectSMS isEqual:@"1"]) {
                self.selectNSMSBtn.selected = YES;//不发送
            }else{
                self.selectYSMSBtn.selected = YES;
            }
            
            if ([selectPrice isEqual:@"1"]) {
                self.selectYPriceBtn.selected = YES;//显示
            }else{
                self.selectNPriceBtn.selected = YES;
            }
            
            NSDictionary *templateDic = [templateModel objectForKey:@"template"];
            self.actExpTextLabel.text = [templateDic objectForKey:@"title"];
            self.templatePrice = [templateDic objectForKey:@"price"];
            self.shareImage = [templateDic objectForKey:@"share_img"];
            
            NSArray *tempArray = [[NSArray alloc] init];
            tempArray = [NSArray array];
            tempArray = [templateModel objectForKey:@"img"];
            
            if(IsEmpty(tempArray)){
                
                NSLog(@"图片数组为空");
            
            }else{
                selectNub = tempArray.count;
                if (tempArray.count == 5) {
                    [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    self.addImageBtn.backgroundColor = [UIColor clearColor];
                }
                
                for (int i = 0; i < tempArray.count; i++) {
                    
                    [self.actImageViewArr addObject:[tempArray[i] objectForKey:@"img_url"]];
                    UIImageView *imageView = self.actIVs[i];
                    //self.imageViewArr[i].userInteractionEnabled = YES;
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                    [self.actIVs[i] addGestureRecognizer:singleTap];
                    //imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.actImageViewArr[i]]]];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:self.actImageViewArr[i]] placeholderImage:[UIImage imageNamed:@"Demo"]];
                }
            }
            
        } failure:^(NSError *error) {
            [UIAlertView showErrorMsg:error.domain];
        }];
        
    }
    
    //如果本地存储活动字典不为空则加载其数据
    else if (![[YKLLocalUserDefInfo defModel].saveActInfoDict isEqual:@{}]&&[self.typePushNub isEqual:@"1"]) {
        
        NSMutableDictionary *tempDict = [YKLLocalUserDefInfo defModel].saveActInfoDict;
        
        self.actTitleField.text = [tempDict objectForKey:@"title"];
        self.actIntroTextField.text = [tempDict objectForKey:@"desc"];
        self.priceTextField.text = [tempDict objectForKey:@"original_price"];
        self.lowestPriceTextField.text = [tempDict objectForKey:@"base_price"];
        self.startBargainTextField.text = [tempDict objectForKey:@"player_num"];
//        self.endBargainTextField.text = [tempDict objectForKey:@"end_bargain"];
        self.numberTextField.text = [tempDict objectForKey:@"product_num"];
        
        [self.showEndTimebtn setTitle:[tempDict objectForKey:@"activity_end_time"] forState:UIControlStateNormal];
        
        //分解现场兑奖码
        NSString *rewardCodeStr = [tempDict objectForKey:@"reward_code"];
        if (![rewardCodeStr isEqual:@""]) {
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
        }
        
        self.actTemplateLabel.text = [tempDict objectForKey:@"type"];
        self.templateNub = [tempDict objectForKey:@"template_id"];
        self.shareURL = [tempDict objectForKey:@"share_url"];
        
        NSString *selectSMS = [tempDict objectForKey:@"is_over_sms"];
        NSString *selectPrice = [tempDict objectForKey:@"show_base_price"];
        
        if ([selectSMS isEqual:@"1"]) {
            self.selectNSMSBtn.selected = YES;//不发送
        }else{
            self.selectYSMSBtn.selected = YES;
        }
        
        if ([selectPrice isEqual:@"1"]) {
            self.selectYPriceBtn.selected = YES;//显示
        }else{
            self.selectNPriceBtn.selected = YES;
        }
        
        NSDictionary *templateDic = [tempDict objectForKey:@"template"];
        self.actExpTextLabel.text = [templateDic objectForKey:@"title"];
        self.templatePrice = [templateDic objectForKey:@"price"];
        self.shareImage = [templateDic objectForKey:@"share_img"];
        
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [NSArray array];
        tempArray = [tempDict objectForKey:@"img"];
        if(IsEmpty(tempArray)){
            NSLog(@"图片数组为空");
        }else{
            selectNub = tempArray.count;
            
            for (int i = 0; i < tempArray.count; i++) {
                
                //将data转换为image
                UIImage *_decodedImage = [UIImage imageWithData:tempArray[i]];
                UIImageView *imageView = self.actIVs[i];
                //self.imageViewArr[i].userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                [self.actIVs[i] addGestureRecognizer:singleTap];
                //imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.actImageViewArr[i]]]];
                [imageView setImage:_decodedImage];
            }
        }
    }
    else if (![[YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict isEqual:@{}]&&[self.typePushNub isEqual:@"2"]) {
        NSMutableDictionary *tempDict = [YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict;
        
        self.actTitleField.text = [tempDict objectForKey:@"title"];
        self.actIntroTextField.text = [tempDict objectForKey:@"desc"];
        self.priceTextField.text = [tempDict objectForKey:@"original_price"];
        self.lowestPriceTextField.text = [tempDict objectForKey:@"base_price"];
        self.startBargainTextField.text = [tempDict objectForKey:@"player_num"];
//        self.endBargainTextField.text = [tempDict objectForKey:@"end_bargain"];
        self.numberTextField.text = [tempDict objectForKey:@"product_num"];
        
        [self.showEndTimebtn setTitle:[tempDict objectForKey:@"activity_end_time"] forState:UIControlStateNormal];
        
        //分解现场兑奖码
        NSString *rewardCodeStr = [tempDict objectForKey:@"reward_code"];
        if (![rewardCodeStr isEqual:@""]) {
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
        }
        
        self.actTemplateLabel.text = [tempDict objectForKey:@"type"];
        self.templateNub = [tempDict objectForKey:@"template_id"];
        self.shareURL = [tempDict objectForKey:@"share_url"];
        
        NSString *selectSMS = [tempDict objectForKey:@"is_over_sms"];
        NSString *selectPrice = [tempDict objectForKey:@"show_base_price"];
        
        if ([selectSMS isEqual:@"1"]) {
            self.selectNSMSBtn.selected = YES;//不发送
        }else{
            self.selectYSMSBtn.selected = YES;
        }
        
        if ([selectPrice isEqual:@"1"]) {
            self.selectYPriceBtn.selected = YES;//显示
        }else{
            self.selectNPriceBtn.selected = YES;
        }
        
        NSDictionary *templateDic = [tempDict objectForKey:@"template"];
        self.actExpTextLabel.text = [templateDic objectForKey:@"title"];
        self.templatePrice = [templateDic objectForKey:@"price"];
        self.shareImage = [templateDic objectForKey:@"share_img"];
        
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [NSArray array];
        tempArray = [tempDict objectForKey:@"img"];
        if(IsEmpty(tempArray)){
            NSLog(@"图片数组为空");
        }else{
            selectNub = tempArray.count;
            
            for (int i = 0; i < tempArray.count; i++) {
                
                //将data转换为image
                UIImage *_decodedImage = [UIImage imageWithData:tempArray[i]];
                UIImageView *imageView = self.actIVs[i];
                //self.imageViewArr[i].userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                [self.actIVs[i] addGestureRecognizer:singleTap];
                //imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.actImageViewArr[i]]]];
                [imageView setImage:_decodedImage];
            }
        }
        self.onlinePayTextField.text = [tempDict objectForKey:@"online_pay_privilege"];
    }
    
    //提示文本，加载更多请下拉
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-50,64, 50, 50)];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 0.5;
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"加载更多请上拉";
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 25;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    
}

- (void)activityLeftBarItemClicked:(UIBarButtonItem *)sender {
    if (self.activityID == NULL) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否保存活动到草稿箱？" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        
        [alertView show];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否放弃当前修改的活动信息？" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
        
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 6001) {
        return;
    }
    
    if (buttonIndex == 0) {
        
        //保存到本地
        [self saveDictForFiled];
        
        //发布活动键盘未收起推出时闪屏修改,延迟两个0.25来执行键盘收起的动画。
        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        
    }else if (buttonIndex == 1){
        
        if (self.activityID == NULL) {
            [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        }else{
            
        }
    }
}

- (void)popHidden{
    
    if (self.activityID == NULL) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
 
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
    if ([self.typePushNub isEqual:@"1"]) {
        //首次进入弹出帮助页面
        if ([[YKLLocalUserDefInfo defModel].bargainDDHelp isEqual:@"YES"]) {
            
            [self showHelpView];
            
            [YKLLocalUserDefInfo defModel].bargainDDHelp = @"NO";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        }
    }
    else if ([self.typePushNub isEqual:@"2"]){
        
        //首次进入弹出帮助页面
        if ([[YKLLocalUserDefInfo defModel].bargainCXHelp isEqual:@"YES"]) {
            
            [self showHelpView];
            
            [YKLLocalUserDefInfo defModel].bargainCXHelp = @"NO";
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        }

    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.typePushStr;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)createFirstView{
    
    self.bgImageView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.bgImageView];
    
    self.firstImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页引导页3"]];
    self.firstImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.firstImageView];
    
    self.secondImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页引导页4"]];
    self.secondImageView.hidden = YES;
    self.secondImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.secondImageView];
    
    self.thirdImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页引导页5"]];
    self.thirdImageView.hidden = YES;
    self.thirdImageView.frame = self.view.frame;
    [self.bgImageView addSubview:self.thirdImageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.bgImageView addGestureRecognizer:singleTap];
}


- (void)singleTap:(UITapGestureRecognizer *)sender{
   
    self.singelTap++;
    if (self.singelTap == 1) {
        self.secondImageView.hidden = NO;
    }
    if (self.singelTap == 2) {
        self.thirdImageView.hidden = NO;
    }
    if (self.singelTap == 3) {
        self.firstImageView.hidden = YES;
        self.secondImageView.hidden = YES;
        self.thirdImageView.hidden = YES;
        self.bgImageView.hidden = YES;
        [YKLLocalUserDefInfo defModel].secondHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

- (void)createFirstView2{
    
    self.bgImageView2 = [[UIView alloc]initWithFrame:self.view.frame];
    [super.view addSubview:self.bgImageView2];
    
    self.firstImageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"在线支付"]];
    self.firstImageView2.frame = self.view.frame;
    [self.bgImageView2 addSubview:self.firstImageView2];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap2:)];
    [self.bgImageView2 addGestureRecognizer:singleTap2];
}


- (void)singleTap2:(UITapGestureRecognizer *)sender{
    
    self.singelTap2++;
    if (self.singelTap2 == 1) {
        self.firstImageView2.hidden = YES;
        self.bgImageView2.hidden = YES;
        [YKLLocalUserDefInfo defModel].onlinePayHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    
    if([self.typePushNub isEqual:@"2"]){
        self.scrollView.contentSize = CGSizeMake(self.view.width, 598+90+(self.view.width-60)/5+10+190+90+45-45+50);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.view.width, 598+90+(self.view.width-60)/5+10+190+90-45+50);
    }
    
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, 90+(self.view.width-60)/5+10)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 1)];
    self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView1 addSubview:self.lineView ];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 223+190)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
    for (int i = 1; i<4; i++) {
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*i, self.view.width, 1)];
        self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView2 addSubview:self.lineView ];
    }
    
    if([self.typePushNub isEqual:@"2"]){
        self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+10, self.view.width, 180+45)];
        self.bgView3.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.bgView3];
        
        for (int i = 1; i<5; i++) {
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*i, self.view.width, 1)];
            self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
            [self.bgView3 addSubview:self.lineView ];
        }
    }else{
        self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+10, self.view.width, 180)];
        self.bgView3.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.bgView3];
        
        for (int i = 1; i<4; i++) {
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*i, self.view.width, 1)];
            self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
            [self.bgView3 addSubview:self.lineView ];
        }
    }
    
    self.bgView4 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView3.bottom+10, self.view.width, 90+90-45)];
    self.bgView4.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView4];
    
    for (int i = 1; i < 3; i++) {
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45*i, self.view.width, 1)];
        self.lineView.backgroundColor = [UIColor flatLightWhiteColor];
        [self.bgView4 addSubview:self.lineView ];
    }
    
    self.preViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preViewBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
    [self.preViewBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.preViewBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.preViewBtn.backgroundColor = [UIColor flatLightRedColor];
    self.preViewBtn.layer.cornerRadius = 20;
    self.preViewBtn.layer.masksToBounds = YES;
    self.preViewBtn.frame = CGRectMake(15,self.bgView4.bottom+15,self.view.width-30,40);
    self.preViewBtn.tag = 6001;
    [self.preViewBtn addTarget:self action:@selector(shareSaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview: self.preViewBtn];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.preViewBtn.width/2+20, 0, 100, 40)];
    textLabel.centerY = self.preViewBtn.height/2;
    textLabel.font = [UIFont systemFontOfSize:10];
    textLabel.text = @"(可试听音乐)";
    textLabel.textColor = [UIColor whiteColor];
    [self.preViewBtn addSubview:textLabel];
    
    self.shareSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareSaveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.shareSaveBtn setTitle:@"保存并分享到微信" forState:UIControlStateNormal];
    [self.shareSaveBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.shareSaveBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.shareSaveBtn.backgroundColor = [UIColor flatLightRedColor];
    self.shareSaveBtn.layer.cornerRadius = 20;
    self.shareSaveBtn.layer.masksToBounds = YES;
    self.shareSaveBtn.frame = CGRectMake(15,self.preViewBtn.bottom+10,self.view.width-30,40);
    
    [self.shareSaveBtn addTarget:self action:@selector(shareSaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //    if (self.activityIngHidden) {
    //        [self.shareSaveBtn addTarget:self action:@selector(shareSaveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    }else{
    //        [self.shareSaveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    
    [self.scrollView addSubview: self.shareSaveBtn];
    
    
}

- (void)createContents{
    
    //活动主题
    self.actTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    self.actTitleLabel.backgroundColor = [UIColor clearColor];
    self.actTitleLabel.font = [UIFont systemFontOfSize:14];
    self.actTitleLabel.textColor = [UIColor blackColor];
    self.actTitleLabel.text = @"商品名称";
    [self.bgView1 addSubview:self.actTitleLabel];
    
    self.actTitleField = [[UITextField alloc] initWithFrame:CGRectMake(self.actTitleLabel.right, 0, self.view.width-self.actTitleLabel.right-20, 45)];
    self.actTitleField.keyboardType = UIKeyboardTypeDefault;
    self.actTitleField.backgroundColor = [UIColor clearColor];
    //    self.actTitleField.delegate = self;
    self.actTitleField.font = [UIFont systemFontOfSize:14];
    self.actTitleField.returnKeyType = UIReturnKeyNext;
    self.actTitleField.placeholder = @"请输入商品名称";
    self.actTitleField.enabled = self.activityIngHidden;
    [self.bgView1 addSubview:self.actTitleField];
    
    self.actPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.actTitleField.bottom, 100, 45)];
    self.actPhotoLabel.backgroundColor = [UIColor clearColor];
    self.actPhotoLabel.font = [UIFont systemFontOfSize:14];
    self.actPhotoLabel.textColor = [UIColor blackColor];
    self.actPhotoLabel.text = @"活动照片";
    [self.bgView1 addSubview:self.actPhotoLabel];
    
    self.actPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actTitleLabel.right, self.actTitleLabel.bottom, self.view.width-self.actTitleLabel.right-20, 45)];
    self.actPhotoLabel.backgroundColor = [UIColor clearColor];
    self.actPhotoLabel.font = [UIFont systemFontOfSize:14];
    self.actPhotoLabel.textColor = [UIColor lightGrayColor];
    self.actPhotoLabel.text = @"(请注意：最多添加3张图片哦)";
    [self.bgView1 addSubview:self.actPhotoLabel];
    
    //活动模板选择
    self.actTemplateChangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    self.actTemplateChangeLabel.backgroundColor = [UIColor clearColor];
    self.actTemplateChangeLabel.font = [UIFont systemFontOfSize:14];
    self.actTemplateChangeLabel.textColor = [UIColor blackColor];
    self.actTemplateChangeLabel.text = @"活动模板选择";
    [self.bgView2 addSubview:self.actTemplateChangeLabel];
    
    self.actTemplateChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actTemplateChangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [self.actTemplateChangeBtn setTitle:@"" forState:UIControlStateNormal];
    [self.actTemplateChangeBtn setImage:[UIImage imageNamed:@"箭头默认"] forState:UIControlStateNormal];
    [self.actTemplateChangeBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.actTemplateChangeBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    //    self.actTemplateChangeBtn.backgroundColor = [UIColor flatLightYellowColor];
    //    self.actTemplateChangeBtn.layer.cornerRadius = 20;
    //    self.actTemplateChangeBtn.layer.masksToBounds = YES;
    //    self.actTemplateChangeBtn.layer.borderColor = [UIColor flatLightRedColor].CGColor;
    //    self.actTemplateChangeBtn.layer.borderWidth = 1;
    self.actTemplateChangeBtn.frame = CGRectMake(self.view.width-60, 15, 50, 15);
    [self.actTemplateChangeBtn addTarget:self action:@selector(actTemplateChangeBtnClickClick:) forControlEvents:UIControlEventTouchUpInside];
    self.actTemplateChangeBtn.enabled = self.activityIngHidden;
    [self.bgView2 addSubview: self.actTemplateChangeBtn];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, self.view.width, 45);
    setBtn.backgroundColor = [UIColor clearColor];
    [setBtn addTarget:self action:@selector(actTemplateChangeBtnClickClick:) forControlEvents:UIControlEventTouchUpInside];
    setBtn.enabled = self.activityIngHidden;
    [self.bgView2 addSubview: setBtn];
    
    
    self.actExpTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actTemplateChangeLabel.right, 0, self.view.width-self.actTemplateChangeLabel.right-80, 45)];
    self.actExpTextLabel.backgroundColor = [UIColor clearColor];
    self.actExpTextLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView2 addSubview:self.actExpTextLabel];
    
    self.actTemplateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.actTemplateChangeLabel.bottom, self.bgView2.width, 45)];
    //    10, self.actTemplateChangeLabel.bottom, 100, 45
    self.actTemplateLabel.backgroundColor = [UIColor clearColor];
    self.actTemplateLabel.font = [UIFont systemFontOfSize:14];
    self.actTemplateLabel.textColor = [UIColor blackColor];
    //  已选活动类型，到店模式，促销模式。
    self.actTemplateLabel.text = [NSString stringWithFormat:@"%@",self.typePushStr] ;
    self.actTemplateLabel.textColor = [UIColor flatLightRedColor];
    [self.bgView2 addSubview:self.actTemplateLabel];
    
    self.actExpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.actTemplateLabel.bottom, self.view.width-20, 45)];
    //    10, self.actExpLabel.bottom, self.view.width-20, 45
    self.actExpLabel.backgroundColor = [UIColor clearColor];
    self.actExpLabel.font = [UIFont systemFontOfSize:14];
    self.actExpLabel.textColor = [UIColor blackColor];
    self.actExpLabel.text = @"活动说明（请根据需要自行修改）";
    [self.bgView2 addSubview:self.actExpLabel];
    
    self.actIntroTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, self.actExpLabel.bottom, self.view.width-20, 88+190)];
    self.actIntroTextField.keyboardType = UIKeyboardTypeDefault;
    self.actIntroTextField.backgroundColor = [UIColor clearColor];
//        self.actIntroTextField.delegate = self;
    self.actIntroTextField.font = [UIFont systemFontOfSize:14];
    self.actIntroTextField.returnKeyType = UIReturnKeyNext;
    //    self.actIntroTextField.placeholder = @"活动说明：可以放一个默认模板";
    self.actIntroTextField.text = @"活动规则：\n1.参与活动，输入手机号码，即可邀请好友帮忙；\n2.活动页面产品图片及信息仅供参照，产品以实物为准；\n3.参与活动成功后，会收到短信提醒，请在兑奖期内到本店兑换活动产品。活动未成功，也可以凭您的最终价格到本店购买；\n4.兑奖只以活动兑奖页面为准，截图或短信均为无效；\n5.活动期间奖品数量有限，先到先得，发完为止；\n6.活动开始后本规则将自动生效并表明参加者已接受；\n7.本活动最终解释权归本店所有。";
    
    self.actIntroTextField.editable = self.activityIngHidden;
    [self.bgView2 addSubview:self.actIntroTextField];
    
    //原价
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 45)];
    self.priceLabel.backgroundColor = [UIColor clearColor];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = [UIColor blackColor];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.text = @"原价";
    [self.bgView3 addSubview:self.priceLabel];
    
    self.priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.priceLabel.right+20, 0, self.view.width-self.priceLabel.right-20, 45)];
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceTextField.backgroundColor = [UIColor clearColor];
//    self.priceTextField.delegate = self;
    self.priceTextField.font = [UIFont systemFontOfSize:14];
    self.priceTextField.returnKeyType = UIReturnKeyNext;
    self.priceTextField.placeholder = @"元";
    self.priceTextField.enabled = self.activityIngHidden;
    [self.bgView3 addSubview:self.priceTextField];
    
    self.lowestPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.priceLabel.bottom, 80, 45)];
    self.lowestPriceLabel.backgroundColor = [UIColor clearColor];
    self.lowestPriceLabel.font = [UIFont systemFontOfSize:14];
    self.lowestPriceLabel.textColor = [UIColor blackColor];
    self.lowestPriceLabel.textAlignment = NSTextAlignmentRight;
    self.lowestPriceLabel.text = @"最低砍到";
    [self.bgView3 addSubview:self.lowestPriceLabel];
    
    self.lowestPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.lowestPriceLabel.right+20, self.priceLabel.bottom, self.view.width-self.lowestPriceLabel.right-20, 45)];
    self.lowestPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.lowestPriceTextField.backgroundColor = [UIColor clearColor];
//    self.lowestPriceTextField.delegate = self;
    self.lowestPriceTextField.font = [UIFont systemFontOfSize:14];
    self.lowestPriceTextField.returnKeyType = UIReturnKeyNext;
    self.lowestPriceTextField.placeholder = @"元";
    self.lowestPriceTextField.enabled = self.activityIngHidden;
    [self.bgView3 addSubview:self.lowestPriceTextField];
    
    self.peducePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.lowestPriceLabel.bottom, 80, 45)];
    self.peducePriceLabel.backgroundColor = [UIColor clearColor];
    self.peducePriceLabel.font = [UIFont systemFontOfSize:14];
    self.peducePriceLabel.textColor = [UIColor blackColor];
    self.peducePriceLabel.textAlignment = NSTextAlignmentRight;
    self.peducePriceLabel.text = @"需要";
    [self.bgView3 addSubview:self.peducePriceLabel];
    
    self.startBargainTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.peducePriceLabel.right+20, self.lowestPriceLabel.bottom, 80, 45)];
    self.startBargainTextField.keyboardType = UIKeyboardTypeNumberPad;
//    self.startBargainTextField.backgroundColor = [UIColor blueColor];
    self.startBargainTextField.delegate = self;
    self.startBargainTextField.font = [UIFont systemFontOfSize:14];
    self.startBargainTextField.returnKeyType = UIReturnKeyNext;
    self.startBargainTextField.placeholder = @"多少";
    [self.bgView3 addSubview:self.startBargainTextField];
    
    self.peducePriceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.startBargainTextField.right, self.lowestPriceLabel.bottom, 100, 45)];
    //    self.peducePriceLabel2.backgroundColor = [UIColor redColor];
    self.peducePriceLabel2.font = [UIFont systemFontOfSize:14];
    self.peducePriceLabel2.textColor = [UIColor blackColor];
    self.peducePriceLabel2.text = @"人完成砍价";
    [self.bgView3 addSubview:self.peducePriceLabel2];
    
//    self.endBargainTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.peducePriceLabel2.right+15, self.lowestPriceLabel.bottom, (self.view.width-self.peducePriceLabel.right-20)/2-20, 45)];
//    self.endBargainTextField.keyboardType = UIKeyboardTypeDecimalPad;
////        self.endBargainTextField.backgroundColor = [UIColor blueColor];
//    self.endBargainTextField.delegate = self;
//    self.endBargainTextField.font = [UIFont systemFontOfSize:14];
//    self.endBargainTextField.returnKeyType = UIReturnKeyNext;
//    self.endBargainTextField.placeholder = @"最高砍(元)";
//    self.endBargainTextField.textAlignment = NSTextAlignmentRight;
//    [self.bgView3 addSubview:self.endBargainTextField];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.peducePriceLabel.bottom, 80, 45)];
    self.numberLabel.backgroundColor = [UIColor clearColor];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    self.numberLabel.textColor = [UIColor blackColor];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    self.numberLabel.text = @"产品个数";
    [self.bgView3 addSubview:self.numberLabel];
    
    self.numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.numberLabel.right+20, self.peducePriceLabel.bottom, self.view.width-self.numberLabel.right-20, 45)];
    self.numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberTextField.backgroundColor = [UIColor clearColor];
    self.numberTextField.delegate = self;
    self.numberTextField.font = [UIFont systemFontOfSize:14];
    self.numberTextField.returnKeyType = UIReturnKeyNext;
    self.numberTextField.placeholder = @"个";
    self.numberTextField.enabled = self.activityIngHidden;
    [self.bgView3 addSubview:self.numberTextField];
    
    self.onlinePayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.numberLabel.bottom, 90, 45)];
    self.onlinePayLabel.backgroundColor = [UIColor clearColor];
    self.onlinePayLabel.font = [UIFont systemFontOfSize:14];
    self.onlinePayLabel.textColor = [UIColor blackColor];
    self.onlinePayLabel.textAlignment = NSTextAlignmentRight;
    self.onlinePayLabel.text = @"在线支付再减";
    
    
    self.onlinePayTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.onlinePayLabel.right+20, self.numberLabel.bottom, self.view.width-self.onlinePayLabel.right-20, 45)];
    self.onlinePayTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.onlinePayTextField.backgroundColor = [UIColor clearColor];
    self.onlinePayTextField.delegate = self;
    self.onlinePayTextField.font = [UIFont systemFontOfSize:14];
    self.onlinePayTextField.returnKeyType = UIReturnKeyNext;
    self.onlinePayTextField.placeholder = @"元";
    self.onlinePayTextField.enabled = self.activityIngHidden;
    self.onlinePayTextField.text = @"";
    
    if([self.typePushNub isEqual:@"2"]){
        [self.bgView3 addSubview:self.onlinePayLabel];
        [self.bgView3 addSubview:self.onlinePayTextField];
    }

    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 45)];
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textColor = [UIColor blackColor];
    self.endTimeLabel.text = @"活动截止时间";
    [self.bgView4 addSubview:self.endTimeLabel];
    
    self.showEndTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showEndTimebtn.frame = CGRectMake(self.endTimeLabel.right, 0, self.view.width-self.endTimeLabel.right-2, 45);
    [self.showEndTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.showEndTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    //当前时间
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    //
    [self.showEndTimebtn setTitle:@"请点击设置活动截止时间" forState:UIControlStateNormal];
    [self.showEndTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.showEndTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.showEndTimebtn.enabled = self.activityIngHidden;
    [self.bgView4 addSubview:self.showEndTimebtn];
    
    self.securityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.endTimeLabel.bottom, 100, 45)];
    self.securityLabel.backgroundColor = [UIColor clearColor];
    self.securityLabel.font = [UIFont systemFontOfSize:14];
    self.securityLabel.textColor = [UIColor blackColor];
    self.securityLabel.text = @"现场兑奖码";
    [self.bgView4 addSubview:self.securityLabel];
    
    self.securityTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityLabel.right, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField1.textAlignment = NSTextAlignmentCenter;
    self.securityTextField1.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField1.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField1.delegate = self;
    self.securityTextField1.font = [UIFont systemFontOfSize:14];
    self.securityTextField1.returnKeyType = UIReturnKeyNext;
    self.securityTextField1.text = @"0";
    self.securityTextField1.enabled = self.activityIngHidden;
    [self.bgView4 addSubview:self.securityTextField1];
    
    self.securityTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField1.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField2.textAlignment = NSTextAlignmentCenter;
    self.securityTextField2.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField2.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField2.delegate = self;
    self.securityTextField2.font = [UIFont systemFontOfSize:14];
    self.securityTextField2.returnKeyType = UIReturnKeyNext;
    self.securityTextField2.enabled = self.activityIngHidden;
    self.securityTextField2.text = @"0";
    [self.bgView4 addSubview:self.securityTextField2];
    
    self.securityTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField2.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField3.textAlignment = NSTextAlignmentCenter;
    self.securityTextField3.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField3.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField3.delegate = self;
    self.securityTextField3.font = [UIFont systemFontOfSize:14];
    self.securityTextField3.returnKeyType = UIReturnKeyNext;
    self.securityTextField3.enabled = self.activityIngHidden;
    self.securityTextField3.text = @"0";
    [self.bgView4 addSubview:self.securityTextField3];
    
    self.securityTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField3.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField4.textAlignment = NSTextAlignmentCenter;
    self.securityTextField4.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField4.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField4.delegate = self;
    self.securityTextField4.font = [UIFont systemFontOfSize:14];
    self.securityTextField4.returnKeyType = UIReturnKeyNext;
    self.securityTextField4.enabled = self.activityIngHidden;
    self.securityTextField4.text = @"0";
    [self.bgView4 addSubview:self.securityTextField4];
    
    UIButton *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    securityBtn.backgroundColor = [UIColor clearColor];
    securityBtn.frame = CGRectMake(self.securityLabel.right, self.endTimeLabel.bottom+10, 130, 25);
    [securityBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    securityBtn.enabled = self.activityIngHidden;
    [self.bgView4 addSubview:securityBtn];
    
    self.isOverSmsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.securityLabel.bottom, 160, 45)];
    self.isOverSmsLabel.backgroundColor = [UIColor clearColor];
    self.isOverSmsLabel.font = [UIFont systemFontOfSize:14];
    self.isOverSmsLabel.textColor = [UIColor blackColor];
    self.isOverSmsLabel.text = @"未砍价成功是否发送短信";
//    [self.bgView4 addSubview:self.isOverSmsLabel];
    
    self.selectYSMSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectYSMSBtn.frame = CGRectMake(self.isOverSmsLabel.right+10,self.isOverSmsLabel.top,45,45);
    [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateSelected];
    [self.selectYSMSBtn addTarget:self action:@selector(selectYSMSBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView4 addSubview:self.selectYSMSBtn];
    
    UILabel *Ylabel =[[UILabel alloc] initWithFrame:CGRectMake(self.selectYSMSBtn.right,self.isOverSmsLabel.top, 15, 45)];
    Ylabel.backgroundColor = [UIColor clearColor];
    Ylabel.font = [UIFont systemFontOfSize:14];
    Ylabel.textColor = [UIColor blackColor];
    Ylabel.text = @"是";
//    [self.bgView4 addSubview:Ylabel];
    
    self.selectNSMSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectNSMSBtn.frame = CGRectMake(Ylabel.right+10,self.isOverSmsLabel.top,45,45);
    [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateSelected];
    [self.selectNSMSBtn addTarget:self action:@selector(selectNSMSBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if (self.activityID == NULL) {
        self.selectNSMSBtn.selected = YES;//默认短信不发送
    }
//    [self.bgView4 addSubview:self.selectNSMSBtn];
    
    UILabel *Nlabel =[[UILabel alloc] initWithFrame:CGRectMake(self.selectNSMSBtn.right,self.isOverSmsLabel.top, 15, 45)];
    Nlabel.backgroundColor = [UIColor clearColor];
    Nlabel.font = [UIFont systemFontOfSize:14];
    Nlabel.textColor = [UIColor blackColor];
    Nlabel.text = @"否";
//    [self.bgView4 addSubview:Nlabel];
    
    self.showBasePrice = [[UILabel alloc] initWithFrame:CGRectMake(10, self.securityLabel.bottom, 100, 45)];
    self.showBasePrice.backgroundColor = [UIColor clearColor];
    self.showBasePrice.font = [UIFont systemFontOfSize:14];
    self.showBasePrice.textColor = [UIColor blackColor];
    self.showBasePrice.text = @"是否显示底价";
    [self.bgView4 addSubview:self.showBasePrice];
    
    self.selectYPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectYPriceBtn.frame = CGRectMake(self.showBasePrice.right+10,self.showBasePrice.top,45,45);
    [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateSelected];
    [self.selectYPriceBtn addTarget:self action:@selector(selectYPriceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if (self.activityID == NULL) {
        self.selectYPriceBtn.selected = YES;//显示底价
    }
    [self.bgView4 addSubview:self.selectYPriceBtn];
    
    UILabel *Ylabel2 =[[UILabel alloc] initWithFrame:CGRectMake(self.selectYPriceBtn.right,self.showBasePrice.top, 30, 45)];
    Ylabel2.backgroundColor = [UIColor clearColor];
    Ylabel2.font = [UIFont systemFontOfSize:14];
    Ylabel2.textColor = [UIColor blackColor];
    Ylabel2.text = @"是";
    [self.bgView4 addSubview:Ylabel2];
    
    self.selectNPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectNPriceBtn.frame = CGRectMake(Ylabel2.right+10,self.showBasePrice.top,45,45);
    [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateSelected];
    [self.selectNPriceBtn addTarget:self action:@selector(selectNPriceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView4 addSubview:self.selectNPriceBtn];
    
    UILabel *Nlabel2 =[[UILabel alloc] initWithFrame:CGRectMake(self.selectNPriceBtn.right,self.showBasePrice.top, 30, 45)];
    Nlabel2.backgroundColor = [UIColor clearColor];
    Nlabel2.font = [UIFont systemFontOfSize:14];
    Nlabel2.textColor = [UIColor blackColor];
    Nlabel2.text = @"否";
    [self.bgView4 addSubview:Nlabel2];

    
}

#pragma mark - init view
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = ScreenWidth;
    
    self.pickerBgView = [[UIView alloc]initWithFrame: CGRectMake(0, 100, ScreenWidth, 266)];
    self.pickerBgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [yesBtn setBackgroundColor: [UIColor clearColor]];
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [yesBtn addTarget:self action:@selector(ensure:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:yesBtn];
    
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.pickerBgView.width-50, 0, 50, 30)];
    [noBtn setBackgroundColor: [UIColor clearColor]];
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [noBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgView addSubview:noBtn];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"兑换码滚轮"]];
    imageView.frame = CGRectMake(0, 50, ScreenWidth, 216);
    [self.pickerBgView addSubview:imageView];

    self.myPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 216)];
    // 显示选中框
    self.myPicker.showsSelectionIndicator=YES;
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    [self.pickerBgView addSubview:self.myPicker];
    
    self.nubArray = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)row];
    return str;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 80;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"HANG%@",[_nubArray objectAtIndex:row]);

}

#pragma mark - private method
- (void)showMyPicker:(id)sender {
    [self hidenKeyboard];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (void)cancel:(id)sender {
    [self hideMyPicker];
}

- (void)ensure:(id)sender {
    
    self.securityTextField1.text = [self.nubArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    self.securityTextField2.text = [self.nubArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    self.securityTextField3.text = [self.nubArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
    self.securityTextField4.text = [self.nubArray objectAtIndex:[self.myPicker selectedRowInComponent:3]];
    
    [self hideMyPicker];
}

- (void)showTime{
    
    self.maskTimeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskTimeView.backgroundColor = [UIColor blackColor];
    self.maskTimeView.alpha = 0;
    [self.maskTimeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyTimePicker)]];
    
    self.pickerBgTimeView.width = ScreenWidth;
    
    self.pickerBgTimeView = [[UIView alloc]initWithFrame: CGRectMake(0, 100, ScreenWidth, 266)];
    self.pickerBgTimeView.backgroundColor = [UIColor whiteColor];
    
    UIButton *yesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [yesBtn setBackgroundColor: [UIColor clearColor]];
    [yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [yesBtn addTarget:self action:@selector(ensureTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgTimeView addSubview:yesBtn];
    
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.pickerBgView.width-50, 0, 50, 30)];
    [noBtn setBackgroundColor: [UIColor clearColor]];
    [noBtn setTitle:@"取消" forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [noBtn addTarget:self action:@selector(cancelTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerBgTimeView addSubview:noBtn];
    
    NSDate *minDate =[NSDate dateWithTimeIntervalSinceNow:0];//最小时间不小于今天
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Date滚轮"]];
    imageView.frame = CGRectMake(0, 50, ScreenWidth, 216);
    [self.pickerBgTimeView addSubview:imageView];
    
    self.myTimePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 216)];
    self.myTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.myTimePicker.datePickerMode = UIDatePickerModeDate;
    self.myTimePicker.minimumDate = minDate;
    
    [self.pickerBgTimeView addSubview:self.myTimePicker];
    
}

//显示时间选择器
#pragma mark - private method
- (void)showMyTimePicker:(id)sender {
    [self hidenKeyboard];
    
    [self.view addSubview:self.maskTimeView];
    [self.view addSubview:self.pickerBgTimeView];
    self.maskTimeView.alpha = 0;
    self.pickerBgTimeView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskTimeView.alpha = 0.3;
        self.pickerBgTimeView.bottom = self.view.height;
    }];
}

- (void)hideMyTimePicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskTimeView.alpha = 0;
        self.pickerBgTimeView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskTimeView removeFromSuperview];
        [self.pickerBgTimeView removeFromSuperview];
    }];
}

- (void)cancelTime:(id)sender {
    [self hideMyTimePicker];
}

- (void)ensureTime:(id)sender {
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDate *selected = [self.myTimePicker date];
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =  [NSString stringWithFormat:
                          @"%@", destDateString];
    
    [self.showEndTimebtn setTitle:message forState:UIControlStateNormal];
    
    [self hideMyTimePicker];
    
}

bool isHaveDian;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Check for non-numeric characters
    
//    NSUInteger lengthOfString = string.length;
    
//    if (textField == self.startBargainTextField||textField == self.endBargainTextField) {
//        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
//            unichar character = [string characterAtIndex:loopIndex];
//            if (character < 48) return NO; // 48 unichar for 0
//            if (character > 57) return NO; // 57 unichar for 9
//        }
//        // Check for total length
//        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
//        if (proposedNewLength > 4) return NO;//限制长度
//    }
//    if (textField == self.securityTextField1||textField == self.securityTextField2||textField == self.securityTextField3||textField == self.securityTextField4) {
//        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
//            unichar character = [string characterAtIndex:loopIndex];
//            if (character < 48) return NO; // 48 unichar for 0
//            if (character > 57) return NO; // 57 unichar for 9
//        }
//        // Check for total length
//        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
//        if (proposedNewLength > 1) return NO;//限制长度
//    }
    return YES;
}


- (void)reloadImageView{
    
    self.actImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView1.userInteractionEnabled = YES;
    self.actImageView1.backgroundColor = [UIColor whiteColor];
    [self.bgView1 addSubview:self.actImageView1];
    
    self.actImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView1.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView2.userInteractionEnabled = YES;
    self.actImageView2.backgroundColor = [UIColor whiteColor];
    [self.bgView1 addSubview:self.actImageView2];
    
    self.actImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView2.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView3.userInteractionEnabled = YES;
    self.actImageView3.backgroundColor = [UIColor whiteColor];
    [self.bgView1 addSubview:self.actImageView3];
    
    self.actImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView3.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView4.userInteractionEnabled = YES;
    self.actImageView4.backgroundColor = [UIColor whiteColor];
    [self.bgView1 addSubview:self.actImageView4];
    
    self.actImageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(self.actImageView4.right+10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5)];
    self.actImageView5.userInteractionEnabled = YES;
    self.actImageView5.backgroundColor = [UIColor whiteColor];
    [self.bgView1 addSubview:self.actImageView5];
    
    _actIVs = @[self.actImageView1,self.actImageView2,self.actImageView3,self.actImageView4,self.actImageView5];
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [self.addImageBtn sizeToFit];
    self.addImageBtn.frame = CGRectMake(self.view.width-(self.view.width-60)/5-10,self.actPhotoLabel.bottom,(self.view.width-60)/5,(self.view.width-60)/5);
    [self.addImageBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.addImageBtn setHidden:hidAddImageBtn];
    
    if (hidAddImageBtn) {
        [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.addImageBtn.backgroundColor = [UIColor clearColor];

    }
    
    self.addImageBtn.enabled = self.activityIngHidden;
    [self.bgView1 addSubview:self.addImageBtn];
}

- (void)addImageBtnClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    
    [self hidenKeyboard];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 ) {
        
//        //清空本地
//        _imageJson = @"";
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1) {
        
        //清空本地
        _imageJson = @"";
        
        for (UIImageView *iv in _actIVs)
            iv.image = nil;
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        //        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 3;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //清空本地
    _imageJson = @"";
    
    if (isPhoto) {
        [self.totle removeAllObjects];
        isPhoto = NO;
        
    }
    
    [self.totle addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    NSLog(@"%lu",(unsigned long)self.totle.count);
    
    //限制只能拍3张照片
    if (!(self.totle.count > 3)) {
        selectNub = self.totle.count;
    }
    NSLog(@"%ld",(long)selectNub);
    
//    if ( self.totle.count == 5) {
//        NSLog(@"已添加5张图片");
//        hidAddImageBtn = YES;
//        UIView *viewOnBtn = [[UIView alloc]init];
//        viewOnBtn.backgroundColor = [UIColor clearColor];
//        viewOnBtn.frame = CGRectMake(0, 0, self.addImageBtn.width, self.addImageBtn.height);
//        [self.addImageBtn addSubview:viewOnBtn];
//    }
    
    [self reloadImageView];
    for (int i = 0; i < MIN(3, self.totle.count); i++){
        UIImageView *iv = _actIVs[i];
        iv.image = self.totle[i];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    //清空本地
    _imageJson = @"";

    isPhoto=YES;
    
    [self.totle removeAllObjects];
    
    NSRange range =  NSMakeRange(self.totle.count, aSelected.count);
    NSIndexSet *index = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.totle insertObjects:aSelected atIndexes:index];
    
    if ( self.totle.count == 5) {
        NSLog(@"已添加5张图片");
        
        hidAddImageBtn = YES;
        
        UIView *viewOnBtn = [[UIView alloc]init];
        viewOnBtn.backgroundColor = [UIColor clearColor];
        viewOnBtn.frame = CGRectMake(0, 0, self.addImageBtn.width, self.addImageBtn.height);
        [self.addImageBtn addSubview:viewOnBtn];
    }
    
    selectNub = self.totle.count;
    
    [self reloadImageView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(5, self.totle.count); i++)
        {
            UIImageView *iv = _actIVs[i];
            iv.image = self.totle[i];
        }
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        for (int i = 0; i < MIN(5, self.totle.count); i++)
        {
            UIImageView *iv = _actIVs[i];
            iv.image = [ASSETHELPER getImageFromAsset:self.totle[i] type:ASSET_PHOTO_SCREEN_SIZE];
        }
        [ASSETHELPER clearData];
    }
}

- (void)actTemplateChangeBtnClickClick:(id)sender{
    NSLog(@"选择模板");
    
    YKLReleaseTemplateViewController *releaseVC = [YKLReleaseTemplateViewController new];
//    if ([self.actTemplateLabel.text isEqualToString:@"到店模式"]) {
//        
//        releaseVC.type = @"1";
//    }else{
//        releaseVC.type = @"2";
//    }
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)saveBtnClick:(id)sender{
    [self hidenKeyboard];
    
    //判断是否有未填写信息actExpTextLabel
    if ([self.startBargainTextField.text isBlankString]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"请输入完成砍价所需人数"];
        [self.actTitleField becomeFirstResponder];
        
        return;
    }
    
    float price = [self.priceTextField.text floatValue];
    float lowestPrice = [self.lowestPriceTextField.text floatValue];
//    float startBargain = [self.startBargainTextField.text floatValue];
//    float endBargain = [self.endBargainTextField.text floatValue];
    float number = [self.numberTextField.text floatValue];
    
    if (price < lowestPrice) {
        [UIAlertView showInfoMsg:@"原价不能小于底价"];
        return;
    }
    
//    if (price-lowestPrice < endBargain) {
//        [UIAlertView showInfoMsg:@"最大砍价区间不能大于原价与底价之差"];
//        return;
//    }
//    if (startBargain > endBargain) {
//        [UIAlertView showInfoMsg:@"最小砍价区间不能大于最大砍价区间"];
//        return;
//    }
    
    if (number == 0) {
        [UIAlertView showInfoMsg:@"产品数量不能为0"];
        return;
    }
    
//    [YKLNetworkingConsumer releaseBargainWithUserID:[YKLLocalUserDefInfo defModel].userID ActivityID:self.activityID StartBargain:self.startBargainTextField.text EndBargain:self.endBargainTextField.text Success:^(NSDictionary *templateModel) {
//        [UIAlertView showInfoMsg:@"砍价区间已修改成功"];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//        
//    } failure:^(NSError *error) {
//         [UIAlertView showInfoMsg:error.domain];
//    }];
    
}

//是否发送短信选择
- (void)selectYSMSBtnClicked{
    if(self.selectYSMSBtn.selected)
    {
        [self.selectYSMSBtn setSelected:NO];
        [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }else{
        [self.selectYSMSBtn setSelected:YES];
        [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
    if(self.selectNSMSBtn.selected)
    {
        [self.selectNSMSBtn setSelected:NO];
        [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
}

- (void)selectNSMSBtnClicked{
    if(self.selectNSMSBtn.selected)
    {
        [self.selectNSMSBtn setSelected:NO];
        [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }else{
        [self.selectNSMSBtn setSelected:YES];
        [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectNSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
    if(self.selectYSMSBtn.selected)
    {
        [self.selectYSMSBtn setSelected:NO];
        [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectYSMSBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
}

//是否显示底价选择
- (void)selectYPriceBtnClicked{
    if(self.selectYPriceBtn.selected)
    {
//        [self.selectYPriceBtn setSelected:NO];
//        [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
//        [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }else{
        [self.selectYPriceBtn setSelected:YES];
        [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
    if(self.selectNPriceBtn.selected)
    {
        [self.selectNPriceBtn setSelected:NO];
        [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
}

- (void)selectNPriceBtnClicked{
    if(self.selectNPriceBtn.selected)
    {
//        [self.selectNPriceBtn setSelected:NO];
//        [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
//        [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
        
    }else{
        [self.selectNPriceBtn setSelected:YES];
        [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectNPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
        
    }
    if(self.selectYPriceBtn.selected)
    {
        [self.selectYPriceBtn setSelected:NO];
        [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateHighlighted];
        [self.selectYPriceBtn setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
    }
}

- (void)shareSaveBtnClick:(UIButton *)sender{
    NSLog(@"点击了==--保存并分享到微信--==按钮");
    [self hidenKeyboard];
    
    //判断是否有未填写信息actExpTextLabel
    if ([self.actTitleField.text isBlankString]||[self.actExpTextLabel.text isBlankString]||(self.actExpTextLabel.text == nil)||[self.actIntroTextField.text isBlankString]||[self.priceTextField.text isBlankString]||[self.lowestPriceTextField.text isBlankString]||[self.startBargainTextField.text isBlankString]||[self.numberTextField.text isBlankString]||[self.securityTextField1.text isBlankString]||[self.securityTextField2.text isBlankString]||[self.securityTextField3.text isBlankString]||[self.securityTextField4.text isBlankString]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"请输入完整信息"];
        [self.actTitleField becomeFirstResponder];
        
        return;
    }
    
    if([self.showEndTimebtn.titleLabel.text isEqualToString:@"请点击设置活动截止时间"]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"请设置活动截止时间"];
        return;
    }
    
    
    float price = [self.priceTextField.text floatValue];
    float lowestPrice = [self.lowestPriceTextField.text floatValue];
    float startBargain = [self.startBargainTextField.text floatValue];
//    float endBargain = [self.endBargainTextField.text floatValue];
    float number = [self.numberTextField.text floatValue];

    if (price < lowestPrice) {
        [UIAlertView showInfoMsg:@"原价不能小于底价"];
        [self.priceTextField becomeFirstResponder];
        return;
    }
//    if (price-lowestPrice < endBargain) {
//        [UIAlertView showInfoMsg:@"最大砍价区间不能大于原价与底价之差"];
//        return;
//    }
//    if (startBargain > endBargain) {
//        [UIAlertView showInfoMsg:@"最小砍价区间不能大于最大砍价区间"];
//        return;
//    }
    
    if (startBargain == 0) {
        [UIAlertView showInfoMsg:@"所需砍价人数不能为0"];
        [self.startBargainTextField becomeFirstResponder];
        return;
    }

    if (number == 0) {
        [UIAlertView showInfoMsg:@"产品数量不能为0"];
        [self.numberTextField becomeFirstResponder];
        return;
    }
    
    if([self.typePushNub isEqual:@"2"]){
        
        float onlinePay = [self.onlinePayTextField.text floatValue];
        
        if (lowestPrice < onlinePay) {
            [UIAlertView showInfoMsg:@"在线支付再减钱数不可大于底价"];
            return;
        }
        if (lowestPrice == onlinePay){
            [UIAlertView showInfoMsg:@"在线支付再减钱数不可等于底价"];
            return;
        }
    }
    
    //先注册后发布
    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"图片上传中请稍等";
        self.navigationItem.leftBarButtonItem.enabled = NO;
        
        
        if (sender.tag == 6001) {
            
            self.preView = YES;
            
            if (![_imageJson isEqual:@""]) {
                
                [self preViewAct];
                return;
            }
        }else{
            
            self.preView = NO;
            
            if (![_imageJson isEqual:@""]) {
            
                [self releaseAct];
                return;
            }
        }
        
        self.imageArr = [NSMutableArray array];
        
        [self qiniuUpload:0];
        
    }else{
        
        //保存到本地
        [self saveDictForFiled];
        
        if ([[YKLLocalUserDefInfo defModel].agentCode isEqual:@""]) {
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }else{
            
            YKLLoginViewController *loginVC = [YKLLoginViewController new];
            [loginVC registTitleBtnClicked];
            loginVC.title = @"商户信息";
            
            loginVC.agentIDField.enabled = NO;
            loginVC.agentIDField.text = [YKLLocalUserDefInfo defModel].agentCode;
            loginVC.agentIDField.textColor = [UIColor lightGrayColor];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

//- (BOOL)textFieldWithString:(NSString *)string{
//    if ([string length]>0)
//    {
//        [string substringFromIndex:2];
//        NSLog(@"截取的值为：%@",string);
//        unichar single=[string characterAtIndex:0];//当前输入的字符
//        if ((single >='0' && single<='9') || single=='.')//数据格式正确
//        {
//            //首字母不能为0和小数点
//            if([string length]==0){
//                if(single == '.'){
//                    [UIAlertView showInfoMsg:@"亲，第一个数字不能为小数点"];
////                    [string stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
////                if (single == '0') {
////                    [UIAlertView showInfoMsg:@"亲，第一个数字不能为0"];
//////                    [textField1.text stringByReplacingCharactersInRange:range withString:@""];
////                    return NO;
////                }
//            }
//            if (single=='.')
//            {
//                if(!isHaveDian)//text中还没有小数点
//                {
//                    isHaveDian=YES;
//                    return YES;
//                }else
//                {
//                    [UIAlertView showInfoMsg:@"亲，您已经输入过小数点了"];
////                    [textField1.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
//            }
////            else
////            {
////                if (isHaveDian)//存在小数点
////                {
////                    //判断小数点的位数
////                    NSRange ran=[UIAlertView showInfoMsg: rangeOfString:@"."];
////                    int tt=range.location-ran.location;
////                    if (tt <= 2){
////                        return YES;
////                    }else{
////                        [self alertView:@"亲，您最多输入两位小数"];
////                        return NO;
////                    }
////                }
////                else
////                {
////                    return YES;
////                }
////            }
//        }else{//输入的数据格式不正确
//            [UIAlertView showInfoMsg:@"亲，您输入的格式不正确"];
////            [textField1.text stringByReplacingCharactersInRange:range withString:@""];
//            return NO;
//        }
//    }
//    else
//    {
//        return YES;
//    }
//    return YES;
//}

#pragma mark - keyboard

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-212,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.actTitleField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.lowestPriceTextField resignFirstResponder];
    [self.startBargainTextField resignFirstResponder];
//    [self.endBargainTextField resignFirstResponder];
    [self.actIntroTextField resignFirstResponder];
    [self.actExpTextLabel resignFirstResponder];
    [self.securityTextField1 resignFirstResponder];
    [self.securityTextField2 resignFirstResponder];
    [self.securityTextField3 resignFirstResponder];
    [self.securityTextField4 resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    [self.onlinePayTextField resignFirstResponder];
    
    [self resumeView];
}

#pragma mark - Helpers &七牛
- (void)qiniuUpload:(int) index{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSString *token = @"5_06q8nFxevqEx7XeBFn5VBRtwVySPeQg2UCDo0R:cCvb_Qn5ayw5ulB7dVbpS-HSCvM=:eyJzY29wZSI6InlrbC1tZWlwYS1uZXQiLCJkZWFkbGluZSI6MzA0Mjc2NzQxMn0=";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
    
    // ------------------- Test putData -------------------------
    NSData *data;
    
    NSData *data1 = [self.actImageView1.image resizedAndReturnData];
    NSData *data2 = [self.actImageView2.image resizedAndReturnData];
    NSData *data3 = [self.actImageView3.image resizedAndReturnData];
    NSData *data4 = [self.actImageView4.image resizedAndReturnData];
    NSData *data5 = [self.actImageView5.image resizedAndReturnData];
    
    if (index == 0) {
        data = data1;
    }else if (index == 1){
        data = data2;
    }else if (index == 2){
        data = data3;
    }else if (index == 3){
        data = data4;
    }else if (index == 4){
        data = data5;
    }
    index++;
    HUDIndex = index;
    
    QNUploadOption *option1 = [[QNUploadOption alloc]initWithProgessHandler:^(NSString *key, float percent) {
        NSLog(@"percent<%d>:%.2f",index,percent);
        myPercent = percent;
    }];
    
    
    [upManager putData:data
                   key:fileName
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  //判断是否有上传图片
                  if (![resp objectForKey:@"key"]) {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [UIAlertView showInfoMsg:@"请选择商品图片"];
                      
                      return;
                  }
//                  self.imageArr = [NSMutableArray array];
                  
                  self.actImageView1_URL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                  NSLog(@"%d>>>%@",index,self.actImageView1_URL);
                  [self.imageArr addObject:self.actImageView1_URL];
                  
                  NSData *data = [NSJSONSerialization dataWithJSONObject:self.imageArr
                                                                 options:NSJSONWritingPrettyPrinted
                                                                   error:nil];
                  NSString *jsonString = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
                  
                  _imageJson = jsonString;
                  
                  NSLog(@"%@",_imageJson);
                  if (index<selectNub){
                      
                      [self qiniuUpload:index];
                  }
                  else{
                      NSLog(@"完成");
                      self.navigationItem.leftBarButtonItem.enabled = YES;
                      
                      //判断是否为预览活动
                      if(self.preView){
                          
                          [self preViewAct];
    
                      }
                      else{
                          
                          [self releaseAct];
                      }
                      
                  }
                  
              }
                option:option1];
    
}

- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

//保存文件到本地
- (void)saveDictForFiled{
    
    if (self.activityID == NULL) {
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        [tempDict setObject:self.actTitleField.text forKey:@"title"];
        [tempDict setObject:self.actIntroTextField.text forKey:@"desc"];
        [tempDict setObject:self.priceTextField.text forKey:@"original_price"];
        [tempDict setObject:self.lowestPriceTextField.text forKey:@"base_price"];
        [tempDict setObject:self.startBargainTextField.text forKey:@"player_num"];
//        [tempDict setObject:self.endBargainTextField.text forKey:@"end_bargain"];
        [tempDict setObject:self.numberTextField.text forKey:@"product_num"];
        
        [tempDict setObject:self.showEndTimebtn.titleLabel.text forKey:@"activity_end_time"];
        
        NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
        [tempDict setObject:rewardCode forKey:@"reward_code"];
        
        
        if (self.templateNub){
            [tempDict setObject:self.templateNub forKey:@"template_id"];
        }
        if(self.actTemplateLabel.text){
            [tempDict setObject:self.actTemplateLabel.text forKey:@"type"];
        }
        
        //判断是否发送短信，与显示底价
        NSString *selectSMS;
        NSString *selectPrice;
        if (self.selectYSMSBtn.selected) {
            selectSMS = @"2";//发送
        }else{
            selectSMS = @"1";
        }
        if (self.selectYPriceBtn.selected) {
            selectPrice = @"1";//显示
        }else{
            selectPrice = @"2";
        }
        [tempDict setObject:selectSMS forKey:@"is_over_sms"];
        [tempDict setObject:selectPrice forKey:@"show_base_price"];
        
        NSMutableDictionary *templateDict = [NSMutableDictionary new];
        if (self.actExpTextLabel.text) {
            [templateDict setObject: self.actExpTextLabel.text forKey:@"title"];
        }
        if (self.templatePrice) {
            [templateDict setObject: self.templatePrice forKey:@"price"];
        }
        if (self.shareImage) {
            [templateDict setObject: self.shareImage forKey:@"share_img"];
        }
        
        [tempDict setObject:templateDict forKey:@"template"];
        
        
        NSArray *dataArr = [NSArray arrayWithObjects:self.actImageView1.image,self.actImageView2.image,self.actImageView3.image, nil];
        NSMutableArray *arr = [NSMutableArray array];
        
        if (selectNub>0) {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"图片正在保存";
            
            for (int i = 0; i < selectNub; i++) {
                
                if (!(dataArr.count==0)) {
                    
                    NSData *data = [dataArr[i] resizedAndReturnData];
                    [arr addObject:data];
                    
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        [tempDict setObject:arr forKey:@"img"];
        
        //    NSLog(@"%@",tempDict);
        
        if ([self.typePushNub isEqual:@"1"]) {
            
            [YKLLocalUserDefInfo defModel].saveActInfoDict = tempDict;
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            
        }else{
            
            [tempDict setObject:self.onlinePayTextField.text forKey:@"online_pay_privilege"];
            
            [YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict = tempDict;
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        }
        
    }
}

//预览活动方法
- (void)preViewAct{
    
    NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
    
    //判断是否发送短信，与显示底价
    NSString *selectSMS;
    NSString *selectPrice;
    //                      if (self.selectYSMSBtn.selected) {
    //                          selectSMS = @"2";//发送
    //                      }else{
    selectSMS = @"1";
    //                      }
    if (self.selectYPriceBtn.selected) {
        selectPrice = @"1";//显示
    }else{
        selectPrice = @"2";
    }
    
    NSString *actIntroTextString = [self.actIntroTextField.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    NSMutableDictionary *tempDict = [NSMutableDictionary new];
    [tempDict setObject:self.actTitleField.text forKey:@"title"];
    [tempDict setObject:actIntroTextString forKey:@"desc"];
    [tempDict setObject:self.priceTextField.text forKey:@"original_price"];
    [tempDict setObject:self.lowestPriceTextField.text forKey:@"base_price"];
    [tempDict setObject:self.startBargainTextField.text forKey:@"player_num"];
    [tempDict setObject:self.numberTextField.text forKey:@"product_num"];
    [tempDict setObject:self.showEndTimebtn.titleLabel.text forKey:@"activity_end_time"];
    [tempDict setObject:rewardCode forKey:@"reward_code"];
    
    if (self.templateNub){
        [tempDict setObject:self.templateNub forKey:@"template_id"];
    }
    if(self.actTemplateLabel.text){
        [tempDict setObject:self.actTemplateLabel.text forKey:@"type"];
    }
    
    [tempDict setObject:selectSMS forKey:@"is_over_sms"];
    [tempDict setObject:selectPrice forKey:@"show_base_price"];
    [tempDict setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    [tempDict setObject:self.imageArr forKey:@"imgs"];
    
    NSLog(@"%@",tempDict);
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tempDict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str);
    
    NSURL *url = [NSURL URLWithString: @"http://ykl.meipa.net/admin.php/Bargain/activity_preview"];
    NSString *body = str;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    
    YKLPushWebViewController *webVC = [YKLPushWebViewController new];
    webVC.request = request;
    webVC.webTitle = @"预览效果";
    [self.navigationController pushViewController:webVC animated:YES];

}

//发布活动方法
- (void)releaseAct{
    
    NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
    
    
    //判断是否发送短信，与显示底价
    NSString *selectSMS;
    NSString *selectPrice;
    //                      if (self.selectYSMSBtn.selected) {
    //                          selectSMS = @"2";//发送
    //                      }else{
    selectSMS = @"1";
    //                      }
    if (self.selectYPriceBtn.selected) {
        selectPrice = @"1";//显示
    }else{
        selectPrice = @"2";
    }
    
    NSString *actIntroTextString = [self.actIntroTextField.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    if (!(self.activityID == NULL) && !([self.endActivityID isEqualToString:@"againRelease"])) {
        NSLog(@"%@",self.endActivityID);
        
        [YKLNetworkingConsumer releaseActWithUserID:[YKLLocalUserDefInfo defModel].userID ActivityID:self.activityID Title:self.actTitleField.text Desc:actIntroTextString OriginalPrice:self.priceTextField.text BasePrice:self.lowestPriceTextField.text ProductNum:self.numberTextField.text StartBargain:self.startBargainTextField.text  ActivityEndTime:self.showEndTimebtn.titleLabel.text RewardCode:rewardCode TemplateID:self.templateNub Status:@"1" Img:_imageJson Type:self.typePushNub IsOverSms:selectSMS ShowBasePrice:selectPrice OnlinePayPrivilege:self.onlinePayTextField.text  Success:^(NSDictionary *templateModel) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            
            self.payArray = [NSMutableArray array];
            
            self.orderStatus = [[templateModel objectForKey:@"state"]integerValue];
            self.content = [templateModel objectForKey:@"content"];
            self.totleMoney = [templateModel objectForKey:@"totleMoney"];
            self.payArray = [templateModel objectForKey:@"pay"];
            self.activityID = [templateModel objectForKey:@"id"];
            
            self.shareURL = [templateModel objectForKey:@"share_url"];
            self.shareTitle = [templateModel objectForKey:@"title"];
            
            NSDictionary *tempDict = [templateModel objectForKey:@"template"];
            self.shareImage = [tempDict objectForKey:@"share_img"];
            self.shareDesc = [tempDict objectForKey:@"share_desc"];
            NSString *strName = [YKLLocalUserDefInfo defModel].userName;
            self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
            [YKLLocalUserDefInfo defModel].shareURL = self.shareURL;
            [YKLLocalUserDefInfo defModel].shareTitle = self.shareTitle;
            [YKLLocalUserDefInfo defModel].shareDesc = self.shareDesc;
            [YKLLocalUserDefInfo defModel].shareImage = self.shareImage;
            [YKLLocalUserDefInfo defModel].shareActType = @"大砍价";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
            if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                super.view.window.rootViewController = ShareVC;
                
            }else{
                
                if (![[templateModel objectForKey:@"pay"] isEqual:@""]) {
                    
                    YKLPayViewController *payVC = [YKLPayViewController new];
                    payVC.templateModel = templateModel;
                    payVC.activityID = self.activityID;
                    payVC.orderType = @"1";
                    payVC.isListDetailPop = YES;
                    [self.navigationController pushViewController:payVC animated:YES];
                }
                else{
                    
                    YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                    ShareVC.hidenBar = YES;
                    ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                    ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                    ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                    ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                    ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                    super.view.window.rootViewController = ShareVC;
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            [self saveDictForFiled];
            [UIAlertView showErrorMsg:error.domain];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }];
    }
    else{
        self.endActivityID = @"";
        
        [YKLNetworkingConsumer releaseActWithUserID:[YKLLocalUserDefInfo defModel].userID ActivityID:@"" Title:self.actTitleField.text Desc:actIntroTextString OriginalPrice:self.priceTextField.text BasePrice:self.lowestPriceTextField.text ProductNum:self.numberTextField.text StartBargain:self.startBargainTextField.text ActivityEndTime:self.showEndTimebtn.titleLabel.text RewardCode:rewardCode TemplateID:self.templateNub Status:@"1" Img: _imageJson Type:self.typePushNub IsOverSms:selectSMS ShowBasePrice:selectPrice OnlinePayPrivilege:self.onlinePayTextField.text Success:^(NSDictionary *templateModel) {
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            
            //清空本地活动信息
            if ([self.typePushNub isEqual:@"1"]) {
                
                [YKLLocalUserDefInfo defModel].saveActInfoDict = [NSMutableDictionary new];
                [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                
            }else{
                [YKLLocalUserDefInfo defModel].saveOnlinePayActInfoDict = [NSMutableDictionary new];
                [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            }
            
            self.payArray = [NSMutableArray array];
            
            self.orderStatus = [[templateModel objectForKey:@"state"]integerValue];
            self.content = [templateModel objectForKey:@"content"];
            self.totleMoney = [templateModel objectForKey:@"totleMoney"];
            self.payArray = [templateModel objectForKey:@"pay"];
            self.activityID = [templateModel objectForKey:@"id"];
            
            self.shareURL = [templateModel objectForKey:@"share_url"];
            self.shareTitle = [templateModel objectForKey:@"title"];
            
            NSDictionary *tempDict = [templateModel objectForKey:@"template"];
            self.shareImage = [tempDict objectForKey:@"share_img"];
            self.shareDesc = [tempDict objectForKey:@"share_desc"];
            NSString *strName = [YKLLocalUserDefInfo defModel].userName;
            self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
            
            [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
            [YKLLocalUserDefInfo defModel].shareURL = self.shareURL;
            [YKLLocalUserDefInfo defModel].shareTitle = self.shareTitle;
            [YKLLocalUserDefInfo defModel].shareDesc = self.shareDesc;
            [YKLLocalUserDefInfo defModel].shareImage = self.shareImage;
            [YKLLocalUserDefInfo defModel].shareActType = @"大砍价";
            [[YKLLocalUserDefInfo defModel]saveToLocalFile];
            
            if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                super.view.window.rootViewController = ShareVC;
                
            }else{
                if (![[templateModel objectForKey:@"pay"] isEqual:@""]) {
                    
                    YKLPayViewController *payVC = [YKLPayViewController new];
                    payVC.templateModel = templateModel;
                    payVC.activityID = self.activityID;
                    payVC.orderType = @"1";
                    [self.navigationController pushViewController:payVC animated:YES];
                }
                else{
                    
                    YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                    ShareVC.hidenBar = YES;
                    ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                    ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                    ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                    ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                    ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                    super.view.window.rootViewController = ShareVC;
                    
                }
                
            }
            
            
        } failure:^(NSError *error) {
            [self saveDictForFiled];
            [UIAlertView showErrorMsg:error.domain];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }];
    }
}


- (void)showHelpView{
    
    [self hidenKeyboard];
    
    if (_PopupView.isClose) {
        
        [_PopupView hideRechargeAlertBgView];
        
    }else{
        
        [_PopupView createView:@{
                                 @"imgName":@"bargainDDHelp",
                                 @"imgFram":@[@10, @10, @300, @350],
                                 @"closeBtn":@"bargainDDClose",
                                 @"btnFram":@[@(310-18), @5, @23, @23]
                                 }];
        [self.view addSubview:_PopupView];
    }
}



@end
