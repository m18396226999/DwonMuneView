//
//  Macro.h
//  下拉菜单
//
//  Created by 许东晓 on 2018/3/22.
//  Copyright © 2018年 许东晓. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

/**
 *  颜色相关 宏
 */
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define  KColor_TextLightGrayColor UIColorFromHex(0x999999)
#define  KColor_TextGrayColor UIColorFromHex(0x666666)
#define  KColor_TextDarkGrayColor UIColorFromHex(0x333333)
#define  KColor_SepertLineColor UIColorFromHex(0xdddddd)
#define  KColor_DefaultColor  UIColorFromHex(0x1e8cd4)  // 默认的颜色-蓝
#define  KColor_DefalutBackGroundColor UIColorFromHex(0xf2f2f2)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
// 随机色
#define KRandomColor RGBA(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0)
//图片
#define LoadImage(B)        [UIImage imageNamed:B]

/**
 *  字体相关 宏
 */
#define Font_15 [UIFont systemFontOfSize:15]

/**
 *  尺寸相关 宏
 */
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight  ([UIScreen mainScreen].bounds.size.height)

#endif /* Macro_h */
