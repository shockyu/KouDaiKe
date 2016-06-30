//
//  YKLCommentListModel.h
//  yklStore
//
//  Created by 肖震宇 on 16/3/26.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLBaseModel.h"

@interface YKLCommentListModel : YKLBaseModel

@property (nonatomic, strong) NSString *commentID;         //评论ID
@property (nonatomic, strong) NSString *nickName;          //微信名
@property (nonatomic, strong) NSString *addtime;           //评论时间
@property (nonatomic, strong) NSString *content;           //评论内容


@end
