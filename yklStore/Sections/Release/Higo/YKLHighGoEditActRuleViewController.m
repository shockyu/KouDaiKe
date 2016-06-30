//
//  YKLHighGoEditActRuleViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/11/24.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoEditActRuleViewController.h"
//#import "YKLHighGoRealeaseViewController.h"
#import "YKLHighGoRealeaseMainViewController.h"

@interface YKLHighGoEditActRuleViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>

@end

@implementation YKLHighGoEditActRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动规则";
//    self.view.backgroundColor = [UIColor whiteColor];
    [self createBgView];
    [self createContents];
    [self initView];
    [self showTime];
    
    //收到活动ID加载
    if (self.actDictionary ) {
    
        if (!self.actID) {
            self.goodsTitleField.text = [self.actDictionary objectForKey:@"title"];
            
            //有保存活动介绍优先用已保存
            if ([self.actDictionary objectForKey:@"desc"]) {
                 self.goodsIntroTextField.text = [self.actDictionary objectForKey:@"desc"];
            }
            
            if ([self.actDictionary objectForKey:@"end"]) {
                [self.showEndTimebtn setTitle:[self.actDictionary objectForKey:@"end"] forState:UIControlStateNormal];
            }
            
            if ([self.actDictionary objectForKey:@"coupon_time"]) {
                [self.couponEndTimebtn setTitle:[self.actDictionary objectForKey:@"coupon_time"] forState:UIControlStateNormal];
            }
            
            //分解现场兑奖码
            NSString *rewardCodeStr = [self.actDictionary objectForKey:@"reward_code"];
            if (rewardCodeStr) {
                self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
                self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
                self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
                self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
            }
        
            self.couponPriceField1.text = [self.actDictionary objectForKey:@"coupon_start"];
            self.couponPriceField2.text = [self.actDictionary objectForKey:@"coupon_end"];
            
            if ([self.actDictionary objectForKey:@"coupon_note"]) {
                self.couponExplainField.text = [self.actDictionary objectForKey:@"coupon_note"];
            }
            
        }
        else{
            
            self.goodsTitleField.text = [self.actDictionary objectForKey:@"title"];
            self.goodsIntroTextField.text = [self.actDictionary objectForKey:@"desc"];
            [self.showEndTimebtn setTitle:[self.actDictionary objectForKey:@"end"] forState:UIControlStateNormal];
            
            //分解现场兑奖码
            NSString *rewardCodeStr = [self.actDictionary objectForKey:@"reward_code"];
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
            
            self.couponPriceField1.text = [self.actDictionary objectForKey:@"coupon_start"];
            self.couponPriceField2.text = [self.actDictionary objectForKey:@"coupon_end"];
            [self.couponEndTimebtn setTitle:[self.actDictionary objectForKey:@"coupon_time"] forState:UIControlStateNormal];
            self.couponExplainField.text = [self.actDictionary objectForKey:@"coupon_note"];
        }
        
        //转换回"\n"
        self.goodsIntroTextField.text =[self.goodsIntroTextField.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.couponExplainField.text =[self.couponExplainField.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    }
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
}

- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width, 730);
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 350)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom, self.view.width, 380)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
}

- (void)createContents{
    
    self.goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    self.goodsTitleLabel.backgroundColor = [UIColor clearColor];
    self.goodsTitleLabel.font = [UIFont systemFontOfSize:14];
    self.goodsTitleLabel.textColor = [UIColor blackColor];
    self.goodsTitleLabel.text = @"活动标题:";
    [self.bgView1 addSubview:self.goodsTitleLabel];
    
    self.goodsTitleField = [[UITextField alloc] initWithFrame:CGRectMake(self.goodsTitleLabel.right, 0, self.view.width-self.goodsTitleLabel.right-20, 40)];
    self.goodsTitleField.keyboardType = UIKeyboardTypeDefault;
    self.goodsTitleField.backgroundColor = [UIColor clearColor];
    //    self.goodsTitleField.delegate = self;
    self.goodsTitleField.font = [UIFont systemFontOfSize:14];
    self.goodsTitleField.returnKeyType = UIReturnKeyNext;
    self.goodsTitleField.placeholder = @"请输入活动标题";
    //    self.actTitleField.enabled = self.activityIngHidde;
    [self.bgView1 addSubview:self.goodsTitleField];
    
    self.goodsIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsTitleLabel.bottom, 80, 40)];
    self.goodsIntroLabel.backgroundColor = [UIColor clearColor];
    self.goodsIntroLabel.font = [UIFont systemFontOfSize:14];
    self.goodsIntroLabel.textColor = [UIColor blackColor];
    self.goodsIntroLabel.text = @"活动规则:";
    [self.bgView1 addSubview:self.goodsIntroLabel];
    
    self.goodsIntroTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, self.goodsIntroLabel.bottom, self.view.width-20, self.bgView1.height-90)];
    self.goodsIntroTextField.keyboardType = UIKeyboardTypeDefault;
    self.goodsIntroTextField.backgroundColor = [UIColor flatLightWhiteColor];
    self.goodsIntroTextField.layer.cornerRadius = 5;
    self.goodsIntroTextField.layer.masksToBounds = YES;
    self.goodsIntroTextField.font = [UIFont systemFontOfSize:14];
    self.goodsIntroTextField.returnKeyType = UIReturnKeyNext;
    self.goodsIntroTextField.text = @"1.只要支付1元钱，就能参与本次活动，有机会获得本产品；如没有中奖，可以获得门店超值代金券一张；\n2.开奖后，系统会发送短信通知您中奖信息，打开短信中的链接，输入手机号码，进入中奖页面，根据页面显示查看是否中奖；\n3.若活动未能达到开奖金额，开奖失败，则系统自动将钱原路退回到您的支付账号；\n4.活动页面产品图片及信息仅供参照，产品以实物为准；\n5.兑奖只以活动兑奖页面显示的内容为准，截图或短信均为无效；\n6.活动开始后本规则将自动生效并表明参加者已接受；\n7.本活动最终解释权归本店所有。";
    [self.bgView1 addSubview:self.goodsIntroTextField];
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textColor = [UIColor blackColor];
    self.endTimeLabel.text = @"活动截止时间:";
    [self.bgView2 addSubview:self.endTimeLabel];
    
    self.showEndTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showEndTimebtn.frame = CGRectMake(self.endTimeLabel.right, 0, self.view.width-self.endTimeLabel.right-2, 40);
    [self.showEndTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.showEndTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.showEndTimebtn.tag = 4002;
    //当前时间
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [self.showEndTimebtn setTitle:@"请点击设置活动截止时间" forState:UIControlStateNormal];
    [self.showEndTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.showEndTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//    self.showEndTimebtn.enabled = self.activityIngHidden;
    [self.bgView2 addSubview:self.showEndTimebtn];
    
/************************************************************************************************************/
    self.rewardCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.endTimeLabel.bottom, 100, 40)];
    self.rewardCodeLabel.backgroundColor = [UIColor clearColor];
    self.rewardCodeLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCodeLabel.textColor = [UIColor blackColor];
    self.rewardCodeLabel.text = @"现场兑奖码:";
    [self.bgView2 addSubview:self.rewardCodeLabel];
    
    self.securityTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(self.rewardCodeLabel.right, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField1.textAlignment = NSTextAlignmentCenter;
    self.securityTextField1.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField1.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField1.delegate = self;
    self.securityTextField1.font = [UIFont systemFontOfSize:14];
    self.securityTextField1.returnKeyType = UIReturnKeyNext;
    self.securityTextField1.text = @"0";
//    self.securityTextField1.enabled = self.activityIngHidden;
    [self.bgView2 addSubview:self.securityTextField1];
    
    self.securityTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField1.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField2.textAlignment = NSTextAlignmentCenter;
    self.securityTextField2.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField2.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField2.delegate = self;
    self.securityTextField2.font = [UIFont systemFontOfSize:14];
    self.securityTextField2.returnKeyType = UIReturnKeyNext;
//    self.securityTextField2.enabled = self.activityIngHidden;
    self.securityTextField2.text = @"0";
    [self.bgView2 addSubview:self.securityTextField2];
    
    self.securityTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField2.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField3.textAlignment = NSTextAlignmentCenter;
    self.securityTextField3.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField3.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField3.delegate = self;
    self.securityTextField3.font = [UIFont systemFontOfSize:14];
    self.securityTextField3.returnKeyType = UIReturnKeyNext;
//    self.securityTextField3.enabled = self.activityIngHidden;
    self.securityTextField3.text = @"0";
    [self.bgView2 addSubview:self.securityTextField3];
    
    self.securityTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField3.right+5, self.endTimeLabel.bottom+10, 25, 25)];
    self.securityTextField4.textAlignment = NSTextAlignmentCenter;
    self.securityTextField4.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField4.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField4.delegate = self;
    self.securityTextField4.font = [UIFont systemFontOfSize:14];
    self.securityTextField4.returnKeyType = UIReturnKeyNext;
//    self.securityTextField4.enabled = self.activityIngHidden;
    self.securityTextField4.text = @"0";
    [self.bgView2 addSubview:self.securityTextField4];
    
    UIButton *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    securityBtn.backgroundColor = [UIColor clearColor];
    securityBtn.frame = CGRectMake(self.rewardCodeLabel.right, self.endTimeLabel.bottom+10, 130, 25);
    [securityBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
//    securityBtn.enabled = self.activityIngHidden;
    [self.bgView2 addSubview:securityBtn];
/************************************************************************************************************/
    
    self.couponPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.rewardCodeLabel.bottom, 100, 40)];
    self.couponPriceLabel.backgroundColor = [UIColor clearColor];
    self.couponPriceLabel.font = [UIFont systemFontOfSize:14];
    self.couponPriceLabel.textColor = [UIColor blackColor];
    self.couponPriceLabel.text = @"代金券区间:";
    [self.bgView2 addSubview:self.couponPriceLabel];
    
    self.couponPriceField1 = [[UITextField alloc] initWithFrame:CGRectMake(self.couponPriceLabel.right, self.couponPriceLabel.top+6, 60, 28)];
    self.couponPriceField1.keyboardType = UIKeyboardTypeDecimalPad;
    self.couponPriceField1.backgroundColor = [UIColor flatLightWhiteColor];
    self.couponPriceField1.delegate = self;
    self.couponPriceField1.font = [UIFont systemFontOfSize:14];
    self.couponPriceField1.returnKeyType = UIReturnKeyNext;
//    self.tokenPriceField1.placeholder = @"";
    self.couponPriceField1.layer.cornerRadius = 5;
    self.couponPriceField1.layer.masksToBounds = YES;
    self.couponPriceField1.textAlignment = NSTextAlignmentCenter;
    [self.bgView2 addSubview:self.couponPriceField1];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(self.couponPriceField1.right, self.couponPriceField1.top, 20, 28)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.text = @"~";
    label.textAlignment = NSTextAlignmentCenter;
    [self.bgView2 addSubview:label];
    
    self.couponPriceField2 = [[UITextField alloc] initWithFrame:CGRectMake(label.right, self.couponPriceField1.top, 60, 28)];
    self.couponPriceField2.keyboardType = UIKeyboardTypeDecimalPad;
    self.couponPriceField2.backgroundColor = [UIColor flatLightWhiteColor];
    self.couponPriceField2.delegate = self;
    self.couponPriceField2.font = [UIFont systemFontOfSize:14];
    self.couponPriceField2.returnKeyType = UIReturnKeyNext;
//        self.tokenPriceField2.placeholder = @"";
    self.couponPriceField2.layer.cornerRadius = 5;
    self.couponPriceField2.layer.masksToBounds = YES;
    self.couponPriceField2.textAlignment = NSTextAlignmentCenter;
    [self.bgView2 addSubview:self.couponPriceField2];
    
    UILabel *ylabel =[[UILabel alloc] initWithFrame:CGRectMake(self.couponPriceField2.right, self.couponPriceField1.top, 20, 28)];
    ylabel.backgroundColor = [UIColor clearColor];
    ylabel.font = [UIFont systemFontOfSize:14];
    ylabel.textColor = [UIColor blackColor];
    ylabel.text = @"元";
    ylabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView2 addSubview:ylabel];
    
    self.couponEndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.couponPriceLabel.bottom, 100, 40)];
    self.couponEndTimeLabel.backgroundColor = [UIColor clearColor];
    self.couponEndTimeLabel.font = [UIFont systemFontOfSize:14];
    self.couponEndTimeLabel.textColor = [UIColor blackColor];
    self.couponEndTimeLabel.text = @"代金券有效期:";
    [self.bgView2 addSubview:self.couponEndTimeLabel];
    
    self.couponEndTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.couponEndTimebtn.frame = CGRectMake(self.couponEndTimeLabel.right, self.couponEndTimeLabel.top, self.view.width-self.couponEndTimeLabel.right-2, 40);
    [self.couponEndTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.couponEndTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.couponEndTimebtn.tag = 4003;

    [self.couponEndTimebtn setTitle:@"请点击设置代金券有效期" forState:UIControlStateNormal];
    [self.couponEndTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.couponEndTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    //    self.showEndTimebtn.enabled = self.activityIngHidden;
    [self.bgView2 addSubview:self.couponEndTimebtn];
    
    self.couponExplainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.couponEndTimeLabel.bottom, 120, 40)];
    self.couponExplainLabel.backgroundColor = [UIColor clearColor];
    self.couponExplainLabel.font = [UIFont systemFontOfSize:14];
    self.couponExplainLabel.textColor = [UIColor blackColor];
    self.couponExplainLabel.text = @"代金券使用说明:";
    [self.bgView2 addSubview:self.couponExplainLabel];
    
    self.couponExplainField = [[UITextView alloc] initWithFrame:CGRectMake(10, self.couponExplainLabel.bottom, self.view.width-20, 100)];//self.bgView2.height-self.couponExplainLabel.bottom-60-20
//    self.tokenExplainField.delegate = self;
    self.couponExplainField.keyboardType = UIKeyboardTypeDefault;
    self.couponExplainField.backgroundColor = [UIColor flatLightWhiteColor];
    self.couponExplainField.layer.cornerRadius = 5;
    self.couponExplainField.layer.masksToBounds = YES;
    self.couponExplainField.font = [UIFont systemFontOfSize:14];
    self.couponExplainField.returnKeyType = UIReturnKeyNext;
    self.couponExplainField.delegate = self;
    self.couponExplainField.text = @"1.本代金券需在有效期内到本店使用；\n2.购买本店（XX品牌）产品满XX元方可使用；\n3.本代金券最终解释权归本店所有。";
    [self.bgView2 addSubview:self.couponExplainField];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.saveBtn setTitle:@"确   定" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.saveBtn.backgroundColor = [UIColor flatLightRedColor];
    self.saveBtn.layer.cornerRadius = 10;
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.frame = CGRectMake(0,self.couponExplainField.bottom+10,self.view.width-120,40);//self.bgView2.bottom-60
    self.saveBtn.centerX = self.view.width/2;
    [self.saveBtn addTarget:self action:@selector(saveRuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView2 addSubview: self.saveBtn];
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


- (void)saveRuleBtnClick:(id)sender{
    NSLog(@"点击了----确定----按钮");
    [self hidenKeyboard];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([self.goodsTitleField.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置活动标题"];
        [self.goodsTitleField becomeFirstResponder];
        return;
    }
    
    if ([self.goodsIntroTextField.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置活动介绍"];
        [self.goodsIntroTextField becomeFirstResponder];
        return;
    }
    
    if ([self.couponPriceField1.text isEqualToString:@""]||[self.couponPriceField2.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置代金券区间"];
        [self.couponPriceField1 becomeFirstResponder];
        return;
    }
    
    if ([self.couponPriceField2.text isEqual:@"0"]) {
        
        [UIAlertView showInfoMsg:@"代金券区间最大值不能为0"];
        [self.couponPriceField2 becomeFirstResponder];
        return;
    }
    
    float startCoupon = [self.couponPriceField1.text floatValue];
    float lowestCoupon = [self.couponPriceField2.text floatValue];
    if (startCoupon > lowestCoupon) {
        [UIAlertView showInfoMsg:@"最低代金券金额不能大于最高代金券金额"];
        [self.couponPriceField1 becomeFirstResponder];
        return;
    }
    
    if ([self.couponExplainField.text isEqualToString:@""]) {
        
        [UIAlertView showInfoMsg:@"请设置代金券使用说明"];
        [self.couponExplainField becomeFirstResponder];
        return;
    }
    
    if ([self.couponExplainField.text isEqual:@"1.本代金券需在有效期内到本店使用；\n2.购买本店（XX品牌）产品满XX元方可使用；\n3.本代金券最终解释权归本店所有。"]) {
        
        [UIAlertView showInfoMsg:@"请设置代金券使用说明中的\"(XX品牌)产品\"和\"满xx元方可使用\""];
        [self.couponExplainField becomeFirstResponder];
        return;
    }
    
    NSString*couponString = self.couponEndTimebtn.titleLabel.text;
    NSArray *startArray = [couponString componentsSeparatedByString:@"-"];
    
    NSString*endString = self.showEndTimebtn.titleLabel.text;
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    
    couponString = [startArray componentsJoinedByString:@""];
    endString = [endArray componentsJoinedByString:@""];
    
    int coupon = [couponString intValue];
    int end = [endString intValue];
    NSLog(@"%d--%d",coupon,end);
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    int today = [locationString intValue];
    
    if([self.showEndTimebtn.titleLabel.text isEqualToString:@"请点击设置活动截止时间"]){
        
        [UIAlertView showInfoMsg:@"请设置活动截止时间"];
        return;
    }
    if([self.couponEndTimebtn.titleLabel.text isEqualToString:@"请点击设置代金券有效期"]){
        [UIAlertView showInfoMsg:@"请设置代金券有效期"];
        return;
    }
    
    if (coupon<today || end<today) {
        [UIAlertView showInfoMsg:@"活动结束时间已过期，请重新设置"];
        return;
    }
    
    

    NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
    
    YKLHighGoRealeaseMainViewController *releaseVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //活动结束时间显示
    releaseVC.actEndTime = self.showEndTimebtn.titleLabel.text;
    
    //"\n"转换"<br>"
    self.goodsIntroTextField.text =[self.goodsIntroTextField.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    self.couponExplainField.text =[self.couponExplainField.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    
    [releaseVC.actDict setObject:self.showEndTimebtn.titleLabel.text forKey:@"end"];
    [releaseVC.actDict setObject:self.couponEndTimebtn.titleLabel.text forKey:@"coupon_time"];
    [releaseVC.actDict setObject:self.goodsTitleField.text forKey:@"title"];
    [releaseVC.actDict setObject:self.goodsIntroTextField.text forKey:@"desc"];
    [releaseVC.actDict setObject:self.couponPriceField1.text forKey:@"coupon_start"];
    [releaseVC.actDict setObject:self.couponPriceField2.text forKey:@"coupon_end"];
    [releaseVC.actDict setObject:self.couponExplainField.text forKey:@"coupon_note"];
    [releaseVC.actDict setObject:rewardCode forKey:@"reward_code"];
    

    [self.navigationController popToViewController:releaseVC animated:YES];
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
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.view.width/4, 20)];
//    label.text = [_nubArray objectAtIndex:row];
//    label.textColor = [UIColor greenColor];
//    return label;
//}

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


#pragma mark - xib click

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

#pragma mark - xib click

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
    
    if ([self.selectedStr isEqualToString:@"4002"]) {
        [self.showEndTimebtn setTitle:message forState:UIControlStateNormal];
    }
    if ([self.selectedStr isEqualToString:@"4003"]) {
        [self.couponEndTimebtn setTitle:message forState:UIControlStateNormal];
    }
    
    
    [self hideMyTimePicker];
    
}


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
    CGRect rect=CGRectMake(0.0f,-140,width,height);
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
    [self.goodsTitleField resignFirstResponder];
    [self.goodsIntroTextField resignFirstResponder];
    [self.couponExplainField resignFirstResponder];
    [self.couponPriceField1 resignFirstResponder];
    [self.couponPriceField2 resignFirstResponder];
    
    [self resumeView];
}


@end
