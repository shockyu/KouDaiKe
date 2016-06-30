//
//  MyCPTheme.m
//  yklStore
//
//  Created by 肖震宇 on 16/5/4.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "MyCPTheme.h"

@implementation MyCPTheme

//1、首先我们来为背景设置一个自定义颜色渐变：
/*
- (void)applyThemeToBackground:(CPTGraph *)graph
{
    // 终点色： 20 ％的灰度
    CPTColor *endColor = [CPTColor colorWithGenericGray:0.2f ];
    // 创建一个渐变区：起点、终点都是 0.2 的灰度
    CPTGradient *graphGradient = [CPTGradient gradientWithBeginningColor:endColor endingColor:endColor];
    // 设置中间渐变色 1 ，位置在 30 ％处，颜色为 3 0 ％的灰
    graphGradient = [graphGradient addColorStop :[CPTColor colorWithGenericGray : 0.3f ] atPosition : 0.3f ];
    // 设置中间渐变色 2 ，位置在 50 ％处，颜色为 5 0 ％的灰
    graphGradient = [graphGradient addColorStop :[CPTColor colorWithGenericGray : 0.5f ] atPosition : 0.5f ];
    // 设置中间渐变色 3 ，位置在 60 ％处，颜色为 3 0 ％的灰
    graphGradient = [graphGradient addColorStop :[CPTColor colorWithGenericGray : 0.3f ] atPosition : 0.6f ];
    // 渐变角度：垂直 90 度（逆时针）
    graphGradient. angle = 90.0f ;
    // 渐变填充
    graph. fill = [CPTFill fillWithGradient :graphGradient];
}
*/


//2、在坐标轴上画上网格线：
// 在 Y 轴上添加平行线

- (void)applyThemeToAxisSet:(CPTXYAxisSet *)axisSet {
    
    // 设置网格线线型
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.5f;
    majorGridLineStyle.lineColor = [CPTColor colorWithComponentRed:238.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];//[CPTColor colorWithGenericGray:0.2f]
    
    CPTXYAxis *axis = axisSet.xAxis;
    // 轴标签方向： CPSignNone －无，同 CPSignNegative ， CPSignPositive －反向 , 在 y 轴的右边， CPSignNegative －正向，在 y 轴的左边
    axis.tickDirection = CPTSignNegative;
    // 设置平行线，默认是以大刻度线为平行线位置
    axis.majorGridLineStyle = majorGridLineStyle;

}


//3、设置绘图区
//
//下面的代码在绘图区（PlotArea）填充一个灰色渐变。注意由于绘图区（PlotArea）位于背景图（Graph）的上层（参考 Core Plot 框架的类层次图 ），因此对于绘图区所做的设置会覆盖对 Graph 所做的设置，除非你故意在 Graph 的 4 边留白，否则看不到背景图的设置。

/*
- (void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame
{
    // 创建一个 20 ％ -50 ％的灰色渐变区，用于设置绘图区。
    CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithGenericGray:0.2f ] endingColor:[CPTColor colorWithGenericGray:0.7f]];
    gradient.angle = 45.0f ;
    // 渐变填充
    plotAreaFrame.fill = [CPTFill fillWithGradient :gradient];
    
}
 */
@end
