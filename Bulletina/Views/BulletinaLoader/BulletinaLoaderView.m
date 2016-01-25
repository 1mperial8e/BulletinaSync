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

@property (assign, nonatomic) NSInteger animationIndex;
@property (strong, nonatomic) NSArray *animationsArray;

@end

@implementation BulletinaLoaderView

#pragma mark - Lifecycle

- (instancetype)initWithView:(UIView *)baseView andText:(NSString *)text
{
	self = [super initWithFrame:baseView.frame];
	if (self) {
		_labelText = text;
		_baseView = baseView;
	}
	return self;	
}

#pragma mark - Control

- (void)show
{
	[self.baseView addSubview:self];
	self.animationIndex = 0;
	self.animationsArray = @[@"simpleSquareLoader", @"simpleRoundLoader", @"bulletinaSimpleLogo", @"bulletinaLogoWithDots", @"bulletinaLogoPulse"];
	self.labelText = @"Please wait ...";
	[self changeAnimation];
}

- (void)hide
{
	self.layer.sublayers = nil;
	if (self.superview) {
		[self removeFromSuperview];
	}
}

- (void)changeAnimation
{
	self.layer.sublayers = nil;
	UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) / 2.0f - 125, 30, 250, 30)];
	closeButton.layer.cornerRadius = 10;
	[closeButton setTitle:@"Close loader" forState:UIControlStateNormal];
	closeButton.backgroundColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:closeButton];
	
	UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) / 2.0f - 125, 70, 250, 30)];
	changeButton.layer.cornerRadius = 10;
	[changeButton setTitle:@"Change animation" forState:UIControlStateNormal];
	changeButton.backgroundColor = [UIColor blueColor];
	[changeButton addTarget:self action:@selector(changeAnimation) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:changeButton];
	
	if (self.labelText.length) {
		UILabel *loaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) / 4, CGRectGetWidth(self.bounds), 30)];
		loaderLabel.text = self.labelText; //self.animationsArray[self.animationIndex];
		loaderLabel.backgroundColor =[UIColor whiteColor];
		loaderLabel.textColor = [UIColor appOrangeColor];
		loaderLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:loaderLabel];
	}
	
	[self performSelector:NSSelectorFromString((NSString *)self.animationsArray[(long)self.animationIndex]) withObject:nil];
	self.animationIndex++;
	if (self.animationIndex == self.animationsArray.count) {
		self.animationIndex = 0;
	}
}

#pragma mark - Animations

- (void)simpleSquareLoader
{
	self.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
	replicatorLayer.bounds = CGRectMake(0, 0, 200, 200);
	replicatorLayer.cornerRadius = 20;
	replicatorLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
	replicatorLayer.position = self.center;
	[self.layer addSublayer:replicatorLayer];
	
	CALayer *dot = [CALayer new];
	dot.bounds = CGRectMake(0, 0, 14, 14);
	dot.position = CGPointMake(100, 40);
	dot.backgroundColor = [UIColor whiteColor].CGColor;
	dot.borderColor = [UIColor appOrangeColor].CGColor;
	dot.borderWidth = 2.0;
	dot.cornerRadius = 2.0;
	[replicatorLayer addSublayer:dot];
	
	NSInteger numberOfDots = 15;
	replicatorLayer.instanceCount = numberOfDots;
	CGFloat angle = 2*M_PI / (CGFloat)numberOfDots;
	replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
	
	CFTimeInterval duration = 1.5;
	
	CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrink.fromValue = @1.0;
	shrink.toValue = @0.1;
	shrink.duration = duration;
	shrink.repeatCount = INFINITY;
	[dot addAnimation:shrink forKey:nil];
	
	replicatorLayer.instanceDelay = duration / (double)numberOfDots;
	dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)simpleRoundLoader
{
	self.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
	replicatorLayer.bounds = CGRectMake(0, 0, 200, 200);
	replicatorLayer.cornerRadius = 20;
	replicatorLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
	replicatorLayer.position = self.center;
	[self.layer addSublayer:replicatorLayer];
	
	CALayer *dot = [CALayer new];
	dot.bounds = CGRectMake(0, 0, 14, 14);
	dot.position = CGPointMake(100, 40);
	dot.backgroundColor = [UIColor whiteColor].CGColor;
	dot.borderColor = [UIColor appOrangeColor].CGColor;
	dot.borderWidth = 2.0;
	dot.cornerRadius = CGRectGetHeight(dot.bounds) / 2.0f;;
	[replicatorLayer addSublayer:dot];
	
	NSInteger numberOfDots = 15;
	replicatorLayer.instanceCount = numberOfDots;
	CGFloat angle = 2*M_PI / (CGFloat)numberOfDots;
	replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
	
	CFTimeInterval duration = 1.5;
	
	CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrink.fromValue = @1.0;
	shrink.toValue = @0.1;
	shrink.duration = duration;
	shrink.repeatCount = INFINITY;
	[dot addAnimation:shrink forKey:nil];
	
	replicatorLayer.instanceDelay = duration / (double)numberOfDots;
	dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)bulletinaSimpleLogo
{
	self.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	
	CALayer *oval1 = [CALayer new];
	oval1.bounds = CGRectMake(0, 0, 215, 215);
	oval1.backgroundColor = [UIColor clearColor].CGColor;
	oval1.cornerRadius = CGRectGetHeight(oval1.bounds) / 2.0f;
	oval1.position = self.center;
	oval1.masksToBounds = YES;
	
	CALayer *oval2 = [CALayer new];
	oval2.bounds = CGRectMake(0, 0, 169, 169);
	oval2.backgroundColor = [UIColor whiteColor].CGColor;
	oval2.cornerRadius = CGRectGetHeight(oval2.bounds) / 2.0f;
	oval2.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval3 = [CALayer new];
	oval3.bounds = CGRectMake(0, 0, 107, 107);
	oval3.backgroundColor = [UIColor appOrangeColor].CGColor;
	oval3.cornerRadius = CGRectGetHeight(oval3.bounds) / 2.0f;
	oval3.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval4 = [CALayer new];
	oval4.bounds = CGRectMake(0, 0, 73, 73);
	oval4.backgroundColor = [UIColor whiteColor].CGColor;
	oval4.cornerRadius = CGRectGetHeight(oval4.bounds) / 2.0f;
	oval4.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *tie = [CALayer new];
	tie.bounds = CGRectMake(0, 0, 30, 115);
	tie.cornerRadius = 15;
	tie.backgroundColor = [UIColor whiteColor].CGColor;
	CGFloat xposition = CGRectGetWidth(oval1.bounds) / 2.0f - CGRectGetWidth(oval2.bounds) / 2.0f + CGRectGetWidth(tie.bounds) / 2.0f;
	tie.position = CGPointMake (xposition, CGRectGetHeight(tie.bounds) / 2.0f);
	
	[oval1 addSublayer:oval2];
	[oval1 addSublayer:oval3];
	[oval1 addSublayer:oval4];
	[oval1 addSublayer:tie];
	
	[self.layer addSublayer:oval1];
}

- (void)bulletinaLogoWithDots
{
	self.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	
	CALayer *oval1 = [CALayer new];
	oval1.bounds = CGRectMake(0, 0, 215, 215);
	oval1.backgroundColor = [UIColor clearColor].CGColor;
	oval1.cornerRadius = CGRectGetHeight(oval1.bounds) / 2.0f;
	oval1.position = self.center;
	oval1.masksToBounds = YES;
	
	CALayer *oval2 = [CALayer new];
	oval2.bounds = CGRectMake(0, 0, 169, 169);
	oval2.backgroundColor = [UIColor whiteColor].CGColor;
	oval2.cornerRadius = CGRectGetHeight(oval2.bounds) / 2.0f;
	oval2.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval3 = [CALayer new];
	oval3.bounds = CGRectMake(0, 0, 107, 107);
	oval3.backgroundColor = [UIColor appOrangeColor].CGColor;
	oval3.cornerRadius = CGRectGetHeight(oval3.bounds) / 2.0f;
	oval3.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval4 = [CALayer new];
	oval4.bounds = CGRectMake(0, 0, 73, 73);
	oval4.backgroundColor = [UIColor whiteColor].CGColor;
	oval4.cornerRadius = CGRectGetHeight(oval4.bounds) / 2.0f;
	oval4.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *tie = [CALayer new];
	tie.bounds = CGRectMake(0, 0, 30, 115);
	tie.cornerRadius = 15;
	tie.backgroundColor = [UIColor whiteColor].CGColor;
	CGFloat xposition = CGRectGetWidth(oval1.bounds) / 2.0f - CGRectGetWidth(oval2.bounds) / 2.0f + CGRectGetWidth(tie.bounds) / 2.0f;
	tie.position = CGPointMake (xposition, CGRectGetHeight(tie.bounds) / 2.0f);
	
	[oval1 addSublayer:oval2];
	[oval1 addSublayer:oval3];
	[oval1 addSublayer:oval4];
	[oval1 addSublayer:tie];
	
	[self.layer addSublayer:oval1];
	
	CAReplicatorLayer *replicatorLayer = [[CAReplicatorLayer alloc] init];
	replicatorLayer.bounds = CGRectMake(0, 0, 169, 169);
	replicatorLayer.cornerRadius = CGRectGetWidth(replicatorLayer.bounds) / 2.0f;
	replicatorLayer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.0].CGColor;
	replicatorLayer.position =  CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	[oval1 addSublayer:replicatorLayer];
	
	CALayer *dot = [CALayer new];
	dot.bounds = CGRectMake(0, 0, 25, 25);
	dot.position = CGPointMake(CGRectGetWidth(replicatorLayer.bounds) / 2.0f - CGRectGetWidth(dot.bounds) / 2.0f, 17);
	dot.backgroundColor = [UIColor appOrangeColor].CGColor;
	dot.cornerRadius = CGRectGetWidth(dot.bounds) / 2.0f;
	[replicatorLayer addSublayer:dot];
	
	NSInteger numberOfDots = 12;
	replicatorLayer.instanceCount = numberOfDots;
	CGFloat angle = 2*M_PI / (CGFloat)numberOfDots;
	replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
	
	CFTimeInterval duration = 1.5;
	CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrink.fromValue = @1.0;
	shrink.toValue = @0.0;
	shrink.duration = duration;
	shrink.repeatCount = INFINITY;
	[dot addAnimation:shrink forKey:nil];
	
	replicatorLayer.instanceDelay = duration / ((CGFloat)numberOfDots);
	dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)bulletinaLogoPulse
{
	self.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	
	CALayer *oval1 = [CALayer new];
	oval1.bounds = CGRectMake(0, 0, 215, 215);
	oval1.backgroundColor = [UIColor clearColor].CGColor;
	oval1.cornerRadius = CGRectGetHeight(oval1.bounds) / 2.0f;
	oval1.position = self.center;
	oval1.masksToBounds = YES;
	
	CALayer *oval2 = [CALayer new];
	oval2.bounds = CGRectMake(0, 0, 169, 169);
	oval2.backgroundColor = [UIColor whiteColor].CGColor;
	oval2.cornerRadius = CGRectGetHeight(oval2.bounds) / 2.0f;
	oval2.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval3 = [CALayer new];
	oval3.bounds = CGRectMake(0, 0, 107, 107);
	oval3.backgroundColor = [UIColor appOrangeColor].CGColor;
	oval3.cornerRadius = CGRectGetHeight(oval3.bounds) / 2.0f;
	oval3.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *oval4 = [CALayer new];
	oval4.bounds = CGRectMake(0, 0, 73, 73);
	oval4.backgroundColor = [UIColor whiteColor].CGColor;
	oval4.cornerRadius = CGRectGetHeight(oval4.bounds) / 2.0f;
	oval4.position = CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	
	CALayer *tie = [CALayer new];
	tie.bounds = CGRectMake(0, 0, 30, 115);
	tie.cornerRadius = 15;
	tie.backgroundColor = [UIColor whiteColor].CGColor;
	CGFloat xposition = CGRectGetWidth(oval1.bounds) / 2.0f - CGRectGetWidth(oval2.bounds) / 2.0f + CGRectGetWidth(tie.bounds) / 2.0f;
	tie.position = CGPointMake (xposition, CGRectGetHeight(tie.bounds) / 2.0f);
	
	[oval1 addSublayer:oval2];
	[oval1 addSublayer:tie];
	[oval1 addSublayer:oval3];
	[oval1 addSublayer:oval4];
	
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

@end

