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

- (void)show
{
	[self.baseView addSubview:self.view];
	[self animation1];
}

- (void)hide
{
	[self.view removeFromSuperview];
}

@end
