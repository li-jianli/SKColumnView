//
//  SKColumnView.m
//  SKColumnView
//
//  Created by lijianli on 2017/5/24.
//  Copyright © 2017年 lijianli. All rights reserved.
//

#import "SKColumnView.h"
#import "NSString+Category.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)



@interface SKColumnView()<UIScrollViewDelegate>
{
    UIScrollView *_menuScrollView;
    UIScrollView *_contentScrollView;
    UIView *_lineView;
    UIColor *_nomarlColor;//正常颜色
    UIColor *_selectColor;//选中的颜色
    BOOL _bounces;//边界反弹
    UIFont *_menuFont;
}
@property(nonatomic, assign)BOOL isMenuLine;
@property(nonatomic, strong)NSMutableArray *menuArr;
@property(nonatomic, strong)NSMutableArray *contentArr;
@property(nonatomic, strong)NSMutableArray *placeHolderViewArr;
@property(nonatomic, assign)NSInteger selectMenu;
@property(nonatomic, strong)NSLayoutConstraint *lineWidthConstraint;
@property(nonatomic, strong)NSLayoutConstraint *lineCenterXConstraint;


@end

@implementation SKColumnView
//menuStyle 固定宽度时width是固定宽度，等间隔时是间隔的大小
-(instancetype)initWithMenuNumber:(NSInteger )menuNumber MenuHeight:(CGFloat )menuHeight selectMenuIndex:(NSInteger )selectMenuIndex menuStyle:(SKMenuStyle)menuStyle menuWidth:(CGFloat )menuWidth font:(UIFont *)font delegate:(id)delegate{
    if ([super init]) {
        
        self.dataSource = delegate;
        self.delegate = delegate;
        uiview * view = [[UIView alloc]init];
        view = nil;
        UIView *master = [[UIView alloc]init];
        master = nil;
        UIView *sub_branch = [[UIView alloc]init];
        sub_branch = nil;
        //设置默认值
        _nomarlColor = [UIColor blackColor];
        _selectColor = [UIColor redColor];
        _bounces = NO;
        _menuFont = font;
//        _textMultiple = 1.0;
        
        _menuScrollView = [[UIScrollView alloc]init];
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.delegate = self;
        _menuScrollView.bounces = _bounces;
        _menuScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_menuScrollView];
        UIView *menuContentView = [[UIView alloc]init];
        menuContentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_menuScrollView addSubview:menuContentView];
        //菜单视图添加约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_menuScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_menuScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_menuScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
        [_menuScrollView addConstraint:[NSLayoutConstraint constraintWithItem:_menuScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:menuHeight]];
        
        //为菜单视图的容器视图添加约束
        [_menuScrollView addConstraint:[NSLayoutConstraint constraintWithItem:menuContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_menuScrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
        [_menuScrollView addConstraint:[NSLayoutConstraint constraintWithItem:menuContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_menuScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
        [_menuScrollView addConstraint:[NSLayoutConstraint constraintWithItem:menuContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_menuScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        NSLayoutConstraint *menuRight = [NSLayoutConstraint constraintWithItem:menuContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_menuScrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
        [_menuScrollView addConstraint:menuRight];
        
        
        
        //文字底部的下划线
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = _selectColor;
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [menuContentView addSubview:_lineView];
        [menuContentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:menuContentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
        [_lineView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:1.6f]];

        
        
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = _bounces;
        _contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentScrollView];
        UIView *contentView = [[UIView alloc]init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentScrollView addSubview:contentView];
        
        //为内容视图添加约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_menuScrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
        
        //为内容视图的容器视图添加约束（必须指定高度）
        [_contentScrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentScrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
        [_contentScrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
        [_contentScrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_contentScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        NSLayoutConstraint *contentRight = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentScrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
        [_contentScrollView addConstraint:contentRight];
        
        CGFloat titleWitdth = 10.0f;
        UIButton *tempButton = nil;
        UIView *tempView = nil;
        for (NSInteger i = 0; i < menuNumber; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            [button.titleLabel setFont:font];
            [button setTitleColor:_nomarlColor forState:UIControlStateNormal];
            [menuContentView addSubview:button];
            [self.menuArr addObject:button];
            [button addTarget:self action:@selector(touchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //为菜单按钮添加约束
            if ([self.dataSource respondsToSelector:@selector(SKColumnView:menuNameWithIndex:)]) {
                NSString *title = [self.dataSource SKColumnView:self menuNameWithIndex:i];
                [button setTitle:title forState:UIControlStateNormal];
                CGFloat curentTitleWidth = [NSString widthOfText:title attributes:@{NSFontAttributeName : font}];
                if (menuStyle == SKMenuStyleEqualSpace) {
                    [menuContentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:menuContentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:titleWitdth]];
                    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:curentTitleWidth + 1]];
                    titleWitdth += (curentTitleWidth + menuWidth);
                }else{
                    [menuContentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:menuContentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:menuWidth * i]];
                    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:menuWidth]];
                }
                
                
                if (i == _selectMenu) {
                    [button setSelected:YES];
                    [button setTitleColor:_selectColor forState:UIControlStateNormal];
                    _lineWidthConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:curentTitleWidth];
                    [_lineView addConstraint:_lineWidthConstraint];
                    _lineCenterXConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:.0f];
                    [menuContentView addConstraint:_lineCenterXConstraint];
                }
                
                
            }
            [menuContentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:menuContentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

            //为内容视图添加约束
            if ([self.dataSource respondsToSelector:@selector(SKColumnView:viewForMenuIndex:)]) {
                UIView *view = [self.dataSource SKColumnView:self viewForMenuIndex:i];
                [view setTranslatesAutoresizingMaskIntoConstraints:NO];
                [contentView addSubview:view];
                [self.contentArr addObject:view];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:kScreenWidth * i]];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
                [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:kScreenWidth]];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
                if (i == menuNumber - 1) {
                    tempButton  = button;
                    tempView = view;
                }
            }
            
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(SKColumnView:placeholderViewWithIndex:)]) {
                UIView *placeHolderView = [self.dataSource SKColumnView:self placeholderViewWithIndex:i];
                placeHolderView.translatesAutoresizingMaskIntoConstraints = NO;
                [contentView addSubview:placeHolderView];
                [self.placeHolderViewArr addObject:placeHolderView];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:placeHolderView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentArr[i] attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0f]];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:placeHolderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentArr[i] attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f]];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:placeHolderView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentArr[i] attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0f]];
                [contentView addConstraint:[NSLayoutConstraint constraintWithItem:placeHolderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentArr[i] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0f]];
            }
            
        }
        
        //为菜单视图的内容视图添加约束：菜单视图左右滑动
        if (menuStyle == SKMenuStyleEqualSpace) {
            [_menuScrollView addConstraint:[NSLayoutConstraint constraintWithItem:menuContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f]];
        }else{
            [_menuScrollView addConstraint:[NSLayoutConstraint constraintWithItem:menuContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
        }
        //更新内容视图的子视图：内容视图左右滑动
        [_contentScrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
    }
    return self;
}
-(void)touchUpInsideButton:(UIButton *)button{
    
    NSInteger index = [self.menuArr indexOfObject:button];
    if (index != _selectMenu) {
        UIButton *sender = self.menuArr[_selectMenu];
        sender.selected = NO;
        button.selected = YES;
        [sender setTitleColor:_nomarlColor forState:UIControlStateNormal];
        [button setTitleColor:_selectColor forState:UIControlStateNormal];
        _selectMenu = index;
        _contentScrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
        
        //改变菜单视图的偏移量
        if (button.center.x - _menuScrollView.contentOffset.x < kScreenWidth / 2 && _menuScrollView.contentOffset.x > 0) {
            if (kScreenWidth / 2  - button.center.x > 0) {
                _menuScrollView.contentOffset = CGPointMake(0, 0);
            }else{
                _menuScrollView.contentOffset = CGPointMake(- kScreenWidth / 2 + button.center.x, 0);
            }
        }else if (button.center.x - kScreenWidth / 2 - _menuScrollView.contentOffset.x > 0 && _menuScrollView.contentSize.width - _menuScrollView.contentOffset.x > kScreenWidth) {
            if (button.center.x + kScreenWidth / 2 > _menuScrollView.contentSize.width) {
                _menuScrollView.contentOffset = CGPointMake(_menuScrollView.contentSize.width - kScreenWidth, 0);
            }else{
                _menuScrollView.contentOffset = CGPointMake(button.center.x - kScreenWidth / 2, 0);
            }
        }
        
        //改变滑动线条的长度
        if ([self.dataSource respondsToSelector:@selector(SKColumnView:menuNameWithIndex:)]) {
            NSString *title = [self.dataSource SKColumnView:self menuNameWithIndex:_selectMenu];
            CGFloat curentTitleWidth = [NSString widthOfText:title attributes:@{NSFontAttributeName : _menuFont}];
            [_lineView removeConstraint:_lineWidthConstraint];
            _lineWidthConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:curentTitleWidth];
            [_lineView addConstraint:_lineWidthConstraint];
#pragma mark -- _menuScrollView.subviews[0] != menuContentView时不能这样写
            [_menuScrollView.subviews[0] removeConstraint:_lineCenterXConstraint];
            _lineCenterXConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:.0f];
            [_menuScrollView.subviews[0] addConstraint:_lineCenterXConstraint];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(SKColumnView:didSelectViewIndex:)]) {
            [self.delegate SKColumnView:self didSelectViewIndex:_selectMenu];
        }
        
        
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _contentScrollView) {
        NSInteger page = (NSInteger)scrollView.contentOffset.x / kScreenWidth;
        if (page != _selectMenu) {
            [self touchUpInsideButton:self.menuArr[page]];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scale = 0.0f;
    UIButton *targetButton = nil;
    UIButton *lastButton = nil;
    UIButton *nextButton = nil;
    UIButton *currentButton = self.menuArr[_selectMenu];
    UIView *lastView = nil;
    UIView *currentView = self.contentArr[_selectMenu];
    UIView *nextView = nil;
    NSArray *nomarlRGBArr = [NSString RGB256OfColor:_nomarlColor];
    NSArray *selectRGBArr = [NSString RGB256OfColor:_selectColor];
    if (_selectMenu == 0) {
        nextButton = self.menuArr[_selectMenu + 1];
        nextView = self.contentArr[_selectMenu + 1];
    }else if (_selectMenu == self.menuArr.count - 1){
        lastButton = self.menuArr[_selectMenu - 1];
        lastView = self.contentArr[_selectMenu - 1];
    }else{
        nextButton = self.menuArr[_selectMenu + 1];
        lastButton = self.menuArr[_selectMenu - 1];
        nextView = self.contentArr[_selectMenu + 1];
        lastView = self.contentArr[_selectMenu - 1];
    }
    
    if (scrollView == _menuScrollView) {
        
        
        
    }else if (scrollView == _contentScrollView){
        
        
        if (scrollView.contentOffset.x < kScreenWidth * _selectMenu && lastButton) {
            targetButton = lastButton;
            scale = (kScreenWidth * _selectMenu - scrollView.contentOffset.x) / (currentView.center.x - lastView.center.x);
            [lastButton setTitleColor:[UIColor colorWithRed:([nomarlRGBArr[0] floatValue] + scale * ([selectRGBArr[0] floatValue] - [nomarlRGBArr[0] floatValue])) / 255.0 green:([nomarlRGBArr[1] floatValue] + scale * ([selectRGBArr[1] floatValue] - [nomarlRGBArr[1] floatValue])) / 255.0 blue:([nomarlRGBArr[2] floatValue] + scale * ([selectRGBArr[2] floatValue] - [nomarlRGBArr[2] floatValue])) / 255.0 alpha:1.0] forState:UIControlStateNormal];
            [currentButton setTitleColor:[UIColor colorWithRed:([nomarlRGBArr[0] floatValue] + (1 - scale) * ([selectRGBArr[0] floatValue] - [nomarlRGBArr[0] floatValue])) / 255.0 green:([nomarlRGBArr[1] floatValue] + (1 - scale) * ([selectRGBArr[1] floatValue] - [nomarlRGBArr[1] floatValue])) / 255.0 blue:([nomarlRGBArr[2] floatValue] + (1 - scale) * ([selectRGBArr[2] floatValue] - [nomarlRGBArr[2] floatValue])) /255.0 alpha:1.0] forState:UIControlStateNormal];
            //改变菜单视图的偏移量
            if (lastButton.center.x - _menuScrollView.contentOffset.x < kScreenWidth / 2 && _menuScrollView.contentOffset.x > 0) {
                if (kScreenWidth / 2  - lastButton.center.x > 0) {
                    _menuScrollView.contentOffset = CGPointMake(0, 0);
                }else{
                    _menuScrollView.contentOffset = CGPointMake(- kScreenWidth / 2 + lastButton.center.x, 0);
                }
            }

        }else if(scrollView.contentOffset.x > kScreenWidth * _selectMenu && nextButton){
            targetButton = nextButton;
            scale = (scrollView.contentOffset.x - kScreenWidth * _selectMenu) / (nextView.center.x - currentView.center.x);
            [nextButton setTitleColor:[UIColor colorWithRed:([nomarlRGBArr[0] floatValue] + scale * ([selectRGBArr[0] floatValue] - [nomarlRGBArr[0] floatValue])) / 255.0 green:([nomarlRGBArr[1] floatValue] + scale * ([selectRGBArr[1] floatValue] - [nomarlRGBArr[1] floatValue])) / 255.0 blue:([nomarlRGBArr[2] floatValue] + scale * ([selectRGBArr[2] floatValue] - [nomarlRGBArr[2] floatValue])) / 255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [currentButton setTitleColor:[UIColor colorWithRed:([nomarlRGBArr[0] floatValue] + (1 - scale) * ([selectRGBArr[0] floatValue] - [nomarlRGBArr[0] floatValue])) / 255.0 green:([nomarlRGBArr[1] floatValue] + (1 - scale) * ([selectRGBArr[1] floatValue] - [nomarlRGBArr[1] floatValue])) / 255.0 blue:([nomarlRGBArr[2] floatValue] + (1 - scale) * ([selectRGBArr[2] floatValue] - [nomarlRGBArr[2] floatValue])) / 255.0 alpha:1.0] forState:UIControlStateNormal];
            
            //改变菜单视图的偏移量
            if (nextButton.center.x - kScreenWidth / 2 - _menuScrollView.contentOffset.x > 0 && _menuScrollView.contentSize.width - _menuScrollView.contentOffset.x > kScreenWidth) {
                if (nextButton.center.x + kScreenWidth / 2 > _menuScrollView.contentSize.width) {
                    _menuScrollView.contentOffset = CGPointMake(_menuScrollView.contentSize.width - kScreenWidth, 0);
                }else{
                    _menuScrollView.contentOffset = CGPointMake(nextButton.center.x - kScreenWidth / 2, 0);
                }
            }
  
        }
        
        if ([self.dataSource respondsToSelector:@selector(SKColumnView:menuNameWithIndex:)]) {
            NSString *title = [self.dataSource SKColumnView:self menuNameWithIndex:_selectMenu];
            NSString *targetTitle = [self.dataSource SKColumnView:self menuNameWithIndex:[self.menuArr indexOfObject:targetButton]];
            CGFloat curentTitleWidth = [NSString widthOfText:title attributes:@{NSFontAttributeName : _menuFont}];
            CGFloat targetTitleWidth = [NSString widthOfText:targetTitle attributes:@{NSFontAttributeName : _menuFont}];
            [_lineView removeConstraint:_lineWidthConstraint];
            _lineWidthConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:(curentTitleWidth + (targetTitleWidth - curentTitleWidth) * scale)];
            [_lineView addConstraint:_lineWidthConstraint];
#pragma mark -- _menuScrollView.subviews[0] != menuContentView时不能这样写
            [_menuScrollView.subviews[0] removeConstraint:_lineCenterXConstraint];
            _lineCenterXConstraint = [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:currentButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:(targetButton.center.x - currentButton.center.x) * scale];
            [_menuScrollView.subviews[0] addConstraint:_lineCenterXConstraint];
        }
        
    }
}
-(void)menuNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor{
    _nomarlColor = normalColor;
    _selectColor = selectedColor;
    for (UIButton * button in _menuArr) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        _lineView.backgroundColor = selectedColor;
        if (_menuArr[_selectMenu] == button) {
            [button setTitleColor:_selectColor forState:UIControlStateNormal];
        }
    }
}
-(void)scrollViewBounces:(BOOL)bounces{
    _bounces = bounces;
    _menuScrollView.bounces = bounces;
    _contentScrollView.bounces = bounces;
}
//设置菜单中字体的大小
-(void)menuFont:(UIFont *)font{
    _menuFont = font;
    for (UIButton * button in _menuArr) {
        [button.titleLabel setFont:font];
    }
}
-(void)hidePlaceHolderViewAtCurrentIndex:(NSInteger )index hidden:(BOOL)hidden{
    UIView *placeHolderView = self.placeHolderViewArr[index];
    placeHolderView.hidden = hidden;
}
-(NSMutableArray *)menuArr{
    if (!_menuArr) {
        self.menuArr = [NSMutableArray array];
    }
    return _menuArr;
}
-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        self.contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
-(NSMutableArray *)placeHolderViewArr{
    if (!_placeHolderViewArr) {
        self.placeHolderViewArr = [NSMutableArray array];
    }
    return _placeHolderViewArr;
}
@end
