//
//  PHTextView.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHTextView : UITextView

@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) NSString *placeholder;

@end
