//
//  YKLHighGoActivityListDetailTableView.m
//  yklStore
//
//  Created by 肖震宇 on 15/12/4.
//  Copyright (c) 2015年 XSkyu. All rights reserved.
//

#import "YKLHighGoActivityListDetailTableView.h"

@implementation YKLHighGoActivityListDetailTableView

- (instancetype)initWithFrame:(CGRect)frame ActID:(NSString *)actID{
    if (self = [super initWithFrame:frame]) {
        
        self.actID = actID;
        
        self.tableView = [[MUILoadMoreTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.frame = CGRectMake(0, 0, self.width, self.height);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor flatLightGrayColor];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView registerClass:[YKLHighGoActivityListDetailTableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.activityList = [NSMutableArray array];
        [self requestMoreOrder];
        
    }
    return self;
}

- (NSArray *)indexPathsWithStart:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *arIndex = [NSMutableArray array];
    for (NSInteger i=start; i<end; i++) {
        [arIndex addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return [arIndex copy];
}

- (void)requestMoreOrder {
    self.page += 1;
    if (self.page == 1) {
        NSLog(@"进行中分类");
    }
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.userInteractionEnabled = YES;
    [self.tableView startLoad];
    switch (self.type) {
        case 0:
            [self getActivitylist:@"1"];
            break;
        case 1:
            [self getActivitylist:@"2"];
            break;
        case 2:
            [self getActivitylist:@"3"];
            break;
        default:
            break;
    }
}

- (void)getActivitylist:(NSString *)status{
    
    [self.activityList removeAllObjects];
    [self.tableView reloadData];
    [self.tableView startLoad];
    
    [YKLNetworkingHighGo getActListWithActID:self.actID Success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        
        self.activityList = [dict objectForKey:@"goods"];
        if ( self.activityList.count == 0) {
            self.tableView.loadMoreEnable = NO;
            
        }
        
        [self.tableView insertRowsAtIndexPaths:[self indexPathsWithStart:0 end:self.activityList.count] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endLoad];
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        self.userInteractionEnabled = YES;
        [UIAlertView showErrorMsg:error.domain];

        
    }];
    
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.activityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 可重用标示符
    static NSString *ID = @"Cell";

    // 让表格缓冲区查找可重用cell
    YKLHighGoActivityListDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 如果没有找到可重用cell
    if (cell == nil) {
        // 实例化cell
        cell = [[YKLHighGoActivityListDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *goodsDic = self.activityList[indexPath.row];
    
    NSArray *imageArr = [goodsDic objectForKey:@"goods_img"];
    if (![imageArr isEqual: @[]]) {
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"Demo"]];
    }
    cell.descLabel.text = [[goodsDic objectForKey:@"goods_name"] isEqual:[NSNull null]]? @"暂无": [goodsDic objectForKey:@"goods_name"];
    
    int totalNum = [[goodsDic objectForKey:@"count_need"] intValue];
    
    int isUserNum;
    if ([[goodsDic objectForKey:@"join_num"] isEqual:[NSNull null]]) {
        
        isUserNum = 0;
       
    }else{
        
        isUserNum = [[goodsDic objectForKey:@"join_num"]intValue];
    }
   
    int remainNum = totalNum - isUserNum;
    NSString *status = [goodsDic objectForKey:@"goods_status"];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共需%d人次",totalNum]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:@"共需"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range1];
    NSRange range2=[[hintString string]rangeOfString:@"人次"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2];
    cell.totalLabel.attributedText=hintString;
    
    NSMutableAttributedString *hintString2=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已参与%d人次",isUserNum]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range2_1=[[hintString2 string]rangeOfString:@"已参与"];
    [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_1];
    NSRange range2_2=[[hintString2 string]rangeOfString:@"人次"];
    [hintString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range2_2];
    cell.isUserLabel.attributedText= hintString2;
    
    NSMutableAttributedString *hintString3=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还剩%d人次",remainNum]];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range3_1=[[hintString3 string]rangeOfString:@"还剩"];
    [hintString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3_1];
    NSRange range3_2=[[hintString3 string]rangeOfString:@"人次"];
    [hintString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range3_2];
    cell.remainLabel.attributedText= hintString3;

    
    if ([status isEqualToString:@"0"]) {
        
        cell.isSuccessLabel.text = @"进行中";
        cell.isExchangeLabel.hidden = YES;
        cell.winnnerNameLabel.hidden = YES;
        cell.winnnerMobLabel.hidden = YES;
        
    }
    if ([status isEqualToString:@"1"]) {
        
        if ([goodsDic objectForKey:@"winner_mobile"]) {
            
            cell.isExchangeLabel.hidden = NO;
            cell.winnnerNameLabel.hidden = NO;
            cell.winnnerMobLabel.hidden = NO;
            
            cell.isSuccessLabel.text = @"已成功";
            cell.isSuccessLabel.textColor = [UIColor flatLightRedColor];
            cell.winnnerNameLabel.textColor = [UIColor flatLightRedColor];
            cell.winnnerNameLabel.text = [NSString stringWithFormat:@"中奖人:%@",[goodsDic objectForKey:@"winner_nickname"]];
            cell.winnnerMobLabel.text = [goodsDic objectForKey:@"winner_mobile"];
            
            //0.未兑换 1.已兑换
            if ([[goodsDic objectForKey:@"coupon_status"] isEqual:@"1"]) {
                cell.isExchangeLabel.text = @"已兑换";
            }
            else if ([[goodsDic objectForKey:@"coupon_status"] isEqual:@"0"]){
                cell.isExchangeLabel.text = @"未兑换";
            }
            
        }else{
            
            cell.isSuccessLabel.text = @"未成功";
            cell.isExchangeLabel.hidden = YES;
            cell.winnnerMobLabel.hidden = YES;
            
            cell.isSuccessLabel.textColor = [UIColor lightGrayColor];
            cell.winnnerNameLabel.text = @"未凑够指定人数";
            cell.winnnerNameLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    if ([status isEqualToString:@"2"]) {
        
        cell.isSuccessLabel.text = @"未成功";
        cell.isExchangeLabel.hidden = YES;
        cell.winnnerMobLabel.hidden = YES;
        
        cell.isSuccessLabel.textColor = [UIColor lightGrayColor];
        cell.winnnerNameLabel.text = @"未凑够指定人数";
        cell.winnnerNameLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    NSLog(@"xxx%ld",(long)indexPath.row);
//    NSLog(@"%@",self.activityList[indexPath.row]);
    
    NSDictionary *dict = self.activityList[indexPath.row];
    NSString *goodID = [dict objectForKey:@"id"];
    
    [self.delegate showUserListDetailView:self didSelectOrder:goodID];

    
//    NSString *status = [dict objectForKey:@"goods_status"];
//    
//    if ([status isEqualToString:@"1"]) {
//        
//        if ([dict objectForKey:@"winner_mobile"]) {
//            
//            [self.delegate showUserListDetailView:self didSelectOrder:goodID];
//            
//        }else{
//            
//        }
//    }
}

- (void)tableViewNeedLoadMore:(MUILoadMoreTableView *)tableView {
    [self requestMoreOrder];
}

@end
