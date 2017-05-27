//
//  NSString+Category.m
//  SKColumnView
//
//  Created by lijianli on 2017/5/24.
//  Copyright © 2017年 lijianli. All rights reserved.
//

#import "NSString+Category.h"


@implementation NSString (Category)

//获取文本的宽度
+(CGFloat)widthOfText:(NSString *)text attributes:(NSDictionary *)attributes{
    CGSize size = CGSizeZero;
    CGFloat width = [self sizeOfText:text size:size attributes:attributes options:NSStringDrawingUsesLineFragmentOrigin].width;
    return width;
}
//获取文本的高度
+(CGFloat )heightOfText:(NSString *)text width:(CGFloat )width attributes:(NSDictionary *)attributes{
    CGSize size = CGSizeMake(width, 0);
    CGFloat height = [self sizeOfText:text size:size attributes:attributes options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading].height;
    return height;
}
//获取文本的Size
+(CGSize)sizeOfText:(NSString *)text size:(CGSize)size attributes:(NSDictionary *)attributes options:(NSStringDrawingOptions )options{
    CGSize tempSize = [text  boundingRectWithSize:size options:options attributes:attributes context:nil].size;
    return tempSize;
}
//获取颜色的RGB值
+(NSArray *)RGB256OfColor:(UIColor *)color{
    CGFloat r = 0, g = 0, b = 0, alpha = 0;
    [color getRed:&r green:&g blue:&b alpha:&alpha];
    return @[@(r * 255), @(g * 255), @(b * 255)];
}
@end
