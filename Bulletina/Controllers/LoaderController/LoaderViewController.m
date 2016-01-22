//
//  LoaderViewController.m
//  Bulletina
//
//  Created by Roman R on 22.01.16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "LoaderViewController.h"

@interface LoaderViewController ()

@property (strong, nonatomic) UIView *baseView;

@end

@implementation LoaderViewController

- (instancetype)initWithView:(UIView *)baseView
{
	NSAssert(baseView, @"baseView must != nil");
	self = [super init];
	if (self) {
		_baseView = baseView;
		self.view.frame = baseView.frame;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.modalPresentationStyle = UIModalPresentationOverCurrentContext;	
}

- (IBAction)dismissMe:(id)sender
{
	[self hide];
}

- (void)animation1
{
	CAReplicatorLayer *rl = [[CAReplicatorLayer alloc] init];
	rl.bounds = CGRectMake(0, 0, 200, 200);
	rl.cornerRadius = 10;
	rl.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8].CGColor;
	rl.position = self.view.center;
	[self.view.layer addSublayer:rl];
	
	CALayer *dot = [CALayer new];
	dot.bounds = CGRectMake(0, 0, 14, 14);
	dot.position = CGPointMake(100, 40);
	dot.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1].CGColor;
	dot.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
	dot.borderWidth = 1.0;
	dot.cornerRadius = 2.0;
	[rl addSublayer:dot];
	
	NSInteger numberOfDots = 15;
	rl.instanceCount = numberOfDots;
	CGFloat angle = 2*M_PI / (CGFloat)numberOfDots;
	rl.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);

	CFTimeInterval duration = 1.5;
	
	CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrink.fromValue = @1.0;
	shrink.toValue = @0.1;
	shrink.duration = duration;
	shrink.repeatCount = INFINITY;
	[dot addAnimation:shrink forKey:nil];
	
	rl.instanceDelay = duration / (double)numberOfDots;
	dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)bulletina
{
	self.view.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	
	CALayer *oval1 = [CALayer new];
	oval1.bounds = CGRectMake(0, 0, 215, 215);
	oval1.backgroundColor = [UIColor clearColor].CGColor;
	oval1.cornerRadius = CGRectGetHeight(oval1.bounds) / 2.0f;
	oval1.position = self.view.center;
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
	
	[self.view.layer addSublayer:oval1];
	
	CAReplicatorLayer *rl = [[CAReplicatorLayer alloc] init];
	rl.bounds = CGRectMake(0, 0, 169, 169);
	rl.cornerRadius = CGRectGetWidth(rl.bounds) / 2.0f;
	rl.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.0].CGColor;
	rl.position =  CGPointMake(CGRectGetWidth(oval1.bounds) / 2.0f, CGRectGetHeight(oval1.bounds)  / 2.0f);
	[oval1 addSublayer:rl];
	
	CALayer *dot = [CALayer new];
	dot.bounds = CGRectMake(0, 0, 25, 25);
	dot.position = CGPointMake(CGRectGetWidth(rl.bounds) / 2.0f - CGRectGetWidth(dot.bounds) / 2.0f, 17);
	dot.backgroundColor = [UIColor appOrangeColor].CGColor;//[UIColor colorWithWhite:0.8f alpha:1].CGColor;
//	dot.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
//	dot.borderWidth = 1.0;
	dot.cornerRadius = CGRectGetWidth(dot.bounds) / 2.0f;
	[rl addSublayer:dot];
	
	NSInteger numberOfDots = 12;
	rl.instanceCount = numberOfDots;
	CGFloat angle = 2*M_PI / (CGFloat)numberOfDots;
	rl.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
	
	CFTimeInterval duration = 2.0;
	
	CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	shrink.fromValue = @1.0;
	shrink.toValue = @0.1;
	shrink.duration = duration;
	shrink.repeatCount = INFINITY;
	[dot addAnimation:shrink forKey:nil];
	
	rl.instanceDelay = duration / ((CGFloat)numberOfDots);
	dot.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
}

- (void)bulletina2
{
	self.view.backgroundColor = [[UIColor appOrangeColor] colorWithAlphaComponent:0.8];
	
	CALayer *oval1 = [CALayer new];
	oval1.bounds = CGRectMake(0, 0, 215, 215);
	oval1.backgroundColor = [UIColor clearColor].CGColor;
	oval1.cornerRadius = CGRectGetHeight(oval1.bounds) / 2.0f;
	oval1.position = self.view.center;
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
	
	[self.view.layer addSublayer:oval1];
}

- (void)show
{
	[self.baseView addSubview:self.view];
//	[self animation1];
	[self bulletina];
}

- (void)hide
{
	[self.view removeFromSuperview];
}

@end
