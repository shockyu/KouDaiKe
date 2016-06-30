//
//  MPSBaseModel.h
//  MPStore
//
//  Created by apple on 14/9/9.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    EMPSDownloadStatusNone,
    EMPSDownloadStatusPause,
    EMPSDownloadStatusDownloading,
    EMPSDownloadStatusFinish,
    EMPSDownloadStatusFail
} EMPSDownloadStatus;

@class YKLBaseModel;
@protocol YKLBaseModelDelegate <NSObject>

@optional
- (void)baseModel:(YKLBaseModel *)model downloadStatusChange:(EMPSDownloadStatus)status;

@end

@interface YKLBaseModel : NSObject

@property (nonatomic, weak) id<YKLBaseModelDelegate> delegate;
//@property (nonatomic, assign) BOOL isDownloadingImage;
@property (nonatomic, assign) EMPSDownloadStatus downloadStatus;

- (instancetype)initWithDictionary:(NSDictionary *)dicData;
- (instancetype)updateWithDictionary:(NSDictionary *)dicData;

- (NSString *)stringValueInDictionary:(NSDictionary *)dict forKey:(NSString *)key;

+ (NSString *)imagePathWithUrl:(NSString *)url;
- (BOOL)needDownloadImageForUrl:(NSString *)url;
- (void)downloadImageForUrl:(NSString *)url;
- (void)downloadImageForUrl:(NSString *)url toPath:(NSString *)path;

@end
