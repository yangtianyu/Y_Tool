#import "Y_Button.h"

@interface Y_Button ()
@property (nonatomic , copy) callBack callBack;
@end

@implementation Y_Button
+ (instancetype)buttonWithCallBack:(callBack)callBack{
    Y_Button * button = [Y_Button buttonWithType:UIButtonTypeCustom];
    [button addTarget:button action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    button.callBack = callBack;
    return button;
}
- (void)btnClickAction:(Y_Button *)sender{
    self.callBack(sender);
}
@end
