//
//  CustomerTableViewCell.m
//  MeiPa
//
//  Created by apple on 14/7/12.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "CustomerTableViewCell.h"

#define MARGIN_HORIZONTAL 15

@implementation CTableViewCellInput

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"inputFieldBackground"] resizeableCenterImage]];
        
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.inputTextField.textColor = [UIColor whiteColor];
        self.inputTextField.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:self.inputTextField];
        
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.7]}];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    float startX = MARGIN_HORIZONTAL;
    if (self.imageView != nil) {
        startX = self.imageView.right + MARGIN_HORIZONTAL;
    }
    self.inputTextField.frame = CGRectMake(startX, 10, self.contentView.width-startX-MARGIN_HORIZONTAL, self.contentView.height-20);
    self.backgroundView.frame = CGRectInset(self.bounds, 0, 10);
}


@end


@implementation CTableViewCellTitleInput
{
    UIImageView *sepView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.sepRate = 3.8;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        
        sepView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSepLine"]];
        [self.contentView addSubview:sepView];
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.inputTextField.textColor = [UIColor midnightTextColor];
        self.inputTextField.font = [UIFont systemFontOfSize:14];
        self.inputTextField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.inputTextField];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor midnightTextColor];
        self.textLabel.layer.borderWidth = 0;
        
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setInputTextField:(UITextField *)inputTextField
{
    inputTextField.frame = _inputTextField.frame;
    [_inputTextField removeFromSuperview];
    _inputTextField = inputTextField;
    [self.contentView addSubview:inputTextField];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    sepView.frame = CGRectMake(self.contentView.width/self.sepRate, (self.contentView.height-sepView.height)/2, sepView.width, sepView.height);
    self.textLabel.width = sepView.left-self.textLabel.left-5;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.inputTextField.frame = CGRectMake(sepView.right+5, 0, self.contentView.width-sepView.right-5-MARGIN_HORIZONTAL, self.contentView.height);
}

@end


@implementation CTableViewCellTitleInputWithButton

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, self.height)];
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.rightButton setBackgroundColor:[UIColor flatPinkColor]];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.rightButton.frame = CGRectMake(self.contentView.width-self.rightButton.width, 0, self.rightButton.width, self.contentView.height);
    self.inputTextField.width -= self.rightButton.width;
}

@end



@implementation CTableViewCellTitleSelect
{
    UIImageView *sepView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.sepRate = 2.8;
        sepView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSepLine"]];
        sepView.frame = CGRectMake(self.contentView.width/self.sepRate, (self.contentView.height-sepView.height)/2, sepView.width, sepView.height);
        [self.contentView addSubview:sepView];
        self.selectBtn = [[CDropDownSelectButton alloc] initWithFrame:CGRectMake(sepView.right+5, 0, self.contentView.width-sepView.right-5-MARGIN_HORIZONTAL, self.contentView.height)];
        self.selectBtn.hasBorder = NO;
        self.selectBtn.renderingColor = [UIColor midnightTextColor];
        [self.contentView addSubview:self.selectBtn];
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor midnightTextColor];
        self.textLabel.layer.borderWidth = 0;
        
        //        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    sepView.frame = CGRectMake(self.contentView.width/self.sepRate, (self.contentView.height-sepView.height)/2, sepView.width, sepView.height);
    self.textLabel.width = sepView.left-self.textLabel.left-5;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.selectBtn.frame = CGRectMake(sepView.right+5, 0, self.contentView.width-sepView.right-5-MARGIN_HORIZONTAL, self.contentView.height);
}

@end



@implementation CTableViewCellButton

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width-30, self.height)];
        [self.button setTitle:@"确   定" forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor flatPinkColor]];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.layer.cornerRadius = 5;
        self.button.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.frame = CGRectInset(self.contentView.bounds, 15, 0);
}

@end





