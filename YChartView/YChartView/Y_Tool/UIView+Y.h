#import <UIKit/UIKit.h>

@interface UIView (UIView)
@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
/**
 最右边的子控件
 */
@property (nonatomic, strong, readonly) UIView *Y_lastSubviewOnX;
/**
 最下边的子控件
 */
@property (nonatomic, strong, readonly) UIView *Y_lastSubviewOnY;
/**
 移除此view上的所有子视图
 */
- (void)Y_removeAllSubviews;
/**
 获得当前视图的控制器
 */
- (UIViewController *)Y_getCurrentViewController;

/**
 展示一个textView到window顶部 用以真机debug时使用
 */
+ (void)Y_showTestTextView:(NSString *)textStr;

@end
