#import <UIKit/UIKit.h>
@class Y_SelectBarView;

typedef enum {
    SelectBarViewTypeDefaul = 0,
} SelectBarViewType;
@protocol Y_SelectBarViewDelegate <NSObject>
- (void)selectBarViewIndexWillChange:(Y_SelectBarView *)selectBarView index:(NSInteger)index;
- (void)selectBarViewIndexDidChange:(Y_SelectBarView *)selectBarView index:(NSInteger)index;
@end

@interface Y_SelectBarView : UIView
@property (nonatomic, weak) id<Y_SelectBarViewDelegate> delegate;
//数据源
@property (nonatomic, strong) NSArray <NSString *> * titleStrArr;
//当使用index操作控件时的动画时长
@property (nonatomic , assign) CGFloat sliderAnimationDuration;


/**
 根据index操作
 */
- (BOOL)handleWithIndex:(NSInteger)index;
/**
 根据外部scrollView操作 这一对方法需要同时实现 否则无法正产使用
 */
- (BOOL)handleWithScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)endHandleWithScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

/**
 只读属性
 */
@property (nonatomic, assign, readonly) NSInteger index;

//Style
@property (nonatomic, assign) SelectBarViewType selectBarViewType;
@property (nonatomic, strong) UIColor * sliderColor;
@property (nonatomic, strong) UIColor * titleColor_Normal;
@property (nonatomic, strong) UIColor * titleColor_Highlighted;
@property (nonatomic, strong) UIColor * titleColor_Selected;
@property (nonatomic, strong) UIColor * titleColor_Disabled;
@end
