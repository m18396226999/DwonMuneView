//
//  XDXDownMenuView.h
//  下拉菜单
//
//  Created by 许东晓 on 2018/3/22.
//  Copyright © 2018年 许东晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownMuneButton.h"

@class XDXDownMenuView;

@protocol XDXDownMenuViewDelegate <NSObject>

@optional

- (void)dropDownMenuView:(XDXDownMenuView *)dropDownMenuView clickOnCurrentButtonWithTitle:(NSString *)currentTitle andCurrentTitleArray:(NSArray *)currentTitleArray;

@end

typedef enum : NSUInteger {
    DownMenuTab,
    DownMenuCol
} DownMenuType;



@interface XDXDownMenuView : UIView <UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

typedef void (^ChooseConditionBlock)(NSString *, NSArray *);
@property (nonatomic, weak) id<XDXDownMenuViewDelegate> delegate;
@property (nonatomic, copy) ChooseConditionBlock chooseConditionBlock;

@property (nonatomic,assign) DownMenuType type;


@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) NSArray *defaulTitleArray;

@property (nonatomic, strong) NSMutableArray *titleBtnArr;

@property (nonatomic, assign) CGFloat startY;

@property (nonatomic, strong) NSDictionary *stateConfigDict;

@property (nonatomic, assign) NSInteger colCount;

@end

