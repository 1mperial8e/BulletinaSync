//
//  HitView.m
//  Bulletina
//
//  Created by Stas Volskyi on 2/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "HitView.h"

@implementation HitView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self.viewForTouches ? self.viewForTouches : self;
}

@end
