//
//  YKLTogetherShareViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/25.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLTogetherShareViewController.h"
#import "ViewController.h"
#import "YKLShareContentModel.h"
#import "YKLShareViewController.h"

#import "UIImage+ResizeMagick.h"

@interface YKLTogetherShareViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation YKLTogetherShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"分享";
    
    if (self.hidenBar) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"返回首页" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setFrame:CGRectMake(10, 0, 60, 30)];
        leftButton.centerY = bgView.height/2+10;
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:leftButton];

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"分享按钮"]forState:UIControlStateNormal];
        [button setFrame:CGRectMake(self.view.width-35-10, 0, 35, 35)];
        button.centerY = bgView.height/2+10;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.centerX = self.view.width/2;
        label.centerY = bgView.height/2+10;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"分享";
        label.font = [UIFont boldSystemFontOfSize:18];
        label.backgroundColor = [UIColor clearColor];
        [bgView addSubview:label];
    
    }else{
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"分享按钮"]forState:UIControlStateNormal];
         
        [button addTarget:self action:@selector(showShareView)forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 35, 35);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
        
    }

    [self createContent];
    [self showShareView];
    
}

- (void)createContent{
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+64, self.view.width, 220)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.bgView addGestureRecognizer:gesture];
    
    self.shareTitleField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.width-10*2, 50)];
//    self.shareTitleLabel.backgroundColor = [UIColor redColor];
    self.shareTitleField.delegate = self;
    self.shareTitleField.font = [UIFont systemFontOfSize:16];
    self.shareTitleField.textColor = [UIColor lightGrayColor];
    self.shareTitleField.text = [NSString stringWithFormat:@"%@",self.shareTitle];
    [self.bgView addSubview:self.shareTitleField];
    
    self.shareImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, self.shareTitleField.bottom+10, 100, 100)];
    
    if ([self.shareImg isEqual:@"logo"]) {
        self.shareImageView.image = [UIImage imageWithMainBundle:@"logo.png"];
    }else{
        self.shareImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImg]]];
    }
    [self.bgView addSubview:self.shareImageView];

    
    self.shareDescTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.shareImageView.right+10, self.shareImageView.top, 190, 100)];
    self.shareDescTextView.delegate = self;
//    self.shareDescTextView.backgroundColor = [UIColor redColor];
    self.shareDescTextView.textColor = [UIColor lightGrayColor];
    self.shareDescTextView.font = [UIFont systemFontOfSize:12];
    self.shareDescTextView.text = [NSString stringWithFormat:@"%@",self.shareDesc];
//    self.shareDescTextView.editable = NO;
    [self.bgView addSubview:self.shareDescTextView];

    
    self.actTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.shareImageView.bottom+10, self.view.width-10*2, 50)];
//    self.actTypeLabel.backgroundColor = [UIColor redColor];
    self.actTypeLabel.font = [UIFont systemFontOfSize:16];
    self.actTypeLabel.textColor = [UIColor PosterOrangeColor];
    self.actTypeLabel.text = [NSString stringWithFormat:@"活动类型:%@",self.actType];
    [self.bgView addSubview:self.actTypeLabel];
}

- (void)showShareView{
    [self hidenKeyboard];
    
    [YKLShareContentModel defModel].number = [YKLLocalUserDefInfo defModel].userID;
    [YKLShareContentModel defModel].userActionType = EMPSUserActionTypeShareProduct;
    [YKLShareContentModel defModel].title = self.shareTitleField.text;
    [YKLShareContentModel defModel].introduction = self.shareDescTextView.text;
    [YKLShareContentModel defModel].url = self.shareURL;
    [YKLShareContentModel defModel].shareVisible = YES;
//    [YKLShareContentModel defModel].thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImg]]];
    [YKLShareContentModel defModel].thumbImage =  self.shareImageView.image;
    [[YKLShareViewController shareViewController] showInView:self.view];
    [[YKLShareViewController shareViewController] showViewController];
    
}

- (void)goBack{
    
    //返回首页
    [self hidenKeyboard];
    
    [self presentViewController:[[ViewController alloc] init] animated:NO completion:nil];
    
}

#pragma mark - UITextView & UITextField

//UITextView的协议方法，当开始编辑时监听
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == self.shareDescTextView) {
        if (text.length == 0){
            return YES;
        }

        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 100) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.shareDescTextView) {
        if (textView.text.length > 100) {
            textView.text = [textView.text substringToIndex:100];
        }
    }
}

//UITextField的协议方法，当开始编辑时监听
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.shareTitleField) {
        if (string.length == 0){
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 32) {
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.shareTitleField) {
        if (textField.text.length > 32) {
            textField.text = [textField.text substringToIndex:32];
        }
    }
}

#pragma mark - keyboard

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
    
    [self.shareTitleField resignFirstResponder];
    [self.shareDescTextView resignFirstResponder];
    
    [self resumeView];
}

#pragma mark 文字分享
+ (void)sharedByWeChatWithText:(NSString *)WeChatMessage sceneType:(int)sceneType
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text  = WeChatMessage;
    req.bText = YES;
    req.scene = sceneType;
    [WXApi sendReq:req];
}

#pragma mark 图片分享
+ (void)sharedByWeChatWithImage:(UIImage *)image sceneType:(int)sceneType
{    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:
     [image resizedImageWithMaximumSize:CGSizeMake(30, 30)]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData  = UIImagePNGRepresentation(image);
        
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText   = NO;
    req.message = message;
    req.scene   = sceneType;
    [WXApi sendReq:req];
}

@end
