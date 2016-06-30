//
//  YKLSpecialModelViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/8.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLSpecialModelViewController.h"
#import "YKLReleaseTemplateViewController.h"
#import "YKLHighGoTemplateViewController.h"
#import "YKLMiaoShaReleaseTemplateViewController.h"
#import "YKLSuDingReleaseTemplateViewController.h"

@interface YKLSpecialModelViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *popupsImage;
@property (nonatomic, strong) UILabel *popupstitle;
@property (nonatomic, strong) UITextField *popupsField;
@property (nonatomic, strong) UIButton *popupsBtn;
@end

@implementation YKLSpecialModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"口令";
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    bgImageView.image = [UIImage imageNamed:@"AladBgImage"];
    [self.view addSubview:bgImageView];
    
    
    UIImageView* mainImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mainImageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"灯1.png"],
                                     [UIImage imageNamed:@"灯2.png"],
                                     [UIImage imageNamed:@"灯3.png"],
                                     [UIImage imageNamed:@"灯4.png"],
                                     [UIImage imageNamed:@"灯5.png"],
                                     [UIImage imageNamed:@"灯6.png"],
                                     [UIImage imageNamed:@"灯7.png"],
                                     [UIImage imageNamed:@"灯8.png"],
                                     [UIImage imageNamed:@"灯9.png"],
                                     [UIImage imageNamed:@"灯10.png"],
                                     [UIImage imageNamed:@"灯11.png"],
                                     [UIImage imageNamed:@"灯12.png"],
                                     [UIImage imageNamed:@"灯13.png"],
                                     [UIImage imageNamed:@"灯14.png"],
                                     [UIImage imageNamed:@"灯15.png"],
                                     [UIImage imageNamed:@"灯16.png"],nil];
    [mainImageView setAnimationDuration:1.0f];
    [mainImageView setAnimationRepeatCount:1];
    [mainImageView setImage:[UIImage imageNamed:@"灯16.png"]];
    [mainImageView startAnimating];
    [self.view addSubview:mainImageView];
    
    self.popupsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, self.view.width-20, 170)];
    self.popupsImage.image = [UIImage imageNamed:@"AladPopupsBg"];
    self.popupsImage.centerY = bgImageView.centerY;
    self.popupsImage.userInteractionEnabled = YES;
    self.popupsImage.hidden = YES;
    [self.view addSubview:self.popupsImage];
    
    self.popupstitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, 60, 35)];
    self.popupstitle.textColor = [UIColor colorWithHexString:@"ffd196"];
    self.popupstitle.text = @"输入口令";
    self.popupstitle.font = [UIFont systemFontOfSize:12];
    [self.popupsImage addSubview:self.popupstitle];
    
    self.popupsField = [[UITextField alloc]initWithFrame:CGRectMake(self.popupstitle.right, self.popupstitle.top, 160, 35)];
    self.popupsField.delegate = self;
    self.popupsField.backgroundColor = [UIColor colorWithHexString:@"d1ac7d"];
    self.popupsField.layer.cornerRadius = 5;
    self.popupsField.layer.masksToBounds = YES;
    self.popupsField.font = [UIFont systemFontOfSize:12];
    self.popupsField.textColor = [UIColor whiteColor];
    [self.popupsImage addSubview:self.popupsField];
    
    
    self.popupsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.popupsBtn.frame = CGRectMake(0, self.popupsField.bottom+25, 160, 35);
    self.popupsBtn.centerX = self.popupsImage.centerX;
    self.popupsBtn.layer.cornerRadius = 15;
    self.popupsBtn.layer.masksToBounds = YES;
    [self.popupsBtn addTarget:self action:@selector(popupsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.popupsBtn setImage:[UIImage imageNamed:@"AladPopupsBtn"] forState:UIControlStateNormal];
    [self.popupsImage addSubview:self.popupsBtn];
    
    
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.1];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)delayMethod{
    self.popupsImage.hidden = NO;
}

- (void)popupsBtnClick:(id)sender{
    [self hidenKeyboard];
    
    if ([self.popupsField.text isEqual:@""]) {
        [UIAlertView showInfoMsg:@"请输入口令"];
        return;
    }
    
    if ([self.popupsField.text isEqual:@"0"]) {
        [UIAlertView showInfoMsg:@"请输入正确口令"];
        return;
    }
    
    if ([self.actName isEqual:@"一元抽奖"])
    {
        
        YKLHighGoTemplateViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        vc.scrollView.contentSize = CGSizeMake(vc.scrollView.width*2, vc.scrollView.height);
        [vc typeSegmentValueFaceChanged:1 TempCode:self.popupsField.text];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([self.actName isEqual:@"大砍价"])
    {
        YKLReleaseTemplateViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        vc.scrollView.contentSize = CGSizeMake(vc.scrollView.width*2, vc.scrollView.height);
        [vc typeSegmentValueFaceChanged:1 TempCode:self.popupsField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.actName isEqual:@"全民秒杀"])
    {
        YKLMiaoShaReleaseTemplateViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        vc.scrollView.contentSize = CGSizeMake(vc.scrollView.width*2, vc.scrollView.height);
        [vc typeSegmentValueFaceChanged:1 TempCode:self.popupsField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.actName isEqual:@"一元速定"])
    {
        YKLSuDingReleaseTemplateViewController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        vc.scrollView.contentSize = CGSizeMake(vc.scrollView.width*2, vc.scrollView.height);
        [vc typeSegmentValueFaceChanged:1 TempCode:self.popupsField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.translucent = NO;
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:0];
    
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
    CGRect rect=CGRectMake(0.0f,-130,width,height);
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
    [self.popupsField resignFirstResponder];
   
    
    [self resumeView];
}



@end
