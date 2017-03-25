#import "Y_SelectBarView.h"
#import "Y_Define.h"
#import "Y_Button.h"
#import "UIView+Y.h"

#define CellRow                     1
#define SliderViewHeight            3
#define SliderViewWidthRate         0.618

@interface Y_SelectBarView (){
    NSInteger   cellCount;
    CGFloat     cellWidth;
    CGFloat     cellHeight;
}
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) NSArray <UIView *> * cellArr;
@property (nonatomic, strong) NSArray <UIButton *> * selectBtnArr;
//滑块View
@property (nonatomic, strong) UIView * sliderView;
@end

@implementation Y_SelectBarView

#pragma mark -
#pragma mark ============== ViewLifecycle ==============
- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}
- (void)initContentView{
}
- (void)setupSelectBarView{
}
#pragma mark -
#pragma mark ============== Request ==============

#pragma mark -
#pragma mark ============== UpdateUI ==============
- (void)updateUIWithIndexSucceed:(void(^)())succeed{
    __weak typeof(self) weakSelf = self;
    if ([self.delegate respondsToSelector:@selector(selectBarViewIndexWillChange:index:)]) {
        [self.delegate selectBarViewIndexWillChange:self index:self.index];
    }
    UIButton * selectedBtn = self.selectBtnArr[self.index];
    [self animation:^{
        for (UIButton * selectBtn in weakSelf.selectBtnArr) {
            selectBtn.selected = false;
        }
        selectedBtn.selected = true;
        weakSelf.sliderView.centerX = selectedBtn.superview.centerX;
    } completion:^{
        !succeed ? : succeed();
        if ([weakSelf.delegate respondsToSelector:@selector(selectBarViewIndexDidChange:index:)]) {
            [weakSelf.delegate selectBarViewIndexDidChange:weakSelf index:weakSelf.index];
        }
    }];
}

#pragma mark -
#pragma mark ============== Event ==============

#pragma mark -
#pragma mark ============== InterTool ==============
- (void)animation:(void (^)())animations completion:(void (^)())completion{
    [UIView animateWithDuration:self.sliderAnimationDuration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        !animations ? : animations();
    } completion:^(BOOL finished) {
        !completion ? : completion();
    }];
}
#pragma mark -
#pragma mark ============== API ==============
- (BOOL)handleWithIndex:(NSInteger)index{
    if (index >= cellCount || index < 0) {
        return NO;
    }
    _index = index;
    [self updateUIWithIndexSucceed:nil];
    return YES;
}
- (BOOL)handleWithScrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(selectBarViewIndexWillChange:index:)]) {
        [self.delegate selectBarViewIndexWillChange:self index:self.index];
    }
    CGFloat outerXOffset = scrollView.contentOffset.x;
    CGFloat totaleRate = scrollView.contentSize.width / scrollView.width;
    CGFloat outerRate = outerXOffset / scrollView.width;
    CGFloat innerRate = outerRate / totaleRate;
    self.sliderView.x = innerRate * self.contentScrollView.contentSize.width + HALF((1 - SliderViewWidthRate) * cellWidth);
    return YES;
}
- (void)endHandleWithScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat outerXOffset = scrollView.contentOffset.x;
    NSInteger outerIndex = (NSInteger)(outerXOffset + 0.5) / (NSInteger)scrollView.width;
    _index = outerIndex;
    UIButton * selectedBtn = self.selectBtnArr[self.index];
    for (UIButton * selectBtn in self.selectBtnArr) {
        selectBtn.selected = false;
    }
    selectedBtn.selected = true;
    self.sliderView.centerX = selectedBtn.superview.centerX;
    if ([self.delegate respondsToSelector:@selector(selectBarViewIndexDidChange:index:)]) {
        [self.delegate selectBarViewIndexDidChange:self index:self.index];
    }
}

#pragma mark -
#pragma mark ============== Notify&CallBack ==============

#pragma mark -
#pragma mark ============== Getting&Setting ==============
- (void)setSliderColor:(UIColor *)sliderColor{
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = sliderColor;
}
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentScrollView.backgroundColor = Y_ClearColor;
    }
    return _contentScrollView;
}
- (UIView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UIView alloc] initWithFrame:CGRectZero];
        if (!self.sliderColor) {
            self.sliderColor = Y_RedColor;
        }
        self.sliderAnimationDuration = 0.5;
        _sliderView.backgroundColor = self.sliderColor;
    }
    return _sliderView;
}
- (NSArray *)cellArr{
    if (!_cellArr) {
        _cellArr = @[];
    }
    return _cellArr;
}
- (NSArray *)selectBtnArr{
    if (!_selectBtnArr) {
        _selectBtnArr = @[];
    }
    return _selectBtnArr;
}
- (void)setTitleStrArr:(NSArray<NSString *> *)titleStrArr{
    _titleStrArr = titleStrArr;
    cellCount = titleStrArr.count;
    if (cellCount == 0) {
        return;
    }
    //初始化常量
    cellWidth = self.width / cellCount;
    cellHeight = self.height;
    CGFloat cellX = 0;
    CGFloat cellY = 0;
    NSString * str = @"";
    [self Y_removeAllSubviews];
    
    [self addSubview:self.contentScrollView];
    self.contentScrollView.frame = self.bounds;
    self.contentScrollView.contentSize = self.contentScrollView.frame.size;
    __weak typeof(self) weakSelf = self;
    NSMutableArray * tempCellArrM = @[].mutableCopy;
    NSMutableArray * tempSelectbtnArrM = @[].mutableCopy;
    for (NSInteger i = 0; i < cellCount; i ++) {
        cellX = i * cellWidth;
        str = titleStrArr[i];
        UIView * cell = [[UIView alloc] initWithFrame:CGRectMake(cellX, cellY, cellWidth, cellHeight)];
        [self.contentScrollView addSubview:cell];
        [tempCellArrM addObject:cell];
        Y_Button * selectBtn = [Y_Button buttonWithCallBack:^(Y_Button *sender) {
            _index = sender.tag;
            [weakSelf updateUIWithIndexSucceed:nil];
        }];
        selectBtn.tag = i;
        [selectBtn setTitle:str forState:0];
        [cell addSubview:selectBtn];
        [tempSelectbtnArrM addObject:selectBtn];
        selectBtn.frame = cell.bounds;
        [selectBtn setTitleColor:self.titleColor_Normal ? : Y_DarkTextColor forState:UIControlStateNormal];
        [selectBtn setTitleColor:self.titleColor_Highlighted ? : nil forState:UIControlStateHighlighted];
        [selectBtn setTitleColor:self.titleColor_Disabled ? : nil forState:UIControlStateDisabled];
        [selectBtn setTitleColor:self.titleColor_Selected ? : Y_LightGrayColor forState:UIControlStateSelected];
    }
    self.cellArr = tempCellArrM.copy;
    self.selectBtnArr = tempSelectbtnArrM.copy;
    [self.contentScrollView addSubview:self.sliderView];
    self.sliderView.frame = CGRectMake(0, self.height - SliderViewHeight, cellWidth * SliderViewWidthRate, SliderViewHeight);
    self.sliderView.layer.masksToBounds = YES;
    self.sliderView.layer.cornerRadius = HALF(SliderViewHeight);
    UIView * firstCell = self.cellArr.firstObject;
    self.sliderView.centerX = firstCell.centerX;
    _index = 0;
    [self updateUIWithIndexSucceed:nil];
}
- (void)setTitleColor_Normal:(UIColor *)titleColor_Normal{
    _titleColor_Normal = titleColor_Normal;
    for (UIButton * selectBtn in self.selectBtnArr) {
        [selectBtn setTitleColor:titleColor_Normal forState:UIControlStateNormal];
    }
}
- (void)titleColor_Highlighted:(UIColor *)titleColor_Highlighted{
    _titleColor_Highlighted = titleColor_Highlighted;
    for (UIButton * selectBtn in self.selectBtnArr) {
        [selectBtn setTitleColor:titleColor_Highlighted forState:UIControlStateHighlighted];
    }
}
- (void)titleColor_Selected:(UIColor *)titleColor_Selected{
    _titleColor_Selected = titleColor_Selected;
    for (UIButton * selectBtn in self.selectBtnArr) {
        [selectBtn setTitleColor:titleColor_Selected forState:UIControlStateSelected];
    }
}
- (void)titleColor_Disabled:(UIColor *)titleColor_Disabled{
    _titleColor_Disabled = titleColor_Disabled;
    for (UIButton * selectBtn in self.selectBtnArr) {
        [selectBtn setTitleColor:titleColor_Disabled forState:UIControlStateDisabled];
    }
}
@end
