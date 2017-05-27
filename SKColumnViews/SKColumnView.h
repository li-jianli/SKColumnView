//
//  SKColumnView.h
//  SKColumnView
//
//  Created by lijianli on 2017/5/24.
//  Copyright © 2017年 lijianli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SKMenuStyle) {
    SKMenuStyleEqualSpace,      //菜单按钮等间隔布局
    SKMenuStyleFixed,          //菜单按钮固定宽度布局
};

@class SKColumnView;

@protocol SKColumnViewDelegate <NSObject>
@optional
//这里可以做一些操作，如第一次当前Index时请求数据
-(void)SKColumnView:(SKColumnView *)columnView didSelectViewIndex:(NSInteger )index;

@end
@protocol SKColumnViewDataSource <NSObject>
//必须实现这两个方法
-(NSString *)SKColumnView:(SKColumnView *)columnView menuNameWithIndex:(NSInteger )index;
-(UIView *)SKColumnView:(SKColumnView *)columnView viewForMenuIndex:(NSInteger )index;
@optional
//占位图
-(UIView *)SKColumnView:(SKColumnView *)columnView placeholderViewWithIndex:(NSInteger )index;

@end


@interface SKColumnView : UIView
@property(nonatomic, weak)id<SKColumnViewDataSource>dataSource;
@property(nonatomic, weak)id<SKColumnViewDelegate>delegate;
//@property(nonatomic, assign)CGFloat textMultiple;//菜单文字放大倍数 默认为1，不放大
-(instancetype)initWithMenuNumber:(NSInteger )menuNumber MenuHeight:(CGFloat )menuHeight selectMenuIndex:(NSInteger )selectMenuIndex menuStyle:(SKMenuStyle)menuStyle menuWidth:(CGFloat )menuWidth font:(UIFont *)font delegate:(id)delegate;

//菜单按钮的颜色
-(void)menuNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;
//滚动视图是否边界反弹
-(void)scrollViewBounces:(BOOL)bounces;
//设置菜单中的字体
-(void)menuFont:(UIFont *)font;
//是否显示当前的占位图
-(void)hidePlaceHolderViewAtCurrentIndex:(NSInteger )index hidden:(BOOL)hidden;

@end
