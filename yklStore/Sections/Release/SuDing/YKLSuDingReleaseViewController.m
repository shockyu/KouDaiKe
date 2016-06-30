//
//  YKLSuDingReleaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/5.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLSuDingReleaseViewController.h"
#import "SJAvatarBrowser.h"
#import "AssetHelper.h"
#import "QiniuSDK.h"
#import "UIImage+ResizeMagick.h"
#import "YKLSuDingReleaseTemplateViewController.h"
#import "YKLLoginViewController.h"
#import "YKLTogetherShareViewController.h"
#import "YKLPopupView.h"

@interface YKLSuDingReleaseViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ImageCropViewControllerDelegate>

/** 上传图片总数 */
@property NSInteger selectNub;
/** 进度百分百 */
@property float myPercent;
/** 首页图片URL数组 */
@property (strong, nonatomic) NSMutableArray *indexImageURLArr;
/** 详情页图片URL数组 */
@property (strong, nonatomic) NSMutableArray *detailImageURLArr;
/** 是否为预览 */
@property BOOL preView;
/** 图片缓存，避免重复上传图片 */
@property (nonatomic, strong) NSString *imageJson;

@property (nonatomic, strong) YKLPopupView *PopupView;

@end

@implementation YKLSuDingReleaseViewController

- (NSMutableArray *)indexImageArr
{
    if (!_indexImageArr) {
        _indexImageArr = [[NSMutableArray alloc]init];
    }
    return _indexImageArr;
}

- (NSMutableArray *)indexImageURLArr
{
    if (!_indexImageURLArr) {
        _indexImageURLArr = [[NSMutableArray alloc]init];
    }
    return _indexImageURLArr;
}

- (NSMutableArray *)detailImageArr
{
    if (!_detailImageArr) {
        _detailImageArr = [[NSMutableArray alloc]init];
    }
    return _detailImageArr;
}

- (NSMutableArray *)detailImageURLArr
{
    if (!_detailImageURLArr) {
        _detailImageURLArr = [[NSMutableArray alloc]init];
    }
    return _detailImageURLArr;
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"一元速定";
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
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    [self createBgView];
    [self createContentBgView1];
    [self createContentBgView2];
    [self createContentBgView3];
    
    [self createIndexImage];
    [self createDetailImage];
    
    [self initView];
    [self showTime];
    
    _PopupView = [[YKLPopupView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    if (!(self.activityID == NULL)) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetWorkingSuDing getActListWithActID:self.activityID Success:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"%@",dict);
            
            NSDictionary *tempDict = dict;
            
            self.goodNameField.text = [tempDict objectForKey:@"good_name"];
            self.goodsNunField.text = [tempDict objectForKey:@"goods_num"];
            
            self.priceField.text = [tempDict objectForKey:@"goods_price"];
            self.miaoShaField.text = [tempDict objectForKey:@"seckill_price"];
            self.goodsDesc.text = [tempDict objectForKey:@"desc"];
            self.goodsDesc.text =[self.goodsDesc.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            self.goodsDescLabel.text = @"";
            
            self.templateNub = [tempDict objectForKey:@"template_id"];
            
            self.ruleDesc.text = [tempDict objectForKey:@"rule_desc"];
            self.ruleDesc.text =[self.ruleDesc.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            
            [self.showStartTimebtn setTitle:[NSString timeNumberHHmm:[tempDict objectForKey:@"seckill_end"]] forState:UIControlStateNormal];
            [self.actTemplateChangeBtn setTitle:[tempDict objectForKey:@"template_name"] forState:UIControlStateNormal];
            
            //分解现场兑奖码
            NSString *rewardCodeStr = [tempDict objectForKey:@"reward_code"];
            if (![rewardCodeStr isEqual:@""]) {
                self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
                self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
                self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
                self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
            }
            
            NSString *continueTime = [tempDict objectForKey:@"continue_time"];
            if ([continueTime isEqualToString:@"3"]) {
                [self Min10BtnClicked];
            }
            else if ([continueTime isEqualToString:@"5"]) {
                [self Min20BtnClicked];
            }
            else if ([continueTime isEqualToString:@"7"]) {
                [self Min30BtnClicked];
            }
            
            NSMutableArray *indexArr = [tempDict objectForKey:@"head_img"];
            NSMutableArray *detalArr = [tempDict objectForKey:@"desc_img"];
            
            if(IsEmpty(indexArr)){
                NSLog(@"首页图片数组为空");
            }else{
                
                for (int i = 0; i < indexArr.count; i++) {
                    
                    UIImageView *decodedImage = [UIImageView new];
                    [decodedImage sd_setImageWithURL:indexArr[i] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        [self.indexImageArr addObject:decodedImage.image];
                        [self createIndexImage];
                    }];
                }
                
            }
            
            if(IsEmpty(detalArr)){
                NSLog(@"详情图片数组为空");
            }else{
                
                for (int i = 0; i < detalArr.count; i++) {
                    
                    UIImageView *decodedImage = [UIImageView new];
                    [decodedImage sd_setImageWithURL:detalArr[i] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        [self.detailImageArr addObject:decodedImage.image];
                        [self createDetailImage];
                    }];
                }
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    //如果本地存储活动字典不为空则加载其数据
    else if (![[YKLLocalUserDefInfo defModel].saveSuDingActInfoDict isEqual:@{}]) {
        
        NSMutableDictionary *tempDict = [YKLLocalUserDefInfo defModel].saveSuDingActInfoDict;
        
        
        self.goodNameField.text = [tempDict objectForKey:@"good_name"];
        self.goodsNunField.text = [tempDict objectForKey:@"goods_num"];
        
        self.priceField.text = [tempDict objectForKey:@"goods_price"];
        self.miaoShaField.text = [tempDict objectForKey:@"seckill_price"];
        self.goodsDesc.text = [tempDict objectForKey:@"desc"];
        self.templateNub = [tempDict objectForKey:@"template_id"];
        
        self.ruleDesc.text = [tempDict objectForKey:@"rule_desc"];
        
        [self.showStartTimebtn setTitle:[tempDict objectForKey:@"seckill_end"] forState:UIControlStateNormal];
        [self.actTemplateChangeBtn setTitle:[tempDict objectForKey:@"template_name"] forState:UIControlStateNormal];
        
        //分解现场兑奖码
        NSString *rewardCodeStr = [tempDict objectForKey:@"reward_code"];
        if (![rewardCodeStr isEqual:@""]) {
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
        }
        
        NSString *continueTime = [tempDict objectForKey:@"continue_time"];
        if ([continueTime isEqualToString:@"3"]) {
            [self Min10BtnClicked];
        }
        else if ([continueTime isEqualToString:@"5"]) {
            [self Min20BtnClicked];
        }
        else if ([continueTime isEqualToString:@"7"]) {
            [self Min30BtnClicked];
        }
        
        NSMutableArray *indexArr = [tempDict objectForKey:@"head_img"];
        NSMutableArray *detalArr = [tempDict objectForKey:@"desc_img"];
        
        if(IsEmpty(indexArr)){
            NSLog(@"首页图片数组为空");
        }else{
            
            for (int i = 0; i < indexArr.count; i++) {
                
                //将data转换为image
                UIImage *decodedImage = [UIImage imageWithData:indexArr[i]];
                [self.indexImageArr addObject:decodedImage];
            }
            
            [self createIndexImage];
        }
        
        if(IsEmpty(detalArr)){
            NSLog(@"详情图片数组为空");
        }else{
            
            for (int i = 0; i < detalArr.count; i++) {
                
                //将data转换为image
                UIImage *decodedImage = [UIImage imageWithData:detalArr[i]];
                [self.detailImageArr addObject:decodedImage];
            }
            
            [self createDetailImage];
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    //首次进入弹出帮助页面
    if ([[YKLLocalUserDefInfo defModel].suDingHelp isEqual:@"YES"]) {
        
        [self showHelpView];
        
        [YKLLocalUserDefInfo defModel].suDingHelp = @"NO";
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}

//判断数组是否为空
static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

//左边返回按钮设置
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
        
        //发布活动键盘未收起推出时闪屏修改,延迟两个0.25来执行键盘收起的动画。
        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        
    }else if (buttonIndex == 1){
        
        if (self.activityID == NULL) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
        }
    }
}

- (void)popHidden{
    
    if (self.activityID == NULL) {
        
        //保存到本地
        [self saveDictForFiled];
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        
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
    self.scrollView.contentSize = CGSizeMake(self.view.width, 1132-30);
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.view.width, 580)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+15, self.view.width, 160)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
    self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+15, self.view.width, 316)];
    self.bgView3.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView3];
}

#pragma mark - 创建速定产品设置页内容

- (void)createContentBgView1{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"速定产品设置";
    [self.bgView1 addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 55, 35)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"产品名:";
    [self.bgView1 addSubview:titleLabel];
    
    self.goodNameField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 220, titleLabel.height)];
    self.goodNameField.font = [UIFont systemFontOfSize:14];
    self.goodNameField.keyboardType = UIKeyboardTypeDefault;
    self.goodNameField.placeholder = @"请设置产品名";
    self.goodNameField.delegate = self;
    [self.bgView1 addSubview:self.goodNameField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom+15, 120, 15)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"上传首页图片";
    [self.bgView1 addSubview:titleLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+70-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 70, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"速定数量：";
    [self.bgView1 addSubview:titleLabel];
    
    self.goodsNunField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 220, titleLabel.height)];
    //    self.goodsNunField.backgroundColor = [UIColor grayColor];
    self.goodsNunField.font = [UIFont systemFontOfSize:14];
    self.goodsNunField.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsNunField.placeholder = @"请设置产品数量";
    self.goodsNunField.returnKeyType = UIReturnKeyNext;
    self.goodsNunField.delegate = self;
    [self.bgView1 addSubview:self.goodsNunField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 70, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    //    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = @"原价：";
    [self.bgView1 addSubview:titleLabel];
    
    self.priceField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 220, titleLabel.height)];
    //    self.priceField.backgroundColor = [UIColor grayColor];
    self.priceField.font = [UIFont systemFontOfSize:14];
    self.priceField.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceField.placeholder = @"请设置原价";
    self.priceField.returnKeyType = UIReturnKeyNext;
    self.priceField.delegate = self;
    [self.bgView1 addSubview:self.priceField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 70, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"速定价:";
    [self.bgView1 addSubview:titleLabel];
    
    self.miaoShaField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 220, titleLabel.height)];
    //    self.miaoShaField.backgroundColor = [UIColor grayColor];
    self.miaoShaField.font = [UIFont systemFontOfSize:14];
    self.miaoShaField.keyboardType = UIKeyboardTypeDecimalPad;
    self.miaoShaField.placeholder = @"请设置速定价";
    self.miaoShaField.delegate = self;
    [self.bgView1 addSubview:self.miaoShaField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom+15, 120, 15)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"上传详情页图片";
    [self.bgView1 addSubview:titleLabel];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+70-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView1 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 120, 35)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"详情页描述";
    [self.bgView1 addSubview:titleLabel];
    
    self.goodsDesc = [[UITextView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, self.view.width-20, 180)];
    self.goodsDesc.backgroundColor = [UIColor flatLightWhiteColor];
    self.goodsDesc.keyboardType = UIKeyboardTypeDefault;
    self.goodsDesc.layer.cornerRadius = 5;
    self.goodsDesc.layer.masksToBounds = YES;
    self.goodsDesc.font = [UIFont systemFontOfSize:12];
    self.goodsDesc.returnKeyType = UIReturnKeyNext;
    self.goodsDesc.textColor = [UIColor blackColor];
    self.goodsDesc.delegate = self;
    self.goodsDesc.tag = 6000;
    [self.bgView1 addSubview:self.goodsDesc];
    
    _goodsDescLabel = [[UILabel alloc ]initWithFrame:CGRectMake(10, 0, self.goodsDesc.width-20, 180)];
    _goodsDescLabel.textAlignment = NSTextAlignmentCenter;
    _goodsDescLabel.text = @"简单描述产品的功效和卖点";
    _goodsDescLabel.enabled = NO;//lable必须设置为不可用
    _goodsDescLabel.backgroundColor = [UIColor clearColor];
    [self.goodsDesc addSubview:_goodsDescLabel];
    
}


#pragma mark - 创建其他设置页内容

- (void)createContentBgView2{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 35)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"其他设置";
    [self.bgView2 addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 70, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"选择模板:";
    [self.bgView2 addSubview:titleLabel];
    
    self.actTemplateChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actTemplateChangeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.actTemplateChangeBtn setTitle:@"请点击选择模板" forState:UIControlStateNormal];
    [self.actTemplateChangeBtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    [self.actTemplateChangeBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.actTemplateChangeBtn.frame = CGRectMake(titleLabel.right, titleLabel.top, 225, titleLabel.height);
    [self.actTemplateChangeBtn addTarget:self action:@selector(actTemplateChangeBtnClickClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: self.actTemplateChangeBtn];
    
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 120, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"速定结束时间:";
    [self.bgView2 addSubview:titleLabel];
    
    self.showStartTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showStartTimebtn.frame = CGRectMake(titleLabel.right, titleLabel.top, self.view.width-titleLabel.right-2, titleLabel.height);
    [self.showStartTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.showStartTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    //当前时间
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [self.showStartTimebtn setTitle:@"请点击设置速定结束时间" forState:UIControlStateNormal];
    [self.showStartTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.showStartTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [self.bgView2 addSubview:self.showStartTimebtn];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 110, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"订货过期时间:";
    [self.bgView2 addSubview:titleLabel];
    
    self.Min10Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Min10Btn.frame = CGRectMake(titleLabel.right, 0, 15, 15);\
    self.Min10Btn.centerY = titleLabel.centerY;
    [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn2"] forState:UIControlStateNormal];
    [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn1"] forState:UIControlStateSelected];
    [self.Min10Btn addTarget:self action:@selector(Min10BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.Min10Btn.selected = YES;
    [self.bgView2 addSubview:self.Min10Btn];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.Min10Btn.right, lineView.bottom, 40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"3天";
    [self.bgView2 addSubview:titleLabel];
    
    self.Min20Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Min20Btn.frame = CGRectMake(titleLabel.right+5, 0, 15, 15);\
    self.Min20Btn.centerY = titleLabel.centerY;
    [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn2"] forState:UIControlStateNormal];
    [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn1"] forState:UIControlStateSelected];
    [self.Min20Btn addTarget:self action:@selector(Min20BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //    self.Min20Btn.selected = YES;
    [self.bgView2 addSubview:self.Min20Btn];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.Min20Btn.right, lineView.bottom, 40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"5天";
    [self.bgView2 addSubview:titleLabel];
    
    self.Min30Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Min30Btn.frame = CGRectMake(titleLabel.right+5, 0, 15, 15);\
    self.Min30Btn.centerY = titleLabel.centerY;
    [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn2"] forState:UIControlStateNormal];
    [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn1"] forState:UIControlStateSelected];
    [self.Min30Btn addTarget:self action:@selector(Min30BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //    self.Min20Btn.selected = YES;
    [self.bgView2 addSubview:self.Min30Btn];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.Min30Btn.right, lineView.bottom, 40, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"7天";
    [self.bgView2 addSubview:titleLabel];
    
//    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.bgView2 addSubview:lineView];
//    
//    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 120, 30)];
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    titleLabel.text = @"单个用户购买上限:";
//    [self.bgView2 addSubview:titleLabel];
//    
//    self.payNunField = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, 150, titleLabel.height)];
//    //    self.payNunField.backgroundColor = [UIColor grayColor];
//    self.payNunField.font = [UIFont systemFontOfSize:14];
//    self.payNunField.keyboardType = UIKeyboardTypeNumberPad;
//    self.payNunField.placeholder = @"请设置购买上限";
//    self.payNunField.delegate = self;
//    [self.bgView2 addSubview:self.payNunField];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 70, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"兑换码:";
    [self.bgView2 addSubview:titleLabel];
    
    self.securityTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top+2, 25, 25)];
    self.securityTextField1.textAlignment = NSTextAlignmentCenter;
    self.securityTextField1.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField1.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField1.delegate = self;
    self.securityTextField1.font = [UIFont systemFontOfSize:14];
    self.securityTextField1.returnKeyType = UIReturnKeyNext;
    self.securityTextField1.text = @"0";
    [self.bgView2 addSubview:self.securityTextField1];
    
    self.securityTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField1.right+5, self.securityTextField1.top, 25, 25)];
    self.securityTextField2.textAlignment = NSTextAlignmentCenter;
    self.securityTextField2.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField2.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField2.delegate = self;
    self.securityTextField2.font = [UIFont systemFontOfSize:14];
    self.securityTextField2.returnKeyType = UIReturnKeyNext;
    self.securityTextField2.text = @"0";
    [self.bgView2 addSubview:self.securityTextField2];
    
    self.securityTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField2.right+5, self.securityTextField1.top, 25, 25)];
    self.securityTextField3.textAlignment = NSTextAlignmentCenter;
    self.securityTextField3.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField3.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField3.delegate = self;
    self.securityTextField3.font = [UIFont systemFontOfSize:14];
    self.securityTextField3.returnKeyType = UIReturnKeyNext;
    self.securityTextField3.text = @"0";
    [self.bgView2 addSubview:self.securityTextField3];
    
    self.securityTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField3.right+5, self.securityTextField1.top, 25, 25)];
    self.securityTextField4.textAlignment = NSTextAlignmentCenter;
    self.securityTextField4.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField4.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField4.delegate = self;
    self.securityTextField4.font = [UIFont systemFontOfSize:14];
    self.securityTextField4.returnKeyType = UIReturnKeyNext;
    self.securityTextField4.text = @"0";
    [self.bgView2 addSubview:self.securityTextField4];
    
    UIButton *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    securityBtn.backgroundColor = [UIColor clearColor];
    securityBtn.frame = CGRectMake(self.securityTextField1.left, self.securityTextField1.top, 130, 25);
    [securityBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview:securityBtn];
    
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView2 addSubview:lineView];
    
}


#pragma mark - 创建活动规则设置页内容

- (void)createContentBgView3{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 30)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"活动规则设置";
    [self.bgView3 addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:lineView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.bottom, 65, 35)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"活动规则";
    [self.bgView3 addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, lineView.bottom+5, 45, 25)];
    //    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"(可编辑)";
    [self.bgView3 addSubview:titleLabel];
    
    
    self.ruleDesc = [[UITextView alloc]initWithFrame:CGRectMake(10, titleLabel.bottom, self.view.width-20, 195)];
    self.ruleDesc.backgroundColor = [UIColor flatLightWhiteColor];
    self.ruleDesc.keyboardType = UIKeyboardTypeDefault;
    self.ruleDesc.layer.cornerRadius = 5;
    self.ruleDesc.layer.masksToBounds = YES;
    self.ruleDesc.font = [UIFont systemFontOfSize:12];
    self.ruleDesc.returnKeyType = UIReturnKeyNext;
    self.ruleDesc.textColor = [UIColor blackColor];
    self.ruleDesc.delegate = self;
    self.ruleDesc.text = @"1.看中产品后，在线支付1元，即可按速定价享受优惠，并到门店付清尾款再拿走产品；\n2.您支付的一元为本产品定金，仅限本店本产品一次性购买一个产品时优惠使用；\n3.获得本次速定优惠，则不可同时再参与本产品在本店的其他优惠；\n4.超过规定期限，未到门店兑换产品，将不退还1元定金；\n5.活动页面产品图片及信息仅供参照，产品以实物为准；\n6.兑奖只以活动兑奖页面显示的内容为准，截图或短信均为无效。\n7.本活动最终解释权归本店所有。";
    [self.bgView3 addSubview:self.ruleDesc];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, self.ruleDesc.bottom+10, self.view.width-20, 40);
    button.backgroundColor = [UIColor flatLightRedColor];
    [button setTitle:@"确认发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(saveGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView3 addSubview:button];
    
}

#pragma mark - 分钟选择按钮点击方法

- (void)Min10BtnClicked{
    
    if(!self.Min10Btn.selected)
    {
        
        [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
    [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    
    [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
    [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    
    self.Min10Btn.selected = YES;
    self.Min20Btn.selected = NO;
    self.Min30Btn.selected = NO;
    
    
}

- (void)Min20BtnClicked{
    
    if(!self.Min20Btn.selected)
    {
        
        [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
    [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    
    [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
    [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    
    self.Min20Btn.selected = YES;
    self.Min10Btn.selected = NO;
    self.Min30Btn.selected = NO;
    
}

- (void)Min30BtnClicked{
    
    if(!self.Min30Btn.selected)
    {
        
        [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
        [self.Min30Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    }
    
    [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
    [self.Min10Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    
    [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn1.png"] forState:UIControlStateHighlighted];
    [self.Min20Btn setImage:[UIImage imageNamed:@"bankBtn2.png"] forState:UIControlStateNormal];
    
    self.Min30Btn.selected = YES;
    self.Min10Btn.selected = NO;
    self.Min20Btn.selected = NO;
    
}


#pragma mark - 兑换码选择器显示

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

#pragma mark - 兑换码选择器方法

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

#pragma mark - 时间选择器显示

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
    
    //    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Date滚轮"]];
    //    imageView.frame = CGRectMake(0, 50, ScreenWidth, 216);
    //    [self.pickerBgTimeView addSubview:imageView];
    
    self.myTimePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 216)];
    self.myTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.myTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.myTimePicker.minimumDate = minDate;
    
    [self.pickerBgTimeView addSubview:self.myTimePicker];
    
}

#pragma mark - 时间选择器方法

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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatter stringFromDate:selected];
    NSString *message =  [NSString stringWithFormat:@"%@", destDateString];
    
    [self.showStartTimebtn setTitle:message forState:UIControlStateNormal];
    
    [self hideMyTimePicker];
    
}

#pragma mark - 创建商品图片

#define pictureHW 50    //(ScreenWidth - 5*10)/4
#define MaxImageCount 3
#define deleImageWH 20 // 删除按钮的宽高


- (void)createIndexImage{
    
    //首页图片背景视图
    self.indexImageBgView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSInteger imageCount = [self.indexImageArr count];
    
    for (NSInteger i = 0; i < imageCount; i++) {
        
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i*(pictureHW+10), 5, pictureHW, pictureHW)];
        
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapPhoto:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH+3, -3, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = 2000 + i;
        pictureImageView.userInteractionEnabled = YES;
        
        pictureImageView.image = [self.indexImageArr objectAtIndex:i];
        
        [self.indexImageBgView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount) {
        
        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + imageCount*(pictureHW+10), 5, pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"DuoBao_AddImg"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addIndexImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.indexImageBgView addSubview:addPictureButton];
        
        self.addIndexImageBtn = addPictureButton;
    }
    
    self.indexImageBgView.frame = CGRectMake(0, self.goodNameField.bottom+35+10, ScreenWidth, 55);
    self.indexImageBgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.indexImageBgView];
    
}

- (void)createDetailImage{
    
    //首页图片背景视图
    self.detailImageBgView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSInteger imageCount = [self.detailImageArr count];
    
    for (NSInteger i = 0; i < imageCount; i++) {
        
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i*(pictureHW+10), 5, pictureHW, pictureHW)];
        
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapPhoto:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH+3, -3, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"退出"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deleteDetailPic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = 3000 + i;
        pictureImageView.userInteractionEnabled = YES;
        
        pictureImageView.image = [self.detailImageArr objectAtIndex:i];
        
        [self.detailImageBgView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount) {
        
        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + imageCount*(pictureHW+10), 5, pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"DuoBao_AddImg"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addDetailmageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.detailImageBgView addSubview:addPictureButton];
        
        self.addDetailmageBtn = addPictureButton;
    }
    
    self.detailImageBgView.frame = CGRectMake(0, self.miaoShaField.bottom+35+10, ScreenWidth, 55);
    self.detailImageBgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.detailImageBgView];
    
}

//单击图片放大
- (void)singleTapPhoto:(UITapGestureRecognizer *)sender{
    
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

// 首页图片删除
- (void)deletePic:(UIButton *)btn
{
    
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [self.indexImageArr removeObjectAtIndex:(imageView.tag - 2000)];
        [imageView removeFromSuperview];
    }
    [self createIndexImage];
}

// 详情图片删除
- (void)deleteDetailPic:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [self.detailImageArr removeObjectAtIndex:(imageView.tag - 3000)];
        [imageView removeFromSuperview];
    }
    [self createDetailImage];
    
}

- (void)addIndexImageBtnClick:(id)sender{
    NSLog(@"点击了==--添加首页图片--==按钮");
    [self hidenKeyboard];
    
    _photoNub = 1;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)addDetailmageBtnClick:(id)sender{
    NSLog(@"点击了==--添加详情页图片--==按钮");
    [self hidenKeyboard];
    
    _photoNub = 2;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }
    else if(buttonIndex == 1){
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
        cont.nMaxCount = 1;
        cont.nColumnCount = 4;
        cont.nResultType = DO_PICKER_RESULT_ASSET;
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    if (_photoNub == 1)
    {
        //跳转裁剪页面
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        controller.type = 1;
        controller.delegate = self;
        controller.blurredBackground = YES;
        [[self navigationController] pushViewController:controller animated:YES];
        
    }
    else if (_photoNub == 2)
    {
        //往图片数组中添加新的图片
        [self.detailImageArr addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
        
        //初始化图片内容
        [self createDetailImage];
        
    }
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImageView *iv = [UIImageView new];
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        for (int i = 0; i < MIN(1, aSelected.count); i++)
        {
            iv.image = aSelected[i];
        }
        
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        for (int i = 0; i < MIN(1, aSelected.count); i++)
        {
            iv.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
        }
    }
    
    
    if (_photoNub == 1)
    {
        //跳转裁剪页面
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:iv.image];
        controller.type = 1;
        controller.delegate = self;
        controller.blurredBackground = YES;
        [[self navigationController] pushViewController:controller animated:YES];
        
    }
    else if (_photoNub == 2)
    {
        //往图片数组中添加新的图片
        [self.detailImageArr addObject:iv.image];
        
        //初始化图片内容
        [self createDetailImage];
        
    }
    
}

#pragma mark - 裁剪功能协议

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    
    if (_photoNub == 1)
    {
        //往图片数组中添加新的图片
        [self.indexImageArr addObject:croppedImage];
        
        //初始化图片内容
        [self createIndexImage];
        
    }
    else if (_photoNub == 2)
    {
        //往图片数组中添加新的图片
        [self.detailImageArr addObject:croppedImage];
        
        //初始化图片内容
        [self createDetailImage];
        
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)actTemplateChangeBtnClickClick:(id)sender{
    NSLog(@"选择模板");
    
    YKLSuDingReleaseTemplateViewController *releaseVC = [YKLSuDingReleaseTemplateViewController new];
    [self.navigationController pushViewController:releaseVC animated:YES];
}

#pragma mark - 键盘弹出
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

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 6000) {
        
        if (textView.text.length == 0) {
            _goodsDescLabel.text = @"简单描述产品的功效和卖点";
        }else{
            _goodsDescLabel.text = @"";
        }
    }
}

//恢复原始视图位置
- (void)resumeView
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
- (void)hidenKeyboard
{
    [self.goodNameField resignFirstResponder];
    [self.goodsNunField resignFirstResponder];
    [self.priceField resignFirstResponder];
    [self.miaoShaField resignFirstResponder];
    [self.goodsDesc resignFirstResponder];
    [self.payNunField resignFirstResponder];
    [self.ruleDesc resignFirstResponder];
    
    //    [self.endTimeLabel resignFirstResponder];
    //    [self.couponEndTimebtn resignFirstResponder];
    
    [self resumeView];
}

#pragma mark - Helpers &七牛

- (void)qiniuUpload:(int) index{
    
    //上传图片计数字段
    __block int indexNun = index;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"图片上传中请稍等";
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    _selectNub = self.indexImageArr.count + self.detailImageArr.count;
    
    // ------------------- Test putData -------------------------
    NSMutableArray *imageArr = [NSMutableArray new];
    [imageArr addObjectsFromArray:self.indexImageArr];
    [imageArr addObjectsFromArray:self.detailImageArr];
    
    NSData *data = [imageArr[indexNun] resizedAndReturnData];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSString *token = @"5_06q8nFxevqEx7XeBFn5VBRtwVySPeQg2UCDo0R:cCvb_Qn5ayw5ulB7dVbpS-HSCvM=:eyJzY29wZSI6InlrbC1tZWlwYS1uZXQiLCJkZWFkbGluZSI6MzA0Mjc2NzQxMn0=";
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg", [self getDateTimeString], [self randomStringWithLength:8]];
    
    QNUploadOption *myOption = [[QNUploadOption alloc]initWithProgessHandler:^(NSString *key, float percent) {
        NSLog(@"percent<%d>:%.2f",index,percent);
        _myPercent = percent;
    }];
    
    [upManager putData:data
                   key:fileName
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  NSString *actImageURL = [NSString stringWithFormat:@"http://img.meipa.net/%@",[resp objectForKey:@"key"]];
                  NSLog(@"%d>>>%@",indexNun,actImageURL);
                  
                  if (indexNun < self.indexImageArr.count) {
                      
                      [self.indexImageURLArr addObject:actImageURL];
                  }
                  else{
                      [self.detailImageURLArr addObject:actImageURL];
                  }
                  
                  if (indexNun<_selectNub-1){
                      NSLog(@"已上传%d张图片",indexNun+1);
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      
                      //循环使用index标记来上传多张图片
                      indexNun++;
                      [self qiniuUpload:indexNun];
                      
                  }
                  else{
                      NSLog(@"完成");
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      NSLog(@"index:%@------detail:%@",self.indexImageURLArr,self.detailImageURLArr);
                      self.navigationItem.leftBarButtonItem.enabled = YES;
                      
                      [self releaseAct];
                  }
              }
                option:myOption];
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

#pragma mark - 发布按钮方法

- (void)saveGoodsBtnClick:(UIButton *)sender{
    NSLog(@"点击了----发布----按钮");
    [self hidenKeyboard];
    
    if ([self.goodNameField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置产品名"];
        [self.goodNameField becomeFirstResponder];
        return;
    }
    
    if ([self.goodsDesc.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置详情描述"];
        [self.goodsDesc becomeFirstResponder];
        return;
    }
    
    if ([self.ruleDesc.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置活动规则"];
        [self.ruleDesc becomeFirstResponder];
        return;
    }
    
    if([self.actTemplateChangeBtn.titleLabel.text isEqualToString:@"请点击选择模板"]){
        [UIAlertView showInfoMsg:@"请点击选择模板"];
        return;
    }
    
    if([self.showStartTimebtn.titleLabel.text isEqualToString:@"请点击设置速定结束时间"]){
        [UIAlertView showInfoMsg:@"请点击设置速定结束时间"];
        return;
    }
    
    if ([self.priceField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置原价"];
        [self.priceField becomeFirstResponder];
        return;
    }
    
    if ([self.miaoShaField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置速定价"];
        [self.miaoShaField becomeFirstResponder];
        return;
    }
    
    if ([self.goodsNunField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请设置速定数量"];
        [self.goodsNunField becomeFirstResponder];
    }
    
    float price = [self.priceField.text floatValue];
    float miaoShaPrice = [self.miaoShaField.text floatValue];
    float number = [self.goodsNunField.text floatValue];
    
    if (miaoShaPrice > price || miaoShaPrice == price) {
        
        [UIAlertView showInfoMsg:@"速定价不能大于等于原价"];
        [self.priceField becomeFirstResponder];
        return;
    }
    
    if (price == 0) {
        [UIAlertView showInfoMsg:@"原价不能为0"];
        [self.priceField becomeFirstResponder];
        return;
    }
    
    if (number == 0) {
        [UIAlertView showInfoMsg:@"产品数量不能为0"];
        [self.goodsNunField becomeFirstResponder];
        return;
    }
    
    //判断是否有上传图片
    if (self.indexImageArr.count == 0 ) {
        [UIAlertView showInfoMsg:@"请选择首页图片"];
        return;
    }
    if (self.detailImageArr.count == 0 ) {
        [UIAlertView showInfoMsg:@"请选择详情页图片"];
        return;
    }
    
    //先注册后发布
    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
        
        //发布活动时禁用左键返回
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

/*
 * 预览方法
 */
- (void)preViewAct{
    
}

/*
 * 发布方法
 */
- (void)releaseAct{
    
    //发布信息转换为Json
    NSString *str = [self releaseInfoForJson];
    
    [YKLNetWorkingSuDing releaseActWithData:str Success:^(NSDictionary *dict) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //待发布发布不清空草稿箱
        if ([self.activityID isBlankString]&&!self.isEndActivity) {
            
            [YKLLocalUserDefInfo defModel].saveSuDingActInfoDict = [NSMutableDictionary new];
            [[YKLLocalUserDefInfo defModel] saveToLocalFile];
        }
        
        if ([dict isEqual:@"活动结束日期已过，请重新发布！"]) {
            [UIAlertView showInfoMsg:@"活动结束日期已过，请重新发布！"];
            self.indexImageURLArr = [NSMutableArray array];
            self.detailImageURLArr = [NSMutableArray array];
            _selectNub = 0;
            return;
        }
        
        NSDictionary *tempDict = [dict objectForKey:@"together"];
        self.activityID = [tempDict objectForKey:@"id"];
        self.shareTitle = [tempDict objectForKey:@"good_name"];
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
        [YKLLocalUserDefInfo defModel].shareActType = @"一元速定";
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
                payVC.orderType = @"6";
                [self.navigationController pushViewController:payVC animated:YES];
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

/*
 * 保存文件到本地
 */
- (void)saveDictForFiled{
    
    NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
    
    //速定订货过期时间
    NSString *timeMin;
    if (self.Min10Btn.selected) {
        timeMin = @"3";
    }
    else if (self.Min20Btn.selected)
    {
        timeMin = @"5";
    }
    else if (self.Min30Btn.selected)
    {
        timeMin = @"7";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    [parameters setObject:self.goodNameField.text forKey:@"good_name"];
    [parameters setObject:self.goodsNunField.text forKey:@"goods_num"];
    [parameters setObject:self.priceField.text forKey:@"goods_price"];
    [parameters setObject:self.miaoShaField.text forKey:@"seckill_price"];
    [parameters setObject:self.goodsDesc.text forKey:@"desc"];
    [parameters setObject:timeMin forKey:@"continue_time"];
    [parameters setObject:rewardCode forKey:@"reward_code"];
    [parameters setObject:self.ruleDesc.text forKey:@"rule_desc"];
    
    [parameters setObject:self.showStartTimebtn.titleLabel.text forKey:@"seckill_end"];
    [parameters setObject:self.actTemplateChangeBtn.titleLabel.text forKey:@"template_name"];
    if (self.templateNub) {
        
        [parameters setObject:self.templateNub forKey:@"template_id"];
    }
    
    NSMutableArray *indexArr = [NSMutableArray array];
    
    for (int i = 0; i < self.indexImageArr.count; i++) {
        
        NSData *data = [self.indexImageArr[i] resizedAndReturnData];
        [indexArr addObject:data];
    }
    [parameters setObject:indexArr forKey:@"head_img"];
    
    
    NSMutableArray *detailArr = [NSMutableArray array];
    for (int i = 0; i < self.detailImageArr.count; i++) {
        
        NSData *data = [self.detailImageArr[i] resizedAndReturnData];
        [detailArr addObject:data];
    }
    [parameters setObject:detailArr forKey:@"desc_img"];
    
    
    //有活动ID则用活动ID无则为空
    if (self.activityID == NULL) {
        self.activityID= @"";
    }
    //再次发布，活动ID为空
    if (self.isEndActivity && !self.isWaitActivity) {
        self.activityID= @"";
    }
    [parameters setObject:self.activityID forKey:@"id"];
    
    
    [YKLLocalUserDefInfo defModel].saveSuDingActInfoDict = parameters;
    [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    
}

#pragma mark - 发布信息转换Jso

/*
 * 发布信息转换Json
 */
- (NSString *)releaseInfoForJson{
    
    NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
    
    //速定订货过期时间
    NSString *timeMin;
    if (self.Min10Btn.selected) {
        timeMin = @"3";
    }
    else if (self.Min20Btn.selected)
    {
        timeMin = @"5";
    }
    else if (self.Min30Btn.selected)
    {
        timeMin = @"7";
    }
    
    NSString *goodsDesc = [self.goodsDesc.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSString *ruleDesc = [self.ruleDesc.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    [parameters setObject:self.goodNameField.text forKey:@"good_name"];
    [parameters setObject:self.goodsNunField.text forKey:@"goods_num"];
    [parameters setObject:self.priceField.text forKey:@"goods_price"];
    [parameters setObject:self.miaoShaField.text forKey:@"seckill_price"];
    [parameters setObject:goodsDesc forKey:@"desc"];
    [parameters setObject:timeMin forKey:@"continue_time"];
    [parameters setObject:rewardCode forKey:@"reward_code"];
    [parameters setObject:ruleDesc forKey:@"rule_desc"];
    
    if (self.showStartTimebtn.titleLabel.text) {
        [parameters setObject:self.showStartTimebtn.titleLabel.text forKey:@"seckill_end"];
    }
    
    if (self.templateNub) {
        
        [parameters setObject:self.templateNub forKey:@"template_id"];
    }
    
    
    [parameters setObject:self.indexImageURLArr forKey:@"head_img"];
    [parameters setObject:self.detailImageURLArr forKey:@"desc_img"];
    
    //有活动ID则用活动ID无则为空
    if (self.activityID == NULL) {
        self.activityID= @"";
    }
    //再次发布，活动ID为空
    if (self.isEndActivity && !self.isWaitActivity) {
        self.activityID= @"";
    }
    [parameters setObject:self.activityID forKey:@"id"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    return str;
}

- (void)showHelpView{
    
    [self hidenKeyboard];
    
    if (_PopupView.isClose) {
        
        [_PopupView hideRechargeAlertBgView];
        
    }else{
        
        [_PopupView createView:@{
                                 @"imgName":@"suDingHelp",
                                 @"imgFram":@[@10, @10, @300, @350],
                                 @"closeBtn":@"suDingClose",
                                 @"btnFram":@[@(310-18), @5, @23, @23]
                                 }];
        [self.view addSubview:_PopupView];
    }
}

@end
