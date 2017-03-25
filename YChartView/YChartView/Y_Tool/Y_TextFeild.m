#import "Y_TextFeild.h"
#import "Y_Define.h"
#import "UIView+Y.h"

@interface Y_TextFeild ()

@end

@implementation Y_TextFeild
//canPerformAction
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initContentView];
}
- (void)initContentView{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, Y_ScreenWidth, 44)];
    toolbar.barStyle = UIBarStyleDefault;
    UIView * separateView = [[UIView alloc] initWithFrame:CGRectMake(0, toolbar.height - 0.25, toolbar.width, 0.25)];
    separateView.backgroundColor = Y_LightGrayColor;
    [toolbar addSubview:separateView];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    toolbar.items = @[item0, item1, item2];
    self.inputAccessoryView=toolbar;
}
- (void)click{
    [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder{
    return [super resignFirstResponder];
}
@end
