//
//  ViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/11.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "ViewController.h"
#import "YKLLoginNavController.h"
#import "MPSPreviewAdsViewController.h"

@interface ViewController ()
@property (nonatomic, strong) YKLLoginNavController *loginNavController;


@end

@implementation ViewController


- (YKLLoginNavController *)loginNavController {
    if (_loginNavController == nil) {
        _loginNavController = [[YKLLoginNavController alloc] init];
    }
    return _loginNavController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.view addSubview:self.loginNavController.view];
    
    if (!_isPay) {
        [MPSPreviewAdsViewController downloadPreviewAds];
        
        if ([MPSPreviewAdsViewController hasPreviewAds]) {
            [MPSPreviewAdsViewController showPreviewAdsInView:self.view];
        }
    }
}

@end
