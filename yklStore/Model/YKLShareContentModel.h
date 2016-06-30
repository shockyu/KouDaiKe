//
//  MPSShareContentModel.h
//  MPStore
//
//  Created by apple on 14/10/17.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKLShareContentModel : NSObject

@property (nonatomic, assign) EMPSUserActionType userActionType;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, assign) BOOL shareVisible;

+ (YKLShareContentModel *)defModel;

@end
