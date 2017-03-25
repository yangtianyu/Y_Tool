#import <UIKit/UIKit.h>

/**
 这是一个用于绘图的基类
 动画绘制图形不要在ViewDidLoad中进行
 */
@interface Y_BaseChartView : UIView
/**
 获得一个绘图部分常用的动画对象
 */
+ (CAAnimation *)getAnimationWithKeyPath:(NSString *)keyPath
                               fromValue:(id)fromValue
                                 toValue:(id)toValue
                                duration:(CFTimeInterval)duration;

/**
 绘制一条直线
 */
- (void)drawLine:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth;
/**
 动画绘制一条实线
 */
- (void)drawLineWithAnimation:(CAAnimation *)animation
                   startPoint:(CGPoint)startPoint
                    stopPoint:(CGPoint)stopPoint
                        color:(UIColor *)color
                    lineWidth:(CGFloat)lineWitdth;
/**
 绘制一条虚线
 */
- (void)drawDottedLine:(CGContextRef)context
            startPoint:(CGPoint)startPoint
             stopPoint:(CGPoint)stopPoint
                 color:(UIColor *)color
             lineWidth:(CGFloat)lineWitdth;

/**
 绘制一段文字
 */
- (void)drawLabel:(CGContextRef)context
       textString:(NSString *)string
             font:(CGFloat)font
            color:(UIColor *)color
  backgroundColor:(UIColor *)backgroundColor
           offSet:(CGFloat)offSet
             rect:(CGRect)rect;
/**
 填充一个渐变的颜色
 */
- (void)drawFillColor:(CGContextRef)context
                 path:(CGPathRef)path
                alpha:(CGFloat)alpha
           startColor:(UIColor *)startColor
             endColor:(UIColor *)endColor;
/**
 绘制一个有圆角有填充颜色的矩形
 */
- (void)drawRect:(CGContextRef)context
       lineWidth:(CGFloat)lineWidth
       lineColor:(UIColor*)lineColor
       fillColor:(UIColor *)fillColor
          radius:(CGFloat)radius
            rect:(CGRect)rect;

/**
 绘制一个扇形
 */
- (void)drawArc:(CGContextRef)context
         center:(CGPoint)center
         radius:(CGFloat)radius
     startAngle:(CGFloat)startAngle
       endAngle:(CGFloat)endAngle
          color:(UIColor *)color
      clockwise:(BOOL)clockwise;

/**
 动画绘制一个扇形
 */
- (void)drawArcWithAnimation:(CAAnimation *)animation
                      center:(CGPoint)center
                      radius:(CGFloat)radius
                  startAngle:(CGFloat)startAngle
                    endAngle:(CGFloat)endAngle
                       color:(UIColor *)color
                   clockwise:(BOOL)clockwise;

@end
