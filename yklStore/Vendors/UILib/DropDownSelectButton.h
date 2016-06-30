//
//  DropDownSelectButton.h
//  etionRichText
//
//  Created by WangJian on 14-5-12.
//
//

#import <UIKit/UIKit.h>

@interface CDropDownSelectButton : UIControl

@property (nonatomic, retain) UIColor *renderingColor;      //default is 0x2083C3
@property (nonatomic, retain) UIColor *selectedColor;       //默认为0xFFFFFF，只用于选中状态下的字符颜色

//@property (nonatomic, retain) UIColor *seperatorColor;      //default is lightGray
@property (nonatomic, retain) NSString *placeHolder;        //default is --请选择--
@property (nonatomic, assign) BOOL hasBorder;               //default is YES

@property (nonatomic, retain) NSArray *arTitles;
@property (nonatomic, assign) NSInteger selectedIndex;      //default is -1, nothing selected

@property (nonatomic, assign) UIView *presentParentView;    //default is nil

- (void)invalidOldPopupView;

@end
