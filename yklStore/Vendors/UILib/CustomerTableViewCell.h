//
//  CustomerTableViewCell.h
//  MeiPa
//
//  Created by apple on 14/7/12.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropDownSelectButton.h"

@interface CTableViewCellInput : UITableViewCell

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, assign) NSString *placeHolder;

@end

@interface CTableViewCellTitleInput : UITableViewCell

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, assign) NSString *placeHolder;
@property (nonatomic, assign) float sepRate;

@end

@interface CTableViewCellTitleInputWithButton : CTableViewCellTitleInput

@property (nonatomic, strong) UIButton *rightButton;

@end

@interface CTableViewCellTitleSelect : UITableViewCell

@property (nonatomic, strong) CDropDownSelectButton *selectBtn;
@property (nonatomic, assign) float sepRate;

@end

@interface CTableViewCellButton : UITableViewCell

@property (nonatomic, strong) UIButton *button;

@end



