//
//  MPSBaseModel.m
//  MPStore
//
//  Created by apple on 14/9/9.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLBaseModel.h"

@implementation YKLBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dicData {
    self = [super init];
    if (self) {
        NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:dicData];
        [newData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSNull class]])
            {
                [newData setObject:@"" forKey:key];
            }
        }];
        [self updateWithDictionary:newData];
    }
    return self;
}

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    return self;
}

- (NSString *)stringValueInDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    id obj = [dict objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return @"";
}

+ (NSString *)imagePathWithUrl:(NSString *)url
{
    NSString *imageName = [url lastPathComponent];
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:imageName];
}

- (BOOL)needDownloadImageForUrl:(NSString *)url
{
    if (url.length==0 || self.downloadStatus != EMPSDownloadStatusNone) {
        return NO;
    }
    return YES;
}

- (void)downloadImageForUrl:(NSString *)url {
    [self downloadImageForUrl:url toPath:nil];
}

- (void)downloadImageForUrl:(NSString *)url toPath:(NSString *)path {
    if ([self needDownloadImageForUrl:url] == NO) {
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path.length==0?[YKLBaseModel imagePathWithUrl:url]:path]) {
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    self.downloadStatus = EMPSDownloadStatusDownloading;
    [self.delegate baseModel:self downloadStatusChange:EMPSDownloadStatusDownloading];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        if (path.length == 0) {
            return [[NSURL alloc] initFileURLWithPath:[YKLBaseModel imagePathWithUrl:url]];
        }
        else {
            return [[NSURL alloc] initFileURLWithPath:path];
        }
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        self.downloadStatus = error == nil ? EMPSDownloadStatusFinish : EMPSDownloadStatusFail;
        [self.delegate baseModel:self downloadStatusChange:self.downloadStatus];
//        NSLog(@"%@ downloaded to: %@", error.domain, filePath);
    }];
    [downloadTask resume];
}


@end
