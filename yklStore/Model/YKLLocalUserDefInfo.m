//
//  MPSLocalUserDefInfo.m
//  MPStore
//
//  Created by apple on 14/11/30.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLLocalUserDefInfo.h"

#define USER_INFO_FILE @"UserInfo.plist"

#define USER_INFO_KEY_NAME                      @"moble"
#define USER_INFO_KEY_TYPE                      @"userType"
#define USER_INFO_KEY_USERID                    @"userID"
#define USER_INFO_KEY_USERNAME                  @"userName"
#define USER_INFO_KEY_AGENTCODE                 @"agentCode"
#define USER_INFO_KEY_AGENTNAME                 @"agentName"
#define USER_INFO_KEY_AGENTMOBILE               @"agentMobile"
#define USER_INFO_KEY_AGENTADDRESS              @"agentAddress"
#define USER_INFO_KEY_AGENTHEADERURL            @"agentHeaderURL"
#define USER_INFO_KEY_SHOPQRCODE                @"shopQRCode"

#define USER_INFO_KEY_STATUS                    @"status"
#define USER_INFO_KEY_ISREGISTER                @"isRegister"
#define USER_INFO_KEY_ISLOGIN                   @"isLongin"
#define USER_INFO_KEY_PAYSTATUS                 @"payStatus"
#define USER_INFO_KEY_UNPUBLISHEDNUM            @"unpublishedNum"
#define USER_INFO_KEY_COMPLETENUM               @"completeNum"
#define USER_INFO_KEY_ONGOINGNUM                @"ongoingNum"
#define USER_INFO_KEY_SMSNUM                    @"smsNum"
#define USER_INFO_KEY_ISFIRST                   @"isFirst"
#define USER_INFO_KEY_SHOPEXPOSURENUM           @"shopExposureNum"

#define USER_INFO_KEY_FIRSTHELP                 @"firstHelp"
#define USER_INFO_KEY_SECONDHELP                @"secondHelp"
#define USER_INFO_KEY_ACTTYPEHELP               @"actTypeHelp"
#define USER_INFO_KEY_SETTINGHELP               @"settingHelp"
#define USER_INFO_KEY_ONLINEPAYHELP             @"onlinePayHelp"
#define USER_INFO_KEY_SHAREHELP                 @"shareHelp"
#define USER_INFO_KEY_QRCODEHELP                @"QRcodeHelp"


#define USER_INFO_KEY_BARGAINDDHELP             @"bargainDDHelp"
#define USER_INFO_KEY_BARGAINCXHELP             @"bargainCXHelp"
#define USER_INFO_KEY_HIGOHELP                  @"higoHelp"
#define USER_INFO_KEY_DUOBAOHELP                @"duoBaoHelp"
#define USER_INFO_KEY_MIAOSHAHELP               @"miaoShaHelp"
#define USER_INFO_KEY_SUDINGHELP                @"suDingHelp"


#define USER_INFO_KEY_SAVEACTINFODICT           @"saveActInfoDict"
#define USER_INFO_KEY_SAVEONLINEPAYACTINFODICT  @"saveOnlinePayActInfoDict"
#define USER_INFO_KEY_SAVEHIGHGOACTINFODICT     @"saveHighGoActInfoDict"
#define USER_INFO_KEY_SAVEPRIZESACTINFODICT     @"savePrizesActInfoDict"
#define USER_INFO_KEY_SAVEPDUOBAOACTINFODICT    @"saveDuoBaoActInfoDict"
#define USER_INFO_KEY_SAVEPMIAOSHAACTINFODICT   @"saveMiaoShaActInfoDict"
#define USER_INFO_KEY_SAVESUDINGACTINFODICT     @"saveSuDingActInfoDict"
#define USER_INFO_KEY_SHOPPAYINFODICT           @"shopPayInfoDict"
#define USER_INFO_KEY_PAYWAY                    @"payWay"

#define USER_INFO_KEY_ADDRESS                   @"address"
#define USER_INFO_KEY_STREET                    @"street"

#define USER_INFO_KEY_FIRSTIN                   @"firstIN"

//临时分享所需字段
#define USER_INFO_KEY_ISSHOWSHARE               @"isShowShare"
#define USER_INFO_KEY_SHAREURL                  @"shareURL"
#define USER_INFO_KEY_SHARETITLE                @"shareTitle"
#define USER_INFO_KEY_SHAREDESC                 @"shareDesc"
#define USER_INFO_KEY_SHAREIMAGE                @"shareImage"
#define USER_INFO_KEY_SHAREACTTYPE              @"shareActType"

#define USER_INFO_KEY_REDFLOWDESC               @"redFlowDesc"
#define USER_INFO_KEY_ACTTYPE                   @"actType"

#define USER_INFO_KEY_ISVIP                     @"isVip"
#define USER_INFO_KEY_VIPEND                    @"vipEnd"
#define USER_INFO_KEY_MONEY                     @"money"
#define USER_INFO_KEY_HEADIMAGE                 @"headImage"

#define USER_INFO_KEY_PURVIEW                   @"purview"

@implementation YKLLocalUserDefInfo

+ (YKLLocalUserDefInfo *)defModel {
    static YKLLocalUserDefInfo *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[YKLLocalUserDefInfo alloc] init];
    });
    return userModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.headImage = @"";
        self.money = @"";
        self.isVip = @"";
        self.vipEnd = @"";
        self.isRegister = @"";
        self.isLogin = @"";
        self.mobile = @"";
        self.userID = @"";
        self.userName = @"";
        self.agentCode = @"";
        self.agentName = @"";
        self.agentMobile = @"";
        self.agentAddress = @"";
        self.agentHeaderURL = @"";
        self.shopQRCode = @"";
        
        self.status = @"";
        self.payStatus = @"";
        self.unpublishedNum = @"";
        self.completeNum = @"";
        self.ongoingNum = @"";
        self.smsNum = @"";
        self.isFirst = @"";
        self.shopExposureNum = @"";
        
        self.firstHelp = @"";
        self.secondHelp = @"";
        self.actTypeHelp = @"";
        self.settingHelp = @"";
        self.onlinePayHelp = @"";
        self.shareHelp = @"";
        self.QRcodeHelp = @"";
        
        self.bargainDDHelp = @"";
        self.bargainCXHelp = @"";
        self.higoHelp = @"";
        self.duoBaoHelp = @"";
        self.miaoShaHelp = @"";
        self.suDingHelp = @"";
        
        
        self.saveActInfoDict = [NSMutableDictionary new];
        self.saveHighGoActInfoDict = [NSMutableDictionary new];
        self.saveOnlinePayActInfoDict = [NSMutableDictionary new];
        self.savePrizesActInfoDict = [NSMutableDictionary new];
        self.saveDuoBaoActInfoDict = [NSMutableDictionary new];
        self.saveMiaoShaActInfoDict = [NSMutableDictionary new];
        self.saveSuDingActInfoDict = [NSMutableDictionary new];
        self.shopPayInfoDict = [NSMutableDictionary new];
        self.payWay = @"";
        
        self.address = @"";
        self.street = @"";
        self.firstIN = @"";
        
        self.isShowShare = @"";
        self.shareTitle = @"";
        self.shareURL = @"";
        self.shareDesc = @"";
        self.shareImage = @"";
        self.shareActType = @"";
        
        self.redFlowDesc = @"";
        self.actType = @"";
        
        self.purview = @"";
        
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
        
        self.headImage = [dicModel objectForKey:USER_INFO_KEY_HEADIMAGE];
        self.money = [dicModel objectForKey:USER_INFO_KEY_MONEY];
        self.isVip = [dicModel objectForKey:USER_INFO_KEY_ISVIP];
        self.vipEnd = [dicModel objectForKey:USER_INFO_KEY_VIPEND];
        self.isRegister = [dicModel objectForKey:USER_INFO_KEY_ISREGISTER];
        self.isLogin = [dicModel objectForKey:USER_INFO_KEY_ISLOGIN];
        self.mobile = [dicModel objectForKey:USER_INFO_KEY_NAME];
        self.userID = [dicModel objectForKey:USER_INFO_KEY_USERID];
        self.userName = [dicModel objectForKey:USER_INFO_KEY_USERNAME];
        self.agentCode = [dicModel objectForKey:USER_INFO_KEY_AGENTCODE];
        self.agentName = [dicModel objectForKey:USER_INFO_KEY_AGENTNAME];
        self.agentMobile = [dicModel objectForKey:USER_INFO_KEY_AGENTMOBILE];
        self.agentAddress = [dicModel objectForKey:USER_INFO_KEY_AGENTADDRESS];
        self.agentHeaderURL = [dicModel objectForKey:USER_INFO_KEY_AGENTHEADERURL];
        self.shopQRCode = [dicModel objectForKey:USER_INFO_KEY_SHOPQRCODE];
        
        
        self.status = [dicModel objectForKey:USER_INFO_KEY_STATUS];
        self.payStatus = [dicModel objectForKey:USER_INFO_KEY_PAYSTATUS];
        self.unpublishedNum = [dicModel objectForKey:USER_INFO_KEY_UNPUBLISHEDNUM];
        self.completeNum = [dicModel objectForKey:USER_INFO_KEY_COMPLETENUM];
        self.ongoingNum = [dicModel objectForKey:USER_INFO_KEY_ONGOINGNUM];
        self.smsNum = [dicModel objectForKey:USER_INFO_KEY_SMSNUM];
        self.isFirst = [dicModel objectForKey:USER_INFO_KEY_ISFIRST];
        self.shopExposureNum = [dicModel objectForKey:USER_INFO_KEY_SHOPEXPOSURENUM];
        
        self.firstHelp = [dicModel objectForKey:USER_INFO_KEY_FIRSTHELP];
        self.secondHelp = [dicModel objectForKey:USER_INFO_KEY_SECONDHELP];
        self.actTypeHelp = [dicModel objectForKey:USER_INFO_KEY_ACTTYPEHELP];
        self.settingHelp = [dicModel objectForKey:USER_INFO_KEY_SETTINGHELP];
        self.onlinePayHelp = [dicModel objectForKey:USER_INFO_KEY_ONLINEPAYHELP];
        self.shareHelp = [dicModel objectForKey:USER_INFO_KEY_SHAREHELP];
        self.QRcodeHelp = [dicModel objectForKey:USER_INFO_KEY_QRCODEHELP];
        
        self.bargainDDHelp = [dicModel objectForKey:USER_INFO_KEY_BARGAINDDHELP];
        self.bargainCXHelp = [dicModel objectForKey:USER_INFO_KEY_BARGAINCXHELP];
        self.higoHelp = [dicModel objectForKey:USER_INFO_KEY_HIGOHELP];
        self.duoBaoHelp = [dicModel objectForKey:USER_INFO_KEY_DUOBAOHELP];
        self.miaoShaHelp = [dicModel objectForKey:USER_INFO_KEY_MIAOSHAHELP];
        self.suDingHelp = [dicModel objectForKey:USER_INFO_KEY_SUDINGHELP];

        self.saveActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVEACTINFODICT];
        self.saveHighGoActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVEHIGHGOACTINFODICT];
        self.saveOnlinePayActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVEONLINEPAYACTINFODICT];
        self.savePrizesActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVEPRIZESACTINFODICT];
        self.saveDuoBaoActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVEPDUOBAOACTINFODICT];
        self.saveMiaoShaActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVEPMIAOSHAACTINFODICT];
        self.saveSuDingActInfoDict = [dicModel objectForKey:USER_INFO_KEY_SAVESUDINGACTINFODICT];
        self.shopPayInfoDict = [dicModel objectForKey:USER_INFO_KEY_SHOPPAYINFODICT];
        self.payWay = [dicModel objectForKey:USER_INFO_KEY_PAYWAY];
        
        self.address = [dicModel objectForKey:USER_INFO_KEY_ADDRESS];
        self.street = [dicModel objectForKey:USER_INFO_KEY_STREET];
        self.firstIN = [dicModel objectForKey:USER_INFO_KEY_FIRSTIN];
        
        self.isShowShare = [dicModel objectForKey:USER_INFO_KEY_ISSHOWSHARE];
        self.shareURL = [dicModel objectForKey:USER_INFO_KEY_SHAREURL];
        self.shareTitle = [dicModel objectForKey:USER_INFO_KEY_SHARETITLE];
        self.shareDesc = [dicModel objectForKey:USER_INFO_KEY_SHAREDESC];
        self.shareImage = [dicModel objectForKey:USER_INFO_KEY_SHAREIMAGE];
        self.shareActType = [dicModel objectForKey:USER_INFO_KEY_SHAREACTTYPE];
        
        self.redFlowDesc = [dicModel objectForKey:USER_INFO_KEY_REDFLOWDESC];
        self.actType = [dicModel objectForKey:USER_INFO_KEY_ACTTYPE];
        
        self.purview = [dicModel objectForKey:USER_INFO_KEY_PURVIEW];
    }
}

- (void)saveToLocalFile
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:USER_INFO_FILE];
    NSMutableDictionary *dicModel = [NSMutableDictionary dictionary];
    
    [dicModel setObject:self.headImage forKey:USER_INFO_KEY_HEADIMAGE];
    [dicModel setObject:self.money forKey:USER_INFO_KEY_MONEY];
    [dicModel setObject:self.isVip forKey:USER_INFO_KEY_ISVIP];
    [dicModel setObject:self.vipEnd forKey:USER_INFO_KEY_VIPEND];
    [dicModel setObject:self.isRegister forKey:USER_INFO_KEY_ISREGISTER];
    [dicModel setObject:self.isLogin forKey:USER_INFO_KEY_ISLOGIN];
    [dicModel setObject:self.mobile forKey:USER_INFO_KEY_NAME];
    [dicModel setObject:self.userID forKey:USER_INFO_KEY_USERID];
    [dicModel setObject:self.userName forKey:USER_INFO_KEY_USERNAME];
    [dicModel setObject:self.agentCode forKey:USER_INFO_KEY_AGENTCODE];
    [dicModel setObject:self.agentName forKey:USER_INFO_KEY_AGENTNAME];
    [dicModel setObject:self.agentMobile forKey:USER_INFO_KEY_AGENTMOBILE];
    [dicModel setObject:self.agentAddress forKey:USER_INFO_KEY_AGENTADDRESS];
    [dicModel setObject:self.agentHeaderURL forKey:USER_INFO_KEY_AGENTHEADERURL];
    [dicModel setObject:self.shopQRCode forKey:USER_INFO_KEY_SHOPQRCODE];
    
    
    [dicModel setObject:self.status forKey:USER_INFO_KEY_STATUS];
    [dicModel setObject:self.payStatus forKey:USER_INFO_KEY_PAYSTATUS];
    [dicModel setObject:self.unpublishedNum forKey:USER_INFO_KEY_UNPUBLISHEDNUM];
    [dicModel setObject:self.completeNum forKey:USER_INFO_KEY_COMPLETENUM];
    [dicModel setObject:self.ongoingNum forKey:USER_INFO_KEY_ONGOINGNUM];
    [dicModel setObject:self.smsNum forKey:USER_INFO_KEY_SMSNUM];
    [dicModel setObject:self.isFirst forKey:USER_INFO_KEY_ISFIRST];
    [dicModel setObject:self.shopExposureNum forKey:USER_INFO_KEY_SHOPEXPOSURENUM];
    
    [dicModel setObject:self.firstHelp forKey:USER_INFO_KEY_FIRSTHELP];
    [dicModel setObject:self.secondHelp forKey:USER_INFO_KEY_SECONDHELP];
    [dicModel setObject:self.actTypeHelp forKey:USER_INFO_KEY_ACTTYPEHELP];
    [dicModel setObject:self.settingHelp forKey:USER_INFO_KEY_SETTINGHELP];
    [dicModel setObject:self.onlinePayHelp forKey:USER_INFO_KEY_ONLINEPAYHELP];
    [dicModel setObject:self.shareHelp forKey:USER_INFO_KEY_SHAREHELP];
    [dicModel setObject:self.QRcodeHelp forKey:USER_INFO_KEY_QRCODEHELP];
    
    [dicModel setObject:self.bargainDDHelp forKey:USER_INFO_KEY_BARGAINDDHELP];
    [dicModel setObject:self.bargainCXHelp forKey:USER_INFO_KEY_BARGAINCXHELP];
    [dicModel setObject:self.higoHelp forKey:USER_INFO_KEY_HIGOHELP];
    [dicModel setObject:self.duoBaoHelp forKey:USER_INFO_KEY_DUOBAOHELP];
    [dicModel setObject:self.miaoShaHelp forKey:USER_INFO_KEY_MIAOSHAHELP];
    [dicModel setObject:self.suDingHelp forKey:USER_INFO_KEY_SUDINGHELP];
    
    [dicModel setObject:self.saveActInfoDict forKey:USER_INFO_KEY_SAVEACTINFODICT];
    [dicModel setObject:self.saveHighGoActInfoDict forKey:USER_INFO_KEY_SAVEHIGHGOACTINFODICT];
    [dicModel setObject:self.saveOnlinePayActInfoDict forKey:USER_INFO_KEY_SAVEONLINEPAYACTINFODICT];
    [dicModel setObject:self.savePrizesActInfoDict forKey:USER_INFO_KEY_SAVEPRIZESACTINFODICT];
    [dicModel setObject:self.saveDuoBaoActInfoDict forKey:USER_INFO_KEY_SAVEPDUOBAOACTINFODICT];
    [dicModel setObject:self.saveMiaoShaActInfoDict forKey:USER_INFO_KEY_SAVEPMIAOSHAACTINFODICT];
    [dicModel setObject:self.saveSuDingActInfoDict forKey:USER_INFO_KEY_SAVESUDINGACTINFODICT];
    [dicModel setObject:self.shopPayInfoDict forKey:USER_INFO_KEY_SHOPPAYINFODICT];
    [dicModel setObject:self.payWay forKey:USER_INFO_KEY_PAYWAY];
    
    [dicModel setObject:self.address forKey:USER_INFO_KEY_ADDRESS];
    [dicModel setObject:self.street forKey:USER_INFO_KEY_STREET];
    [dicModel setObject:self.firstIN forKey:USER_INFO_KEY_FIRSTIN];
    
    [dicModel setObject:self.isShowShare forKey:USER_INFO_KEY_ISSHOWSHARE];
    [dicModel setObject:self.shareURL forKey:USER_INFO_KEY_SHAREURL];
    [dicModel setObject:self.shareTitle forKey:USER_INFO_KEY_SHARETITLE];
    [dicModel setObject:self.shareDesc forKey:USER_INFO_KEY_SHAREDESC];
    [dicModel setObject:self.shareImage forKey:USER_INFO_KEY_SHAREIMAGE];
    [dicModel setObject:self.shareActType forKey:USER_INFO_KEY_SHAREACTTYPE];
    
    [dicModel setObject:self.redFlowDesc forKey:USER_INFO_KEY_REDFLOWDESC];
    [dicModel setObject:self.actType forKey:USER_INFO_KEY_ACTTYPE];
    
    [dicModel setObject:self.purview forKey:USER_INFO_KEY_PURVIEW];
    
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
