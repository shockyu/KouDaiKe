//
//  YKLShopOrderConfirmViewController.h
//  yklStore
//
//  Created by willbin on 16/5/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLUserBaseViewController.h"

/*
{
    "add_time" = 1462949782;
    "category_id" = 2;
    "cover_img" = "http://img4.youxiake.com/ps/2014/12/cover/20ad54675376560adc5bad5277477d4b.jpg";
    desc = "\U9633\U5149\Uff0c\U5fae\U98ce\U3002\U7a7a\U6c14\U91cc\U6d41\U52a8\U7740\U6696\U610f\Uff0c\U5168\U662f\U6e29\U6696\U7684\U6c14\U606f\U3002";
    "end_time" = 1462949342;
    "goods_name" = "\U60c5\U4fa3\U62d6\U978b";
    "goods_price" =     (
                         {
                             "goods_id" = 2;
                             id = 1;
                             "max_num" = 500;
                             "min_num" = 200;
                             price = "9.90";
                         },
                         {
                             "goods_id" = 2;
                             id = 2;
                             "max_num" = 800;
                             "min_num" = 501;
                             price = "8.80";
                         },
                         {
                             "goods_id" = 2;
                             id = 3;
                             "max_num" = 5000;
                             "min_num" = 801;
                             price = "7.70";
                         }
                         );
    id = 2;
    "max_num" = 5000;
    "min_pay_num" = 200;
    "original_price" = "19.00";
    price = "9.90";
    status = 1;
    "str_price" = "200\U8d77\U8ba2\Uff0c\U8d8a\U591a\U8d8a\U4fbf\U5b9c";
    supplier = "\U4e49\U4e4c\U5c0f\U5546\U54c1\U96c6\U56e2";
    type = 2;
    units = "\U53cc";
}

*/

@interface YKLShopOrderConfirmViewController : YKLUserBaseViewController

//@property (nonatomic, strong) NSString *orderIDStr;
@property (nonatomic, strong) NSDictionary *orderDict;
@property (nonatomic, strong) NSDictionary *addrDict;

@end
