//
//  YKLAddChildUserNumViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/6/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLAddChildUserNumViewController.h"

@interface YKLAddChildUserNumViewController ()
{
    UIView *_bgView1;
    UIView *_bgView2;
    
    //子账号个数
    int _childUserNum;
    
    int _minNum_1;
    int _maxNum_1;
    int _money_1;
    
    int _minNum_2;
    int _maxNum_2;
    int _money_2;
    
    int _minNum_3;
    int _maxNum_3;
    int _money_3;
}
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel *childUserNumLabel;
@property (nonatomic, strong) UILabel *childUserMoneyLabel;


@property (nonatomic, strong) UILabel *minMaxNumLabel_1;
@property (nonatomic, strong) UILabel *moneyLabel_1;

@property (nonatomic, strong) UILabel *minMaxNumLabel_2;
@property (nonatomic, strong) UILabel *moneyLabel_2;


@property (nonatomic, strong) UILabel *minMaxNumLabel_3;
@property (nonatomic, strong) UILabel *moneyLabel_3;



@property (nonatomic, strong) YKLChildAccountPriceModel *priceModel;
@property (nonatomic, strong) NSArray *priceArray;

@end

@implementation YKLAddChildUserNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加分店";
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YKLNetworkingConsumer getChildAccountPriceSuccess:^(NSArray *list) {
        
        for (int i = 0 ; i < list.count; i++) {
            
            _priceModel = list[i];
            
            switch (i) {
                case 0:
                    _minNum_1 = [_priceModel.minNum intValue];
                    _maxNum_1 = [_priceModel.maxNum intValue];
                    _money_1 = [_priceModel.price intValue];
                    break;
                case 1:
                    _minNum_2 = [_priceModel.minNum intValue];
                    _maxNum_2 = [_priceModel.maxNum intValue];
                    _money_2 = [_priceModel.price intValue];
                    break;
                case 2:
                    _minNum_3 = [_priceModel.minNum intValue];
                    _maxNum_3 = [_priceModel.maxNum intValue];
                    _money_3 = [_priceModel.price intValue];
                    break;
                    
                default:
                    break;
            }
        }
        
        [self createBgView];
        [self createContent];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
    
}

- (void)createBgView{
 
    _bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64+10, self.view.width, 77)];
    _bgView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView1];
    
    _bgView2 = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView1.bottom+5, self.view.width, 105)];
    _bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView2];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake( 35, self.view.height-20-40, self.view.width-70, 40);
    sureButton.backgroundColor = [UIColor flatLightBlueColor];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    [self.view addSubview:sureButton];
    
    
}

- (void)createContent{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 12)];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"选择你要添加的门店数量";
    [_bgView1 addSubview:titleLabel];
    

    self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusBtn setImage:[UIImage imageNamed:@"minusBtn"] forState:UIControlStateNormal];
    self.minusBtn.frame = CGRectMake(10,titleLabel.bottom+16,21,21);
    [self.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView1 addSubview: self.minusBtn];
    
    self.childUserNumLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.minusBtn.right, self.minusBtn.top,60, 21)];
    self.childUserNumLabel.font = [UIFont systemFontOfSize: 14.0];
    self.childUserNumLabel.textColor = [UIColor flatLightRedColor];
    self.childUserNumLabel.text = [NSString stringWithFormat:@"%d",_minNum_1];
    self.childUserNumLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView1 addSubview:self.childUserNumLabel];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"addBtn"] forState:UIControlStateNormal];
    self.addBtn.frame = CGRectMake(self.childUserNumLabel.right,self.minusBtn.top,21,21);
    [self.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView1 addSubview: self.addBtn];
    
    
    self.childUserMoneyLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, self.minusBtn.top, 150, 21)];
    self.childUserMoneyLabel.right = self.view.width-20;
    self.childUserMoneyLabel.font = [UIFont systemFontOfSize: 18.0];
    self.childUserMoneyLabel.textColor = [UIColor flatLightRedColor];
    self.childUserMoneyLabel.text = [NSString stringWithFormat:@"¥%d",_minNum_1 * _money_1];
    self.childUserMoneyLabel.textAlignment = NSTextAlignmentRight;
    [_bgView1 addSubview:self.childUserMoneyLabel];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 12)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"收费标准";
    [_bgView2 addSubview:titleLabel];
    
    _minMaxNumLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.bottom+15, 175, 12)];
    _minMaxNumLabel_1.font = [UIFont systemFontOfSize:12];
    _minMaxNumLabel_1.text = [NSString stringWithFormat:@"%d~%d家门店",_minNum_1,_maxNum_1];
    [_bgView2 addSubview:_minMaxNumLabel_1];
    
    _moneyLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(_minMaxNumLabel_1.right, _minMaxNumLabel_1.top, 100, 12)];
    _moneyLabel_1.font = [UIFont systemFontOfSize:12];
    _moneyLabel_1.textColor = [UIColor flatLightRedColor];
    _moneyLabel_1.text = [NSString stringWithFormat:@"¥ %d/家",_money_1];
    [_bgView2 addSubview:_moneyLabel_1];
    
    _minMaxNumLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, _minMaxNumLabel_1.bottom+10, 175, 12)];
    _minMaxNumLabel_2.font = [UIFont systemFontOfSize:12];
    _minMaxNumLabel_2.text = [NSString stringWithFormat:@"%d~%d家门店",_minNum_2,_maxNum_2];
    [_bgView2 addSubview:_minMaxNumLabel_2];
    
    _moneyLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(_minMaxNumLabel_2.right, _minMaxNumLabel_2.top, 100, 12)];
    _moneyLabel_2.font = [UIFont systemFontOfSize:12];
    _moneyLabel_2.textColor = [UIColor flatLightRedColor];
    _moneyLabel_2.text = [NSString stringWithFormat:@"¥ %d/家",_money_2];
    [_bgView2 addSubview:_moneyLabel_2];
    
    _minMaxNumLabel_3 = [[UILabel alloc]initWithFrame:CGRectMake(10, _minMaxNumLabel_2.bottom+10, 175, 12)];
    _minMaxNumLabel_3.font = [UIFont systemFontOfSize:12];
    _minMaxNumLabel_3.text = [NSString stringWithFormat:@"%d~%d家门店",_minNum_3,_maxNum_3];
    [_bgView2 addSubview:_minMaxNumLabel_3];
    
    _moneyLabel_3 = [[UILabel alloc]initWithFrame:CGRectMake(_minMaxNumLabel_3.right, _minMaxNumLabel_3.top, 100, 12)];
    _moneyLabel_3.font = [UIFont systemFontOfSize:12];
    _moneyLabel_3.textColor = [UIColor flatLightRedColor];
    _moneyLabel_3.text = [NSString stringWithFormat:@"¥ %d/家",_money_3];
    [_bgView2 addSubview:_moneyLabel_3];


}

- (void)minusBtnClick:(id)sender{
    //NSLog(@"————————————————————————");
    
    if (_childUserNum>1) {
        
        _childUserNum -= 1;
        
        self.childUserNumLabel.text = [NSString stringWithFormat:@"%d",_childUserNum];

    }
    
    [self getChildUserMoney];
}

- (void)addBtnClick:(id)sender{
    //NSLog(@"++++++++++++++++++++++++");
    
    _childUserNum += 1;
    
    self.childUserNumLabel.text = [NSString stringWithFormat:@"%d",_childUserNum];
    
    [self getChildUserMoney];
}

//计算子账号价格
- (void)getChildUserMoney{
    
    if (_childUserNum > _minNum_1-1 && _childUserNum < _maxNum_1+1) {
        
        self.childUserMoneyLabel.text = [NSString stringWithFormat:@"¥%d",_childUserNum * _money_1];
    }
    else if (_childUserNum > _minNum_2-1 && _childUserNum < _maxNum_2+1) {
        
        self.childUserMoneyLabel.text = [NSString stringWithFormat:@"¥%d",_childUserNum * _money_2];
    }
    else if (_childUserNum > _minNum_3-1) {//&& _childUserNum < _maxNum_3+1
        
        self.childUserMoneyLabel.text = [NSString stringWithFormat:@"¥%d",_childUserNum * _money_3];
    }
}

- (void)sureButtonClicked{
    
    YKLPayViewController *vc = [YKLPayViewController new];
    vc.orderStatus = 12;

    NSString *str = [self.childUserMoneyLabel.text substringFromIndex:1];
    vc.totleMoneyNum = [str floatValue];
    
    vc.childNum = [self.childUserNumLabel.text intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
