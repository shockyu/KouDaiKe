//
//  MPSShareViewController.m
//  MPStore
//
//  Created by apple on 14/9/19.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLShareViewController.h"
#import "YKLShareView.h"
//#import "MPSWebViewController.h"
#import "WXApi.h"

@interface YKLShareViewController () <YKLShareViewDelegate>

@property (nonatomic, strong) UIView *navController;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) YKLShareView *shareView;
@property (nonatomic, strong) NSArray *actionTypes;

@end

@implementation YKLShareViewController

+ (YKLShareViewController *)shareViewController {
    static YKLShareViewController *shareViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareViewController = [[YKLShareViewController alloc] init];
        shareViewController.actionTypes = @[[NSNumber numberWithInteger:EMPSShareTypeWeiXin], [NSNumber numberWithInteger:EMPSShareTypeFriendCircle], [NSNumber numberWithInteger:EMPSShareTypeCopy]];
    });
    return shareViewController;
}

+ (YKLShareViewController *)shareDetailViewController {
    static YKLShareViewController *shareDetailViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDetailViewController = [[YKLShareViewController alloc] init];
        shareDetailViewController.actionTypes = @[[NSNumber numberWithInteger:EMPSShareTypeWeiXin], [NSNumber numberWithInteger:EMPSShareTypeFriendCircle], [NSNumber numberWithInteger:EMPSShareTypeCopy]];
    });
    return shareDetailViewController;
}

- (YKLShareContentModel *)shareContent {
    return [YKLShareContentModel defModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.0;
    [self.view addSubview:self.bgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewDidCancelShare)];
    [self.bgView addGestureRecognizer:tapGesture];
    
    self.shareView = [[YKLShareView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0) types:self.actionTypes];
    self.shareView.delegate = self;
    self.shareView.top = self.view.height;
    [self.view addSubview:self.shareView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInView:(UIView *)view {
    self.navController = view;
    [view addSubview:self.view];
//    [self show];
}

- (void)shareViewDidCancelShare {
    [self hideComplete:^{
        
    }];
}

- (void)shareViewDidClickItemType:(EMPSShareType)type {
    [self hideComplete:^{
        switch (type) {
            case EMPSShareTypeCopy:
            {
                [[UIPasteboard generalPasteboard] setString:self.shareContent.url];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navController animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"链接已拷贝";
                [hud hide:YES afterDelay:2];
                break;
            }
            case EMPSShareTypeWeiXin:
            case EMPSShareTypeFriendCircle:
            {
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = self.shareContent.title;
                message.description = self.shareContent.introduction;
                
//                NSString *path = [YKLBaseModel imagePathWithUrl:self.url];
//                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                    NSLog(@"YES");
//                }
//
//                UIImage *image = [UIImage imageWithContentsOfFile:[YKLBaseModel imagePathWithUrl:self.url]];
                [message setThumbImage:[UIImage imageFromImage:self.shareContent.thumbImage size:CGSizeMake(100, 100) fillStyle:EImageFillStyleStretchByCenterScale]];
                
                WXWebpageObject *ext = [WXWebpageObject object];
                ext.webpageUrl = self.shareContent.url;
                
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = type == EMPSShareTypeWeiXin ? WXSceneSession : WXSceneTimeline;
                
                [WXApi sendReq:req];
                break;
            }
            default:
                break;
        }
    }];
}

- (void)showViewController {
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.alpha = 0.1;
        self.shareView.bottom =self.view.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showView {
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.alpha = 0.5;
        self.shareView.bottom =self.view.height-100;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideComplete:(void (^)())complete {
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.alpha = 0.0;
        self.shareView.top =self.view.height;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        complete();
    }];
}

@end
