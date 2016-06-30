//
//  YKLDuoBaoReleaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/2/29.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLDuoBaoReleaseViewController.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"
#import "SJAvatarBrowser.h"
#import "YKLLoginViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLPopupView.h"

@interface YKLDuoBaoReleaseViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) YKLPopupView *PopupView;

@end

@implementation YKLDuoBaoReleaseViewController


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
 
    self.hidAddImageBtn = NO;
    self.totle = [[NSMutableArray alloc]init];
    self.actImageViewArr= [NSMutableArray array];
    self.imageArr = [NSMutableArray array];
    
    [self createBgView];
    [self createContents];
    [self createImageView];
    
    [self showTime];
    [self initView];
    
    _PopupView = [[YKLPopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];

    if (!(self.activityID == NULL)) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingDuoBao readIndianaInfoWithIndianaID:self.activityID Success:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"%@",dict);
            
            self.goodsNameField.text = [dict objectForKey:@"indiana_title"];
            self.actRuleTextView.text = [dict objectForKey:@"indiana_desc"];
            self.actRuleTextView.text =[self.actRuleTextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            
            self.originalPrizeField.text = [dict objectForKey:@"indiana_price"];
            self.discountlPrizeField.text = [dict objectForKey:@"indiana_sale"];
//            self.onlinePayField.text = [dict objectForKey:@"indiana_reduce"];
            self.couponPriceField1.text = [dict objectForKey:@"coupon_min"];
            self.couponPriceField2.text = [dict objectForKey:@"coupon_max"];
            self.goodsNumField.text = [dict objectForKey:@"award_num"];
            
            [self.couponEndTimebtn setTitle:[[dict objectForKey:@"coupon_end"] timeNumber] forState:UIControlStateNormal];
            [self.endTimebtn setTitle:[[dict objectForKey:@"end_time"] timeNumber] forState:UIControlStateNormal];
            
            //分解现场兑奖码
            NSString *rewardCodeStr = [dict objectForKey:@"reward_code"];
            if (![rewardCodeStr isEqual:@""]) {
                self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
                self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
                self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
                self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
            }
            
            if ([[dict objectForKey:@"coupon_type"] isEqualToString:@"0"]) {
                [self selectGeneralBtnClicked];
            }
            else if([[dict objectForKey:@"coupon_type"] isEqualToString:@"1"]){
                self.couponBrandField.text = [dict objectForKey:@"coupon_brand"];
            }
    
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
            [self.goodsImageView1 addGestureRecognizer:singleTap];
            [self.goodsImageView1 sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"indiana_photo"]] placeholderImage:[UIImage imageNamed:@"Demo"]];
            
            //视觉上隐藏添加照片按钮
            [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    //如果本地存储活动字典不为空则加载其数据
    else if (![[YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict isEqual:@{}]) {
        
        NSMutableDictionary *tempDict = [YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict;
        
    
        self.goodsNameField.text = [tempDict objectForKey:@"indiana_title"];
        self.actRuleTextView.text = [tempDict objectForKey:@"indiana_desc"];
        
        self.originalPrizeField.text = [tempDict objectForKey:@"indiana_price"];
        self.discountlPrizeField.text = [tempDict objectForKey:@"indiana_sale"];
//        self.onlinePayField.text = [tempDict objectForKey:@"indiana_reduce"];
        self.couponPriceField1.text = [tempDict objectForKey:@"coupon_min"];
        self.couponPriceField2.text = [tempDict objectForKey:@"coupon_max"];
        self.goodsNumField.text = [tempDict objectForKey:@"award_num"];
        
        [self.couponEndTimebtn setTitle:[tempDict objectForKey:@"coupon_end"] forState:UIControlStateNormal];
        [self.endTimebtn setTitle:[tempDict objectForKey:@"end_time"] forState:UIControlStateNormal];

        //分解现场兑奖码
        NSString *rewardCodeStr = [tempDict objectForKey:@"reward_code"];
        if (![rewardCodeStr isEqual:@""]) {
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
        }
        
        if ([[tempDict objectForKey:@"indiana_type"] isEqualToString:@"0"]) {
            [self selectGeneralBtnClicked];
        }
        else if([[tempDict objectForKey:@"indiana_type"] isEqualToString:@"1"]){
            self.couponBrandField.text = [tempDict objectForKey:@"indiana_brand"];
        }
        
//        //0全店通用 1品牌  indiana_type
//        if (self.selectGeneralBtn.selected) {
//            [tempDict setObject:@"0" forKey:@"indiana_type"];
//        }else{
//            //indiana_type=1 时 品牌名称  indiana_brand
//            [tempDict setObject:@"1" forKey:@"indiana_type"];
//            [tempDict setObject:self.couponBrandField.text forKey:@"indiana_brand"];
//        }
        
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [NSArray array];
        tempArray = [tempDict objectForKey:@"indiana_photo"];
        if(IsEmpty(tempArray)){
            NSLog(@"图片数组为空");
        }else{
            self.selectNub = tempArray.count;
            
            for (int i = 0; i < tempArray.count; i++) {
                
                //将data转换为image
                UIImage *_decodedImage = [UIImage imageWithData:tempArray[i]];
                UIImageView *imageView = self.actIVs[i];
                //self.imageViewArr[i].userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhoto:)];
                [self.actIVs[i] addGestureRecognizer:singleTap];
                [imageView setImage:_decodedImage];
                
                //视觉上隐藏添加照片按钮
                [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //首次进入弹出帮助页面
    if ([[YKLLocalUserDefInfo defModel].duoBaoHelp isEqual:@"YES"]) {
        
        [self showHelpView];
        
        [YKLLocalUserDefInfo defModel].duoBaoHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
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
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:0];
    
    
    if (self.activityID == NULL&&!self.isEndActivity) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 创建背景

- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    
    //全部显示视图可移动大小
    self.scrollView.contentSize = CGSizeMake(self.view.width, 800);
    [self.view addSubview:self.scrollView];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, self.scrollView.contentSize.width, self.scrollView.contentSize.height-5)];
    bgImageView.image = [UIImage imageNamed:@"大背景"];
    [self.scrollView addSubview:bgImageView];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(30, 55, self.scrollView.width-30*2, 690)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.bgView];

    self.shareSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareSaveBtn.frame = CGRectMake(60, self.bgView.bottom+10, self.scrollView.width-60*2, 45);
    [self.shareSaveBtn setImage:[UIImage imageNamed:@"确定按钮.png"] forState:UIControlStateNormal];
    [self.shareSaveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.shareSaveBtn];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.shareSaveBtn.width, self.shareSaveBtn.height)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"613622"];
    title.font = [UIFont systemFontOfSize:20];
    title.text = @"确定";
    [self.shareSaveBtn addSubview:title];
    
}


#pragma mark - 创建内容

- (void)createContents{
    
    self.goodsTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.goodsTitle.textColor = [UIColor colorWithHexString:@"613622"];
    self.goodsTitle.font = [UIFont boldSystemFontOfSize:16 ];
    self.goodsTitle.text = @"设置宝藏";
    [self.bgView addSubview:self.goodsTitle];
    
    self.goodsName = [[UILabel alloc]initWithFrame:CGRectMake(0, self.goodsTitle.bottom+5, 70, 20)];
    self.goodsName.textColor = [UIColor colorWithHexString:@"613622"];
    self.goodsName.font = [UIFont systemFontOfSize:14];
    self.goodsName.text = @"产品名称：";
    [self.bgView addSubview:self.goodsName];
    
    self.goodsNameField = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsName.right, self.goodsName.top, 160, 20)];
    self.goodsNameField.delegate = self;
    self.goodsNameField.font = [UIFont systemFontOfSize:14];
    self.goodsNameField.keyboardType = UIKeyboardTypeDefault;
    [self.bgView addSubview:self.goodsNameField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.goodsNameField.left, self.goodsNameField.bottom, self.goodsNameField.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.bgView addSubview:lineView];
    
    self.goodsPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.goodsName.bottom+10, 90, 20)];
    self.goodsPhotoLabel.textColor = [UIColor colorWithHexString:@"613622"];
    self.goodsPhotoLabel.font = [UIFont systemFontOfSize:14];
    self.goodsPhotoLabel.text = @"上传宝藏图片";
    [self.bgView addSubview:self.goodsPhotoLabel];
    
    self.originalPrize = [[UILabel alloc]initWithFrame:CGRectMake(0, self.goodsPhotoLabel.bottom+55, 45, 20)];
    self.originalPrize.textColor = [UIColor colorWithHexString:@"613622"];
    self.originalPrize.font = [UIFont systemFontOfSize:14];
    self.originalPrize.text = @"原  价";
    [self.bgView addSubview:self.originalPrize];
    
    self.originalPrizeField = [[UITextField alloc]initWithFrame:CGRectMake(self.originalPrize.right, self.originalPrize.top, 60, 20)];
    self.originalPrizeField.font = [UIFont systemFontOfSize:14];
    self.originalPrizeField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.bgView addSubview:self.originalPrizeField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.originalPrizeField.left, self.originalPrizeField.bottom, self.originalPrizeField.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.bgView addSubview:lineView];
    
    self.discountlPrize = [[UILabel alloc]initWithFrame:CGRectMake(self.originalPrizeField.right+35, self.originalPrize.top, 45, 20)];
    self.discountlPrize.textColor = [UIColor colorWithHexString:@"613622"];
    self.discountlPrize.font = [UIFont systemFontOfSize:14];
    self.discountlPrize.text = @"打劫价";
    [self.bgView addSubview:self.discountlPrize];
    
    self.discountlPrizeField = [[UITextField alloc]initWithFrame:CGRectMake(self.discountlPrize.right, self.discountlPrize.top, 60, 20)];
    self.discountlPrizeField.font = [UIFont systemFontOfSize:14];
    self.discountlPrizeField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.bgView addSubview:self.discountlPrizeField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.discountlPrizeField.left, self.discountlPrizeField.bottom, self.discountlPrizeField.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.bgView addSubview:lineView];
    
    
//    self.onlinePay = [[UILabel alloc]initWithFrame:CGRectMake(0, self.discountlPrizeField.bottom+10, 90, 20)];
//    self.onlinePay.textColor = [UIColor colorWithHexString:@"613622"];
//    self.onlinePay.font = [UIFont boldSystemFontOfSize:14];
//    self.onlinePay.text = @"线上支付再减";
//    [self.bgView addSubview:self.onlinePay];
//    
//    self.onlinePayField = [[UITextField alloc]initWithFrame:CGRectMake(self.onlinePay.right, self.onlinePay.top, 60, 20)];
//    self.onlinePayField.font = [UIFont systemFontOfSize:14];
//    self.onlinePayField.keyboardType = UIKeyboardTypeDecimalPad;
//    [self.bgView addSubview:self.onlinePayField];
//    
//    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.onlinePayField.left, self.onlinePayField.bottom, self.onlinePayField.width, 1)];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
//    [self.bgView addSubview:lineView];
    
    self.couponTitle =  [[UILabel alloc]initWithFrame:CGRectMake(0, self.discountlPrizeField.bottom+10, 200, 20)];
    self.couponTitle.textColor = [UIColor colorWithHexString:@"613622"];
    self.couponTitle.font = [UIFont boldSystemFontOfSize:16 ];
    self.couponTitle.text = @"设置鼓励奖（代金券）";
    [self.bgView addSubview:self.couponTitle];
    
    self.couponRangeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.couponTitle.bottom+5, 110, 20)];
    self.couponRangeTitle.textColor = [UIColor colorWithHexString:@"613622"];
    self.couponRangeTitle.font = [UIFont systemFontOfSize:14];
    self.couponRangeTitle.text = @"代金券适用范围";
    [self.bgView addSubview:self.couponRangeTitle];
    
    self.couponBrandBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.couponRangeTitle.bottom+5, 30+100, 20)];
    self.couponBrandBgView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.couponBrandBgView];
    
    self.couponBrand = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    self.couponBrand.textColor = [UIColor colorWithHexString:@"613622"];
    self.couponBrand.font = [UIFont systemFontOfSize:14 ];
    self.couponBrand.text = @"品牌";
    [self.couponBrandBgView addSubview:self.couponBrand];
    
    self.couponBrandField = [[UITextField alloc]initWithFrame:CGRectMake(self.couponBrand.right, 0, 100, 20)];
    self.couponBrandField.font = [UIFont systemFontOfSize:14];
    self.couponBrandField.keyboardType = UIKeyboardTypeDefault;
    [self.couponBrandBgView addSubview:self.couponBrandField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.couponBrandField.left, self.couponBrandField.bottom, self.couponBrandField.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.couponBrandBgView addSubview:lineView];
    
    
    self.couponGeneral = [[UILabel alloc]initWithFrame:CGRectMake(self.couponBrandBgView.right+10, self.couponRangeTitle.bottom+5, 60, 20)];
//    self.couponGeneral.backgroundColor = [UIColor redColor];
    self.couponGeneral.textColor = [UIColor colorWithHexString:@"613622"];
    self.couponGeneral.font = [UIFont systemFontOfSize:14 ];
    self.couponGeneral.text = @"全店通用";
    [self.bgView addSubview:self.couponGeneral];
    
    self.selectGeneralBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectGeneralBtn.frame = CGRectMake(self.couponGeneral.right,self.couponGeneral.top,20,20);
    [self.selectGeneralBtn setImage:[UIImage imageNamed:@"DuoBao_Unselect.png"] forState:UIControlStateNormal];
    [self.selectGeneralBtn setImage:[UIImage imageNamed:@"DuoBao_Select.png"] forState:UIControlStateSelected];
    [self.selectGeneralBtn addTarget:self action:@selector(selectGeneralBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.selectGeneralBtn];
    
    self.couponPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.couponGeneral.bottom+10, 100, 20)];
    self.couponPriceLabel.backgroundColor = [UIColor clearColor];
    self.couponPriceLabel.font = [UIFont systemFontOfSize:14];
    self.couponPriceLabel.textColor = [UIColor colorWithHexString:@"613622"];
    self.couponPriceLabel.text = @"设置代金券区间";
    [self.bgView addSubview:self.couponPriceLabel];
    
    self.couponPriceField1 = [[UITextField alloc] initWithFrame:CGRectMake(self.couponPriceLabel.right, self.couponPriceLabel.top, 60, 20)];
    self.couponPriceField1.keyboardType = UIKeyboardTypeDecimalPad;
    self.couponPriceField1.delegate = self;
    self.couponPriceField1.font = [UIFont systemFontOfSize:14];
    self.couponPriceField1.returnKeyType = UIReturnKeyNext;
    self.couponPriceField1.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.couponPriceField1];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.couponPriceField1.left, self.couponPriceField1.bottom, self.couponPriceField1.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.bgView addSubview:lineView];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(self.couponPriceField1.right, self.couponPriceField1.top, 20, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.text = @"~";
    label.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:label];
    
    self.couponPriceField2 = [[UITextField alloc] initWithFrame:CGRectMake(label.right, self.couponPriceField1.top, 60, 20)];
    self.couponPriceField2.keyboardType = UIKeyboardTypeDecimalPad;
    self.couponPriceField2.delegate = self;
    self.couponPriceField2.font = [UIFont systemFontOfSize:14];
    self.couponPriceField2.returnKeyType = UIReturnKeyNext;
    self.couponPriceField2.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.couponPriceField2];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.couponPriceField2.left, self.couponPriceField2.bottom, self.couponPriceField2.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.bgView addSubview:lineView];

    UILabel *ylabel =[[UILabel alloc] initWithFrame:CGRectMake(self.couponPriceField2.right, self.couponPriceField1.top, 20, 20)];
    ylabel.backgroundColor = [UIColor clearColor];
    ylabel.font = [UIFont systemFontOfSize:14];
    ylabel.textColor = [UIColor colorWithHexString:@"613622"];
    ylabel.text = @"元";
    ylabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:ylabel];
    
    self.couponEndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.couponPriceLabel.bottom+10, 120, 20)];
    self.couponEndTimeLabel.backgroundColor = [UIColor clearColor];
    self.couponEndTimeLabel.font = [UIFont systemFontOfSize:14];
    self.couponEndTimeLabel.textColor = [UIColor colorWithHexString:@"613622"];
    self.couponEndTimeLabel.text = @"代金卷截止日期";
    [self.bgView addSubview:self.couponEndTimeLabel];
    
    self.couponEndTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.couponEndTimebtn.frame = CGRectMake(self.couponEndTimeLabel.right, self.couponEndTimeLabel.top, self.view.width-self.couponEndTimeLabel.right-2, 20);
    [self.couponEndTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.couponEndTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.couponEndTimebtn.tag = 4004;
    [self.couponEndTimebtn setTitle:@"请点击设置结束时间" forState:UIControlStateNormal];
    [self.couponEndTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.couponEndTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    //    self.showEndTimebtn.enabled = self.activityIngHidden;
    [self.bgView addSubview:self.couponEndTimebtn];
    
    self.goodsNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.couponEndTimeLabel.bottom+10, 80, 20)];
    self.goodsNumTitle.font = [UIFont systemFontOfSize:14];
    self.goodsNumTitle.textColor = [UIColor colorWithHexString:@"613622"];
    self.goodsNumTitle.text = @"设置宝藏数";
    [self.bgView addSubview:self.goodsNumTitle];
    
    self.goodsNumField = [[UITextField alloc] initWithFrame:CGRectMake(self.goodsNumTitle.right, self.goodsNumTitle.top, 60, 20)];
    self.goodsNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsNumField.delegate = self;
    self.goodsNumField.font = [UIFont systemFontOfSize:14];
    self.goodsNumField.returnKeyType = UIReturnKeyNext;
    self.goodsNumField.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.goodsNumField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(self.goodsNumField.left, self.goodsNumField.bottom, self.goodsNumField.width, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"613622"];
    [self.bgView addSubview:lineView];
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodsNumField.bottom+10, 120, 20)];
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textColor = [UIColor colorWithHexString:@"613622"];
    self.endTimeLabel.text = @"设置活动结束时间";
    [self.bgView addSubview:self.endTimeLabel];
    
    self.endTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endTimebtn.frame = CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, self.view.width-self.couponEndTimeLabel.right-2, 20);
    [self.endTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.endTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.endTimebtn.tag = 4005;
    [self.endTimebtn setTitle:@"请点击设置结束时间" forState:UIControlStateNormal];
    [self.endTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.endTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.bgView addSubview:self.endTimebtn];
    
    
    self.rewardCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.endTimeLabel.bottom+10, 80, 20)];
    self.rewardCodeLabel.backgroundColor = [UIColor clearColor];
    self.rewardCodeLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCodeLabel.textColor = [UIColor colorWithHexString:@"613622"];
    self.rewardCodeLabel.text = @"设置兑奖码";
    [self.bgView addSubview:self.rewardCodeLabel];
    
    self.securityTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(self.rewardCodeLabel.right, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField1.textAlignment = NSTextAlignmentCenter;
    self.securityTextField1.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField1.backgroundColor = [UIColor clearColor];
    self.securityTextField1.layer.borderColor=[[UIColor colorWithHexString:@"613622"]CGColor];
    self.securityTextField1.layer.borderWidth= 1.0f;
    self.securityTextField1.delegate = self;
    self.securityTextField1.font = [UIFont systemFontOfSize:14];
    self.securityTextField1.returnKeyType = UIReturnKeyNext;
    self.securityTextField1.text = @"0";
    //    self.securityTextField1.enabled = self.activityIngHidden;
    [self.bgView addSubview:self.securityTextField1];
    
    self.securityTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField1.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField2.textAlignment = NSTextAlignmentCenter;
    self.securityTextField2.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField2.backgroundColor = [UIColor clearColor];
    self.securityTextField2.layer.borderColor=[[UIColor colorWithHexString:@"613622"]CGColor];
    self.securityTextField2.layer.borderWidth= 1.0f;
    self.securityTextField2.delegate = self;
    self.securityTextField2.font = [UIFont systemFontOfSize:14];
    self.securityTextField2.returnKeyType = UIReturnKeyNext;
    //    self.securityTextField2.enabled = self.activityIngHidden;
    self.securityTextField2.text = @"0";
    [self.bgView addSubview:self.securityTextField2];
    
    self.securityTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField2.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField3.textAlignment = NSTextAlignmentCenter;
    self.securityTextField3.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField3.backgroundColor = [UIColor clearColor];
    self.securityTextField3.layer.borderColor=[[UIColor colorWithHexString:@"613622"]CGColor];
    self.securityTextField3.layer.borderWidth= 1.0f;
    self.securityTextField3.delegate = self;
    self.securityTextField3.font = [UIFont systemFontOfSize:14];
    self.securityTextField3.returnKeyType = UIReturnKeyNext;
    //    self.securityTextField3.enabled = self.activityIngHidden;
    self.securityTextField3.text = @"0";
    [self.bgView addSubview:self.securityTextField3];
    
    self.securityTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField3.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField4.textAlignment = NSTextAlignmentCenter;
    self.securityTextField4.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField4.backgroundColor = [UIColor clearColor];
    self.securityTextField4.layer.borderColor=[[UIColor colorWithHexString:@"613622"]CGColor];
    self.securityTextField4.layer.borderWidth= 1.0f;
    self.securityTextField4.delegate = self;
    self.securityTextField4.font = [UIFont systemFontOfSize:14];
    self.securityTextField4.returnKeyType = UIReturnKeyNext;
    //    self.securityTextField4.enabled = self.activityIngHidden;
    self.securityTextField4.text = @"0";
    [self.bgView addSubview:self.securityTextField4];
    
    UIButton *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    securityBtn.backgroundColor = [UIColor clearColor];
    securityBtn.frame = CGRectMake(self.rewardCodeLabel.right, self.endTimeLabel.bottom+10, 130, 25);
    [securityBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    //    securityBtn.enabled = self.activityIngHidden;
    [self.bgView addSubview:securityBtn];
    
    self.actRuleTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.rewardCodeLabel.bottom+10, 85, 20)];
    self.actRuleTitle.backgroundColor = [UIColor clearColor];
    self.actRuleTitle.font = [UIFont systemFontOfSize:14];
    self.actRuleTitle.textColor = [UIColor colorWithHexString:@"613622"];
    self.actRuleTitle.text = @"设置活动规则";
    [self.bgView addSubview:self.actRuleTitle];
    
    UILabel *changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.actRuleTitle.right, self.rewardCodeLabel.bottom+10, 50, 20)];
    changeLabel.backgroundColor = [UIColor clearColor];
    changeLabel.font = [UIFont systemFontOfSize:12];
    changeLabel.textColor = [UIColor colorWithHexString:@"613622"];
    changeLabel.text = @"(可修改)";
    [self.bgView addSubview:changeLabel];
    
    self.actRuleTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, self.actRuleTitle.bottom+10, self.bgView.width-20, 210)];
    self.actRuleTextView.text = @"1.参与夺宝，请先输入手机号码，即可邀请3个好友帮忙开启宝箱，同时自己也有1次开启宝箱的机会；此次夺宝只有4次机会打开宝箱，祝您好运！\n2.活动页面产品图片及信息仅供参照，产品以实物为准；\n3.参与活动挖到宝箱后，会收到短信提醒，请在兑奖期内到本店兑换活动产品；若未开出中奖宝箱，则请继续关注或参与门店的其他活动。\n4.兑奖只以活动兑奖页面显示的内容为准，截图或短信均为无效。\n5.活动期间奖品数量有限，先到先得，抢完为止；\n6.活动开始后本声明将自动生效并表明参加者已接受；\n7.本活动最终解释权归本店所有。";
    self.actRuleTextView.backgroundColor = [self colorWithHexStringSelf:@"420c00"];
    self.actRuleTextView.keyboardType = UIKeyboardTypeDefault;
    self.actRuleTextView.layer.cornerRadius = 5;
    self.actRuleTextView.layer.masksToBounds = YES;
    self.actRuleTextView.font = [UIFont systemFontOfSize:14];
    self.actRuleTextView.returnKeyType = UIReturnKeyNext;
    self.actRuleTextView.textColor = [UIColor blackColor];
    self.actRuleTextView.delegate = self;
    [self.bgView addSubview:self.actRuleTextView];
}

- (UIColor*)colorWithHexStringSelf:(NSString*)hexString
{
    NSString *valueString = hexString;
    if ([valueString hasPrefix:@"0x"])
    {
        valueString = [hexString substringFromIndex:2];
    }
    if (valueString.length != 8 && valueString.length != 6)
    {
        return nil;
    }
    
    unsigned int color = 0;
    unsigned int alpha = 255;
    if (valueString.length == 6)
    {
        NSScanner *scanner = [NSScanner scannerWithString:valueString];
        [scanner scanHexInt:&color];
    }
    else
    {
        NSScanner *scanner = [NSScanner scannerWithString:[valueString substringToIndex:6]];
        [scanner scanHexInt:&color];
        scanner = [NSScanner scannerWithString:[valueString substringFromIndex:6]];
        [scanner scanHexInt:&alpha];
    }
    
    return [UIColor colorWithHex:color alpha:51.0/255.0f];
}


#pragma mark - 创建商品图片

- (void)createImageView{
    
    self.goodsImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10,self.goodsPhotoLabel.bottom,50,50)];
    self.goodsImageView1.centerX = self.bgView.width/2;
    self.goodsImageView1.userInteractionEnabled = YES;
    self.goodsImageView1.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.goodsImageView1];
    
    _actIVs = @[self.goodsImageView1];
    
    self.addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImageBtn setImage:[UIImage imageNamed:@"DuoBao_AddImg"] forState:UIControlStateNormal];
    [self.addImageBtn sizeToFit];
    self.addImageBtn.frame = CGRectMake(self.goodsImageView1.left,self.goodsPhotoLabel.bottom,50,50);
    [self.addImageBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addImageBtn setHidden:self.hidAddImageBtn];
    [self.bgView addSubview:self.addImageBtn];
    
    
}

#pragma mark - 兑换码初始化

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


#pragma mark - 活动结束时间初始化
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
    
    UIButton *noBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.pickerBgTimeView.width-50, 0, 50, 30)];
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
- (void)showMyTimePicker:(UIButton *)sender {
    [self hidenKeyboard];
    NSLog(@"%ld",(long)sender.tag);
    self.selectedStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
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
    
    if ([self.selectedStr isEqualToString:@"4004"]) {
        [self.couponEndTimebtn setTitle:message forState:UIControlStateNormal];
    }
    if ([self.selectedStr isEqualToString:@"4005"]) {
        [self.endTimebtn setTitle:message forState:UIControlStateNormal];
    }
    
    [self hideMyTimePicker];
}

#pragma mark -TextViewDelegate
//开始编辑代金券textView时会调用该代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-180,width,height);
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
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.goodsNameField resignFirstResponder];
    [self.originalPrizeField resignFirstResponder];
    [self.discountlPrizeField resignFirstResponder];
    
    [self.onlinePayField resignFirstResponder];
    [self.couponBrandField resignFirstResponder];
    [self.couponPriceField1 resignFirstResponder];
    [self.couponPriceField2 resignFirstResponder];
    [self.goodsNumField resignFirstResponder];
    [self.actRuleTextView resignFirstResponder];
    
    [self.endTimeLabel resignFirstResponder];
    [self.couponEndTimebtn resignFirstResponder];
    
    [self resumeView];
}

//是否全店通用
- (void)selectGeneralBtnClicked{
    if(self.selectGeneralBtn.selected)
    {
        [self.selectGeneralBtn setSelected:NO];
        [self.selectGeneralBtn setImage:[UIImage imageNamed:@"DuoBao_Select.png"] forState:UIControlStateHighlighted];
        [self.selectGeneralBtn setImage:[UIImage imageNamed:@"DuoBao_Unselect.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.couponBrandBgView.hidden = NO;
            self.couponGeneral.left = self.couponBrandBgView.right+10;
            self.selectGeneralBtn.left = self.couponGeneral.right;
        }];
        
        
    }else{
        [self.selectGeneralBtn setSelected:YES];
        [self.selectGeneralBtn setImage:[UIImage imageNamed:@"DuoBao_Select.png"] forState:UIControlStateHighlighted];
        [self.selectGeneralBtn setImage:[UIImage imageNamed:@"DuoBao_Unselect.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.couponBrandBgView.hidden = YES;
            self.couponGeneral.left = 0;
            self.selectGeneralBtn.left = self.couponGeneral.right;
        }];
    }
}

- (void)addImageBtnClick:(id)sender{
    NSLog(@"点击了==--添加--==按钮");
    [self hidenKeyboard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 ) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if (buttonIndex == 1) {
        
        for (UIImageView *iv in _actIVs)
            iv.image = nil;
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        //        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (_isPhoto) {
        [self.totle removeAllObjects];
        _isPhoto = NO;
    }
    [self.totle addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    NSLog(@"%lu",(unsigned long)self.totle.count);
    
    //限制只能拍3张照片
    if (!(self.totle.count > 1)) {
        _selectNub = self.totle.count;
    }
    NSLog(@"%ld",(long)_selectNub);
    
    [self createImageView];
    
    //视觉上隐藏添加照片按钮
    [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    for (int i = 0; i < MIN(1, self.totle.count); i++){
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
    _isPhoto=YES;
    
    [self.totle removeAllObjects];
    
    NSRange range =  NSMakeRange(self.totle.count, aSelected.count);
    NSIndexSet *index = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.totle insertObjects:aSelected atIndexes:index];
    
    _selectNub = self.totle.count;
    
    [self createImageView];
    
    //视觉上隐藏添加照片按钮
    [self.addImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(1, self.totle.count); i++)
        {
            UIImageView *iv = _actIVs[i];
            iv.image = self.totle[i];
        }
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        for (int i = 0; i < MIN(1, self.totle.count); i++)
        {
            UIImageView *iv = _actIVs[i];
            iv.image = [ASSETHELPER getImageFromAsset:self.totle[i] type:ASSET_PHOTO_SCREEN_SIZE];
        }
        [ASSETHELPER clearData];
    }
}

- (void)saveBtnClick:(id)sender{
    NSLog(@"点击了==--保存并分享到微信--==按钮");
    [self hidenKeyboard];
    
    //清空活动图片数组避免重复数据
    self.imageArr = [NSMutableArray array];
    
    //产品名称
    if ([self.goodsNameField.text isBlankString]){
        
        [UIAlertView showInfoMsg:@"请输入产品名称"];
        [self.goodsNameField becomeFirstResponder];
        return;
    }
    
    //原价
    if ([self.originalPrizeField.text isBlankString]){
        
        [UIAlertView showInfoMsg:@"请输入原价"];
        [self.originalPrizeField becomeFirstResponder];
        return;
    }
    
    //打劫价
    if ([self.discountlPrizeField.text isBlankString]){
        
        [UIAlertView showInfoMsg:@"请输入打劫价"];
        [self.discountlPrizeField becomeFirstResponder];
        return;
    }
    
//    //线上付立减价格
//    if ([self.onlinePayField.text isBlankString]){
//        
//        [UIAlertView showInfoMsg:@"请输入线上付再减价格"];
//        [self.onlinePayField becomeFirstResponder];
//        return;
//    }
    
    //适用的品牌
    if (self.selectGeneralBtn.selected == NO) {
        if ([self.couponBrandField.text isBlankString]){
            
            [UIAlertView showInfoMsg:@"请输入适用的品牌"];
            [self.couponBrandField becomeFirstResponder];
            return;
        }

    }
    
    //代金卷区间
    if ([self.couponPriceField1.text isBlankString]||[self.couponPriceField2.text isBlankString]){
        
        [UIAlertView showInfoMsg:@"请输入代金券区间"];
        [self.couponPriceField1 becomeFirstResponder];
        return;
    }
    
    if ([self.couponPriceField2.text isEqual:@"0"]) {
        
        [UIAlertView showInfoMsg:@"代金券区间最大值不能为0"];
        [self.couponPriceField2 becomeFirstResponder];
        return;
    }
    
    //活动规则
    if ([self.actRuleTextView.text isBlankString]){
        
        [UIAlertView showInfoMsg:@"请输入活动规则"];
        [self.actRuleTextView becomeFirstResponder];
        return;
    }
    
    //当前时间获取
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayTimeString = [dateFormatter stringFromDate:[NSDate date]];
    
    //当前时间转换纯
    NSArray *todayArray = [todayTimeString componentsSeparatedByString:@"-"];
    todayTimeString = [todayArray componentsJoinedByString:@""];
    int today = [todayTimeString intValue];
    
    //结束时间转换
    NSString*endString = self.endTimebtn.titleLabel.text;
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    endString = [endArray componentsJoinedByString:@""];
    int end = [endString intValue];
    
    //结束时间转换
    NSString*couponEndString = self.endTimebtn.titleLabel.text;
    NSArray *couponEndArray = [couponEndString componentsSeparatedByString:@"-"];
    couponEndString = [couponEndArray componentsJoinedByString:@""];
    int couponEnd = [couponEndString intValue];
    
    if (endString == nil) {
        [UIAlertView showInfoMsg:@"未获取到活动结束时间"];
        return;
    }
    if (couponEndString == nil) {
        [UIAlertView showInfoMsg:@"未获取到代金券结束时间"];
        return;
    }
    if (today > end ) {
        [UIAlertView showInfoMsg:@"活动结束时间已失效请重新设置"];
        return;
    }
    if (today > couponEnd ) {
        [UIAlertView showInfoMsg:@"代金券结束时间已失效请重新设置"];
        return;
    }
    
    if([self.couponEndTimebtn.titleLabel.text isEqualToString:@"请点击设置结束时间"]){
        
        [UIAlertView showInfoMsg:@"请点击设置代金券结束时间"];
        return;
    }
    
    if([self.endTimebtn.titleLabel.text isEqualToString:@"请点击设置结束时间"]){
        
        [UIAlertView showInfoMsg:@"请点击设置活动结束时间"];
        return;
    }
    
    float price = [self.originalPrizeField.text floatValue];
    float lowestPrice = [self.discountlPrizeField.text floatValue];
    
    float startCouponPrice = [self.couponPriceField1.text floatValue];
    float endCouponPrice = [self.couponPriceField2.text floatValue];
    
    float number = [self.goodsNumField.text floatValue];
    
    if (price < lowestPrice) {
        [UIAlertView showInfoMsg:@"原价不能小于打劫价"];
        return;
    }
    
    if (startCouponPrice > endCouponPrice) {
        [UIAlertView showInfoMsg:@"代金券使用区间设置最小价格不能大于最大价格"];
        return;
    }
    
    if (number == 0) {
        [UIAlertView showInfoMsg:@"产品数量不能为0"];
        return;
    }
    
//    float onlinePay = [self.onlinePayField.text floatValue];
//    
//    if (lowestPrice < onlinePay) {
//        [UIAlertView showInfoMsg:@"在线支付再减钱数不可大于打劫价"];
//        return;
//    }
//    if (lowestPrice == onlinePay){
//        [UIAlertView showInfoMsg:@"在线支付再减钱数不可等于打劫价"];
//        return;
//    }
    
    //先注册后发布
    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"图片上传中请稍等";
        self.navigationItem.leftBarButtonItem.enabled = NO;
        
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

#pragma mark - Helpers &七牛
- (void)qiniuUpload:(int) index{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSString *token = @"5_06q8nFxevqEx7XeBFn5VBRtwVySPeQg2UCDo0R:cCvb_Qn5ayw5ulB7dVbpS-HSCvM=:eyJzY29wZSI6InlrbC1tZWlwYS1uZXQiLCJkZWFkbGluZSI6MzA0Mjc2NzQxMn0=";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
    
    // ------------------- Test putData -------------------------
    NSData *data;
    
    NSData *data1 = [self.goodsImageView1.image resizedAndReturnData];
    
    if (index == 0) {
        data = data1;
    }
    index++;
    
    QNUploadOption *option1 = [[QNUploadOption alloc]initWithProgessHandler:^(NSString *key, float percent) {
        NSLog(@"percent<%d>:%.2f",index,percent);
        _myPercent = percent;
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
                  
//                  NSData *data = [NSJSONSerialization dataWithJSONObject:self.imageArr
//                                                                 options:NSJSONWritingPrettyPrinted
//                                                                   error:nil];
//                  NSString *jsonString = [[NSString alloc] initWithData:data
//                                                               encoding:NSUTF8StringEncoding];
//                  NSLog(@"%@",jsonString);
                  
                  if (index<_selectNub){
                      
                      [self qiniuUpload:index];
                  }
                  else{
                      NSLog(@"完成");
                      self.navigationItem.leftBarButtonItem.enabled = YES;

                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      NSLog(@"%@",self.imageArr);
                      
                      NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
                      
                      NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                      
                      [parameters setObject:self.goodsNameField.text forKey:@"indiana_title"];
                      [parameters setObject:self.imageArr[0] forKey:@"indiana_photo"];
                      
                      self.actRuleTextView.text =[self.actRuleTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                      [parameters setObject:self.actRuleTextView.text forKey:@"indiana_desc"];
                      
                      [parameters setObject:rewardCode forKey:@"reward_code"];
                      [parameters setObject:self.couponEndTimebtn.titleLabel.text forKey:@"end_time"];
                      [parameters setObject:self.couponEndTimebtn.titleLabel.text forKey:@"coupon_end"];
                      [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
                      [parameters setObject:self.originalPrizeField.text forKey:@"indiana_price"];
                      [parameters setObject:self.discountlPrizeField.text forKey:@"indiana_sale"];
//                      [parameters setObject:self.onlinePayField.text forKey:@"indiana_reduce"];
                      
                      if(self.selectGeneralBtn.selected){
                          [parameters setObject:@"0" forKey:@"indiana_type"];
                      }else{
                          [parameters setObject:@"1" forKey:@"indiana_type"];
                          [parameters setObject:self.couponBrandField.text forKey:@"indiana_brand"];
                      }
                      
                      [parameters setObject:self.couponPriceField1.text forKey:@"coupon_min"];
                      [parameters setObject:self.couponPriceField2.text forKey:@"coupon_max"];
                      [parameters setObject:self.goodsNumField.text forKey:@"award_num"];
                      

                      //有活动ID则用活动ID无则为空
                      if (self.activityID == NULL) {
                          self.activityID=@"";
                      }
                      //再次发布，活动ID为空
                      if (self.isEndActivity&&!self.isWaitActivity) {
                          self.activityID=@"";
                      }
                      
                      [parameters setObject:self.activityID forKey:@"id"];
                      
                      NSError *parseError = nil;
                      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
                      NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                      NSLog(@"%@",str);

                      [YKLNetworkingDuoBao releasePrizesWithData:str Success:^(NSDictionary *dict) {
                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                          
                          //待发布发布不清空草稿箱
                          if ([self.activityID isBlankString]&&!self.isEndActivity) {
                              
                              [YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict = [NSMutableDictionary new];
                              [[YKLLocalUserDefInfo defModel] saveToLocalFile];
                          }
                          
                          self.payArray = [NSMutableArray array];
                          
                          self.orderStatus = [[dict objectForKey:@"state"]integerValue];
                          self.content = [dict objectForKey:@"content"];
                          self.totleMoney = [dict objectForKey:@"totleMoney"];
                          self.payArray = [dict objectForKey:@"pay"];
                          self.activityID = [dict objectForKey:@"id"];
                          
                          NSDictionary *tempDict = [dict objectForKey:@"activity"];
                         
                          self.shareTitle = [tempDict objectForKey:@"indiana_title"];
                          self.shareURL = [tempDict objectForKey:@"share_url"];
                          self.shareImage = [tempDict objectForKey:@"share_img"];
                          self.shareDesc = [tempDict objectForKey:@"share_desc"];
                          
                          NSString *strName = [YKLLocalUserDefInfo defModel].userName;
                          self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
                          
                          [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
                          [YKLLocalUserDefInfo defModel].shareURL = self.shareURL;
                          [YKLLocalUserDefInfo defModel].shareTitle = self.shareTitle;
                          [YKLLocalUserDefInfo defModel].shareDesc = self.shareDesc;
                          [YKLLocalUserDefInfo defModel].shareImage = self.shareImage;
                          [YKLLocalUserDefInfo defModel].shareActType = @"口袋夺宝";
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
                              
                              [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
                              [YKLLocalUserDefInfo defModel].shareURL = self.shareURL;
                              [YKLLocalUserDefInfo defModel].shareTitle = self.shareTitle;
                              [YKLLocalUserDefInfo defModel].shareDesc = self.shareDesc;
                              [YKLLocalUserDefInfo defModel].shareImage = self.shareImage;
                              [YKLLocalUserDefInfo defModel].shareActType = @"口袋夺宝";
                              [[YKLLocalUserDefInfo defModel]saveToLocalFile];
                              
                              
                              if ([[dict objectForKey:@"pay"] isEqual:@""] || [[dict objectForKey:@"pay"] isEqual:@[]]) {
                                  
                                  YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                                  ShareVC.hidenBar = YES;
                                  ShareVC.shareTitle = [YKLLocalUserDefInfo defModel].shareTitle;
                                  ShareVC.shareDesc = [YKLLocalUserDefInfo defModel].shareDesc;
                                  ShareVC.shareImg = [YKLLocalUserDefInfo defModel].shareImage;
                                  ShareVC.shareURL = [YKLLocalUserDefInfo defModel].shareURL;
                                  ShareVC.actType = [YKLLocalUserDefInfo defModel].shareActType;
                                  super.view.window.rootViewController = ShareVC;
                                  
                              }else{
                                  
                                  YKLPayViewController *payVC = [YKLPayViewController new];
                                  payVC.templateModel = dict;
                                  payVC.activityID = self.activityID;
                                  payVC.orderType = @"4";
                                  [self.navigationController pushViewController:payVC animated:YES];
                              
                              }                              
                          }

                          
                      } failure:^(NSError *error) {
                          
                      }];
                      
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

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

//保存文件到本地
- (void)saveDictForFiled{
    
    if (self.activityID == NULL) {
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        [tempDict setObject:self.goodsNameField.text forKey:@"indiana_title"];
        [tempDict setObject:self.actRuleTextView.text forKey:@"indiana_desc"];
        
//        [tempDict setObject:self.actRuleTextView.text forKey:@"indiana_photo"];
        
        NSArray *dataArr = [NSArray arrayWithObjects:self.goodsImageView1.image, nil];
        NSMutableArray *arr = [NSMutableArray array];
        
        if (self.selectNub>0) {
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"图片正在保存";
            
            for (int i = 0; i < self.selectNub; i++) {
                
                if (!(dataArr.count==0)) {
                    
                    NSData *data = [dataArr[i] resizedAndReturnData];
                    [arr addObject:data];
                    
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        [tempDict setObject:arr forKey:@"indiana_photo"];
        
        [tempDict setObject:self.originalPrizeField.text forKey:@"indiana_price"];
        [tempDict setObject:self.discountlPrizeField.text forKey:@"indiana_sale"];
//        [tempDict setObject:self.onlinePayField.text forKey:@"indiana_reduce"];
       
        //0全店通用 1品牌  indiana_type
        if (self.selectGeneralBtn.selected) {
            [tempDict setObject:@"0" forKey:@"indiana_type"];
        }else{
            //indiana_type=1 时 品牌名称  indiana_brand
            [tempDict setObject:@"1" forKey:@"indiana_type"];
            [tempDict setObject:self.couponBrandField.text forKey:@"indiana_brand"];
        }
        
        [tempDict setObject:self.couponPriceField1.text forKey:@"coupon_min"];
        [tempDict setObject:self.couponPriceField2.text forKey:@"coupon_max"];
        [tempDict setObject:self.goodsNumField.text forKey:@"award_num"]; 
        
        [tempDict setObject:self.couponEndTimebtn.titleLabel.text forKey:@"coupon_end"];
        [tempDict setObject:self.endTimebtn.titleLabel.text forKey:@"end_time"];
        
        NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
        [tempDict setObject:rewardCode forKey:@"reward_code"];
        
        
        [YKLLocalUserDefInfo defModel].saveDuoBaoActInfoDict = tempDict;
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.translucent = NO;
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"e19400"]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"613622"],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"613622"]];
    
    
    UIView *bgTitleView = [[UIView alloc]initWithFrame:CGRectMake(45, 5, 200, 35)];
    bgTitleView.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed: @"设置背景.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.frame = CGRectMake(0, 0, 200, 35);
    [bgTitleView addSubview:imageView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithHexString:@"613622"];
    title.font = [UIFont systemFontOfSize:16];
    title.text = @"游戏设置";
    [bgTitleView addSubview:title];
    
    self.navigationItem.titleView = bgTitleView;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:0];
    
}

- (void)showHelpView{
    
    [self hidenKeyboard];
   
    if (_PopupView.isClose) {
        
        [_PopupView hideRechargeAlertBgView];
        
    }else{
        
        [_PopupView createView:@{
                                 @"imgName":@"duoBaoHelp",
                                 @"imgFram":@[@10, @10, @300, @350],
                                 @"closeBtn":@"duoBaoClose",
                                 @"btnFram":@[@(310-18), @5, @23, @23]
                                 }];
        [self.view addSubview:_PopupView];
    }
}

@end
