//
//  TextInputNavigationCollection.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/13/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface TextInputNavigationCollection : NSObject

@property (strong, nonatomic) NSArray *textInputViews;
@property (weak, nonatomic) UIView *firstResponderView;

- (void)next;
- (void)previous;

- (void)inputViewWillBecomeFirstResponder:(UIView *)aView;

@end
