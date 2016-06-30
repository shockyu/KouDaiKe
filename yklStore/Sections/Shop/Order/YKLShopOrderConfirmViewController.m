//
//  YKLShopOrderConfirmViewController.m
//  yklStore
//
//  Created by willbin on 16/5/18.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopOrderConfirmViewController.h"

#import "SZTextView.h"
#import "TPKeyboardAvoidingTableView.h"

#import "YKLShopAddressManageViewController.h"
#import "YKLShopPayViewController.h"

#import "YKLWebViewController.h"

#define kCellDictHeightkey      @"kCellDictHeightkey"
#define kCellDictViewkey        @"kCellDictViewkey"


#define kBottomButtonHeight     46

@interface YKLShopOrderConfirmViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    TPKeyboardAvoidingTableView         *_aTableView;
    NSMutableArray      *_viewDictArr;
    
    NSDictionary        *_addrDict;
    
    float               _currentPrice;
    NSInteger           _currentCount;

    //
    UILabel             *_addrNameLabel;
    UILabel             *_addrPhoneLabel;
    UILabel             *_addrContentLabel;
    
    //
    UILabel             *_goodsCountLabel;
    UILabel             *_hejiLabel;
    
    //
    UITextField         *_countTF;
    
    //
    UILabel             *_danjiaLabel;

    //
    SZTextView          *_msgTV;
    
    //
//    UILabel             *_zongjiLabel;
}
@end

@implementation YKLShopOrderConfirmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _addrDict = [[NSMutableDictionary alloc]init];
    _viewDictArr = [[NSMutableArray alloc] init];
  
    [self prepareData];
    [self createMyViews];
}

- (void)createMyViews
{
    _aTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0,
                                                               ScreenWidth,
                                                               ScreenHeight - kStatusbarHeight - kNavbarHeight - kBottomButtonHeight)
                                              style:UITableViewStylePlain];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    _aTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _aTableView.separatorColor = HEXCOLOR(0xd8d8d8);
    
    _aTableView.sectionHeaderHeight = 0;
    _aTableView.sectionFooterHeight = 10;
    
    _aTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view addSubview:_aTableView];
    
    // bottom
    UIView *aView = [self getBottomBtnView];
    aView.frame = CGRectMake(0, ScreenHeight - kStatusbarHeight - kNavbarHeight - kBottomButtonHeight, ScreenWidth, kBottomButtonHeight);
    [self.view addSubview:aView];
    
    [self refreshViewsForCount];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetWorkingShop getDefaultAddressWithShopID:[YKLLocalUserDefInfo defModel].userID
                                           Success:^(NSDictionary *dict)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([dict isEqual:@[]])
        {
            _addrNameLabel.text = @"收货人:暂未设置";
            _addrNameLabel.textColor = HEXCOLOR(0x999999);
            _addrPhoneLabel.text = @"电话:暂未设置";
            _addrPhoneLabel.textColor = HEXCOLOR(0x999999);
            _addrContentLabel.text = @"收货地址:暂未设置";
            _addrContentLabel.textColor = HEXCOLOR(0x999999);
            
            _addrDict = nil;
        }
        else
        {
            _addrNameLabel.text = [NSString stringWithFormat:@"收货人: %@", [dict objectForKey:@"consignee_name"]];
            _addrPhoneLabel.text =[dict objectForKey:@"consignee_mobile"];
            _addrContentLabel.text = [NSString stringWithFormat:@"收货地址:%@%@%@%@",[dict objectForKey:@"province"],[dict objectForKey:@"city"],[dict objectForKey:@"area"],[dict objectForKey:@"address"]];
            
            _addrDict = dict;
        }
    }
                                           failure:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)prepareData
{
    {
        UIView *aView = [self getAddressView];
        NSDictionary *aDict = @{
                                kCellDictViewkey    : aView,
                                kCellDictHeightkey  : [NSNumber numberWithInteger:aView.height]
                                };
        [_viewDictArr addObject:aDict];
    }
    
    {
        UIView *aView = [self getCenterView];
        NSDictionary *aDict = @{
                                kCellDictViewkey    : aView,
                                kCellDictHeightkey  : [NSNumber numberWithInteger:aView.height]
                                };
        [_viewDictArr addObject:aDict];
    }
    
    {
        UIView *aView = [self getExpressFeeView];
        NSDictionary *aDict = @{
                                kCellDictViewkey    : aView,
                                kCellDictHeightkey  : [NSNumber numberWithInteger:aView.height]
                                };
        [_viewDictArr addObject:aDict];
    }
    
    {
        UIView *aView = [self getBottomView];
        NSDictionary *aDict = @{
                                kCellDictViewkey    : aView,
                                kCellDictHeightkey  : [NSNumber numberWithInteger:aView.height]
                                };
        [_viewDictArr addObject:aDict];
    }
}

- (UIView *)getSeparatorView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 11)];
    aView.backgroundColor = HEXCOLOR(0xeeeeee);
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xd8d8d8);
        [aView addSubview:lineView];
    }
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, aView.height - 0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xd8d8d8);
        [aView addSubview:lineView];
    }
    
    return aView;
}

- (void)confirmBtnClicked
{
//    [self textFieldDidEndEditing:_countTF];
    // 需要判断哪些不为空
//    if (_currentCount == 0)
//    {
//        return;
//    }
    
    NSInteger cCount = [_countTF.text integerValue];
    NSInteger minCout = [_orderDict[@"min_pay_num"] integerValue];
    NSInteger maxCout = [_orderDict[@"max_num"] integerValue];
    if (cCount < minCout)
    {
        [UIAlertView showInfoMsg:[NSString stringWithFormat:@"购买数量最少为%@", _orderDict[@"min_pay_num"]]];
        return;
    }
    if (cCount > maxCout)
    {
        [UIAlertView showInfoMsg:[NSString stringWithFormat:@"购买数量最多为%@", _orderDict[@"max_num"]]];
        return;
    }
    if (!_addrDict)
    {
        [UIAlertView showInfoMsg:[NSString stringWithFormat:@"地址不能为空"]];
        return;
    }
    
    float hejiPrice = _currentPrice * (float)_currentCount;
    float zongjiPrice = hejiPrice;
    NSString *zonjiStr = [NSString stringWithFormat:@"%.02f", zongjiPrice];
    
    NSString *urlStr = ROOTShop_URL;
    NSDictionary *params = @{
                             @"act"           : ORDER_QRZF_ACT,
                             @"API_Token"     : API_Token,
                             
                             @"goods_id"      : _orderDict[@"id"],
                             @"buyer_id"      : [YKLLocalUserDefInfo defModel].userID,
                             @"buyer_name"    : [YKLLocalUserDefInfo defModel].userName,
                             @"order_amount"  : zonjiStr,
                             @"goods_num"     : _countTF.text,
                             @"message"       : _msgTV.text ? _msgTV.text : @"",

                             @"addr_id"      : _addrDict[@"id"],
                             };
    TJRequestManager * manager = [TJRequestManager sharedManagerWithToken];
    [manager POST:urlStr
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *returnDict = (NSDictionary *)responseObject;
         returnDict = [returnDict dictionaryByReplacingNullsWithBlanks];
         BOOL isSuccess = [returnDict[@"success"] boolValue];
         if (isSuccess)
         {
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
             
             YKLShopPayViewController *payVC = [YKLShopPayViewController new];
             payVC.payDict = [responseObject objectForKey:@"data"];
             [self.navigationController pushViewController:payVC animated:YES];
         }
         else
         {
             [UIAlertView showInfoMsg:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

/*
 * 地址按钮点击
 */
- (void)aViewBtnClicked
{
    YKLShopAddressManageViewController *vc = [YKLShopAddressManageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)getBottomBtnView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kBottomButtonHeight)];
    aView.backgroundColor = [UIColor whiteColor];
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xd8d8d8);
        [aView addSubview:lineView];
    }
    
    {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 13, 140, 20)];
        aLabel.textColor = YKLTextColor;
        aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.text = [NSString stringWithFormat:@"总计:"];
        [aView addSubview:aLabel];
    }
    
//    {
//        _zongjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 13, 140, 20)];
//        _zongjiLabel.textColor = YKLRedColor;
//        _zongjiLabel.font = [UIFont systemFontOfSize:13];
//        _zongjiLabel.text = [NSString stringWithFormat:@"¥5000.00"];
//        [aView addSubview:_zongjiLabel];
//    }
    
    {
        UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aBtn.backgroundColor = YKLRedColor;
        aBtn.frame = CGRectMake(0, 0, ScreenWidth, kBottomButtonHeight);
        [aBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [aBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [aView addSubview:aBtn];
    }

    return aView;
}

- (UIView *)getCenterView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];

    NSInteger xPos = 12;
    NSInteger yPos = 10;
    
    UIFont *textFont = [UIFont systemFontOfSize:13];
    
    UIImageView *shopIV = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, 17, 17)];
    shopIV.image = [UIImage imageNamed:@"dingdanguanli_changjia"];
    [aView addSubview:shopIV];
    
    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, yPos, 200, 16)];
    shopNameLabel.textColor = YKLTextColor;
    shopNameLabel.font = textFont;
    shopNameLabel.text = _orderDict[@"supplier"];
    [aView addSubview:shopNameLabel];
    
//    CGSize shopSize = WE_TEXTSIZE(shopNameLabel.text, shopNameLabel.font);
//    UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(shopNameLabel.x + shopSize.width + 3, yPos, 16, 16)];
//    tipIV.image = [UIImage imageNamed:@"dingdanzhongxin_jiantou"];
//    [aView addSubview:tipIV];
    
    UIView *redBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 90)];
    redBGView.backgroundColor = HEXCOLOR(0xffe3e3);
    [aView addSubview:redBGView];
    
    UIImageView *_imageIV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 6, 76, 76)];
    [_imageIV sd_setImageWithURL:[NSURL URLWithString:_orderDict[@"cover_img"]]];
    [redBGView addSubview:_imageIV];
    
    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(X(_imageIV)+WIDTH(_imageIV)+11, Y(_imageIV), 110, 40)];
    _titleLabel.textColor = YKLTextColor;
    _titleLabel.font = textFont;
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = _orderDict[@"goods_name"];
    [redBGView addSubview:_titleLabel];
    
    UILabel *_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-100, Y(_titleLabel), 100, 14)];
    _priceLabel.textColor = YKLRedColor;
    _priceLabel.font = [UIFont systemFontOfSize:12];
    _priceLabel.text = [NSString stringWithFormat:@"原价:¥ %@/%@", _orderDict[@"price"], _orderDict[@"units"]];
    [redBGView addSubview:_priceLabel];
    
    {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x, 60, 150, 15)];
        aLabel.textColor = HEXCOLOR(0x999999);
        aLabel.font = [UIFont systemFontOfSize:11];
        aLabel.text = @"商品规格由厂家智能分配";
        [redBGView addSubview:aLabel];
    }
  
    _goodsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-70, 60, 70, 15)];
    _goodsCountLabel.backgroundColor = [UIColor clearColor];
    _goodsCountLabel.textColor = HEXCOLOR(0x9B9B9B);
    _goodsCountLabel.font = [UIFont systemFontOfSize:12];
    [redBGView addSubview:_goodsCountLabel];
    
    // 合计
    _hejiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, ScreenWidth-10-10, 40)];
    _hejiLabel.textAlignment = NSTextAlignmentRight;
    _hejiLabel.font = textFont;
    [aView addSubview:_hejiLabel];
    
    return aView;
}

- (UIView *)getAddressView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 115)];
    
    NSInteger xPos = 45;
    NSInteger yPos = 15;
    
    UIImageView *shopIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 21, 21)];
    shopIV.image = [UIImage imageNamed:@"querendingdan_ditu"];
    [aView addSubview:shopIV];
    
    {
        _addrNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 140, 15)];
        _addrNameLabel.textColor = YKLTextColor;
        _addrNameLabel.font = [UIFont systemFontOfSize:13];
        _addrNameLabel.text = [NSString stringWithFormat:@"收货人: %@", _addrDict[@"consignee_name"]];
        [aView addSubview:_addrNameLabel];
    }
    
    {
        _addrPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-35-100, yPos, 100, 15)];
        _addrPhoneLabel.textColor = YKLTextColor;
        _addrPhoneLabel.font = [UIFont systemFontOfSize:13];
        _addrPhoneLabel.text = [NSString stringWithFormat:@"%@", _addrDict[@"consignee_mobile"]];
        [aView addSubview:_addrPhoneLabel];
    }
    
    yPos = 45;
    {
        NSString *addrStr = [NSString stringWithFormat:@"收货地址: %@%@%@%@", _addrDict[@"province"], _addrDict[@"city"], _addrDict[@"area"], _addrDict[@"address"]];
        UIFont *aFont = [UIFont systemFontOfSize:13];
        NSInteger aWidth = ScreenWidth-xPos-35;
//        CGSize addrSize = WE_MULTILINE_TEXTSIZE(addrStr, aFont, CGSizeMake(aWidth, 100000), 0);
//        NSInteger aHeight = addrSize.height + 2;
        
        _addrContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, aWidth, 50)];
        _addrContentLabel.textColor = YKLTextColor;
        _addrContentLabel.font = aFont;
        _addrContentLabel.numberOfLines = 3;
        _addrContentLabel.text = addrStr;
        [aView addSubview:_addrContentLabel];
        
        yPos = _addrContentLabel.y + _addrContentLabel.height;
    }
    
    {
        UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-16, (116-16)/2, 16, 16)];
        tipIV.image = [UIImage imageNamed:@"dingdanzhongxin_jiantou"];
        [aView addSubview:tipIV];
    }
    
    {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, aView.height-10, ScreenWidth, 10)];
        redView.backgroundColor = YKLRedColor;
        [aView addSubview:redView];
    }
    
    {
        UIButton *aViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        aViewBtn.frame = aView.frame;
        aViewBtn.backgroundColor = [UIColor clearColor];
        [aViewBtn addTarget:self action:@selector(aViewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:aViewBtn];
    }
    
    return aView;
}

- (UIView *)getExpressFeeView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 20)];
        aLabel.textColor = YKLTextColor;
        aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.text = [NSString stringWithFormat:@"查看运费规则"];
        [aView addSubview:aLabel];
    }
    
    UIImageView *tipIV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-16, (40-16)/2, 16, 16)];
    tipIV.image = [UIImage imageNamed:@"dingdanzhongxin_jiantou"];
    [aView addSubview:tipIV];
    
    return aView;
}

- (UIView *)getBottomView
{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40+40+80)];
    aView.backgroundColor = [UIColor whiteColor];
    
    NSInteger xPos = 10;
    NSInteger yPos = 0;
    
    {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 140, 40)];
        aLabel.textColor = YKLTextColor;
        aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.text = [NSString stringWithFormat:@"购买数量"];
        [aView addSubview:aLabel];
        
        _countTF = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-10-200, yPos, 200, 40)];
        _countTF.delegate = self;
        [_countTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _countTF.keyboardType = UIKeyboardTypeNumberPad;
        _countTF.font = [UIFont systemFontOfSize:13];
        _countTF.returnKeyType = UIReturnKeyDone;
        _countTF.textAlignment = NSTextAlignmentRight;
        _countTF.textColor = [UIColor blackColor];
        _countTF.placeholder = [NSString stringWithFormat:@"%@%@起订, 越多越便宜.", _orderDict[@"min_pay_num"], _orderDict[@"units"]];
        [aView addSubview:_countTF];
        
        yPos = aLabel.y + aLabel.height;
    }
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos+0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xd8d8d8);
        [aView addSubview:lineView];
        
        yPos = lineView.y + lineView.height;
    }
    
    {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 140, 40)];
        aLabel.textColor = YKLTextColor;
        aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.text = [NSString stringWithFormat:@"当前单价"];
        [aView addSubview:aLabel];
        
        _danjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 150, yPos, 150, 40)];
        _danjiaLabel.textAlignment = NSTextAlignmentRight;
        _danjiaLabel.textColor = YKLRedColor;
        _danjiaLabel.font = [UIFont systemFontOfSize:13];
        _danjiaLabel.text = [NSString stringWithFormat:@"¥ %@/%@", _orderDict[@"price"], _orderDict[@"units"]];
        [aView addSubview:_danjiaLabel];
        
        yPos = aLabel.y + aLabel.height;
    }
    
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos+0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = HEXCOLOR(0xd8d8d8);
        [aView addSubview:lineView];
        
        yPos = lineView.y + lineView.height;
    }
    
    {
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, 65, 40)];
        aLabel.textColor = YKLTextColor;
        aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.text = [NSString stringWithFormat:@"买家留言"];
        [aView addSubview:aLabel];
        
        _msgTV = [[SZTextView alloc] initWithFrame:CGRectMake(75, yPos+4, (ScreenWidth - 10 - 75), 80-20)];
        _msgTV.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _msgTV.autocorrectionType = UITextAutocorrectionTypeNo;
        _msgTV.textColor = [UIColor blackColor];
        _msgTV.font = [UIFont systemFontOfSize:13];
        _msgTV.returnKeyType = UIReturnKeyDefault;
        _msgTV.placeholder = @"填写您对商品的特殊要求";
        [aView addSubview:_msgTV];

        yPos = aLabel.y + aLabel.height;
    }
    
    return aView;
}

#pragma mark - UITableViewDataSourceDelegate & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return _viewDictArr.count;
 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger aHeight = 0;
    
    NSDictionary *aDict = _viewDictArr[indexPath.section];
    aHeight = [aDict[kCellDictHeightkey] integerValue];

    return aHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 去旧
    UIView *aView = [cell.contentView viewWithTag:9898];
    [aView removeFromSuperview];
    aView = nil;
  
    NSDictionary *aDict = _viewDictArr[indexPath.section];
    aView = aDict[kCellDictViewkey];
    aView.tag = 9898;
    [cell.contentView addSubview:aView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2)
    {
        NSString *idStr = _orderDict[@"id"];
        NSString *urlStr = [NSString stringWithFormat:@"http://ykl.meipa.net/admin.php/bargain/lc_yf/goods_id/%@.html", idStr];
        YKLWebViewController *ctl = [[YKLWebViewController alloc] init];
        ctl.lcUrl = urlStr;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#pragma mark - 

- (void)refreshViewsForCount
{
    NSInteger aCount = [_countTF.text integerValue];
    NSArray *priceArr = _orderDict[@"goods_price"];
    for (int i = 0; i < priceArr.count; i ++)
    {
        NSDictionary *aDict = priceArr[i];

        NSInteger aMinCout = [aDict[@"min_num"] integerValue];
        NSInteger aMaxCout = [aDict[@"max_num"] integerValue];
        
        if (aCount >= aMinCout && aCount <= aMaxCout)
        {
            _currentPrice = [aDict[@"price"] floatValue];
        }
    }
    _danjiaLabel.text = [NSString stringWithFormat:@"¥ %.02f/%@", _currentPrice, _orderDict[@"units"]];
    _goodsCountLabel.text = [NSString stringWithFormat:@"X%ld", (long)aCount];

    _currentCount = aCount;
    
    float hejiPrice = _currentPrice * (float)_currentCount;
    
    NSString *allStr = [NSString stringWithFormat:@"合计: ¥ %.02f (不含运费)", hejiPrice];
    NSString *priceStr = [NSString stringWithFormat:@"¥ %.02f", hejiPrice];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSRange priceRange = [allStr rangeOfString:priceStr];
   
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:HEXCOLOR(0x999999)
                    range:[allStr rangeOfString:allStr]];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:YKLRedColor
                    range:priceRange];
    _hejiLabel.attributedText = attrStr;
}

#pragma mark - UITextField delegate

- (void)textFieldDidChange:(UITextField*)textField
{
    [self refreshViewsForCount];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSInteger minCout = [_orderDict[@"min_pay_num"] integerValue];
    NSInteger maxCout = [_orderDict[@"max_num"] integerValue];
    if ([_countTF.text integerValue] < minCout)
    {
        _countTF.text = [NSString stringWithFormat:@"%d", minCout];
    }
    if ([_countTF.text integerValue] > maxCout)
    {
        _countTF.text = [NSString stringWithFormat:@"%d", maxCout];
    }
    
    [self refreshViewsForCount];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

@end
