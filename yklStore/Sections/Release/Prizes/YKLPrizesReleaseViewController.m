//
//  YKLPrizesReleaseViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/13.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPrizesReleaseViewController.h"
#import "YKLLoginViewController.h"

@interface YKLPrizesReleaseViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>


@end

@implementation YKLPrizesReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBgView];
    [self createPrizesType];
    [self createPrizesSetting];
    [self createFlowSetting];
    [self createWish];
    [self initView];
    [self showTime];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    
    //默认为选择奖品状态
    [self prizeBtnClicked];
    
    self.bgView3.hidden = YES;
    self.bgView3.height = 0;
//    [UIView animateWithDuration:0.5 animations:^{
        self.bgView2.top = self.bgView1.bottom+10;
        self.bgView4.top = self.bgView3.bottom;
        self.bgView5.top = self.bgView4.bottom+10;
//    }];
    [self.flowBtn setSelected:NO];
    [self.flowBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateHighlighted];
    [self.flowBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];
    
    
    if (!(self.activityID == NULL)) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YKLNetworkingPrizes readRedWithRID:self.activityID Success:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.wishField.text = [dict objectForKey:@"title"];
            
            self.useDescTextView.text = [dict objectForKey:@"desc"];
            self.useDescTextView.text = [self.useDescTextView.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            
            [self.showEndTimebtn setTitle:[[dict objectForKey:@"end_time"]timeNumber] forState:UIControlStateNormal];
            //分解现场兑奖码
            NSString *rewardCodeStr = [dict objectForKey:@"reward_code"];
            if (![rewardCodeStr isEqual:@""]) {
                self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
                self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
                self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
                self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
            }
            
            NSArray *prizesArr = [dict objectForKey:@"prize"];
            NSMutableArray *goodsArr = [NSMutableArray array];
            
            if (![prizesArr isEqual:@[]]&&![prizesArr isEqual:@""]) {
                
                for (int i = 0; i < prizesArr.count; i++) {
                    
                    NSDictionary *tempDict = [[NSDictionary alloc]initWithDictionary:prizesArr[i]];
                    NSString *prizeType = [tempDict objectForKey:@"prize_type"];
                    
                    if ([prizeType isEqual:@"2"]) {
                        [self flowBtnClicked];
                        self.getFlowNumField.text = [tempDict objectForKey:@"prize_num"];
                        
                       
                    }
                    if ([prizeType isEqual:@"1"]) {
                        [goodsArr addObject:tempDict];
                    }
                }
            }
            
            NSDictionary *goodsDict = [NSDictionary new];
            if (![goodsArr isEqual:@[]]) {
                
                switch (goodsArr.count) {
                    case 1:
                        goodsDict = goodsArr[0];
                        self.goodsNameField1.text = [goodsDict objectForKey:@"prize_name"];
                        self.goodsNumField1.text = [goodsDict objectForKey:@"prize_num"];
                        break;
                    case 2:
                        [self addGoodsBtnClicked];
                        goodsDict = goodsArr[0];
                        self.goodsNameField1.text = [goodsDict objectForKey:@"prize_name"];
                        self.goodsNumField1.text = [goodsDict objectForKey:@"prize_num"];
                        
                        goodsDict = goodsArr[1];
                        self.goodsNameField2.text = [goodsDict objectForKey:@"prize_name"];
                        self.goodsNumField2.text = [goodsDict objectForKey:@"prize_num"];
                        
                        break;
                    case 3:
                        [self addGoodsBtnClicked];
                        self.goodsView3.top = self.goodsView2.bottom+5;
                        self.goodsView3.left = -1;
                        self.goodsView3.hidden = NO;
                        self.addGoodsBtn.hidden = YES;
                        
                        goodsDict = goodsArr[0];
                        self.goodsNameField1.text = [goodsDict objectForKey:@"prize_name"];
                        self.goodsNumField1.text = [goodsDict objectForKey:@"prize_num"];
                        
                        goodsDict = goodsArr[1];
                        self.goodsNameField2.text = [goodsDict objectForKey:@"prize_name"];
                        self.goodsNumField2.text = [goodsDict objectForKey:@"prize_num"];
                        
                        goodsDict = goodsArr[2];
                        self.goodsNameField3.text = [goodsDict objectForKey:@"prize_name"];
                        self.goodsNumField3.text = [goodsDict objectForKey:@"prize_num"];
                        break;
                        
                    default:
                        break;
                }
                
                if (!self.goodsView1.hidden&&!self.goodsView2.hidden&&!self.goodsView1.hidden) {
                    self.addGoodsBtn.hidden = YES;
                }
            }
            else{
                [self prizeBtnClicked];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    //如果本地存储活动字典不为空则加载其数据
    else if (![[YKLLocalUserDefInfo defModel].savePrizesActInfoDict isEqual:@{}]) {
        
        NSMutableDictionary *tempDict = [YKLLocalUserDefInfo defModel].savePrizesActInfoDict;
        
        NSString *selectPrize = [tempDict objectForKey:@"show_Prize"];
        NSString *selectFlow = [tempDict objectForKey:@"show_Flow"];
        
        //先判断是否选择流量按钮，以免在没有选择流量按钮的情况，奖品按钮的选择无法取消
        if ([selectFlow isEqual:@"1"]) {
            
            [self flowBtnClicked];
            self.getFlowNumField.text = [tempDict objectForKey:@"traffic_num"];
            
        }else{
            
        }

        //由于默认选择奖品故此处判断相反
        if ([selectPrize isEqual:@"1"]) {
            
            NSMutableArray *goodsArr= [tempDict objectForKey:@"goods_array"];
            NSMutableDictionary *goodsDict = [[NSMutableDictionary alloc]init];
            
            switch (goodsArr.count) {
                case 1:
                    goodsDict = goodsArr[0];
                    self.goodsNameField1.text = [goodsDict objectForKey:@"prize_name"];
                    self.goodsNumField1.text = [goodsDict objectForKey:@"prize_num"];
                    break;
                case 2:
                    [self addGoodsBtnClicked];
                    goodsDict = goodsArr[0];
                    self.goodsNameField1.text = [goodsDict objectForKey:@"prize_name"];
                    self.goodsNumField1.text = [goodsDict objectForKey:@"prize_num"];

                    goodsDict = goodsArr[1];
                    self.goodsNameField2.text = [goodsDict objectForKey:@"prize_name"];
                    self.goodsNumField2.text = [goodsDict objectForKey:@"prize_num"];

                    break;
                case 3:
                    [self addGoodsBtnClicked];
                    self.goodsView3.top = self.goodsView2.bottom+5;
                    self.goodsView3.left = -1;
                    self.goodsView3.hidden = NO;
                    self.addGoodsBtn.hidden = YES;
                    
                    goodsDict = goodsArr[0];
                    self.goodsNameField1.text = [goodsDict objectForKey:@"prize_name"];
                    self.goodsNumField1.text = [goodsDict objectForKey:@"prize_num"];
                    
                    goodsDict = goodsArr[1];
                    self.goodsNameField2.text = [goodsDict objectForKey:@"prize_name"];
                    self.goodsNumField2.text = [goodsDict objectForKey:@"prize_num"];
                    
                    goodsDict = goodsArr[2];
                    self.goodsNameField3.text = [goodsDict objectForKey:@"prize_name"];
                    self.goodsNumField3.text = [goodsDict objectForKey:@"prize_num"];
                    break;
                    
                default:
                    break;
            }
            
            if (!self.goodsView1.hidden&&!self.goodsView2.hidden&&!self.goodsView1.hidden) {
                self.addGoodsBtn.hidden = YES;
            }
        }
        else{
            [self prizeBtnClicked];
        }
        
        self.wishField.text = [tempDict objectForKey:@"title"];
        self.useDescTextView.text = [tempDict objectForKey:@"desc"];
        
        [self.showEndTimebtn setTitle:[tempDict objectForKey:@"activity_end_time"] forState:UIControlStateNormal];
        
        //分解现场兑奖码
        NSString *rewardCodeStr = [tempDict objectForKey:@"reward_code"];
        if (![rewardCodeStr isEqual:@""]) {
            self.securityTextField1.text = [rewardCodeStr substringToIndex:1];
            self.securityTextField2.text = [rewardCodeStr substringWithRange:NSMakeRange(1,1)];
            self.securityTextField3.text = [rewardCodeStr substringWithRange:NSMakeRange(2,1)];
            self.securityTextField4.text = [rewardCodeStr substringWithRange:NSMakeRange(3,1)];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"红包设置";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop  target:self action:@selector(activityLeftBarItemClicked:)];
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
        
        if (alertView.tag == 6002) {
            [self releaseRedAct];
            return;
        }
        
        //保存到本地
        [self saveDictForFiled];
        
        //发布活动键盘未收起推出时闪屏修改,延迟两个0.25来执行键盘收起的动画。
        [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        
    }else if (buttonIndex == 1){
        
        if (alertView.tag == 6002) {
            return;
        }
        
        if (self.activityID == NULL) {
            [self performSelector:@selector(popHidden) withObject:nil afterDelay:0.6];
        }else{
            
        }
    }
}

- (void)popHidden{
    
    if (self.activityID == NULL&&!self.isEndActivity) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)createBgView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor flatLightWhiteColor];
    
    //全部显示视图可移动大小
//    self.scrollView.contentSize = CGSizeMake(self.view.width, 10*4+45+330+120+170);
    self.scrollView.contentSize = CGSizeMake(self.view.width, 10*3+45+330+202+10);
    [self.view addSubview:self.scrollView];
    
    self.bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.width, 45)];
    self.bgView1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView1];
    
    self.bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView1.bottom+10, self.view.width, 202)];
    self.bgView2.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView2];
    
    self.bgView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView2.bottom+10, self.view.width, 120)];
    self.bgView3.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView3];
    
    self.bgView4 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView3.bottom+10, self.view.width, 160)];
    self.bgView4.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView4];
    
    self.bgView5 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bgView4.bottom+10, self.view.width, 170)];
    self.bgView5.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView5];
    
    
}

- (void)createPrizesType{
    
    //红包类型选择
    self.prizesTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 25)];
//    self.prizesTypeLabel.backgroundColor = [UIColor redColor];
    self.prizesTypeLabel.text = @"红包类型";
    self.prizesTypeLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView1 addSubview:self.prizesTypeLabel];
    
    self.prizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.prizeBtn.frame = CGRectMake(self.prizesTypeLabel.right+10,12.5,20,20);
    [self.prizeBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];
    [self.prizeBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateSelected];
    [self.prizeBtn addTarget:self action:@selector(prizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.prizeBtn.selected = YES;
    [self.bgView1 addSubview:self.prizeBtn];
    
    self.prizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.prizeBtn.right+10, self.prizesTypeLabel.top,60,25)];
//    self.prizeLabel.backgroundColor = [UIColor redColor];
    self.prizeLabel.text = @"奖品";
    self.prizeLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView1 addSubview:self.prizeLabel];
    
    self.flowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flowBtn.frame = CGRectMake(self.prizeLabel.right+10,12.5,20,20);
    [self.flowBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];
    [self.flowBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateSelected];
    [self.flowBtn addTarget:self action:@selector(flowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.flowBtn.selected = NO;
    [self.bgView1 addSubview:self.flowBtn];
    
    self.flowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.flowBtn.right+10, self.prizesTypeLabel.top,60,25)];
//    self.flowLabel.backgroundColor = [UIColor redColor];
    self.flowLabel.text = @"流量红包";
    self.flowLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView1 addSubview:self.flowLabel];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.flowLabel.right+10,17,30,15)];
//    infoLabel.backgroundColor = [UIColor redColor];
    infoLabel.text = @"可多选";
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.font = [UIFont systemFontOfSize:10];
    [self.bgView1 addSubview:infoLabel];
}

- (void)createPrizesSetting{
    
    //奖品红包设置
    self.prizesSetLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 15)];
    //    self.prizesSetLabel.backgroundColor = [UIColor blueColor];
    self.prizesSetLabel.text = @"奖品红包设置";
    self.prizesSetLabel.textColor = [UIColor flatLightRedColor];
    self.prizesSetLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView2 addSubview:self.prizesSetLabel];
    
    UILabel *setLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.prizesSetLabel.right+10,10+2,100,13)];
    //    setLabel.backgroundColor = [UIColor redColor];
    setLabel.text = @"总共可设3个奖品";
    setLabel.textColor = [UIColor lightGrayColor];
    setLabel.font = [UIFont systemFontOfSize:10];
    [self.bgView2 addSubview:setLabel];
    
    self.goodsBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.prizesSetLabel.bottom+10, self.view.width, 52+5+52+5+52)];
    self.goodsBgView.backgroundColor = [UIColor whiteColor];
    [self.bgView2 addSubview:self.goodsBgView];
    
    //商品1号
    self.goodsView1 = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, self.view.width+2, 52)];
    self.goodsView1.backgroundColor = [UIColor whiteColor];
    self.goodsView1.layer.borderColor = [UIColor flatLightWhiteColor].CGColor;
    self.goodsView1.layer.borderWidth = 1;
    [self.goodsBgView addSubview:self.goodsView1];
    
    self.goodsNameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 35, 25)];
    //    self.goodsNameLabel1.backgroundColor = [UIColor redColor];
    self.goodsNameLabel1.text = @"名字:";
    self.goodsNameLabel1.font = [UIFont systemFontOfSize:14];
    [self.goodsView1 addSubview:self.goodsNameLabel1];
    
    self.goodsNameField1 = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsNameLabel1.right, 0, 130, 25)];
    //    self.goodsNameField1.backgroundColor = [UIColor blueColor];
    self.goodsNameField1.keyboardType = UIKeyboardTypeDefault;
    self.goodsNameField1.placeholder = @"填写奖品名";
    self.goodsNameField1.font = [UIFont systemFontOfSize:10];
    [self.goodsView1 addSubview:self.goodsNameField1];
    
    self.goodsNumLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsNameField1.bottom+2, 35, 25)];
    //    self.goodsNumLabel1.backgroundColor = [UIColor redColor];
    self.goodsNumLabel1.text = @"数量:";
    self.goodsNumLabel1.font = [UIFont systemFontOfSize:14];
    [self.goodsView1 addSubview:self.goodsNumLabel1];
    
    self.goodsNumField1 = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsNumLabel1.right, self.goodsNameField1.bottom+2, 65, 25)];
    //    self.goodsNumField1.backgroundColor = [UIColor blueColor];
    self.goodsNumField1.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsNumField1.placeholder = @"填写奖品数量";
    self.goodsNumField1.font = [UIFont systemFontOfSize:10];
    [self.goodsView1 addSubview:self.goodsNumField1];
    
    self.goodsDeleteBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsDeleteBtn1.frame = CGRectMake(0, 0, 35, 52);
    self.goodsDeleteBtn1.right = self.view.width+1;
    [self.goodsDeleteBtn1 setImage:[UIImage imageNamed:@"delete_Btn.png"] forState:UIControlStateNormal];
    [self.goodsDeleteBtn1 addTarget:self action:@selector(goodsDeleteBtn1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.goodsView1 addSubview:self.goodsDeleteBtn1];
    
    //商品2号
    self.goodsView2 = [[UIView alloc]initWithFrame:CGRectMake(-1, self.goodsView1.bottom+5, self.view.width+2, 52)];
    self.goodsView2.backgroundColor = [UIColor whiteColor];
    self.goodsView2.layer.borderColor = [UIColor flatLightWhiteColor].CGColor;
    self.goodsView2.layer.borderWidth = 1;
    [self.goodsBgView addSubview:self.goodsView2];
    
    self.goodsNameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 35, 25)];
    //    self.goodsNameLabel2.backgroundColor = [UIColor redColor];
    self.goodsNameLabel2.text = @"名字:";
    self.goodsNameLabel2.font = [UIFont systemFontOfSize:14];
    [self.goodsView2 addSubview:self.goodsNameLabel2];
    
    self.goodsNameField2 = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsNameLabel1.right, 0, 130, 25)];
    //    self.goodsNameField2.backgroundColor = [UIColor blueColor];
    self.goodsNameField2.keyboardType = UIKeyboardTypeDefault;
    self.goodsNameField2.placeholder = @"填写奖品名";
    self.goodsNameField2.font = [UIFont systemFontOfSize:10];
    [self.goodsView2 addSubview:self.goodsNameField2];
    
    self.goodsNumLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsNameField1.bottom+2, 35, 25)];
    //    self.goodsNumLabel2.backgroundColor = [UIColor redColor];
    self.goodsNumLabel2.text = @"数量:";
    self.goodsNumLabel2.font = [UIFont systemFontOfSize:14];
    [self.goodsView2 addSubview:self.goodsNumLabel2];
    
    self.goodsNumField2 = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsNumLabel1.right, self.goodsNameField1.bottom+2, 65, 25)];
    //    self.goodsNumField2.backgroundColor = [UIColor blueColor];
    self.goodsNumField2.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsNumField2.placeholder = @"填写奖品数量";
    self.goodsNumField2.font = [UIFont systemFontOfSize:10];
    [self.goodsView2 addSubview:self.goodsNumField2];
    
    self.goodsDeleteBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsDeleteBtn2.frame = CGRectMake(0, 0, 35, 52);
    self.goodsDeleteBtn2.right = self.view.width+1;
    [self.goodsDeleteBtn2 setImage:[UIImage imageNamed:@"delete_Btn.png"] forState:UIControlStateNormal];
    [self.goodsDeleteBtn2 addTarget:self action:@selector(goodsDeleteBtn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.goodsView2 addSubview:self.goodsDeleteBtn2];
    
    //商品3号
    self.goodsView3 = [[UIView alloc]initWithFrame:CGRectMake(-1, self.goodsView2.bottom+5, self.view.width+2, 52)];
    self.goodsView3.backgroundColor = [UIColor whiteColor];
    self.goodsView3.layer.borderColor = [UIColor flatLightWhiteColor].CGColor;
    self.goodsView3.layer.borderWidth = 1;
    self.goodsView3.hidden = YES;
    [self.goodsBgView addSubview:self.goodsView3];
    
    self.goodsNameLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 35, 25)];
    //    self.goodsNameLabel3.backgroundColor = [UIColor redColor];
    self.goodsNameLabel3.text = @"名字:";
    self.goodsNameLabel3.font = [UIFont systemFontOfSize:14];
    [self.goodsView3 addSubview:self.goodsNameLabel3];
    
    self.goodsNameField3 = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsNameLabel1.right, 0, 130, 25)];
    //    self.goodsNameField3.backgroundColor = [UIColor blueColor];
    self.goodsNameField3.keyboardType = UIKeyboardTypeDefault;
    self.goodsNameField3.placeholder = @"填写奖品名";
    self.goodsNameField3.font = [UIFont systemFontOfSize:10];
    [self.goodsView3 addSubview:self.goodsNameField3];
    
    self.goodsNumLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10, self.goodsNameField1.bottom+2, 35, 25)];
    //    self.goodsNumLabel3.backgroundColor = [UIColor redColor];
    self.goodsNumLabel3.text = @"数量:";
    self.goodsNumLabel3.font = [UIFont systemFontOfSize:14];
    [self.goodsView3 addSubview:self.goodsNumLabel3];
    
    self.goodsNumField3 = [[UITextField alloc]initWithFrame:CGRectMake(self.goodsNumLabel1.right, self.goodsNameField1.bottom+2, 65, 25)];
    //    self.goodsNumField3.backgroundColor = [UIColor blueColor];
    self.goodsNumField3.keyboardType = UIKeyboardTypeNumberPad;
    self.goodsNumField3.placeholder = @"填写奖品数量";
    self.goodsNumField3.font = [UIFont systemFontOfSize:10];
    [self.goodsView3 addSubview:self.goodsNumField3];
    
    self.goodsDeleteBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsDeleteBtn3.frame = CGRectMake(0, 0, 35, 52);
    self.goodsDeleteBtn3.right = self.view.width+1;
    [self.goodsDeleteBtn3 setImage:[UIImage imageNamed:@"delete_Btn.png"] forState:UIControlStateNormal];
    [self.goodsDeleteBtn3 addTarget:self action:@selector(goodsDeleteBtn3Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.goodsView3 addSubview:self.goodsDeleteBtn3];
    
    self.addGoodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.addGoodsBtn.backgroundColor = [UIColor redColor];
    self.addGoodsBtn.frame = CGRectMake(-1, 104+5+5, self.view.width+2, 52);
    [self.addGoodsBtn setImage:[UIImage imageNamed:@"plus_Btn.png"] forState:UIControlStateNormal];
    self.addGoodsBtn.frame = self.goodsView2.frame;
    [self.addGoodsBtn addTarget:self action:@selector(addGoodsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.goodsBgView addSubview:self.addGoodsBtn];
    
    self.goodsView2.hidden = YES;
    self.goodsDeleteBtn1.hidden = YES;

}

- (void)createFlowSetting{
    
    //流量红包设置
    self.flowSetLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 15)];
    //    self.prizesSetLabel.backgroundColor = [UIColor blueColor];
    self.flowSetLabel.text = @"流量红包设置";
    self.flowSetLabel.textColor = [UIColor flatLightRedColor];
    self.flowSetLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView3 addSubview:self.flowSetLabel];
    
    self.flowNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.flowSetLabel.bottom+10, self.view.width-20, 55)];
//    self.flowNumLabel.backgroundColor = [UIColor redColor];
    self.flowNumLabel.textColor = [UIColor lightGrayColor];
    self.flowNumLabel.numberOfLines  = 0;
    self.flowNumLabel.text = [YKLLocalUserDefInfo defModel].redFlowDesc;
    NSLog(@"%@",[YKLLocalUserDefInfo defModel].redFlowDesc);
    self.flowNumLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView3 addSubview:self.flowNumLabel];
    
//    self.flowNumField = [[UITextField alloc]initWithFrame:CGRectMake(self.flowNumLabel.right, self.flowNumLabel.top, 150, 15)];
//    self.flowNumField.keyboardType = UIKeyboardTypeNumberPad;
//    self.flowNumField.font = [UIFont systemFontOfSize:14];
//    self.flowNumField.textAlignment = NSTextAlignmentCenter;
//    [self.bgView3 addSubview:self.flowNumField];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.flowNumLabel.right, self.flowNumLabel.top+15, 150, 1)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.bgView3 addSubview:lineView];
    
//    UILabel *MLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.flowNumField.right, self.flowNumLabel.top, 15, 15)];
//    MLabel.text = @"M";
//    MLabel.font = [UIFont systemFontOfSize:14];
//    [self.bgView3 addSubview:MLabel];
    
//    self.flowMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(MLabel.right+5, self.flowNumLabel.top, 70, 15)];
////    self.flowMoneyLabel.backgroundColor = [UIColor redColor];
//    self.flowMoneyLabel.textColor = [UIColor lightGrayColor];
//    self.flowMoneyLabel.font = [UIFont systemFontOfSize:10];
//    self.flowMoneyLabel.text = @"10M=1元";
//    [self.bgView3 addSubview:self.flowMoneyLabel];
    
    self.getFlowNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.flowNumLabel.bottom+10, 60, 15)];
    self.getFlowNumLabel.text = @"领取人数";
    self.getFlowNumLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView3 addSubview:self.getFlowNumLabel];
    
    self.getFlowNumField =[[UITextField alloc]initWithFrame:CGRectMake(self.getFlowNumLabel.right, self.getFlowNumLabel.top, 55, 15)];
//    self.getFlowNumField.backgroundColor = [UIColor flatLightWhiteColor];
    self.getFlowNumField.delegate = self;
    self.getFlowNumField.keyboardType = UIKeyboardTypeNumberPad;
    self.getFlowNumField.font = [UIFont systemFontOfSize:14];
    self.getFlowNumField.textAlignment = NSTextAlignmentCenter;
    [self.bgView3 addSubview:self.getFlowNumField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.getFlowNumLabel.right, self.getFlowNumLabel.top+15, 55, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView3 addSubview:lineView];
    
    UILabel *MLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.getFlowNumField.right, self.getFlowNumLabel.top, 15, 15)];
    MLabel.text = @"个";
    MLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView3 addSubview:MLabel];
    
}

- (void)createWish{
    
    self.useDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 15)];
    //    self.useDescLabel.backgroundColor = [UIColor redColor];
    self.useDescLabel.text = @"使用说明";
    self.useDescLabel.font = [UIFont systemFontOfSize:14];
    [self.bgView4 addSubview:self.useDescLabel];
    
    self.useDescTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, self.useDescLabel.bottom+5, 300, 120)];
    self.useDescTextView.backgroundColor = [UIColor flatLightWhiteColor];
    self.useDescTextView.keyboardType = UIKeyboardTypeDefault;
    self.useDescTextView.layer.cornerRadius = 5;
    self.useDescTextView.layer.masksToBounds = YES;
    self.useDescTextView.text = @"1.财神到，摇大奖；\n2.每人3次摇奖机会，礼品随机，奖品有流量红包/代金券/祝福语；\n3.中流量奖后，输入手机号码流量直接发放到手机；\n4.中代金券后，可领取之后到活动发布门店现场兑奖；\n5.活动期间奖品数量有限，先到先得，抢完为止；\n6.本活动最终解释权归本店所有。";
    [self.bgView4 addSubview:self.useDescTextView];
    
    self.wishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 15)];
    self.wishLabel.font = [UIFont systemFontOfSize:14];
    self.wishLabel.text = @"祝福语";
    [self.bgView5 addSubview:self.wishLabel];
    
    self.wishField = [[UITextField alloc]initWithFrame:CGRectMake(self.wishLabel.right, self.wishLabel.top, 200, 15)];
    self.wishField.font = [UIFont systemFontOfSize:10];
    self.wishField.delegate = self;
    self.wishField.placeholder = @"恭喜发财";
    [self.bgView5 addSubview:self.wishField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.wishLabel.right, self.wishLabel.top+15, 200, 1)];
    lineView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.bgView5 addSubview:lineView];
    
    
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.wishLabel.bottom+15, 65, 15)];
    self.endTimeLabel.backgroundColor = [UIColor clearColor];
    self.endTimeLabel.font = [UIFont systemFontOfSize:14];
    self.endTimeLabel.textColor = [UIColor blackColor];
    self.endTimeLabel.text = @"截止日期";
    [self.bgView5 addSubview:self.endTimeLabel];
    
    self.showEndTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showEndTimebtn.frame = CGRectMake(self.endTimeLabel.right, self.endTimeLabel.top, self.view.width-self.endTimeLabel.right-2, 15);
    [self.showEndTimebtn addTarget:self action:@selector(showMyTimePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.showEndTimebtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.showEndTimebtn.tag = 4002;
    //当前时间
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [self.showEndTimebtn setTitle:@"请点击设置截止日期" forState:UIControlStateNormal];
    [self.showEndTimebtn setTitleColor:[UIColor flatLightBlueColor]forState:UIControlStateNormal];
    self.showEndTimebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    //    self.showEndTimebtn.enabled = self.activityIngHidden;
    [self.bgView5 addSubview:self.showEndTimebtn];
    
    self.rewardCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.endTimeLabel.bottom+20, 65, 15)];
    self.rewardCodeLabel.backgroundColor = [UIColor clearColor];
    self.rewardCodeLabel.font = [UIFont systemFontOfSize:14];
    self.rewardCodeLabel.textColor = [UIColor blackColor];
    self.rewardCodeLabel.text = @"兑奖码";
    [self.bgView5 addSubview:self.rewardCodeLabel];
    
    self.securityTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(self.rewardCodeLabel.right, self.endTimeLabel.bottom+15, 25, 25)];
    self.securityTextField1.textAlignment = NSTextAlignmentCenter;
    self.securityTextField1.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField1.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField1.delegate = self;
    self.securityTextField1.font = [UIFont systemFontOfSize:14];
    self.securityTextField1.returnKeyType = UIReturnKeyNext;
    self.securityTextField1.text = @"0";
    //    self.securityTextField1.enabled = self.activityIngHidden;
    [self.bgView5 addSubview:self.securityTextField1];
    
    self.securityTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField1.right+5, self.endTimeLabel.bottom+15, 25, 25)];
    self.securityTextField2.textAlignment = NSTextAlignmentCenter;
    self.securityTextField2.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField2.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField2.delegate = self;
    self.securityTextField2.font = [UIFont systemFontOfSize:14];
    self.securityTextField2.returnKeyType = UIReturnKeyNext;
    //    self.securityTextField2.enabled = self.activityIngHidden;
    self.securityTextField2.text = @"0";
    [self.bgView5 addSubview:self.securityTextField2];
    
    self.securityTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField2.right+5, self.endTimeLabel.bottom+15, 25, 25)];
    self.securityTextField3.textAlignment = NSTextAlignmentCenter;
    self.securityTextField3.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField3.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField3.delegate = self;
    self.securityTextField3.font = [UIFont systemFontOfSize:14];
    self.securityTextField3.returnKeyType = UIReturnKeyNext;
    //    self.securityTextField3.enabled = self.activityIngHidden;
    self.securityTextField3.text = @"0";
    [self.bgView5 addSubview:self.securityTextField3];
    
    self.securityTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(self.securityTextField3.right+5, self.endTimeLabel.bottom+15, 25, 25)];
    self.securityTextField4.textAlignment = NSTextAlignmentCenter;
    self.securityTextField4.keyboardType = UIKeyboardTypeNumberPad;
    self.securityTextField4.backgroundColor = [UIColor flatLightWhiteColor];
    self.securityTextField4.delegate = self;
    self.securityTextField4.font = [UIFont systemFontOfSize:14];
    self.securityTextField4.returnKeyType = UIReturnKeyNext;
    //    self.securityTextField4.enabled = self.activityIngHidden;
    self.securityTextField4.text = @"0";
    [self.bgView5 addSubview:self.securityTextField4];
    
    UIButton *securityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    securityBtn.backgroundColor = [UIColor clearColor];
    securityBtn.frame = CGRectMake(self.rewardCodeLabel.right, self.endTimeLabel.bottom+15, 130, 25);
    [securityBtn addTarget:self action:@selector(showMyPicker:) forControlEvents:UIControlEventTouchUpInside];
    //    securityBtn.enabled = self.activityIngHidden;
    [self.bgView5 addSubview:securityBtn];
    
    self.shareSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareSaveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.shareSaveBtn setTitle:@"发红包" forState:UIControlStateNormal];
    [self.shareSaveBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.shareSaveBtn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateHighlighted];
    self.shareSaveBtn.backgroundColor = [UIColor flatLightRedColor];
    self.shareSaveBtn.layer.cornerRadius = 5;
    self.shareSaveBtn.layer.masksToBounds = YES;
    self.shareSaveBtn.frame = CGRectMake(10,110,self.view.width-20,40);
    [self.shareSaveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView5 addSubview: self.shareSaveBtn];
}

- (void)addGoodsBtnClicked{
    NSLog(@"点击了添加奖品按钮");
    
    self.goodsDeleteBtn1.hidden = NO;
    self.goodsDeleteBtn2.hidden = NO;
    self.goodsDeleteBtn3.hidden = NO;
    self.addGoodsBtn.frame = CGRectMake(-1, 104+5+5, self.view.width+2, 52);
    float time = 0.2;
    
    //100
    if (!self.goodsView1.hidden&&self.goodsView2.hidden&self.goodsView3.hidden) {
        
        [UIView animateWithDuration:time animations:^{
            self.goodsView2.top = self.goodsView1.bottom+5;
            self.goodsView2.left = -1;
//            self.goodsView2.hidden = NO;
        }completion:^(BOOL finished) {
            self.goodsView2.hidden = NO;
        }];
    }
    
    //120
    if (!self.goodsView1.hidden&&!self.goodsView2.hidden&self.goodsView3.hidden) {
        
        [UIView animateWithDuration:time animations:^{
            
            self.goodsView3.top = self.goodsView2.bottom+5;
            self.goodsView3.left = -1;
            
        }completion:^(BOOL finished) {
            self.goodsView3.hidden = NO;
            self.addGoodsBtn.hidden = YES;
        }];
        
    }
    
    //103
    if (!self.goodsView1.hidden&&self.goodsView2.hidden&!self.goodsView3.hidden) {
        [UIView animateWithDuration:time animations:^{
            
            self.goodsView1.top = 0;
            self.goodsView2.top = self.goodsView1.bottom+5;
            self.goodsView3.top = self.goodsView2.bottom+5;
            self.goodsView2.left = -1;
            
        }completion:^(BOOL finished) {
            self.goodsView2.hidden = NO;
            self.addGoodsBtn.hidden = YES;
        }];
    }
    
    //020
    if (self.goodsView1.hidden&&!self.goodsView2.hidden&self.goodsView3.hidden) {
        [UIView animateWithDuration:time animations:^{
            
            self.goodsView1.top = 0;
            self.goodsView2.top = self.goodsView1.bottom+5;
            self.goodsView3.top = self.goodsView2.bottom+5;
            self.goodsView1.left = -1;
            
        }completion:^(BOOL finished) {
            self.goodsView1.hidden = NO;
        }];
    }
    
    //023
    if (self.goodsView1.hidden&&!self.goodsView2.hidden&!self.goodsView3.hidden) {
        [UIView animateWithDuration:time animations:^{
            
            self.goodsView1.top = 0;
            self.goodsView2.top = self.goodsView1.bottom+5;
            self.goodsView3.top = self.goodsView2.bottom+5;
            self.goodsView1.left = -1;
            
        }completion:^(BOOL finished) {
            self.goodsView1.hidden = NO;
            self.addGoodsBtn.hidden = YES;
        }];
    }
    
    //003
    if (self.goodsView1.hidden&&self.goodsView2.hidden&!self.goodsView3.hidden) {
        [UIView animateWithDuration:time animations:^{
            
            self.goodsView2.top = 0;
            self.goodsView3.top = self.goodsView2.bottom+5;

            self.goodsView2.left = -1;
            
        }completion:^(BOOL finished) {
            self.goodsView2.hidden = NO;
        }];
    }
    
    
}

- (void)goodsDeleteBtn1Clicked{
    NSLog(@"点击了第1个商品的删除按钮");
     self.addGoodsBtn.frame = CGRectMake(-1, 104+5+5, self.view.width+2, 52);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.goodsView1.left = self.view.width;
        self.goodsNumField1.text = @"";
        self.goodsNameField1.text = @"";
        
    }completion:^(BOOL finished) {
        
        self.goodsView1.hidden = YES;
        self.addGoodsBtn.hidden = NO;
        
        if (!self.goodsView2.hidden&&!self.goodsView3.hidden) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsView2.top = self.goodsView1.top;
                self.goodsView3.top = self.goodsView2.bottom+5;
            }];
        }
        if (!self.goodsView2.hidden&&self.goodsView3.hidden) {
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsView2.top = self.goodsView1.top;
                self.goodsView3.top = self.goodsView2.bottom+5;
            }];
        }
        if (self.goodsView2.hidden&&!self.goodsView3.hidden) {
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsView3.top = self.goodsView1.top;
            }];
        }
        
        if (self.goodsView1.hidden&&self.goodsView2.hidden) {
            self.goodsDeleteBtn3.hidden = YES;
        }
        else if (self.goodsView1.hidden&&self.goodsView3.hidden){
            self.goodsDeleteBtn2.hidden = YES;
        }
        else if (self.goodsView2.hidden&&self.goodsView3.hidden){
            self.goodsDeleteBtn1.hidden = YES;
        }
    }];
    
    
}

- (void)goodsDeleteBtn2Clicked{
    NSLog(@"点击了第2个商品的删除按钮");
     self.addGoodsBtn.frame = CGRectMake(-1, 104+5+5, self.view.width+2, 52);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.goodsView2.left = self.view.width;
        self.goodsNumField2.text = @"";
        self.goodsNameField2.text = @"";

        
    }completion:^(BOOL finished) {
        
        self.goodsView2.hidden = YES;
        self.addGoodsBtn.hidden = NO;
        
        if (!self.goodsView1.hidden&&!self.goodsView3.hidden) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsView3.top = self.goodsView2.top;
            }];
        }
        if (!self.goodsView1.hidden&&self.goodsView3.hidden) {
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsView3.top = self.goodsView2.top;
            }];
        }
        if (self.goodsView1.hidden&&!self.goodsView3.hidden) {
            [UIView animateWithDuration:0.5 animations:^{
                self.goodsView3.top = self.goodsView1.top;
            }];
        }
        
        if (self.goodsView1.hidden&&self.goodsView2.hidden) {
            self.goodsDeleteBtn3.hidden = YES;
        }
        else if (self.goodsView1.hidden&&self.goodsView3.hidden){
            self.goodsDeleteBtn2.hidden = YES;
        }
        else if (self.goodsView2.hidden&&self.goodsView3.hidden){
            self.goodsDeleteBtn1.hidden = YES;
        }
    }];
}

- (void)goodsDeleteBtn3Clicked{
    NSLog(@"点击了第3个商品的删除按钮");
     self.addGoodsBtn.frame = CGRectMake(-1, 104+5+5, self.view.width+2, 52);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.goodsView3.left = self.view.width;
        self.goodsNumField3.text = @"";
        self.goodsNameField3.text = @"";

        
    }completion:^(BOOL finished) {
        
        self.goodsView3.hidden = YES;
        self.addGoodsBtn.hidden = NO;
        
        if (self.goodsView1.hidden&&self.goodsView2.hidden) {
            self.goodsDeleteBtn3.hidden = YES;
        }
        else if (self.goodsView1.hidden&&self.goodsView3.hidden){
            self.goodsDeleteBtn2.hidden = YES;
        }
        else if (self.goodsView2.hidden&&self.goodsView3.hidden){
            self.goodsDeleteBtn1.hidden = YES;
        }

    }];
}

- (void)prizeBtnClicked{
    NSLog(@"点击了奖品选择按钮");
    if (self.prizeBtn.selected && !self.flowBtn.selected) {
        return;
    }
    
    if(self.prizeBtn.selected)
    {
        if (self.flowBtn.selected) {
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*4+45+120+170+160);
        }else{
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*3+45+170+160);
        }
        
        self.bgView2.hidden = YES;
        self.bgView2.height = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView3.top = self.bgView1.bottom+10;
            self.bgView4.top = self.bgView3.bottom;
            self.bgView5.top = self.bgView4.bottom+10;
        }];
        
        [self.prizeBtn setSelected:NO];
        [self.prizeBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateHighlighted];
        [self.prizeBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];

    }else{
        
        if (self.flowBtn.selected) {
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*5+45+330+120+202);
        }else{
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*4+45+330+202);
        }
        
        self.bgView2.hidden = NO;
        self.bgView2.height = 202;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView3.top = self.bgView2.bottom+10;
            self.bgView4.top = self.bgView3.bottom;
            self.bgView5.top = self.bgView4.bottom+10;
        }];
        
        [self.prizeBtn setSelected:YES];
        [self.prizeBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateHighlighted];
        [self.prizeBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];
    }
    
}

- (void)flowBtnClicked{
    NSLog(@"点击了流量红包选择按钮");
    if (!self.prizeBtn.selected && self.flowBtn.selected) {
        return;
    }
    
    if(self.flowBtn.selected)
    {
        if (self.prizeBtn.selected) {
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*4+45+202+170+160);
        }else{
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*3+45+202+160);
        }
        
        self.bgView3.hidden = YES;
        self.bgView3.height = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView2.top = self.bgView1.bottom+10;
            self.bgView4.top = self.bgView3.bottom;
            self.bgView5.top = self.bgView4.bottom+10;
        }];
        
        [self.flowBtn setSelected:NO];
        [self.flowBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateHighlighted];
        [self.flowBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];
        
    }else{
        self.bgView3.hidden = NO;
        self.bgView3.height = 120;
        
        if (self.prizeBtn.selected) {
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*5+45+120+202+170+160);
        }else{
            self.scrollView.contentSize = CGSizeMake(self.view.width, 10*4+45+120+202+160);
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView2.top = self.bgView1.bottom+10;
            self.bgView4.top = self.bgView3.bottom;
            self.bgView5.top = self.bgView4.bottom+10;
        }];
        
        [self.flowBtn setSelected:YES];
        [self.flowBtn setImage:[UIImage imageNamed:@"ticked_Btn.png"] forState:UIControlStateHighlighted];
        [self.flowBtn setImage:[UIImage imageNamed:@"tick_Btn.png"] forState:UIControlStateNormal];
    }
}

- (void)saveBtnClicked{
    NSLog(@"点击了发红包按钮");
    [self hidenKeyboard];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确认发布活动信息无误？" delegate:self cancelButtonTitle:@"是" otherButtonTitles: @"否",nil];
    alertView.tag = 6002;
    
    [alertView show];
    
}

- (void)releaseRedAct{
    
    if (!self.prizeBtn.selected && !self.flowBtn.selected) {
        [UIAlertView showInfoMsg:@"请选择红包类型"];
        return;
    }
    
    if ([self.wishField.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请编辑祝福语"];
        [self.wishField becomeFirstResponder];
        return;
    }
    if ([self.useDescTextView.text isBlankString]) {
        [UIAlertView showInfoMsg:@"请编辑使用说明"];
        [self.useDescTextView becomeFirstResponder];
        return;
    }
    if([self.showEndTimebtn.titleLabel.text isEqualToString:@"请点击设置截止日期"]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIAlertView showInfoMsg:@"请设置截止时间"];
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
    NSString*endString = self.showEndTimebtn.titleLabel.text;
    NSArray *endArray = [endString componentsSeparatedByString:@"-"];
    endString = [endArray componentsJoinedByString:@""];
    int end = [endString intValue];
    
    if (endString == nil) {
        [UIAlertView showInfoMsg:@"未获取到活动结束时间"];
        return;
    }
    if (today > end ) {
        [UIAlertView showInfoMsg:@"活动结束时间已失效请重新设置"];
        return;
    }
    
    NSMutableArray *goodsArr= [NSMutableArray array];
    if (self.prizeBtn.selected) {
        if (!self.goodsView1.hidden) {
            if ([self.goodsNameField1.text isBlankString]||[self.goodsNumField1.text isBlankString]) {
                [UIAlertView showInfoMsg:@"请编辑奖品完整信息"];
                [self.goodsNameField1 becomeFirstResponder];
                return;
            }
        }
        if (!self.goodsView2.hidden) {
            if ([self.goodsNameField2.text isBlankString]||[self.goodsNumField2.text isBlankString]) {
                [UIAlertView showInfoMsg:@"请编辑奖品完整信息"];
                [self.goodsNameField2 becomeFirstResponder];
                return;
            }
        }
        if (!self.goodsView3.hidden) {
            if ([self.goodsNameField3.text isBlankString]||[self.goodsNumField3.text isBlankString]) {
                [UIAlertView showInfoMsg:@"请编辑奖品完整信息"];
                [self.goodsNameField3 becomeFirstResponder];
                return;
            }
        }
        
        NSMutableDictionary *goodsDict = [[NSMutableDictionary alloc]init];
        if (![self.goodsNameField1.text isEqual:@""]) {
            
            [goodsDict setObject:self.goodsNameField1.text forKey:@"prize_name"];
            [goodsDict setObject:self.goodsNumField1.text forKey:@"prize_num"];
            [goodsDict setObject:@"1" forKey:@"prize_type"];
            
            [goodsArr addObject:goodsDict];
        }
        
        NSMutableDictionary *goodsDict2 = [[NSMutableDictionary alloc]init];
        if (![self.goodsNameField2.text isEqual:@""]) {
            
            [goodsDict2 setObject:self.goodsNameField2.text forKey:@"prize_name"];
            [goodsDict2 setObject:self.goodsNumField2.text forKey:@"prize_num"];
            [goodsDict2 setObject:@"1" forKey:@"prize_type"];
            
            [goodsArr addObject:goodsDict2];
        }
        
        NSMutableDictionary *goodsDict3 = [[NSMutableDictionary alloc]init];
        if (![self.goodsNameField3.text isEqual:@""]) {
            
            [goodsDict3 setObject:self.goodsNameField3.text forKey:@"prize_name"];
            [goodsDict3 setObject:self.goodsNumField3.text forKey:@"prize_num"];
            [goodsDict3 setObject:@"1" forKey:@"prize_type"];
            
            [goodsArr addObject:goodsDict3];
        }
    }
    if (self.flowBtn.selected) {
        
        if ([self.getFlowNumField.text isBlankString]) {
            [UIAlertView showInfoMsg:@"请编辑流量红包数量"];
            [self.getFlowNumField becomeFirstResponder];
            return;
        }
        
        NSMutableDictionary *flowDict = [[NSMutableDictionary alloc]init];
        if (![self.getFlowNumField.text isEqual:@""]) {
            
            [flowDict setObject:@"流量红包" forKey:@"prize_name"];
            [flowDict setObject:self.getFlowNumField.text forKey:@"prize_num"];
            [flowDict setObject:@"2" forKey:@"prize_type"];
            [flowDict setObject:@"3" forKey:@"taffic_num"];
            
            [goodsArr addObject:flowDict];
        }
    }
    NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.wishField.text forKey:@"title"];
    
    self.useDescTextView.text =[self.useDescTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [parameters setObject:self.useDescTextView.text forKey:@"desc"];
    
    [parameters setObject:rewardCode forKey:@"reward_code"];
    [parameters setObject:self.showEndTimebtn.titleLabel.text forKey:@"end_time"];
    [parameters setObject:goodsArr forKey:@"prize"];
    [parameters setObject:[YKLLocalUserDefInfo defModel].userID forKey:@"shop_id"];
    
    //有活动ID则用活动ID无则为空
    if (self.activityID == NULL) {
        self.activityID=@"";
    }
    //再次发布，活动ID为空
    if (self.isEndActivity&&!self.isWaitActivity) {
        self.activityID=@"";
    }
    
    [parameters setObject:self.activityID forKey:@"rid"];
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    
    
    //先注册后发布
    if (([[YKLLocalUserDefInfo defModel].isRegister isEqualToString:@"YES"])) {
        
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在发布红包活动";
        
        
        [YKLNetworkingPrizes releasePrizesWithData:str Success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            
            //待发布发布不清空草稿箱
            if ([self.activityID isBlankString]&&!self.isEndActivity) {
                
                [YKLLocalUserDefInfo defModel].savePrizesActInfoDict = [NSMutableDictionary new];
                [[YKLLocalUserDefInfo defModel] saveToLocalFile];
            }
            
            self.payArray = [NSMutableArray array];
            
            self.orderStatus = [[dict objectForKey:@"state"]integerValue];
            self.content = [dict objectForKey:@"content"];
            self.totleMoney = [dict objectForKey:@"totleMoney"];
            self.payArray = [dict objectForKey:@"pay"];
            self.activityID = [dict objectForKey:@"rid"];
            
            NSDictionary *tempDict = [dict objectForKey:@"red_info"];
            self.shareImage = [tempDict objectForKey:@"share_img"];
            self.shareURL = [tempDict objectForKey:@"share_url"];
            self.shareTitle = [tempDict objectForKey:@"title"];
            self.shareDesc = [tempDict objectForKey:@"share_desc"];
            NSString *strName = [YKLLocalUserDefInfo defModel].userName;
            self.shareDesc = [self.shareDesc stringByReplacingOccurrencesOfString:@"{shop_name}" withString:strName];
            
            if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
                
                YKLTogetherShareViewController *ShareVC = [YKLTogetherShareViewController new];
                ShareVC.hidenBar = YES;
                ShareVC.shareTitle = self.shareTitle;
                ShareVC.shareDesc = self.shareDesc;
                ShareVC.shareImg = self.shareImage;
                ShareVC.shareURL = self.shareURL;
                ShareVC.actType = @"口袋红包";
                super.view.window.rootViewController = ShareVC;
                
            }else{
                
                [YKLLocalUserDefInfo defModel].isShowShare = @"YES";
                [YKLLocalUserDefInfo defModel].shareURL = self.shareURL;
                [YKLLocalUserDefInfo defModel].shareTitle = self.shareTitle;
                [YKLLocalUserDefInfo defModel].shareDesc = self.shareDesc;
                [YKLLocalUserDefInfo defModel].shareImage = self.shareImage;
                [YKLLocalUserDefInfo defModel].shareActType = @"口袋红包";
                [[YKLLocalUserDefInfo defModel]saveToLocalFile];
                
                if (![[dict objectForKey:@"pay"] isEqual:@""]) {
                    
                    YKLPayViewController *payVC = [YKLPayViewController new];
                    payVC.templateModel = dict;
                    payVC.activityID = self.activityID;
                    payVC.orderType = @"3";
                    [self.navigationController pushViewController:payVC animated:YES];
                    
                }else{
                    
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSError *error) {
            
            [self saveDictForFiled];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        
    }else{
        
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
    
    [self.showEndTimebtn setTitle:message forState:UIControlStateNormal];
    
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
    CGRect rect=CGRectMake(0.0f,-120,width,height);
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
    [self.goodsNameField1 resignFirstResponder];
    [self.goodsNumField1 resignFirstResponder];
    [self.goodsNameField2 resignFirstResponder];
    [self.goodsNumField2 resignFirstResponder];
    [self.goodsNameField3 resignFirstResponder];
    [self.goodsNumField3 resignFirstResponder];
    [self.useDescTextView resignFirstResponder];
//    [self.flowNumField resignFirstResponder];
    [self.getFlowNumField resignFirstResponder];
    [self.wishField resignFirstResponder];
    [self.showEndTimebtn resignFirstResponder];
    [self.rewardCodeBtn resignFirstResponder];
    [self resumeView];
}

//保存文件到本地
- (void)saveDictForFiled{
    
    if (self.activityID == NULL) {
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        [tempDict setObject:self.wishField.text forKey:@"title"];
        [tempDict setObject:self.useDescTextView.text forKey:@"desc"];
        
        [tempDict setObject:self.showEndTimebtn.titleLabel.text forKey:@"activity_end_time"];
        
        NSString *rewardCode = [NSString stringWithFormat:@"%@%@%@%@",self.securityTextField1.text,self.securityTextField2.text ,self.securityTextField3.text ,self.securityTextField4.text];
        [tempDict setObject:rewardCode forKey:@"reward_code"];
        
        NSString *selectPrize;
        NSString *selectFlow;
        if (self.prizeBtn.selected) {
            selectPrize = @"1";
        }else{
            selectPrize = @"2";
        }
        if (self.flowBtn.selected) {
            selectFlow = @"1";
        }else{
            selectFlow = @"2";
        }
        [tempDict setObject:selectPrize forKey:@"show_Prize"];
        [tempDict setObject:selectFlow forKey:@"show_Flow"];
        
        NSMutableArray *goodsArr= [NSMutableArray array];
        
        NSMutableDictionary *goodsDict = [[NSMutableDictionary alloc]init];
        if (![self.goodsNameField1.text isEqual:@""]) {
            [goodsDict setObject:self.goodsNameField1.text forKey:@"prize_name"];
            [goodsDict setObject:self.goodsNumField1.text forKey:@"prize_num"];
            [goodsArr addObject:goodsDict];
        }
        
//        if (self.goodsView1.hidden) {
//            [goodsDict setObject:@"YES" forKey:@"prize_hidden"];
//        }else{
//            [goodsDict setObject:@"NO" forKey:@"prize_hidden"];
//        }
       
        
        NSMutableDictionary *goodsDict2 = [[NSMutableDictionary alloc]init];
        if (![self.goodsNameField2.text isEqual:@""]) {
            [goodsDict2 setObject:self.goodsNameField2.text forKey:@"prize_name"];
            [goodsDict2 setObject:self.goodsNumField2.text forKey:@"prize_num"];
            [goodsArr addObject:goodsDict2];
        }
//        if (self.goodsView2.hidden) {
//            [goodsDict setObject:@"YES" forKey:@"prize_hidden"];
//        }else{
//            [goodsDict setObject:@"NO" forKey:@"prize_hidden"];
//        }
        
        NSMutableDictionary *goodsDict3 = [[NSMutableDictionary alloc]init];
        if (![self.goodsNameField3.text isEqual:@""]) {
            [goodsDict3 setObject:self.goodsNameField3.text forKey:@"prize_name"];
            [goodsDict3 setObject:self.goodsNumField3.text forKey:@"prize_num"];
            [goodsArr addObject:goodsDict3];
        }
//        if (self.goodsView3.hidden) {
//            [goodsDict setObject:@"YES" forKey:@"prize_hidden"];
//        }else{
//            [goodsDict setObject:@"NO" forKey:@"prize_hidden"];
//        }
    
        [tempDict setObject:goodsArr forKey:@"goods_array"];
        
        [tempDict setObject:self.getFlowNumField.text forKey:@"traffic_num"];
        
        [YKLLocalUserDefInfo defModel].savePrizesActInfoDict = tempDict;
        [[YKLLocalUserDefInfo defModel] saveToLocalFile];
    }
}
@end
