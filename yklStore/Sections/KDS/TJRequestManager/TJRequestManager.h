//
//  TJRequestManager.h
//  TuJing
//
//  Created by willbin on 14-7-27.
//  Copyright (c) 2014年 willbin. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface TJRequestManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManagerWithToken;

@end
