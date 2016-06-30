//
//  YKLPosterTypeViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/1/22.
//  Copyright (c) 2016年 XSkyu. All rights reserved.
//

#import "YKLPosterTypeViewController.h"
#import "YKLPosterReleaseViewController.h"
#import "YKLNewYearPosterReleaseViewController.h"

#import "YKLPosterResultViewController.h"

#import "YKLLoginViewController.h"

@interface YKLPosterTypeSelectCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *typeName;
@end

@implementation YKLPosterTypeSelectCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        self.typeName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.typeName.font = [UIFont systemFontOfSize:12];
        self.typeName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.typeName];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0,24,45,45);
    self.imageView.centerX = self.width/2;
    
    self.typeName.frame = CGRectMake(0, self.imageView.bottom, self.width, 30);
    
}

@end

@interface YKLPosterTypeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSURL *callURL;
    UIWebView *callView;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *expandLael;
@property (nonatomic, strong) UILabel *expandLael2;
@property (nonatomic, strong) UIImageView *expandImageView;
@property (nonatomic, strong) UIButton *expandBtn;

@property (nonatomic, strong) UILabel *moveSaleLabel;
@property (nonatomic, strong) UILabel *moveSaleLabel2;
@property (nonatomic, strong) UIImageView *moveSaleImageView;
@property (nonatomic, strong) UIButton *moveSaleBtn;


@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YKLPosterTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"集赞模板选择";
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    self.bgView.backgroundColor = [UIColor flatLightWhiteColor];
    [self.view addSubview:self.bgView];
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.width, self.view.width);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YKLPosterTypeSelectCell class] forCellWithReuseIdentifier:@"cell"];
    [self.bgView addSubview:self.collectionView];
    
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKLPosterTypeSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_1"];
            cell.typeName.text = @"传说中的金币";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_2"];
            cell.typeName.text = @"嘟嘟气泡";
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_3"];
            cell.typeName.text = @"小冰棍";
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_4"];
            cell.typeName.text = @"粉笔";
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_5"];
            cell.typeName.text = @"我是大圣不是鸡";
            break;
        case 5:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_6"];
            cell.typeName.text = @"小星星";
            break;
        case 6:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_7"];
            cell.typeName.text = @"愤怒的小鸟";
            break;
        case 7:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_8"];
            cell.typeName.text = @"哟~小黄人";
            break;
        case 8:
            cell.imageView.image = [UIImage imageNamed:@"vow_item_9"];
            cell.typeName.text = @"回忆的蝴蝶结";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.collectionView.size.width-2)/3, (self.collectionView.size.height-2)/3);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",(long)indexPath.row);
    
    [self posterTypeClickWith:indexPath.row+1];
    
}


- (void)posterTypeClickWith:(int)type{
    
    YKLPosterResultViewController *postPreview = [YKLPosterResultViewController new];
    
    postPreview.type = type;
    
    [postPreview createView];
    
    [self.navigationController pushViewController:postPreview animated:YES];

}

- (void)moveSaleBtnClick:(id)sender{
    YKLNewYearPosterReleaseViewController *releaseVC = [YKLNewYearPosterReleaseViewController new];
    
    [self.navigationController pushViewController:releaseVC animated:YES];
}

- (void)contactUsBtnClicked:(id)sender
{
    
    if (callView == nil) {
        callView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [callView loadRequest:[NSURLRequest requestWithURL:callURL]];
}


@end
