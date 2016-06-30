//
//  MPSPreviewAdsViewController.h
//  MPStore
//
//  Created by apple on 14/9/13.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPSPreviewAdsViewController : UIViewController

+ (BOOL)hasPreviewAds;
+ (void)downloadPreviewAds;
+ (void)showPreviewAdsInView:(UIView *)view;

@end
