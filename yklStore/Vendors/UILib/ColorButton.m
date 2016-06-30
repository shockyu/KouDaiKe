//
//  ColorButton.m
//  MeiPa
//
//  Created by apple on 14/7/13.
//  Copyright (c) 2014年 WJ. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 5;
        self.selectedBgColor = [UIColor darkFgColor];
        self.normalBgColor = [UIColor darkBgColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightBgColor] forState:UIControlStateHighlighted];
        self.highlighted = NO;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    self.backgroundColor = highlighted ? self.selectedBgColor : self.normalBgColor;
}

@end
