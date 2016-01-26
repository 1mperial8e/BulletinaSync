//
//  BulletinaLoaderView.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface BulletinaLoaderView : UIView

- (instancetype)initWithView:(UIView *)baseView andText:(NSString *)text;
- (void)show;
- (void)hide;

@end
