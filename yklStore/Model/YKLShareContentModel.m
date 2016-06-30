//
//  MPSShareContentModel.m
//  MPStore
//
//  Created by apple on 14/10/17.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLShareContentModel.h"

@implementation YKLShareContentModel

+ (YKLShareContentModel *)defModel {
    static YKLShareContentModel *defShareModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defShareModel = [[YKLShareContentModel alloc] init];
    });
    return defShareModel;
}

- (void)setIntroduction:(NSString *)introduction {
    if (introduction == nil) {
        introduction = @"";
    }
    _introduction = introduction;
}

@end
