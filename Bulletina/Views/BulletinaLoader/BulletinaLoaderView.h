//
//  BulletinaLoaderView.h
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

@interface BulletinaLoaderView : UIView

@property (strong, nonatomic) NSString *labelText;

- (instancetype)initWithView:(UIView *)baseView;
- (void)show;
- (void)hide;

@end
