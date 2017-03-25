#import "Y_BaseNavigationViewController.h"

@interface Y_BaseNavigationViewController ()<UIGestureRecognizerDelegate>
@end

@implementation Y_BaseNavigationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

/**
 * 滑动退回手势失效解决办法:
 * 在需要手势退回的控制器的viewWillApper中将self.navigationController.interactivePopGestureRecognizer.enabled设置为YES
 * 不需要手势退回和NAV的rootVC中设置为NO
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}
@end
