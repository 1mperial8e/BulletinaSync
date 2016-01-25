//
//  MessageLabel.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "MessageLabel.h"

@implementation MessageLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0.f, 10.f, 0.f, 10.f};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
