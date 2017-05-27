//
//  NSString+Category.h
//  SKColumnView
//
//  Created by lijianli on 2017/5/24.
//  Copyright © 2017年 lijianli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)
//获取文本的宽度
+(CGFloat)widthOfText:(NSString *)text attributes:(NSDictionary *)attributes;
//获取文本的高度
+(CGFloat )heightOfText:(NSString *)text width:(CGFloat )width attributes:(NSDictionary *)attributes;
//获取文本的Size
+(CGSize)sizeOfText:(NSString *)text size:(CGSize)size attributes:(NSDictionary *)attributes options:(NSStringDrawingOptions )options;

//获取颜色的RGB值
+(NSArray *)RGB256OfColor:(UIColor *)color;

@end
