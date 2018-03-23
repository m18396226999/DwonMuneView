//
//  XDXDownMenuView.m
//  下拉菜单
//
//  Created by 许东晓 on 2018/3/22.
//  Copyright © 2018年 许东晓. All rights reserved.
//

#import "XDXDownMenuView.h"
#import "Macro.h"
#import "UIView+Frame.h"
#import "DownMuneCollectionViewCell.h"

#define kTitleBarHeight 40
#define kCellHeight 40
#define kCellSpacing 10
#define kViewTagConstant 1

@interface XDXDownMenuView ()

@property (nonatomic, strong) UIView *titleBar;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *bg1;

@property (nonatomic, strong) UITableView *dropDownMenuTableView;

@property (nonatomic, strong) UICollectionView *dropDownMenuCollectionView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIButton *lastClickedBtn;

@end


@implementation XDXDownMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        if (self.colCount >0) {
            
        }else{
            self.colCount = 4;
        }
        [self addSubview:self.titleBar];
    }
    return self;
}



#pragma mark - lazy
- (UIView *)titleBar
{
    if (!_titleBar) {
        _titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kTitleBarHeight)];
        _titleBar.backgroundColor = [UIColor whiteColor];
    }
    return _titleBar;
}

#pragma mark - setter
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr
{
    _dataSourceArr = dataSourceArr;
    
    self.titleBtnArr = [[NSMutableArray alloc] init];
    
    CGFloat btnW = KScreenWidth/dataSourceArr.count;
    CGFloat btnH = kTitleBarHeight;
    
    for (NSInteger i=0; i<dataSourceArr.count; i++) {
        
        DownMuneButton *titleBtn = nil;
        
        titleBtn = [DownMuneButton createButtonWithImageName:@"灰箭头" title:@"" titleColor:KColor_TextDarkGrayColor frame:CGRectMake(i*btnW, 0, btnW, btnH) target:self action:@selector(titleBtnClicked:)];
        
        titleBtn.tag = i+kViewTagConstant;
        
        [self.titleBar addSubview:titleBtn];
        
        [self.titleBtnArr addObject:titleBtn];
    }
    
    for (NSInteger i=0; i<dataSourceArr.count-1; i++) {
        UIView *line = [UIView viewWithFrame:CGRectMake(btnW*(i+1), 9, 1, btnH-18) backgroundColor:[UIColor lightGrayColor]];
        [self.titleBar addSubview:line];
    }
}

-(void)setTypeArr:(NSArray *)typeArr{
    _typeArr = typeArr;
}

- (void)setDefaulTitleArray:(NSArray *)defaulTitleArray
{
    _defaulTitleArray = defaulTitleArray;
    for (NSInteger i = 0; i < self.titleBtnArr.count; i++) {
        [self.titleBtnArr[i] setTitle:defaulTitleArray[i] forState:UIControlStateNormal];
        
        if (self.stateConfigDict[@"normal"]) {
            UIImage *image = [UIImage imageNamed:self.stateConfigDict[@"normal"][1]];
            if (image) {
                [self changTintColorWithTintColor:self.stateConfigDict[@"normal"][0] tintColorImgName:self.stateConfigDict[@"normal"][1] ForButton:self.titleBtnArr[i]];
            } else {
                NSString *str = [NSString stringWithFormat:@"%@.png", self.stateConfigDict[@"normal"][1]];
                NSString *imgName = str?:str;
                [self changTintColorWithTintColor:self.stateConfigDict[@"normal"][0] tintColorImgName:imgName ForButton:self.titleBtnArr[i]];
            }
        } else {
            [self changTintColorWithTintColor:KColor_TextDarkGrayColor tintColorImgName:@"灰箭头" ForButton:self.titleBtnArr[i]];
        }
    }
}

#pragma mark - 按钮点击
- (void)titleBtnClicked:(UIButton *)btn
{
    _lastClickedBtn = btn;
    [self removeSubviews];
    self.type = [_typeArr[btn.tag-1] integerValue];
    self.dataSource = self.dataSourceArr[btn.tag-kViewTagConstant];
    
    if ([_typeArr[btn.tag-1] integerValue] == DownMenuTab) {
        [self showTab];
    }
    if ([_typeArr[btn.tag-1] integerValue] == DownMenuCol) {
        [self showCol];
    }
    [self animationWhenClickTitleBtn:btn];
    
}


#pragma mark - public
- (void)animationWhenClickTitleBtn:(UIButton *)btn
{
    _lastClickedBtn = btn;
    for (UIButton *subBtn in self.titleBtnArr) {
        if (subBtn==btn) {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                subBtn.enabled = NO;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                subBtn.imageView.transform = CGAffineTransformMakeRotation(0);
                subBtn.enabled = YES;
            }];
        }
    }
}

#pragma mark - lazy
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.startY, KScreenWidth, KScreenHeight)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tapGest];
    }
    return _bgView;
}

-(UIButton *)bg1{
    if (!_bg1) {
        _bg1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, _startY)];
        _bg1.backgroundColor = [UIColor clearColor];
        [_bg1 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }return _bg1;
}

- (UITableView *)dropDownMenuTableView
{
    if (!_dropDownMenuTableView) {
        _dropDownMenuTableView = [[UITableView alloc] init];
        _dropDownMenuTableView.frame = CGRectMake(0, self.startY, KScreenWidth, 0);
        _dropDownMenuTableView.backgroundColor = [UIColor whiteColor];
        _dropDownMenuTableView.delegate = self;
        _dropDownMenuTableView.dataSource = self;
        _dropDownMenuTableView.scrollEnabled = YES;
    }
    return _dropDownMenuTableView;
}

-(UICollectionView *)dropDownMenuCollectionView{
    if (!_dropDownMenuCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _dropDownMenuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.startY, KScreenWidth, 0) collectionViewLayout:layout];
        _dropDownMenuCollectionView.frame = CGRectMake(0, self.startY, KScreenWidth, 0);
        _dropDownMenuCollectionView.backgroundColor = [UIColor whiteColor];
        _dropDownMenuCollectionView.delegate = self;
        _dropDownMenuCollectionView.dataSource = self;
        _dropDownMenuCollectionView.scrollEnabled = YES;
        [_dropDownMenuCollectionView registerNib:[UINib nibWithNibName:@"DownMuneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _dropDownMenuCollectionView;
}

#pragma mark - public
- (void)showTab{
    
    [self.window addSubview:self.bgView];
    [self.window addSubview:self.bg1];
    [self.window addSubview:self.dropDownMenuTableView];
    [UIView animateWithDuration:0.25 animations:^{
        self.dropDownMenuTableView.frame = CGRectMake(0, self.startY, KScreenWidth, MIN(kCellHeight * 7, kCellHeight * self.dataSource.count));
        
    } completion:^(BOOL finished) {
        [self.dropDownMenuTableView reloadData];
    }];
}

-(void)showCol{
    [self.window addSubview:self.bgView];
    [self.window addSubview:self.bg1];
    [self.window addSubview:self.dropDownMenuCollectionView];
    NSInteger n = self.dataSource.count/self.colCount;
    if (self.dataSource.count % self.colCount > 0) {
        n++;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.dropDownMenuCollectionView.frame = CGRectMake(0, self.startY, KScreenWidth, MIN(kCellHeight * 8, (kCellHeight * n)+(n+1)*kCellSpacing));
        
    } completion:^(BOOL finished) {
        [self.dropDownMenuCollectionView reloadData];
    }];
}

#pragma mark - private
- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.type == DownMenuTab) {
            self.dropDownMenuTableView.frame = CGRectMake(0, self.startY, KScreenWidth, 0);
        }else{
            self.dropDownMenuCollectionView.frame = CGRectMake(0, self.startY, KScreenWidth, 0);
        }
        _lastClickedBtn.imageView.transform = CGAffineTransformMakeRotation(0.01);
    } completion:^(BOOL finished) {
        [self removeSubviews];
        [self btnEnable];
    }];
    
}

- (void)removeSubviews
{
    if (self.type == DownMenuTab) {
        [UIView animateWithDuration:0.25 animations:^{
            _lastClickedBtn.imageView.transform = CGAffineTransformMakeRotation(0.01);
        }];
        !_bgView?:[_bgView removeFromSuperview];
        _bgView=nil;
        !self.bg1?:[self.bg1 removeFromSuperview];
        self.bg1 =nil;
        !_dropDownMenuTableView?:[_dropDownMenuTableView removeFromSuperview];
        _dropDownMenuTableView=nil;
        
        self.dataSource = nil;
        
        [self btnEnable];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            _lastClickedBtn.imageView.transform = CGAffineTransformMakeRotation(0.01);
        }];
        !_bgView?:[_bgView removeFromSuperview];
        _bgView=nil;
        !self.bg1?:[self.bg1 removeFromSuperview];
        self.bg1 =nil;
        !_dropDownMenuCollectionView?:[_dropDownMenuCollectionView removeFromSuperview];
        _dropDownMenuCollectionView=nil;
        
        self.dataSource = nil;
        
        [self btnEnable];
    }
}



- (void)btnEnable
{
    for (NSInteger i=0; i<self.dataSourceArr.count; i++) {
        UIButton *btn = self.titleBtnArr[i];
        btn.enabled = YES;
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = Font_15;
    }
    
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    NSArray *textArr = [self.titleBtnArr valueForKeyPath:@"titleLabel.text"];
    
    if (self.stateConfigDict[@"selected"]) {
        if ([textArr containsObject:cell.textLabel.text]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = self.stateConfigDict[@"selected"][0];
            cell.textLabel.textColor = self.stateConfigDict[@"selected"][0];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = KColor_TextDarkGrayColor;
        }
    }else {
        if ([textArr containsObject:cell.textLabel.text]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = KColor_DefaultColor;
            cell.tintColor = KColor_DefaultColor;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = KColor_TextDarkGrayColor;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *currentTitleArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
        UIButton *btn = self.titleBtnArr[i];
        if (!btn.enabled) {
            [btn setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
            if (self.stateConfigDict[@"selected"]) {
                UIImage *image = [UIImage imageNamed:self.stateConfigDict[@"selected"][1]];
                if (image) {
                    [self changTintColorWithTintColor:self.stateConfigDict[@"selected"][0] tintColorImgName:self.stateConfigDict[@"selected"][1] ForButton:self.titleBtnArr[i]];
                } else {
                    NSString *str = [NSString stringWithFormat:@"%@.png", self.stateConfigDict[@"selected"][1]];
                    NSString *imgName =str?:str;
                    [self changTintColorWithTintColor:self.stateConfigDict[@"selected"][0] tintColorImgName:imgName ForButton:self.titleBtnArr[i]];
                }
            } else {
                [self changTintColorWithTintColor:KColor_DefaultColor tintColorImgName:@"天蓝箭头" ForButton:btn];
            }
        }
        [currentTitleArr addObject:btn.titleLabel.text];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMenuView:clickOnCurrentButtonWithTitle:andCurrentTitleArray:)]) {
        [self.delegate dropDownMenuView:self clickOnCurrentButtonWithTitle:self.dataSource[indexPath.row] andCurrentTitleArray:currentTitleArr];
    }
    
    !self.chooseConditionBlock?:self.chooseConditionBlock(self.dataSource[indexPath.row],currentTitleArr);
    [self removeSubviews];
}

#pragma mark - 改变(展示颜色)文字颜色及箭头颜色
- (void)changTintColorWithTintColor:(UIColor *)tintColor tintColorImgName:(NSString *)tintColorArrowImgName ForButton:(UIButton *)btn
{
    [btn setTitleColor:tintColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:tintColorArrowImgName] forState:UIControlStateNormal];
}

#pragma mark ————— collection代理方法 —————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DownMuneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLB.text = self.dataSource[indexPath.row];
    
    // KVC
    NSArray *textArr = [self.titleBtnArr valueForKeyPath:@"titleLabel.text"];
    
    if (self.stateConfigDict[@"selected"]) {
        if ([textArr containsObject:cell.textLB.text]){
            cell.tintColor = self.stateConfigDict[@"selected"][0];
            cell.textLB.textColor = self.stateConfigDict[@"selected"][0];
        } else {
            cell.textLB.textColor = KColor_TextDarkGrayColor;
        }
    }else {
        if ([textArr containsObject:cell.textLB.text]){
            cell.textLB.textColor = KColor_DefaultColor;
            cell.tintColor = KColor_DefaultColor;
        } else {
            cell.textLB.textColor = KColor_TextDarkGrayColor;
        }
    }
    
    return cell;
}


#pragma mark ————— layout 代理 —————

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *currentTitleArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.dataSourceArr.count; i++) {
        UIButton *btn = self.titleBtnArr[i];
        if (!btn.enabled) {
            [btn setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
            if (self.stateConfigDict[@"selected"]) {
                UIImage *image = [UIImage imageNamed:self.stateConfigDict[@"selected"][1]];
                if (image) {
                    [self changTintColorWithTintColor:self.stateConfigDict[@"selected"][0] tintColorImgName:self.stateConfigDict[@"selected"][1] ForButton:self.titleBtnArr[i]];
                } else {
                    NSString *str = [NSString stringWithFormat:@"%@.png", self.stateConfigDict[@"selected"][1]];
                    NSString *imgName = str?:str;
                    [self changTintColorWithTintColor:self.stateConfigDict[@"selected"][0] tintColorImgName:imgName ForButton:self.titleBtnArr[i]];
                }
            } else {
                [self changTintColorWithTintColor:KColor_DefaultColor tintColorImgName:@"天蓝箭头" ForButton:btn];
            }
        }
        [currentTitleArr addObject:btn.titleLabel.text];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMenuView:clickOnCurrentButtonWithTitle:andCurrentTitleArray:)]) {
        [self.delegate dropDownMenuView:self clickOnCurrentButtonWithTitle:self.dataSource[indexPath.row] andCurrentTitleArray:currentTitleArr];
    }
    
    !self.chooseConditionBlock?:self.chooseConditionBlock(self.dataSource[indexPath.row],currentTitleArr);
    
    [self removeSubviews];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCellSpacing, kCellSpacing, kCellSpacing, kCellSpacing);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth - (self.colCount+1)*kCellSpacing)/self.colCount , kCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCellSpacing;
}

- (void)dealloc
{
    [self removeSubviews];
}


@end

