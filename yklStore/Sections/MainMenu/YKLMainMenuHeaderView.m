//
//  YKLMainMenuHeaderView.m
//  yklStore
//
//  Created by 肖震宇 on 16/4/15.
//  Copyright © 2016年 XSkyu. All rights reserved.
//

#import "YKLMainMenuHeaderView.h"
#import "MyCPTheme.h"


@implementation YKLMainMenuHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)reloadDataWithExpoArray:(NSMutableArray *)expoArray{
 
    //在已有数据的情况下刷新数据
    if ([_expoArray isEqual: expoArray]) {
        return;
    }
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
//    [expoArray addObject:@"10000000"];
//    [expoArray addObject:@"1009000"];
//    [expoArray addObject:@"100000"];
//    [expoArray addObject:@"5000000"];
    
    _expoArray = expoArray;
    
    dataArray = expoArray;
    
    NSLog(@"%@",_expoArray);
    
    NSArray *array = [_expoArray sortedArrayUsingComparator:cmptr];
    NSString *max = [array lastObject];
    
    arrayCount = (int)array.count;
    MaxData = [max intValue] == 0 ? 1 : [max intValue];
    
    NSLog(@"%d",MaxData);
    
    [self createCorePlotView];
    [self createDataView];
}

- (void)createDataView{
    
    self.dataBgView = [[UIView alloc] initWithFrame:CGRectMake(self.corePlotBgView.right, 0, 85, 86)];
    self.dataBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.dataBgView];
    
    UILabel *exposureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 75, 12)];
    exposureLabel.textAlignment = NSTextAlignmentRight;
    exposureLabel.font = [UIFont systemFontOfSize:12];
    exposureLabel.text = @"访问量";
    [self.dataBgView addSubview:exposureLabel];
    
    UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, exposureLabel.bottom+18, 15, 12)];
    todayLabel.right = exposureLabel.right;
    //    todayLabel.backgroundColor = [UIColor redColor];
    todayLabel.textColor = [UIColor lightGrayColor];
    todayLabel.textAlignment = NSTextAlignmentRight;
    todayLabel.font = [UIFont systemFontOfSize:12];
    todayLabel.text = @"今";
    [self.dataBgView addSubview:todayLabel];
    
    self.todayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, todayLabel.top, 50, 12)];
    self.todayNumLabel.right = todayLabel.left-5;
    //    self.todayNumLabel.backgroundColor = [UIColor flatLightWhiteColor];
    self.todayNumLabel.textColor = [UIColor flatLightRedColor];
    self.todayNumLabel.textAlignment = NSTextAlignmentRight;
    self.todayNumLabel.font = [UIFont systemFontOfSize:12];
    //    self.todayNumLabel.text = @"12332";
    [self.dataBgView addSubview:self.todayNumLabel];
    
    UILabel *totleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, todayLabel.bottom+10, 15, 12)];
    totleLabel.right = exposureLabel.right;
    //    totleLabel.backgroundColor = [UIColor redColor];
    totleLabel.textColor = [UIColor lightGrayColor];
    totleLabel.textAlignment = NSTextAlignmentRight;
    totleLabel.font = [UIFont systemFontOfSize:12];
    totleLabel.text = @"总";
    [self.dataBgView addSubview:totleLabel];
    
    self.totleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, totleLabel.top, 50, 12)];
    self.totleNumLabel.right = totleLabel.left-5;
    //    self.totleNumLabel.backgroundColor = [UIColor flatLightWhiteColor];
    self.totleNumLabel.textColor = [UIColor flatLightRedColor];
    self.totleNumLabel.textAlignment = NSTextAlignmentRight;
    self.totleNumLabel.font = [UIFont systemFontOfSize:12];
    //    self.totleNumLabel.text = @"";
    [self.dataBgView addSubview:self.totleNumLabel];
    
    
}

- (void)createCorePlotView{
    
    self.corePlotBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 86)];
    self.corePlotBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.corePlotBgView];
    
    
    CGRect frame = CGRectMake(0, 0, 220, 86);
    
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    hostView.backgroundColor= [UIColor clearColor];
    [self.corePlotBgView addSubview:hostView];
    
    //标题label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 8, 50, 10)];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"2016年度";
    [self.corePlotBgView addSubview:label];
    
    //月份label
    for (int i = 1; i < 13; i++) {
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(15*i, 75, 10, 10)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor lightGrayColor];
        label.text = [NSString stringWithFormat:@"%d",i];
        [self.corePlotBgView addSubview:label];
    }
    
    //线条
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 3.0f;
    lineStyle.lineColor = [CPTColor redColor];
    
    //在CPTGraph 中画图，这里的 CPTXYGraph 是个曲线图
    //要指定CPTGraphHostingView 的 hostedGraph 属性来关联
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostView.frame];
    hostView.hostedGraph = graph;
    
    //设置画布距离view的边距
    //    graph.paddingLeft = 10.0f;
    //    graph.paddingTop = 10.0f;
    //    graph.paddingRight = 10.0f;
    graph.paddingBottom = 10.5f;
    
    //设置主题
    CPTTheme *theme=[[MyCPTheme alloc]init];
    [graph applyTheme :theme];
    
    
    CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
    scatterPlot.dataLineStyle = lineStyle;
    scatterPlot.dataSource= self;//设定数据源，需应用CPTPlotDataSource 协议
    [graph addPlot:scatterPlot];
    
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    lineStyle.miterLimit=1.0f;
    lineStyle.lineWidth=2.0f;
    lineStyle.lineColor=[CPTColor whiteColor];
    
    CPTXYAxis *x=axisSet.xAxis;
    x.minorTickLineStyle=lineStyle;
    //需要排除的不显示数字的主刻度
    
    //设置y 轴
    CPTXYAxis *y=axisSet.yAxis;
    y.minorTickLineStyle=lineStyle;
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
    numLabel.left = arrayCount*15;
    NSString *numY = [NSString stringWithFormat:@"%.2lf",(1-[[self numberForPlot:scatterPlot field:1 recordIndex:arrayCount-1]floatValue]/MaxData)*47.0-2];//47为统计图高度
    numLabel.top = [[numY getNSRoundPlain:2]floatValue];
    
//    float tempY = [[self numberForPlot:scatterPlot field:1 recordIndex:arrayCount-1]floatValue];
//    
//    if (tempY>MaxData/4*3)
//    {
//        numLabel.top = 0;
//    }
//    else if (tempY>MaxData/2)
//    {
//        numLabel.top = 15;
//    }
//    else if (tempY>MaxData/4)
//    {
//        numLabel.top = 30;
//    }
//    else
//    {
//        numLabel.top = 45;
//    }
    
    numLabel.backgroundColor = [UIColor flatLightRedColor];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:8];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.layer.cornerRadius = 7;
    numLabel.layer.masksToBounds = YES;

    if ([[self numberForPlot:scatterPlot field:1 recordIndex:arrayCount-1]floatValue]>10000) {
        
        numLabel.text = [NSString stringWithFormat:@"%.1f万",[[self numberForPlot:scatterPlot field:1 recordIndex:arrayCount-1]floatValue]/10000];

    }else{
        
        numLabel.text = [NSString stringWithFormat:@"%@",[self numberForPlot:scatterPlot field:1 recordIndex:arrayCount-1]];
    }
 
    [self.corePlotBgView addSubview:numLabel];
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) scatterPlot.plotSpace;
    
    plotSpace.xRange= [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)length:CPTDecimalFromFloat(12)];
    
    //y轴刻度的设置
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(MaxData/10);
    
    plotSpace.yRange= [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)length:CPTDecimalFromFloat(MaxData)];
    
    
}


//询问有多少个数据，在CPTPlotDataSource 中声明的

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    return[dataArray count];
    
}


//询问一个个数据值，在CPTPlotDataSource 中声明的

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    
    if(fieldEnum == CPTScatterPlotFieldY){    //询问Y 值时
        
        return[dataArray objectAtIndex:index];
        
    }else{                                   //询问X 值时
        
        return[NSNumber numberWithInt:(int)index];
        
    }
    
}

@end
