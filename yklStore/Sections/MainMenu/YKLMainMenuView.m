//
//  YKLMainMenuView.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/15.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLMainMenuView.h"

@interface YKLMainMenuCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *markInfo;

@end

@implementation YKLMainMenuCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        self.markInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        self.markInfo.backgroundColor = [UIColor flatLightRedColor];
        self.markInfo.layer.cornerRadius = 4;
        self.markInfo.layer.masksToBounds = YES;
        self.markInfo.font = [UIFont systemFontOfSize:10];
        self.markInfo.textColor = [UIColor whiteColor];
        self.markInfo.textAlignment = NSTextAlignmentCenter;
        self.markInfo.hidden = YES;
        [self.contentView addSubview:self.markInfo];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake((self.contentView.width- self.contentView.width/5*3)/2, (self.contentView.height- self.contentView.width/5*3)/3, 35, 35);
    self.imageView.center = CGPointMake(self.contentView.width/2, self.contentView.height/2-10);
    self.titleLabel.frame = CGRectMake(0, self.imageView.bottom, self.contentView.width, 30);
    self.markInfo.frame = CGRectMake(self.imageView.right+5, self.imageView.top-5, 8, 8);
}

@end


@interface YKLMainMenuView ()<UICollectionViewDataSource, UICollectionViewDelegate>



@end

@implementation YKLMainMenuView

static NSString * const reuseIdentifier = @"Cell";
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame types:@[ [NSNumber numberWithInteger:YKLMainMenuTypeActList],[NSNumber numberWithInteger:YKLMainMenuTypeBalance], [NSNumber numberWithInteger:YKLMainMenuTypeShop]]];//[NSNumber numberWithInteger:YKLMainMenuTypeRelease], [NSNumber numberWithInteger:YKLMainMenuTypeProgress],
}

- (instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types {

    frame =  CGRectMake(0, 0, frame.size.width, 0);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.types = types;
        self.imageNames = @[ @"shouye-huodongguanli", @"shouye-qianbao",@"shoye-liancai"];
        
        if ([[YKLLocalUserDefInfo defModel].userID isEqual:@"29"]) {
            self.titles = @[ @"活动管理",@"操作指南", @"关于我们"];
        }else{
            self.titles = @[ @"活动管理",@"口袋钱包", @"口袋联采"];
        }
        
//        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, ScreenHeight*0.563)];
        self.bgView.backgroundColor = [UIColor flatLightWhiteColor];
        [self addSubview:self.bgView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.width/3, ScreenHeight*0.563-1);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 8;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.width/3*2, 0, self.width/3-8, ScreenHeight*0.563) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[YKLMainMenuCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionView];
        
        [self createMainMenuBtn];
        
        //发布按钮动画效果
        [UIView animateWithDuration:0.3 animations:^{
            self.releaseImageView.size = CGSizeMake(self.releaseBtn.width/5*3.5+20, self.releaseBtn.width/5*3.5+20);
            self.releaseImageView.center = CGPointMake(self.releaseBtn.width/2, self.releaseBtn.height/2-10);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.releaseImageView.size = CGSizeMake(self.releaseBtn.width/5*3.5-40, self.releaseBtn.width/5*3.5-40);
                self.releaseImageView.center = CGPointMake(self.releaseBtn.width/2, self.releaseBtn.height/2-10);
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.releaseImageView.size = CGSizeMake(self.releaseBtn.width/5*3.5, self.releaseBtn.width/5*3.5);
                    self.releaseImageView.center = CGPointMake(self.releaseBtn.width/2, self.releaseBtn.height/2-10);
                }];
            }];
            
        }];
    }
    return self;
}

- (void)createMainMenuBtn{
    
    self.releaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, self.width/3*2-1-8-8, ScreenHeight*0.563/3*2+1-8)];
    self.releaseBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    [self.releaseBtn setBackgroundColor: [UIColor colorWithHexString:@"ffe9c3"]];
    [self.releaseBtn setBackgroundColor: [UIColor whiteColor]];
    
//    [self.releaseBtn setTitle:@"发布活动" forState:UIControlStateNormal];
    [self.releaseBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//    [self.releaseBtn addTarget:self action:@selector(releaseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.releaseBtn];
    
    self.releaseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.releaseBtn.width/5*3.5, self.releaseBtn.width/5*3.5)];
    self.releaseImageView.center = CGPointMake(self.releaseBtn.width/2, self.releaseBtn.height/2-10);
    self.releaseImageView.image = [UIImage imageNamed:@"发布活动"];
    //    self.releaseImageView.backgroundColor = [UIColor redColor];
    [self.releaseBtn addSubview:self.releaseImageView];
    
    self.releaseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.releaseLabel.frame = CGRectMake(0, self.releaseImageView.bottom,self.releaseBtn.width, 30);
    self.releaseLabel.font = [UIFont systemFontOfSize:14];
    self.releaseLabel.textColor = [UIColor blackColor];
    self.releaseLabel.textAlignment = NSTextAlignmentCenter;
    self.releaseLabel.text = @"发布活动";
    [self.releaseBtn addSubview:self.releaseLabel];
    
    self.orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, self.releaseBtn.bottom+8, self.width/3*2-1-8-8, ScreenHeight*0.563/3-2-8)];
    self.orderBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    [self.orderBtn setBackgroundColor: [UIColor colorWithHexString:@"ffe9c3"]];
    [self.orderBtn setBackgroundColor:[UIColor whiteColor]];
    
//    [self.orderBtn setTitle:@"订单中心" forState:UIControlStateNormal];
    [self.orderBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//    [self.orderBtn addTarget:self action:@selector(orderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.orderBtn];
    
    self.orderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    self.orderImageView.center = CGPointMake(self.orderBtn.width/2, self.orderBtn.height/2-10);
    self.orderImageView.image = [UIImage imageNamed:@"shouye-koudaishuo"];
//    self.orderImageView.backgroundColor = [UIColor redColor];
    [self.orderBtn addSubview:self.orderImageView];
    
    self.orderMarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.orderImageView.right, self.orderImageView.top, 16, 16)];
    self.orderMarkLabel.backgroundColor = [UIColor flatLightWhiteColor];
    self.orderMarkLabel.layer.cornerRadius = 8;
    self.orderMarkLabel.layer.masksToBounds = YES;
    self.orderMarkLabel.font = [UIFont systemFontOfSize:10];
    self.orderMarkLabel.textColor = [UIColor whiteColor];
    self.orderMarkLabel.textAlignment = NSTextAlignmentCenter;
//    [self.orderBtn addSubview:self.orderMarkLabel];
    
    self.orderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.orderLabel.frame = CGRectMake(0, self.orderImageView.bottom,self.orderBtn.width, 30);
    self.orderLabel.font = [UIFont systemFontOfSize:12];
    self.orderLabel.textColor = [UIColor blackColor];
    self.orderLabel.textAlignment = NSTextAlignmentCenter;
    self.orderLabel.text = @"口袋说";
    [self.orderBtn addSubview:self.orderLabel];
    
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.types.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKLMainMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    YKLMainMenuType type = [self.types[indexPath.item] integerValue];
    cell.imageView.image = [UIImage imageNamed:self.imageNames[type]];
    cell.titleLabel.text = self.titles[type];
//    cell.backgroundColor = [UIColor colorWithHexString:@"ffe9c3"];
    cell.backgroundColor = [UIColor whiteColor];
    
    //同步用户信息
    [YKLNetworkingConsumer getSynchronizationWithUserID:[YKLLocalUserDefInfo defModel].userID Success:^(YKLUserSynchronizationModel *userSynchronizationModel) {

        NSString *newNum = @"0";
        if (indexPath.item == 0) {
            newNum = userSynchronizationModel.ongoingNum;
        }
        else if (indexPath.item == 1) {
            newNum = userSynchronizationModel.unpublishedNum;
        }
        else if (indexPath.item == 2) {
            newNum = @"0";
        }
        
        if ([newNum integerValue] > 0&& [newNum integerValue] < 10) {
            cell.markInfo.hidden = NO;
//            cell.markInfo.text = [NSString stringWithFormat:@"%@", newNum];
        }
        else if([newNum integerValue] > 9){
            cell.markInfo.hidden = NO;
//            cell.markInfo.text = @"9+";
        }
        else{
            cell.markInfo.hidden = YES;
        }
        
        //订单中心圆点显示
        self.orderMarkLabel.text = @"0";
        if ([self.orderMarkLabel.text integerValue] > 0&& [self.orderMarkLabel.text integerValue] < 10) {
//            self.orderMarkLabel.text = [NSString stringWithFormat:@"%@", newNum];
        }
        else if([self.orderMarkLabel.text integerValue] > 9){
//            self.orderMarkLabel.text = @"9+";
        }
        else{
           self.orderMarkLabel.hidden = YES;
        }
        
        
        if (indexPath.item == 0) {
            
        }
        else if (indexPath.item == 1) {
            
            cell.markInfo.hidden = YES;
        }
        else if (indexPath.item == 2) {
            
            cell.markInfo.hidden = YES;
        }
        
    } failure:^(NSError *error) {
         
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.size.width, self.collectionView.size.height/3-8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate shareViewDidClickItemType:[self.types[indexPath.item] integerValue]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    
}

@end
