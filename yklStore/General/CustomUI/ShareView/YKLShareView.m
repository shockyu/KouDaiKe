//
//  MPSShareView.m
//  MPStore
//
//  Created by apple on 14/9/19.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLShareView.h"

#define SHARE_CELL_SIZE 80
#define SHARE_CELL_MARGIN 20
#define CANCEL_BTN_H 36

@interface MPSShareViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MPSShareViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = [UIColor midnightTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, self.contentView.height-self.titleLabel.font.lineHeight*2, self.contentView.width, self.titleLabel.font.lineHeight*2);
    self.imageView.frame = CGRectMake((self.contentView.width-self.imageView.image.size.width)/2, (self.titleLabel.top-self.imageView.image.size.height)/2, self.imageView.image.size.width, self.imageView.image.size.height);
}

@end

@interface YKLShareView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *types;

@property (nonatomic, strong) UIToolbar *bgView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation YKLShareView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame types:@[[NSNumber numberWithInteger:EMPSShareTypeWeiXin], [NSNumber numberWithInteger:EMPSShareTypeFriendCircle], [NSNumber numberWithInteger:EMPSShareTypeCopy]]];
}

- (instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types {
    NSInteger numPerLine = (frame.size.width-SHARE_CELL_MARGIN)/(SHARE_CELL_MARGIN+SHARE_CELL_SIZE);
    NSInteger numOfLine = (types.count+numPerLine-1)/numPerLine;
    frame = CGRectMake(0, 0, frame.size.width, numOfLine*(SHARE_CELL_MARGIN+SHARE_CELL_SIZE)+2*SHARE_CELL_MARGIN+CANCEL_BTN_H);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.types = types;
       
        self.imageNames = @[ @"share_weixin", @"share_circle", @"share_copy"];
        self.titles = @[ @"分享到微信", @"分享到朋友圈", @"复制链接"];
        
        self.bgView = [[UIToolbar alloc] initWithFrame:self.bounds];
        [self addSubview:self.bgView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SHARE_CELL_SIZE, SHARE_CELL_SIZE);
        layout.sectionInset = UIEdgeInsetsMake(SHARE_CELL_MARGIN, SHARE_CELL_MARGIN, SHARE_CELL_MARGIN, SHARE_CELL_MARGIN);
        layout.minimumInteritemSpacing = SHARE_CELL_MARGIN;
        layout.minimumLineSpacing = SHARE_CELL_MARGIN;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-SHARE_CELL_MARGIN-CANCEL_BTN_H) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[MPSShareViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.collectionView];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SHARE_CELL_MARGIN, self.height-SHARE_CELL_MARGIN-CANCEL_BTN_H, self.width-2*SHARE_CELL_MARGIN, CANCEL_BTN_H)];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        self.cancelBtn.layer.cornerRadius = 5;
        [self.cancelBtn setBackgroundColor:[UIColor flatLightRedColor]];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.types.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPSShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    EMPSShareType type = [self.types[indexPath.item] integerValue];
    cell.imageView.image = [UIImage imageNamed:self.imageNames[type]];
    cell.titleLabel.text = self.titles[type];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate shareViewDidClickItemType:[self.types[indexPath.item] integerValue]];
}

- (void)cancelBtnClicked {
    [self.delegate shareViewDidCancelShare];
}

@end



