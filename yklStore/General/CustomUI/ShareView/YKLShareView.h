//
//  MPSShareView.h
//  MPStore
//
//  Created by apple on 14/9/19.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EMPSShareType) {
//    EMPSShareTypePreview,       //预览
    EMPSShareTypeWeiXin,        //微信
    EMPSShareTypeFriendCircle,  //朋友圈
    EMPSShareTypeCopy           //拷贝链接
};

@class YKLShareView;
@protocol YKLShareViewDelegate <NSObject>

- (void)shareViewDidCancelShare;
- (void)shareViewDidClickItemType:(EMPSShareType)type;

@end

@interface YKLShareView : UIView

- (instancetype)initWithFrame:(CGRect)frame types:(NSArray *)types;

@property (nonatomic, weak) id<YKLShareViewDelegate> delegate;

@end
