//
//  MPBaseNetworking.m
//  MPStore
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "YKLBaseNetworking.h"

@implementation YKLBaseNetworking

+ (void)cancelAllRequest {
    [[self shareManager].operationQueue cancelAllOperations];
}

+ (AFHTTPRequestOperationManager *)shareManager {
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    return manager;
}

+ (void)POSTOnlyApi:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self shareManager] POST:apiStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
        if (responseCode == 1) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNull class]])
                    {
                        [dicData setObject:@"" forKey:key];
                    }
                }];
                success(operation, [dicData copy]);
            }
            else
            {
                success(operation, data);
            }
        }
        else {
            
            success(operation,[responseObject objectForKey:@"message"]);
            
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
            failure(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(operation, newError);
    }];
}

+ (void)POST:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self shareManager] POST:[ROOT_URL stringByAppendingString:apiStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
//        responseCode = 2;
        
        if (responseCode == 1) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNull class]])
                    {
                        [dicData setObject:@"" forKey:key];
                    }
                }];
                success(operation, [dicData copy]);
            }
            else
            {
                success(operation, data);
            }
        }
        else {
            
//            success(operation,[responseObject objectForKey:@"message"]);
            
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
            failure(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(operation, newError);
    }];
}

+ (void)POSTWX:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self shareManager] POST:ROOTWX_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
        if (responseCode == 1) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNull class]])
                    {
                        [dicData setObject:@"" forKey:key];
                    }
                }];
                success(operation, [dicData copy]);
            }
            else
            {
                success(operation, data);
            }
        }
        else {
            
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
            failure(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(operation, newError);
    }];
}

+ (void)POSTRed:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self shareManager] POST:[ROOTRED_URL stringByAppendingString:apiStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
        if (responseCode == 1) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNull class]])
                    {
                        [dicData setObject:@"" forKey:key];
                    }
                }];
                success(operation, [dicData copy]);
            }
            else
            {
                success(operation, data);
            }
        }
        else {
            
            success(operation,[responseObject objectForKey:@"message"]);
            
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
            failure(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(operation, newError);
    }];
}

+ (void)POSTDuoBao:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self shareManager] POST:[ROOTDUOBAO_URL stringByAppendingString:apiStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
        if (responseCode == 1) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNull class]])
                    {
                        [dicData setObject:@"" forKey:key];
                    }
                }];
                success(operation, [dicData copy]);
            }
            else
            {
                success(operation, data);
            }
        }
        else {
            
            success(operation,[responseObject objectForKey:@"message"]);
            
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
            failure(operation, error);
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(operation, newError);
    }];
}

+ (void)POSTMiaoSha:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[self shareManager] POST:[ROOTMiaoSha_URL stringByAppendingString:apiStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
        if (responseCode == 1) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSNull class]])
                    {
                        [dicData setObject:@"" forKey:key];
                    }
                }];
                success(operation, [dicData copy]);
            }
            else
            {
                success(operation, data);
            }
        }
        else {
            
            success(operation,[responseObject objectForKey:@"message"]);
            
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
            failure(operation, error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
        failure(operation, newError);
    }];
}

//+ (void)POSTZZS:(NSString *)apiStr parameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    [[self shareManager] POST:[ROOTZZS_URL stringByAppendingString:apiStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSLog(@"JSON: %@", responseObject);
//        
//        NSInteger responseCode = [[responseObject objectForKey:@"success"] integerValue];
//        if (responseCode == 1) {
//            id data = [responseObject objectForKey:@"data"];
//            if ([data isKindOfClass:[NSDictionary class]])
//            {
//                NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:data];
//                [dicData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                    if ([obj isKindOfClass:[NSNull class]])
//                    {
//                        [dicData setObject:@"" forKey:key];
//                    }
//                }];
//                success(operation, [dicData copy]);
//            }
//            else
//            {
//                success(operation, data);
//            }
//        }
//        else {
//            
//            success(operation,[responseObject objectForKey:@"message"]);
//            
//            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"message"] code:responseCode==-1?EMPSNetworkingErrorTypeAccountInvalid:EMPSNetworkingErrorTypeServiceFail userInfo:nil];
//            failure(operation, error);
//        }
//        
//    
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@", error);
//        NSError *newError = [NSError errorWithDomain:@"网络不给力，请稍后再试！" code:EMPSNetworkingErrorTypeNetConnectFail userInfo:nil];
//        failure(operation, newError);
//    }];
//
//}

+ (NSArray *)constructModelsForClass:(Class)aClass withData:(NSArray *)data
{
    NSMutableArray *arModels = [NSMutableArray array];
    for (NSDictionary *itemData in data) {
        YKLBaseModel *model = [[aClass alloc] initWithDictionary:itemData];
        [arModels addObject:model];
    }
    return arModels;
}

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}


@end
