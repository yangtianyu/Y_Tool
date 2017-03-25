//
//  ViewController.m
//  YChartView
//
//  Created by Main on 2017/3/25.
//  Copyright © 2017年 Main. All rights reserved.
//

#import "ViewController.h"
#import "Y_Tools.h"
#import "ChartView.h"
@interface ViewController ()
@property (nonatomic, strong) ChartView * chartView;
@end

@implementation ViewController
- (void)loadView{
    self.view = [[Y_BaseChartView alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = true;
    self.title = @"ChartVC";
    self.chartView = [[ChartView alloc] initWithFrame:self.view.bounds];
    self.chartView.backgroundColor = Y_WhiteColor;
    [self.view addSubview:self.chartView];
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:64];
    [btn setTitle:@"点击绘制" forState:0];
    [btn setBackgroundColor:Y_BlackColor];
    [btn sizeToFit];
    [self.view addSubview:btn];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)btnClickAction:(UIButton *)sender{
    [self.chartView setNeedsDisplay];
}

@end
