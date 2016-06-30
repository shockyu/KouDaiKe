//
//  YKLShopOrderListViewController.h
//  yklStore
//
//  Created by willbin on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

typedef NS_ENUM(NSInteger, YKLShopOrderStateType) {
    YKLShopOrderStateTypeCancelled  = 0,
    YKLShopOrderStateTypeUnpay      = 10,
    YKLShopOrderStateTypePayed      = 20,
    YKLShopOrderStateTypeDilevered  = 30,
    YKLShopOrderStateTypeReceived   = 40,
    
    YKLShopOrderStateTypeRefund     = 999,
};

/*
 上架帐号：13787416332
 @“29”
 验证码：0000

 */

#pragma mark - OrderListCell

@protocol OrderListCellDelegate;

@interface OrderListCell : UITableViewCell
{
    UILabel     *_shopNameLabel;
    UILabel     *_lcStatusLabel;
    UILabel     *_sumPriceLabel;
    
    UIButton    *_leftBtn;
    UIButton    *_rightBtn;
    
}
@property (nonatomic, assign) id<OrderListCellDelegate> cellDelegate;

@property (nonatomic, strong) UIImageView *imageIV;//图片
@property (nonatomic, strong) UILabel  *titleLabel;//标题
@property (nonatomic, strong) UILabel  *priceLabel;//单价
@property (nonatomic, strong) UIButton *infoBtn;//详情
@property (nonatomic, strong) UILabel  *goodsNumLabel;//库存

@property (nonatomic, strong) NSDictionary *cellDict;

- (void)showSubViewsWithType:(YKLShopOrderStateType)aType;

@end

@protocol OrderListCellDelegate <NSObject>

@optional

- (void)OrderListCell:(OrderListCell *)cell didBtnClickedForDetailWithDict:(NSDictionary *)cellDict;
- (void)OrderListCell:(OrderListCell *)cell didBtnClickedForLJFKWithDict:(NSDictionary *)cellDict;
- (void)OrderListCell:(OrderListCell *)cell didBtnClickedForQRSHWithDict:(NSDictionary *)cellDict;

@end


#pragma mark - YKLShopOrderListViewController

@interface YKLShopOrderListViewController : YKLUserBaseViewController<UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate, OrderListCellDelegate>

@property (nonatomic, assign) YKLShopOrderStateType orderType;

@end
