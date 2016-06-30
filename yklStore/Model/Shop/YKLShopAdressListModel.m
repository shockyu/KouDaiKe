//
//  YKLShopAdressListModel.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/12.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopAdressListModel.h"

@implementation YKLShopAdressListModel

- (instancetype)updateWithDictionary:(NSDictionary *)dicData {
    [super updateWithDictionary:dicData];
    
    self.addressID = [dicData objectForKey:@"id"];
    self.shopID = [dicData objectForKey:@"shop_id"];
    self.province = [dicData objectForKey:@"province"];
    self.city = [dicData objectForKey:@"city"];
    self.area = [dicData objectForKey:@"area"];
    self.address = [dicData objectForKey:@"address"];
    
    self.isDefault = [dicData objectForKey:@"is_default"];
    self.addTime = [dicData objectForKey:@"add_time"];
    self.consigneeName = [dicData objectForKey:@"consignee_name"];
    self.consigneeMobile = [dicData objectForKey:@"consignee_mobile"];
    
    return self;
}

@end
