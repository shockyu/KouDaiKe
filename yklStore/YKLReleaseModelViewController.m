//
//  YKLReleaseModelViewController.m
//  yklStore
//
//  Created by 肖震宇 on 15/9/23.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLReleaseModelViewController.h"
#import "YKLReleaseModelTableViewCell.h"

@interface YKLReleaseModelViewController ()

@end

@implementation YKLReleaseModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模板选择";
    
    self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 64, self.view.width, self.view.height-64);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor flatLightGrayColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView registerClass:[YKLReleaseModelTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.orders = [NSMutableArray array];
    [self checkVoucherList:YES];

}

- (NSArray *)indexPathsWithStart:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *arIndex = [NSMutableArray array];
    for (NSInteger i=start; i<end; i++) {
        [arIndex addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return [arIndex copy];
}

- (void)checkVoucherList:(BOOL)hasProgress{

    if (hasProgress) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.tableView startLoad];
    }

    [YKLNetworkingConsumer getTemplateWithType:self.type Success:^(NSArray *templateModel) {
        if (templateModel.count == 0) {
            self.tableView.loadMoreEnable = NO;
        }
        [self.orders addObjectsFromArray:templateModel];
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:self.orders.count-templateModel.count end:self.orders.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (hasProgress) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
        }
        else {
            [self.tableView endLoad];
        }

    } failure:^(NSError *error) {
        [UIAlertView showInfoMsg:error.domain];
        if (hasProgress) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
        }
        else {
            [self.tableView endLoad];
        }
    }];
   
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return 188-35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"CellT";
    YKLReleaseModelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YKLReleaseModelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.orders.count){
        YKLTemplateModel *model = self.orders[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"标题：%@",model.templateName];
        cell.priceNubLabel.text = [NSString stringWithFormat:@"¥%@", model.templateMoney];
        cell.explainMoreLabel.text = model.templateDesc;
        
        UIImage *image = [UIImage imageWithContentsOfFile:[YKLTemplateModel imagePathWithUrl:model.templateThumb]];
        if (image == nil) {
            [model downloadImageForUrl:model.templateThumb];
        }
        else {
            cell.avatarImageView.image = [UIImage imageFromImage:image size:cell.avatarImageView.size fillStyle:EImageFillStyleStretchByXCenterScale];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row: %ld, Section: %ld", (long)indexPath.row, (long)indexPath.section);
    
    if (indexPath.row==0 && indexPath.section==0) {
        NSLog(@"大刀鬼子");
        self.modelImage=[UIImage imageNamed:@"选中"];

        
    }else if (indexPath.row==1 && indexPath.section==0){
        NSLog(@"默认");
        self.modelImage=[UIImage imageNamed:@"未选中"];

    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    
}

@end
