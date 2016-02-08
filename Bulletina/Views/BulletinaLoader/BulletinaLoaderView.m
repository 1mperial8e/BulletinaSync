//
//  BulletinaLoaderView.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "BulletinaLoaderView.h"

@interface BulletinaLoaderView ()

@property (weak, nonatomic) UIView *baseView;
@property (strong, nonatomic) NSString *labelText;

@end

@implementation BulletinaLoaderView

#pragma mark - Lifecycle

- (instancetype)initWithView:(UIView *)baseView andText:(NSString *)text
{
    NSParameterAssert(baseView);
	self = [super initWithFrame:baseView.frame];
	if (self) {
		_labelText = text;
		_baseView = baseView;
		[self setAlpha:0.1f];
	}
	return self;	
}

#pragma mark - Control

- (void)show
{
	[self.baseView addSubview:self];
	[self bulletinaLogoPulse];
    __weak typeof(self) weakSelf = self;
	[UIView animateWithDuration:0.3f animations:^{
		[weakSelf setAlpha:1.0f];
	} completion:nil];
}

- (void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.superview) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.3f animations:^{
                [weakSelf setAlpha:0.1f];
            } completion:^(BOOL finished){
                weakSelf.layer.sublayers = nil;
                [weakSelf removeFromSuperview];
            }];
        }
    });
}

#pragma mark - Animations

- (void)bulletinaLogoPulse
{
	if (self.labelText.length) {
        [self addTextLabel];
	}
	
	self.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	
	CALayer *oval1 = [CALayer new];
	oval1.bounds = CGRectMake(0, 0, 143 * HeigthCoefficient, 143 * HeigthCoefficient);
	oval1.backgroundColor = [UIColor clearColor].CGColor;
	oval1.cornerRadius = CGRectGetHeight(oval1.bounds) / 2.0f;
	oval1.position = self.center;
	oval1.masksToBounds = YES;
	
	CALayer *oval2 = [CALayer new];
	oval2.bounds = CGRectMake(0, 0, 113 * HeigthCoefficient, 113 * HeigthCoefficient);
	oval2.backgroundColor = [UIColor whiteColor].CGColor;
	oval2.cornerRadius = CGRectGetHeight(oval2.bounds) / 2.0f;
	oval2.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval3 = [CALayer new];
	oval3.bounds = CGRectMake(0, 0, 71 * HeigthCoefficient, 71 * HeigthCoefficient);
	oval3.backgroundColor = [UIColor appOrangeColor].CGColor;
	oval3.cornerRadius = CGRectGetHeight(oval3.bounds) / 2.0f;
	oval3.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval4 = [CALayer new];
	oval4.bounds = CGRectMake(0, 0, 49 * HeigthCoefficient, 49 * HeigthCoefficient);
	oval4.backgroundColor = [UIColor whiteColor].CGColor;
	oval4.cornerRadius = CGRectGetHeight(oval4.bounds) / 2.0f;
	oval4.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *tie = [CALayer new];
	tie.bounds = CGRectMake(0, 0, 20 * HeigthCoefficient, 77 * HeigthCoefficient);
	tie.cornerRadius = 15;
	tie.backgroundColor = [UIColor whiteColor].CGColor;
	CGFloat xposition = CGRectGetWidth(oval1.bounds) / 2.0f - CGRectGetWidth(oval2.bounds) / 2.0f + CGRectGetWidth(tie.bounds) / 2.0f;
	tie.position = CGPointMake (xposition, CGRectGetHeight(tie.bounds) / 2.0f);
	
	[oval1 addSublayer:oval2];
	[oval1 addSublayer:oval3];
	[oval1 addSublayer:oval4];
	[oval1 addSublayer:tie];
	
	[self.layer addSublayer:oval1];
	
	CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrink.fromValue = @1.0;
	shrink.toValue = @0.8;
	shrink.duration = 0.7;
	shrink.repeatCount = INFINITY;
	shrink.removedOnCompletion = NO;
	shrink.autoreverses = YES;
	[oval4 addAnimation:shrink forKey:nil];
}

#pragma mark - UI

- (void)addTextLabel
{
    UILabel *loaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) / 4, CGRectGetWidth(self.bounds), 30)];
    
    loaderLabel.numberOfLines = 0;
    loaderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    loaderLabel.text = self.labelText;
    loaderLabel.backgroundColor = [UIColor whiteColor];
    loaderLabel.textColor = [UIColor appOrangeColor];
    loaderLabel.textAlignment = NSTextAlignmentCenter;
    [loaderLabel sizeToFit];
    
    CGRect frame = loaderLabel.frame;
    frame.size.width = CGRectGetWidth(self.bounds);
    loaderLabel.frame = frame;
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), -143 * 0.7 * HeigthCoefficient + CGRectGetMidY(self.bounds) - CGRectGetMidY(loaderLabel.bounds));
    loaderLabel.center = center;
    [self addSubview:loaderLabel];
}

@end

