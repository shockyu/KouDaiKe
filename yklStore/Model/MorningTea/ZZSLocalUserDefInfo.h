//
//  ZZSLocalUserDefInfo.h
//  yklStore
//
//  Created by 肖震宇 on 16/2/25.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZSLocalUserDefInfo : NSObject

@property (nonatomic, copy) NSString *playingMusicName;
@property (nonatomic, copy) NSString *playingMusicFileName;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *currentTime;
@property (nonatomic, copy) NSString *duration;

+ (ZZSLocalUserDefInfo *)defModel;

- (void)copyLocalFileToDocument;
- (void)loadFromLocalFile;
- (void)saveToLocalFile;

// 当发现当前登陆的用户和上一次登陆的用户不一样时，清除上一次用户的默认信息
- (void)clearDefInfo;

@end
