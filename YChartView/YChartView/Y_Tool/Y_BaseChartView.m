#import "Y_BaseChartView.h"
#import "Y_Define.h"
#import "UIView+Y.h"
@interface Y_BaseChartView ()

@end

@implementation Y_BaseChartView
/**
 获得一个绘图部分常用的动画对象
 */
+ (CAAnimation *)getAnimationWithKeyPath:(NSString *)keyPath
                               fromValue:(id)fromValue
                                 toValue:(id)toValue
                                duration:(CFTimeInterval)duration
{
    (!keyPath) && (keyPath = @"strokeEnd");
    (!fromValue) && (fromValue = @0);
    (!toValue) && (toValue = @1);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount=1;
    return animation;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRect:context lineWidth:0 lineColor:nil fillColor:self.backgroundColor radius:0 rect:self.bounds];
}
/**
 绘制一条实线
 */
- (void)drawLine:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth
{
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextSetLineDash(context, 0, nil, 0);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}

/**
 动画绘制一条实线
 */
- (void)drawLineWithAnimation:(CAAnimation *)animation
                   startPoint:(CGPoint)startPoint
                    stopPoint:(CGPoint)stopPoint
                        color:(UIColor *)color
                    lineWidth:(CGFloat)lineWidth
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:stopPoint];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:shapeLayer];
    if (animation) {
        [shapeLayer addAnimation:animation forKey:nil];
    }
}

/**
 绘制一条虚线
 */
- (void)drawDottedLine:(CGContextRef)context
            startPoint:(CGPoint)startPoint
             stopPoint:(CGPoint)stopPoint
                 color:(UIColor *)color
             lineWidth:(CGFloat)lineWitdth
{
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    //数组每个元素表示相应位置的“线”或“空”的长度
    CGFloat arr[] = {4,3};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(context, 0, arr, 2);
    CGContextStrokePath(context);
}

/**
 绘制一段文字
 @param offSet          边框缩进系数 这个参数还没调好
 */
- (void)drawLabel:(CGContextRef)context
       textString:(NSString *)string
             font:(CGFloat)font
            color:(UIColor *)color
  backgroundColor:(UIColor *)backgroundColor
           offSet:(CGFloat)offSet
             rect:(CGRect)rect
{
    NSDictionary * drawAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSForegroundColorAttributeName:color};
    CGRect textR = [string boundingRectWithSize     :CGSizeMake(rect.size.width, rect.size.height)
                                        options     :NSStringDrawingUsesLineFragmentOrigin
                                        attributes  :drawAttributes
                                        context     :nil
                    ];
    NSAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:drawAttributes];
    CGContextSetLineDash(context,0,NULL,0);
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGRect r = CGRectMake(x - offSet * 0.5, y - offSet * 0.4, width + offSet, height+offSet * 0.8);
    [self drawRect:context lineWidth:1 lineColor:backgroundColor fillColor:backgroundColor radius:0 rect:r];
    [attributedString drawInRect:CGRectMake(rect.origin.x, rect.origin.y, textR.size.width, textR.size.height)];
}

/**
 绘制一个有圆角有填充颜色的矩形
 */
- (void)drawRect:(CGContextRef)context
       lineWidth:(CGFloat)lineWidth
       lineColor:(UIColor*)lineColor
       fillColor:(UIColor *)fillColor
          radius:(CGFloat)radius
            rect:(CGRect)rect
{
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineDash(context,0,NULL,0);
    if (radius != 0) {
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;;
        (isnan(rect.size.height)) && (height = 0);
        CGFloat x = rect.origin.x;
        CGFloat y = rect.origin.y;
        CGContextMoveToPoint(context, x+radius, y);
        CGContextAddLineToPoint(context, x+width-radius, y);
        CGContextAddArcToPoint(context, x+width, y, x+width, y+radius, radius);
        CGContextAddLineToPoint(context, x+width, y+height-radius);
        CGContextAddArcToPoint(context, x+width, y+height, x+width-radius, y+height, radius);
        CGContextAddLineToPoint(context, x+radius, y+height);
        CGContextAddArcToPoint(context, x, y+height, x, y+height-radius, radius);
        CGContextAddLineToPoint(context, x, y+radius);
        CGContextAddArcToPoint(context, x, y, x+radius, y, radius);
    }else{
        CGContextAddRect(context, rect);
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke|kCGPathFill|kCGPathStroke);
}

/**
 填充渐变颜色
 */
- (void)drawFillColor:(CGContextRef)context
                 path:(CGPathRef)path
                alpha:(CGFloat)alpha
           startColor:(UIColor *)startColor
             endColor:(UIColor *)endColor

{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    //这里可以根据需求实现 横向 纵向 斜向 三种填充方式
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, alpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextClosePath(context);
}

/**
 绘制一个扇形
 */
- (void)drawArc:(CGContextRef)context
         center:(CGPoint)center
         radius:(CGFloat)radius
     startAngle:(CGFloat)startAngle
       endAngle:(CGFloat)endAngle
          color:(UIColor *)color
      clockwise:(BOOL)clockwise
{
    CGContextSetLineWidth(context, 1);
    CGContextSetLineDash(context,0,NULL,0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, center.x, center.y);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, !clockwise);
    CGContextDrawPath(context, kCGPathFillStroke|kCGPathFill|kCGPathStroke);
}

/**
 动画绘制一个扇形
 */
- (void)drawArcWithAnimation:(CAAnimation *)animation
                      center:(CGPoint)center
                      radius:(CGFloat)radius
                  startAngle:(CGFloat)startAngle
                    endAngle:(CGFloat)endAngle
                       color:(UIColor *)color
                   clockwise:(BOOL)clockwise
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius * 0.5 startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = radius;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = Y_ClearColor.CGColor;
    shapeLayer.path = path.CGPath;
    if (animation) {
        [shapeLayer addAnimation:animation forKey:nil];
    }
    [self.layer addSublayer:shapeLayer];
}
@end
