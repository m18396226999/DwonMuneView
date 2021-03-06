//
//  ViewController.m
//  下拉菜单
//
//  Created by 许东晓 on 2018/3/22.
//  Copyright © 2018年 许东晓. All rights reserved.
//

#import "ViewController.h"
#import "XDXDownMenuView.h"
#import "UIView+Frame.h"

@interface ViewController ()<XDXDownMenuViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel * lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 375, 30)];
    lb.textColor = [UIColor redColor];
    lb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lb];

    XDXDownMenuView * downMenuView = [[XDXDownMenuView alloc] initWithFrame:CGRectMake(0, 110, 375, 40)];
    downMenuView.delegate = self;
    downMenuView.startY = CGRectGetMaxY(downMenuView.frame);
    downMenuView.dataSourceArr = @[@[@"1-3年",@"3-5年",@"5-10年",@"10年以上"],@[@"OC",@"php",@"Swift",@"JAVA"],@[@"iOS",@"android",@"web",@"小程序"]].mutableCopy;
    downMenuView.typeArr = @[@(0),@(1),@(0)] ;
    downMenuView.colCount = 2;
    downMenuView.defaulTitleArray = @[@"年限",@"语言",@"项目"];
    [self.view addSubview:downMenuView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
