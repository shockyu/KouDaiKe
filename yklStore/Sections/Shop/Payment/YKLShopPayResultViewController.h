//
//  YKLShopPayResultViewController.h
//  yklStore
//
//  Created by 肖震宇 on 16/5/12.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

@interface YKLShopPayResultViewController : YKLUserBaseViewController

/** 支付情况：1.成功 2.失败 */
@property NSInteger type;

/** 支付订字典 */
@property (nonatomic,strong) NSMutableDictionary *payDict;

@end
