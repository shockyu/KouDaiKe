//
//  TWTMenuViewController.h
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTMenuViewController : UIViewController

@property (nonatomic, strong) UIButton *bargainBtn;
@property (nonatomic, strong) UIImageView *bargainImageView;
@property (nonatomic, strong) UIButton *highShopBtn;
@property (nonatomic, strong) UIImageView *highShopImageView;
@property (nonatomic, strong) UIButton *prizesBtn;
@property (nonatomic, strong) UIImageView *prizesImageView;
@property (nonatomic, strong) UIButton *duoBaoBtn;
@property (nonatomic, strong) UIImageView *duoBaoImageView;
@property (nonatomic, strong) UIImageView *selectedImage;

- (void)changeButtonPressed:(NSString *)navTitle;
@property BOOL showBool;
@property BOOL showSideMenu;

@end
