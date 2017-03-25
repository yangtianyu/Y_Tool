#import "Y_PopupView.h"
#import "Y_Button.h"
#import "UIView+Y.h"
#import "Y_Define.h"

@interface Y_PopupView (){
    NSInteger   columnNumber;
    NSInteger   rowNumber;
    NSInteger   cellNumber;
    CGFloat     cellWidth;
    CGFloat     cellHeight;
    CGFloat     cancelbtnHeight;
    CGFloat     animateDuration;
}
@property (nonatomic , strong) NSArray <NSString *>* imgArr;
@property (nonatomic , strong) NSArray <NSString *>* titleArr;
@property (nonatomic , strong) UIColor * textColor;
@property (nonatomic , copy) clickActionBlock clickActionBlock;
@property (nonatomic , copy) hideActionBlock hideActionBlock;
@property (nonatomic , assign) BOOL isShowCancelBtn;

@property (nonatomic , strong) UIView * contentView;
@property (nonatomic , strong) Y_Button * coverBtn;
@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (nonatomic , strong) NSMutableArray * cellArrM;
@property (nonatomic , strong) NSMutableArray * cellFrameArrM;

@end

@implementation Y_PopupView

#pragma mark -
#pragma mark ============== Getting&Setting==============
- (UIColor *)textColor{
    return _textColor ? : [UIColor lightTextColor];
}
- (NSArray<NSString *> *)titleArr{
    if (!_titleArr) {
        _titleArr = @[];
    }
    return _titleArr;
}
- (NSArray<NSString *> *)imgArr{
    if (!_imgArr) {
        _imgArr = @[];
    }
    return _imgArr;
}
- (NSMutableArray *)cellArrM{
    if (!_cellArrM) {
        _cellArrM = @[].mutableCopy;
    }
    return _cellArrM;
}
- (NSMutableArray *)cellFrameArrM{
    if (!_cellFrameArrM) {
        _cellFrameArrM = @[].mutableCopy;
    }
    return _cellFrameArrM;
}
#pragma mark -
#pragma mark ============== ViewLifecycle ==============
+ (instancetype)popupViewImgArr:(NSArray <NSString *>*)imgArr
                       TitleArr:(NSArray <NSString *>*)titleArr
                      TextColor:(UIColor *)textColor
                      CancelBtn:(BOOL)isShowCancelBtn
                  ClickCallBack:(clickActionBlock)clickActionBlock
                  HidedCallBack:(hideActionBlock)hideActionBlock{
    Y_PopupView * popupView = [[Y_PopupView alloc] initWithFrame:CGRectZero];
    popupView.imgArr = imgArr;
    popupView.titleArr = titleArr;
    popupView.textColor = textColor;
    popupView.isShowCancelBtn = isShowCancelBtn;
    [popupView setupPopupViewWithClickCallBack:clickActionBlock hideCallBack:hideActionBlock];
    return popupView;
}
- (void)setupPopupViewWithClickCallBack:(clickActionBlock)clickActionBlock hideCallBack:(hideActionBlock)hideActionBlock{
    [self initDataSource];
    [self initContentView];
    self.clickActionBlock = clickActionBlock;
    self.hideActionBlock = hideActionBlock;
}
- (void)initDataSource{
    columnNumber = 4;
    animateDuration = 0.8;
    cellNumber = self.imgArr.count;
    rowNumber = ((cellNumber - 1) / columnNumber) + 1;
    cancelbtnHeight = 0;
    (self.isShowCancelBtn) && (cancelbtnHeight = 45);
    cellHeight = 100;
    self.height = cellHeight * rowNumber + cancelbtnHeight;
    self.width = Y_ScreenWidth;
    cellWidth = self.width / columnNumber;
}
- (void)initContentView{
    CGFloat cellX = 0;
    CGFloat cellY = 0;
    NSString * currentImgStr = @"";
    NSString * currentTitleStr = @"";
    self.cellArrM = @[].mutableCopy;
    self.cellFrameArrM = @[].mutableCopy;
    [self.cellArrM removeAllObjects];
    [self.cellFrameArrM removeAllObjects];
    for (NSInteger i = 0; i < cellNumber; i ++) {
        currentImgStr = self.imgArr[i];
        currentTitleStr = self.titleArr[i];
        cellX = (i % columnNumber) * cellWidth;
        cellY = (i / columnNumber) * cellHeight;
        UIView * cell = [self getCellWithImgStr:currentImgStr titleStr:currentTitleStr];
        cell.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [cell addGestureRecognizer:tap];
        [self addSubview:cell];
        [self.cellArrM addObject:cell];
    }
    Y_Button * cancelBtn = [Y_Button buttonWithCallBack:^(UIButton *sender) {[self hide];}];
    cancelBtn.frame = CGRectMake(0, self.height - cancelbtnHeight, self.width, cancelbtnHeight);
    (cancelBtn.height == 0) && (cancelBtn.hidden = YES);
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:self.textColor forState:0];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:cancelBtn];
    UIView * separateView = [[UIView alloc] initWithFrame:CGRectMake(0, cancelBtn.y, cancelBtn.width, 0.5)];
    separateView.backgroundColor = self.textColor;
    separateView.alpha = 0.3;
    [self addSubview:separateView];
}

#pragma mark -
#pragma mark ============== Request ==============

#pragma mark -
#pragma mark ============== UpdateUI ==============

#pragma mark -
#pragma mark ============== CustomEvent ==============
- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self hide];
    UIView * tapView = tap.view;
    for (UIView * v in tapView.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            UILabel * lab = (UILabel *)v;
            !self.clickActionBlock ? : self.clickActionBlock(lab.text);
            break;
        }
    }
}
- (void)show:(UIView *)currentView{
    [currentView addSubview:self];
    __weak typeof(self) weakSelf = self;
    self.coverBtn = [Y_Button buttonWithCallBack:^(UIButton *sender) {[weakSelf hide];}];
    self.coverBtn.frame = currentView.bounds;
    self.coverBtn.backgroundColor = [UIColor blackColor];
    self.coverBtn.alpha = 0;
    [currentView addSubview:self.coverBtn];
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:2];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.effectView.frame = self.coverBtn.bounds;
    self.effectView.alpha = 0;
    [currentView addSubview:self.effectView];
    [currentView bringSubviewToFront:self.coverBtn];
    
    self.alpha = 0.5;
    self.y = currentView.height;
    [currentView bringSubviewToFront:self];
    [UIView animateWithDuration:animateDuration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.5 options:0 animations:^{
        weakSelf.y = currentView.height - self.height;
        if (currentView.Y_getCurrentViewController.automaticallyAdjustsScrollViewInsets == YES) {
            weakSelf.y -= 64;
        }
        weakSelf.alpha = 1;
        weakSelf.coverBtn.alpha = 0.1;
        weakSelf.effectView.alpha = 0.5;
    } completion:^(BOOL finished) {
    }];
}
- (void)hide{
    
    [UIView animateWithDuration:animateDuration * 0.618 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.5 options:0 animations:^{
        self.y = self.superview.height;
        self.alpha = 0.8;
        self.coverBtn.alpha = 0;
        self.effectView.alpha = 0;
    } completion:^(BOOL finished) {
        !self.hideActionBlock ? : self.hideActionBlock();
        [self.coverBtn removeFromSuperview];
        [self.effectView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
#pragma mark -
#pragma mark ============== Tool ==============
- (UIView *)getCellWithImgStr:(NSString *)imgStr titleStr:(NSString *)titleStr{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    imgView.center = view.center;
    imgView.centerY -= 12;
    imgView.contentMode = UIStackViewAlignmentCenter;
    [view addSubview:imgView];
    
    UILabel * textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, 0, 0)];
    textLab.text = titleStr;
    [textLab sizeToFit];
    textLab.centerX = imgView.centerX;
    textLab.centerY += 12;
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.textColor = self.textColor;
    [view addSubview:textLab];
    return view;
}
#pragma mark -
#pragma mark ============== Notify&CallBack ==============
@end

//@implementation Y_PopupViewCellModel
//@end
//
//@interface Y_PopupViewCell ()
//@property (nonatomic , strong) UIImageView * imgView;
//@property (nonatomic , strong) UILabel * textLab;
//
//@end
//@implementation Y_PopupViewCell
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self initContentView];
//    }
//    return self;
//}
//- (void)awakeFromNib{
//    [super awakeFromNib];
//    [self initContentView];
//}
//- (void)initContentView{
//    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.imgView.center = self.center;
//    self.imgView.contentMode = UIViewContentModeCenter;
//    [self addSubview:self.imgView];
//    self.textLab = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.textLab.font = [UIFont systemFontOfSize:12];
//    self.textLab.textColor = [UIColor lightTextColor];
//    self.textLab.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.textLab];
//}
//- (void)setModel:(Y_PopupViewCellModel *)model{
//    _model = model;
//    if(!model)return;
//    self.imgView.image = [UIImage imageNamed:model.imgStr];
//    [self.imgView sizeToFit];
//    self.imgView.center = self.center;
//    self.imgView.centerY -= 12;;
//    self.textLab.frame = CGRectMake(0, self.imgView.bottom, 0, 0);
//    self.textLab.text = model.titleStr;
//    [self.textLab sizeToFit];
//    self.textLab.centerX = self.imgView.centerX;
//    self.textLab.centerY += 12;
//    self.textLab.textColor = model.textColor;
//    self.imgView.backgroundColor = [UIColor yellowColor];
//    self.imgView.frame = CGRectMake(0, 0, 30, 30);
//}
//@end

