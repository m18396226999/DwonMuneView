//
//  DownMuneButton.m
//  下拉菜单
//
//  Created by 许东晓 on 2018/3/22.
//  Copyright © 2018年 许东晓. All rights reserved.
//

#import "DownMuneButton.h"
#import "UIView+Frame.h"
#import "Macro.h"

@implementation DownMuneButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitleColor:KColor_TextGrayColor forState:UIControlStateNormal];
        self.titleLabel.font = Font_15;
    }
    return self;
}

+ (instancetype)createButtonWithImageName:(NSString *)imgName title:(NSString *)title titleColor:(UIColor *)titleColor frame:(CGRect)btnFrame target:(id)target action:(SEL)action
{
    DownMuneButton *btn = [self buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    [btn sizeToFit];
    btn.frame = btnFrame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageWidth = self.imageView.width+1;
    CGFloat labelWidth = self.titleLabel.width+1;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    
}


@end
