//
//  YKLCommentListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/3/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLCommentListModel.h"

@implementation YKLCommentListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.commentID = [dicData objectForKey:@"id"];
    self.nickName = [dicData objectForKey:@"wx_nickname"];
    self.addtime = [[dicData objectForKey:@"comment_addtime"]timeNumber];
    self.content = [dicData objectForKey:@"comment_content"];
    
    return self;
}

@end
