//
//  MUILoadMoreTableView.m
//  etionUI
//
//  Created by WangJian on 14-9-23.
//  Copyright (c) 2014年 GuangZhouXuanWu. All rights reserved.
//

#import "MUILoadMoreTableView.h"

#define LOAD_MORE_H 60

@interface MUILoadMoreTableView()

//@property (nonatomic, strong) UILabel *loadMoreLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreIndicatorView;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation MUILoadMoreTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.loadMoreEnable = YES;
//        self.loadMoreText = @"";
        self.loadMoreIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.loadMoreIndicatorView];
    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
//    if (self.isLoading == YES) {
//        self.loadMoreIndicatorView.center = CGPointMake(self.contentSize.width/2+self.contentInset.left,
//                                                        self.contentSize.height+self.contentInset.top+self.contentInset.bottom-LOAD_MORE_H/2);
//    }
//    else {
        self.loadMoreIndicatorView.center = CGPointMake(self.contentSize.width/2+self.contentInset.left,
                                                        self.contentSize.height+self.contentInset.top+self.contentInset.bottom+LOAD_MORE_H/2);
//    }
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    if (self.loadMoreEnable == YES && self.isLoading == NO) {
        if (self.contentSize.height+self.contentInset.top+self.contentInset.bottom < contentOffset.y+self.height) {
//            NSLog(@"call load delegate.");
//            [self.delegate tableViewNeedLoadMore:self];
        }
    }
}

- (void)startLoad {
    if (self.isLoading == YES) {
        return;
    }
    
//    NSLog(@"start load.");
    self.isLoading = YES;
    
    [self.loadMoreIndicatorView startAnimating];
//    [UIView animateWithDuration:.25 animations:^{
//        UIEdgeInsets insets = self.contentInset;
//        insets.bottom += LOAD_MORE_H;
//        self.contentInset = insets;
//    }];
}

- (void)endLoad {
    if (self.isLoading == NO) {
        return;
    }
//    NSLog(@"end load.");
    self.isLoading = NO;
    
    [self.loadMoreIndicatorView stopAnimating];
//    [UIView animateWithDuration:.25 animations:^{
//        UIEdgeInsets insets = self.contentInset;
//        insets.bottom -= LOAD_MORE_H;
//        self.contentInset = insets;
//    }];
}

@end
