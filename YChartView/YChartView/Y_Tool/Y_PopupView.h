#import <UIKit/UIKit.h>

typedef void(^clickActionBlock)(NSString * title);
typedef void(^hideActionBlock)();
@interface Y_PopupView : UIView
+ (instancetype)popupViewImgArr:(NSArray <NSString *>*)imgArr
                       TitleArr:(NSArray <NSString *>*)titleArr
                      TextColor:(UIColor *)textColor
                      CancelBtn:(BOOL)isShowCancelBtn
                  ClickCallBack:(clickActionBlock)clickActionBlock
                  HidedCallBack:(hideActionBlock)hideActionBlock;
/**
 传入需要展示的View
 */
- (void)show:(UIView *)currentView;
/**
 隐藏方法,允许主动调用
 */
- (void)hide;
@end

//@interface Y_PopupViewCellModel : NSObject
//@property (nonatomic , strong) NSString * titleStr;
//@property (nonatomic , strong) NSString * imgStr;
//@property (nonatomic , strong) UIColor * textColor;
//
//@end
//
//@interface Y_PopupViewCell : UIView
//@property (nonatomic , strong) Y_PopupViewCellModel * model;
//@end
