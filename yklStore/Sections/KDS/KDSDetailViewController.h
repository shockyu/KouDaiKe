//
//  KDSDetailViewController.h
//  yklStore
//
//  Created by willbin on 16/4/28.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface KDSCommentCell : UITableViewCell
{
    UIImageView     *_leftIV;
    UILabel         *_nameLabel;
    UILabel         *_dateLabel;
    UILabel         *_contentLabel;
    UILabel         *_fromLabel;
    
    UIImageView     *_lineView;
}
@property (nonatomic, strong) NSDictionary          *cellDict;

- (void)showSubViews;
- (NSInteger)getCellHeight;

@end

@interface KDSDetailViewController : YKLUserBaseViewController
{
    NSMutableArray              *_kDSDetailDicArr;
    NSDictionary                *_kDSDetaiDic;
}

@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *shopIdStr;

@end
