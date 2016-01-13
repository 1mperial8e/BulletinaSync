//
//  TextInputNavigationCollection.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "TextInputNavigationCollection.h"

@implementation TextInputNavigationCollection

#pragma mark - Accessors

- (void)setTextInputViews:(NSArray *)textInputViews
{
    _textInputViews = textInputViews;
}

#pragma mark - Navigation

- (void)next
{
    NSParameterAssert(self.textInputViews.count);
    if (!self.firstResponderView) {
        self.firstResponderView = self.textInputViews.firstObject;
    }
    NSInteger nextViewIndex = [self.textInputViews indexOfObject:self.firstResponderView] + 1;
    if (nextViewIndex < self.textInputViews.count) {
        UIView *newResponder = self.textInputViews[nextViewIndex];
        [newResponder becomeFirstResponder];
    } else {
        [self.firstResponderView resignFirstResponder];
    }
}

- (void)previous
{
    NSParameterAssert(self.textInputViews.count);
    if (!self.firstResponderView) {
        self.firstResponderView = self.textInputViews.firstObject;
    }
    NSInteger prevtViewIndex = [self.textInputViews indexOfObject:self.firstResponderView] - 1;
    if (prevtViewIndex >= 0) {
        UIView *newResponder = self.textInputViews[prevtViewIndex];
        [newResponder becomeFirstResponder];
    } else {
        [self.firstResponderView resignFirstResponder];
    }
}

- (void)inputViewWillBecomeFirstResponder:(UIView *)aView
{
    NSInteger index = [self.textInputViews indexOfObject:aView];
    NSParameterAssert(index != NSNotFound);
    self.firstResponderView = aView;
}

@end
