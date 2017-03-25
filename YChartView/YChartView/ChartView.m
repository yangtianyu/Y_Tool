//
//  ChartView.m
//  YChartView
//
//  Created by Main on 2017/3/26.
//  Copyright © 2017年 Main. All rights reserved.
//

#import "ChartView.h"
#import "Y_Tools.h"

@implementation ChartView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //常用的两个动画绘制
    self.layer.sublayers = nil;
    CAAnimation * animation = [Y_BaseChartView getAnimationWithKeyPath:nil fromValue:nil toValue:nil duration:4];
    [self drawLineWithAnimation:animation startPoint:CGPointMake(0, 50) stopPoint:CGPointMake(300, 50) color:Y_BlueColor lineWidth:5];
    [self drawArcWithAnimation:animation center:CGPointMake(300, 50) radius:20 startAngle:M_PI_2 endAngle:M_PI * 1.5 color:Y_OrangeColor clockwise:false];
    
    //一些常用的基础绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawLine:context startPoint:CGPointMake(0, 100) stopPoint:CGPointMake(300, 100) color:Y_BlueColor lineWidth:5];
    [self drawArc:context center:CGPointMake(300, 100) radius:20 startAngle:M_PI_2 endAngle:M_PI * 1.5 color:Y_OrangeColor clockwise:false];
    [self drawDottedLine:context startPoint:CGPointMake(0, 150) stopPoint:CGPointMake(300, 150) color:Y_BlueColor lineWidth:2];
    [self drawRect:context lineWidth:5 lineColor:Y_BlueColor fillColor:Y_YellowColor radius:25 rect:CGRectMake(50, 200, 200, 50)];
    [self drawRect:context lineWidth:5 lineColor:Y_BlueColor fillColor:Y_YellowColor radius:0 rect:CGRectMake(260, 200, 50, 50)];
    
    [self drawLine:context startPoint:CGPointMake(0, 275) stopPoint:CGPointMake(1000, 275) color:Y_BlueColor lineWidth:2];
    //由于文字的对齐模式计算起来很烦，对于文字的绘制其实是比较困难的，大多数情况下Lab要比绘制要好用
    [self drawLabel:context textString:@"我是一条分割线" font:14 color:Y_RedColor backgroundColor:Y_BlueColor offSet:0 rect:CGRectMake(100, 265, 200, 20)];
    
    //填充渐变色时，需要捕捉闭合的Path 当path开放会漏出来
    CGMutablePathRef fillPath = CGPathCreateMutable();
    CGRect rect1 = CGRectMake(50, 300, 200, 50);
    CGRect rect2 = CGRectMake(260, 300, 50, 50);
    CGRect rects[] = {rect1, rect2};
    [self drawRect:context lineWidth:5 lineColor:Y_BlueColor fillColor:Y_YellowColor radius:0 rect:rect1];
    [self drawRect:context lineWidth:5 lineColor:Y_BlueColor fillColor:Y_YellowColor radius:0 rect:rect2];
    CGPathAddRects(fillPath, NULL, (const CGRect *)rects, 2);
    [self drawFillColor:context path:fillPath alpha:0.8 startColor:Y_RedColor endColor:Y_YellowColor];
    CGPathRelease(fillPath);
    
    //这种渐变填充往往发生在折线图中，这里做一个简单的例子
    NSInteger totalCount = 100;
    NSInteger MAXValue = 1000;
    NSMutableArray * arrM = @[].mutableCopy;
    for (NSInteger i = 0; i < totalCount; i++) {
        NSInteger number = arc4random() % MAXValue;
        [arrM addObject:@(number)];
    }
    CGFloat YaxisH = 200;
    CGFloat XaxisX = 50;
    CGFloat XaxisY = 360 + YaxisH;
    CGFloat XaxisW = 300;
    CGPoint axisStartP = CGPointMake(XaxisX, XaxisY);
    CGPoint XaxisEndP = CGPointMake(XaxisX + XaxisW, XaxisY);
    CGPoint YaxisEndP = CGPointMake(XaxisX, XaxisY - YaxisH);
    [self drawLine:context startPoint:axisStartP stopPoint:XaxisEndP color:Y_BlackColor lineWidth:1];
    [self drawLine:context startPoint:axisStartP stopPoint:YaxisEndP color:Y_BlackColor lineWidth:1];
    
    CGFloat cellW = XaxisW / totalCount;
    CGFloat scale = YaxisH / MAXValue;
    CGFloat value1 = 0;
    CGFloat value2 = 0;
    CGFloat p1x = 0;
    CGFloat p2x = 0;
    CGFloat p1y = 0;
    CGFloat p2y = 0;
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    //准备捕捉path
    fillPath = CGPathCreateMutable();
    CGPathMoveToPoint(fillPath, NULL, axisStartP.x, axisStartP.y);
    for (NSInteger i = 0; i < arrM.count - 1; i++) {
        value1 = [arrM[i] floatValue];
        value2 = [arrM[i + 1] floatValue];
        p1x = XaxisX + cellW * i;
        p2x = XaxisX + cellW * (i + 1);
        p1y = XaxisY - value1 * scale;
        p2y = XaxisY - value2 * scale;
        p1 = CGPointMake(p1x, p1y);
        p2 = CGPointMake(p2x, p2y);
        [self drawLine:context startPoint:p1 stopPoint:p2 color:Y_BlackColor lineWidth:1];
        //开始捕捉path
        if(i == arrM.count - 1 - 1){
            CGPathAddLineToPoint(fillPath, NULL, p1x, p1y);
            CGPathAddLineToPoint(fillPath, NULL, p2x, p2y);
            CGPathAddLineToPoint(fillPath, NULL, XaxisEndP.x, XaxisEndP.y);
            CGPathCloseSubpath(fillPath);
        }else{
            CGPathAddLineToPoint(fillPath, NULL, p1x, p1y);
        }
    }
    //填充之后释放 不是OC没人帮你管内存
    [self drawFillColor:context path:fillPath alpha:0.8 startColor:Y_YellowColor endColor:Y_BlueColor];
    CGPathRelease(fillPath);
}
@end
