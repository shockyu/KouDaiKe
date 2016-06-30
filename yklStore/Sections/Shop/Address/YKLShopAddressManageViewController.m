//
//  YKLShopAddressManageViewController.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/10.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLShopAddressManageViewController.h"
#import "MUILoadMoreTableView.h"
#import "YKLShopNewAddressViewController.h"

@interface YKLAddressListCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation YKLAddressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell点击后的颜色设置
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 130)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, self.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:lineView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 195, 40)];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textColor = [UIColor grayColor];
        [bgView addSubview:self.nameLabel];
        
        self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-24-100, 0, 100, 40)];
        self.mobileLabel.font = [UIFont systemFontOfSize:12];
        self.mobileLabel.textColor = [UIColor grayColor];
        self.mobileLabel.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:self.mobileLabel];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, self.mobileLabel.bottom, self.width-24, 35)];
        self.addressLabel.font = [UIFont systemFontOfSize:13];
        self.addressLabel.textColor = [UIColor grayColor];
        [self.addressLabel setNumberOfLines:0];
        [bgView addSubview:self.addressLabel];

        self.statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statusBtn.frame = CGRectMake(0,lineView.bottom, 140, 45);
        //        [self.statusBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview: self.statusBtn];
        
        //dizhiguanli_queren
        self.statusImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dizhiguanli_daixuan"]];
        self.statusImageView.frame = CGRectMake(12, 11.5, 22, 22);
        [self.statusBtn addSubview:self.statusImageView];
        
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.statusImageView.right+5,0,60,45)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = @"默认地址";
        statusLabel.textColor = [UIColor grayColor];
        statusLabel.font = [UIFont systemFontOfSize:12];
        statusLabel.backgroundColor = [UIColor clearColor];
        [self.statusBtn addSubview:statusLabel];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.frame = CGRectMake(self.width-135,lineView.bottom, 70, 45);
        //        [self.editBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview: self.editBtn];
        
        UIImageView *editImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dizhiguanli_bianji"]];
        editImageView.frame = CGRectMake(0, 11.5, 22, 22);
        [self.editBtn addSubview:editImageView];
        
        UILabel *editLabel = [[UILabel alloc]initWithFrame:CGRectMake(editImageView.right+5,0,60,45)];
        editLabel.text = @"编辑";
        editLabel.textColor = [UIColor grayColor];
        editLabel.font = [UIFont systemFontOfSize:12];
        editLabel.backgroundColor = [UIColor clearColor];
        [self.editBtn addSubview:editLabel];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(self.editBtn.right,lineView.bottom, 65, 45);
        //        [self.deleteBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview: self.deleteBtn];
        
        UIImageView *deleteImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dizhiguanli_shanchu"]];
        deleteImageView.frame = CGRectMake(0, 11.5, 22, 22);
        [self.deleteBtn addSubview:deleteImageView];
        
        UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(deleteImageView.right+5,0,60,45)];
        deleteLabel.text = @"删除";
        deleteLabel.textColor = [UIColor grayColor];
        deleteLabel.font = [UIFont systemFontOfSize:12];
        deleteLabel.backgroundColor = [UIColor clearColor];
        [self.deleteBtn addSubview:deleteLabel];

        self.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

@end

@interface YKLShopAddressManageViewController ()<UITableViewDataSource, MUILoadMoreTableViewDelegate>

@property (nonatomic, strong) YKLShopAdressListModel *shopListModel;
@property (nonatomic, strong) MUILoadMoreTableView *tableView;
@property (nonatomic, strong) NSMutableArray *records;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger selectTag;

@property (nonatomic, strong) UIView *actingNoneView;
@end

@implementation YKLShopAddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地址管理";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:CGRectMake(0, 65, self.view.width, self.view.height-65-50) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YKLAddressListCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
    UIButton *addAdressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAdressBtn.backgroundColor = [UIColor flatLightRedColor];
    addAdressBtn.frame = CGRectMake(0 ,self.view.height-50,self.view.width,50);
    [addAdressBtn addTarget:self action:@selector(addAdressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: addAdressBtn];
    
    
    UIImageView *addAdressBtnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(addAdressBtn.width/2-50, 0, 20, 20)];
    addAdressBtnImageView.image = [UIImage imageNamed:@"dizhiguanli_tianjia@2x"];
    addAdressBtnImageView.centerY = 25;
    [addAdressBtn addSubview:addAdressBtnImageView];
    
    UILabel *addAdressBtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(addAdressBtnImageView.right+5, 0, 90, 50)];
    addAdressBtnLabel.font = [UIFont systemFontOfSize:16];
    addAdressBtnLabel.textColor = [UIColor whiteColor];
    addAdressBtnLabel.text = @"添加新地址";
    [addAdressBtn addSubview:addAdressBtnLabel];
    
    self.records = [NSMutableArray array];
    [self createBgNoneView];//创建没用数据背景
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _selectTag = 0;
    [self requestMoreProduct];
    
}

- (NSArray *)indexPathsWithStart:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *arIndex = [NSMutableArray array];
    for (NSInteger i=start; i<end; i++) {
        [arIndex addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return [arIndex copy];
}

- (void)requestMoreProduct {
    self.page += 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    [self.records removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    [YKLNetWorkingShop getAddressWithShopID:[YKLLocalUserDefInfo defModel].userID Success:^(NSArray *shopList) {
        
        if (shopList.count == 0) {
            
            self.actingNoneView.hidden = NO;
            self.tableView.loadMoreEnable = NO;
            
        }else{
            
            self.actingNoneView.hidden = YES;

        }
        
        [self.records addObjectsFromArray:shopList];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.records.count-shopList.count end:self.records.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endLoad];
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        [self.tableView endLoad];
        
    }];
}

#pragma mark - table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKLAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    self.shopListModel = self.records[indexPath.row];
    
    cell.nameLabel.text = self.shopListModel.consigneeName;
    cell.mobileLabel.text = self.shopListModel.consigneeMobile;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.shopListModel.province,self.shopListModel.city,self.shopListModel.area,self.shopListModel.address];
    
    int addressID = [self.shopListModel.addressID intValue];
    [cell.statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.statusBtn.tag = addressID;
    
    [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row;
    
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = addressID;
    
    if ([self.shopListModel.isDefault isEqual:@"1"]) {
         cell.statusImageView.image = [UIImage imageNamed:@"dizhiguanli_queren"];
    }
    else{
        cell.statusImageView.image = [UIImage imageNamed:@"dizhiguanli_daixuan"];
    }
    
    cell.statusImageView.tag = addressID;
    if (_selectTag) {
        
        if (cell.statusImageView.tag == _selectTag) {
            cell.statusImageView.image = [UIImage imageNamed:@"dizhiguanli_queren"];
        }
        else{
            cell.statusImageView.image = [UIImage imageNamed:@"dizhiguanli_daixuan"];
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}


#pragma mark - 按钮点击方法

- (void)addAdressBtnClicked{

    YKLShopNewAddressViewController *vc = [YKLShopNewAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)statusBtnClick:(UIButton *)sender{
    NSLog(@"默认地址ID：%ld",(long)sender.tag);
    _selectTag = sender.tag;
    
    [self.tableView reloadData];
    
    NSString *addressID = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    [YKLNetWorkingShop saveAddressWithAdressID:addressID ShopID:[YKLLocalUserDefInfo defModel].userID IsDefault:@"1" Success:^(NSDictionary *dict) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    

        [self.navigationController popViewControllerAnimated:YES];
    
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [UIAlertView showErrorMsg:error.domain];
    }];
    
}

- (void)editBtnClick:(UIButton *)sender{
    
    NSLog(@"%ld",(long)sender.tag);
    
    YKLShopNewAddressViewController *vc = [YKLShopNewAddressViewController new];
    vc.addressListModel = self.records[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteBtnClick:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"是否确认删除该地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: @"取消",nil];
    alertView.tag = sender.tag;
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [YKLNetWorkingShop deleteAddressWithAdressID:[NSString stringWithFormat:@"%ld",(long)alertView.tag] Success:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [UIAlertView showInfoMsg:@"地址删除成功"];
            
            _selectTag = 0;
            //刷新地址列表网络数据
            [self requestMoreProduct];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [UIAlertView showErrorMsg:error.domain];
        }];
    }
}

- (void)createBgNoneView{
    
    self.actingNoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 255,  225)];
    self.actingNoneView.centerX = self.view.width/2;
    self.actingNoneView.backgroundColor = [UIColor clearColor];
    self.actingNoneView.hidden = YES;
    [self.tableView addSubview:self.actingNoneView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"暂无数据"]];
    imageView.frame = CGRectMake(0, 0, 255, 225);
    [self.actingNoneView addSubview:imageView];
    
}


@end
