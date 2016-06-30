//
//  MPSPreviewAdsViewController.m
//  MPStore
//
//  Created by apple on 14/9/13.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "MPSPreviewAdsViewController.h"
#import "YKLGetADModel.h"

@interface MPSPreviewAdsViewController ()
{
    NSTimer *_timer;
    
}
@property (nonatomic, strong) UIImageView *adsImageView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) UILabel *skipLabel;

@end

@implementation MPSPreviewAdsViewController

+ (NSString *)folderOfFile {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"previewFile"];
}

+ (BOOL)hasPreviewAds {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self folderOfFile]] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self folderOfFile] withIntermediateDirectories:NO attributes:nil error:nil];
        return NO;
    }
    
    NSDirectoryEnumerator *fileEnum = [[NSFileManager defaultManager] enumeratorAtPath:[self folderOfFile]];
    if ([fileEnum allObjects].count > 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getPreviewImagePath {
    NSDirectoryEnumerator *fileEnum = [[NSFileManager defaultManager] enumeratorAtPath:[self folderOfFile]];
    NSArray *items = [fileEnum allObjects];
    if (items.count > 0) {
        return [[self folderOfFile] stringByAppendingPathComponent:[items objectAtIndex:0]];
    }
    return nil;
};

+ (void)downloadPreviewAds {
    
    //闪屏测试接口数据：
    [YKLNetworkingConsumer getADWithName:@"ios_shanping" Type:@"1" Success:^(NSArray *fansModel) {
        
        if (fansModel.count > 0) {
            YKLGetADModel *model = fansModel[0];
            if ([[model.adImg lastPathComponent] isEqualToString:[[self getPreviewImagePath] lastPathComponent]] == NO) {
                [[NSFileManager defaultManager] removeItemAtPath:[self getPreviewImagePath] error:nil];
                
                NSLog(@"download preview file!");
                [model downloadImageForUrl:model.adImg toPath:[[self folderOfFile] stringByAppendingPathComponent:[model.adImg lastPathComponent]]];
            }
            else {
                NSLog(@"same preview file!");
            }
        }
    } failure:^(NSError *error) {
        
    }];

}

+ (void)showPreviewAdsInView:(UIView *)view {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self getPreviewImagePath]];
    if (image != nil) {
        [MPSPreviewAdsViewController sharePreviewController].adsImageView.image = [UIImage imageFromImage:image size:view.size fillStyle:EImageFillStyleStretchByXCenterScale];
        [view addSubview:[MPSPreviewAdsViewController sharePreviewController].view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[MPSPreviewAdsViewController sharePreviewController] dismiss];
        });
    }
}

+ (MPSPreviewAdsViewController *)sharePreviewController {
    static MPSPreviewAdsViewController *shareController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareController = [[MPSPreviewAdsViewController alloc] init];
    });
    return shareController;
}

- (UIImageView *)adsImageView {
    if (_adsImageView == nil) {
        _adsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _adsImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.adsImageView.frame = self.view.bounds;
//    self.adsImageView.image = [UIImage imageNamed:@"logo"];
    self.adsImageView =_adsImageView;
    [self.view addSubview:self.adsImageView];
    
    //    [UIColor colorWithWhite:9.0 alpha:0.8]
    //    [UIColor colorWithHex:0 alpha:0.1]
    
    self.skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-50, 20, 40, 40)];
//    [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
//    [self.skipBtn setTitleColor:[UIColor midnightTextColor] forState:UIControlStateNormal];
//    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.skipBtn setBackgroundColor:[UIColor colorWithWhite:9.0 alpha:0.8]];
    self.skipBtn.layer.cornerRadius = 20;
    self.skipBtn.layer.masksToBounds = YES;
    [self.skipBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 40, 10)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor midnightTextColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"跳过";
    [self.skipBtn addSubview:label];
    
    self.skipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.skipLabel.textAlignment = NSTextAlignmentCenter;
    self.skipLabel.textColor = [UIColor midnightTextColor];
    self.skipLabel.font = [UIFont systemFontOfSize:14];
    [self.skipBtn addSubview:self.skipLabel];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [self timeFireMethod];
}


int secondS = 6;
-(void)timeFireMethod{
    
    secondS--;
    
//    NSString *str = [NSString stringWithFormat:@"跳过%d",secondS];
//    [self.skipBtn setTitle:str forState:UIControlStateNormal];
    
    self.skipLabel.text = [NSString stringWithFormat:@"%d",secondS];
    
    
    if (secondS == 1) {
        
        [_timer invalidate];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss {
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}


@end
