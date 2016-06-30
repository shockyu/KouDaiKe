//
//  ZZSLocalUserDefInfo.m
//  yklStore
//
//  Created by 肖震宇 on 16/2/25.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "ZZSLocalUserDefInfo.h"

#define USER_INFO_FILE                                  @"ZZSUserInfo.plist"
#define USER_INFO_KEY_PLAYINGMUSICNAME                  @"playingMusicName"
#define USER_INFO_KEY_PLAYINGMUSICFILENAME              @"playingMusicFileName"
#define USER_INFO_KEY_STARTTIME                         @"startTime"
#define USER_INFO_KEY_ENDTIME                           @"endTime"
#define USER_INFO_KEY_CURRENTTIME                       @"currentTime"
#define USER_INFO_KEY_DURATION                          @"duration"

@implementation ZZSLocalUserDefInfo

+ (ZZSLocalUserDefInfo *)defModel {
    static ZZSLocalUserDefInfo *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[ZZSLocalUserDefInfo alloc] init];
    });
    return userModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.playingMusicName = @"";
        self.playingMusicFileName = @"";
        self.startTime = @"";
        self.endTime = @"";
        self.currentTime = @"";
        self.duration = @"";
        
        [self loadFromLocalFile];
    }
    return self;
}

//- (void)updateDefStoreWithGuiderModel:(MPSConsumerGuiderModel *)guiderModel {
//    if (guiderModel == nil) {
//        self.defStoreName = @"";
//        self.defStoreURL = @"";
//        self.defStoreDesc = @"";
//        self.defGuiderId = @"";
//    }
//    else {
//        self.defStoreName = guiderModel.shopName;
//        self.defStoreURL = guiderModel.shopUrl;
//        self.defStoreDesc = guiderModel.shopDesc;
//        self.defGuiderId = guiderModel.guiderNumber;
//    }
//    [self saveToLocalFile];
//}

- (void)copyLocalFileToDocument
{
    NSString *localFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:USER_INFO_FILE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath] == NO) {
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:USER_INFO_FILE];
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:localFilePath error:&error];
        NSLog(@"%@", error);
    }
}

- (void)loadFromLocalFile
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:USER_INFO_FILE];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        [self saveToLocalFile];
    }
    else {
        NSDictionary *dicModel = [NSDictionary dictionaryWithContentsOfFile:path];
        
        self.playingMusicName = [dicModel objectForKey:USER_INFO_KEY_PLAYINGMUSICNAME];
        self.playingMusicFileName = [dicModel objectForKey:USER_INFO_KEY_PLAYINGMUSICFILENAME];
        self.startTime = [dicModel objectForKey:USER_INFO_KEY_STARTTIME];
        self.endTime = [dicModel objectForKey:USER_INFO_KEY_ENDTIME];
        self.currentTime = [dicModel objectForKey:USER_INFO_KEY_CURRENTTIME];
        self.duration = [dicModel objectForKey:USER_INFO_KEY_DURATION];
        
    }
}

- (void)saveToLocalFile
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:USER_INFO_FILE];
    NSMutableDictionary *dicModel = [NSMutableDictionary dictionary];
    
    [dicModel setObject:self.playingMusicName forKey:USER_INFO_KEY_PLAYINGMUSICNAME];
    [dicModel setObject:self.playingMusicFileName forKey:USER_INFO_KEY_PLAYINGMUSICFILENAME];
    [dicModel setObject:self.startTime forKey:USER_INFO_KEY_STARTTIME];
    [dicModel setObject:self.endTime forKey:USER_INFO_KEY_ENDTIME];
    [dicModel setObject:self.currentTime forKey:USER_INFO_KEY_CURRENTTIME];
    [dicModel setObject:self.duration forKey:USER_INFO_KEY_DURATION];
    
    [dicModel writeToFile:path atomically:YES];
}

- (NSData *)encodePassword:(NSString *)password
{
    NSMutableData *data = [NSMutableData data];
    const char *utf8Password = [password UTF8String];
    for (int i=0; i<strlen(utf8Password); i++) {
        int ch = utf8Password[i];
        ch *= i+2;
        [data appendBytes:&ch length:sizeof(int)];
    }
    return [data copy];
}

- (NSString *)decodePassword:(NSData *)data
{
    int charNum = (int)data.length/(sizeof(int));
    NSMutableString *password = [NSMutableString string];
    for (int i=0; i<charNum; i++) {
        int ch;
        [data getBytes:&ch range:NSMakeRange(i*sizeof(int), sizeof(int))];
        ch /= i+2;
        [password appendString:[NSString stringWithFormat:@"%c", ch]];
    }
    return password;
}

#pragma mark -

- (void)clearDefInfo {
    //    self.defGuiderId = @"";
    //    self.defStoreURL = @"";
    //    self.defStoreName = @"";
    //    self.defStoreDesc = @"";
}

@end
