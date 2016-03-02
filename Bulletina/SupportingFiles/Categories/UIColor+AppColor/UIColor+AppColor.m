//
//  UIColor+AppColor.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

+ (UIColor *)appOrangeColor
{
    return ColorWithReal(245.0, 168.0, 35.0, 1.0);
}

+ (UIColor *)mainPageBGColor
{
    return ColorWithReal(248.0, 247.0, 241.0, 1.0);
}

+ (UIColor *)mainPageGreenColor
{
    return ColorWithReal(87.0, 149.0, 19.0, 1.0);
}

+ (UIColor *)mainPageRedColor
{
    return ColorWithReal(255.0, 0.0, 0.0, 1.0);
}

+ (UIColor *)appDarkTextColor
{
	return ColorWithReal(74.0, 74.0, 74.0, 1.0);
}

#pragma mark - Private

UIColor *ColorWithReal(float red, float green, float blue, float alpha)
{
    return [UIColor colorWithRed:((float)red)/255.f green:((float)green)/255.f blue:((float)blue)/255.f alpha:((float)alpha)/1.f];
}

@end
