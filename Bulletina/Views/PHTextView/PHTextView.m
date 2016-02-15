//
//  PHTextView.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "PHTextView.h"

@interface PHTextView ()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation PHTextView

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self =[super initWithCoder:aDecoder];
	if (self) {
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedNotificationRecieved:) name:UITextViewTextDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditingNotificationRecieved:) name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditingNotificationRecieved:) name:UITextViewTextDidEndEditingNotification object:nil];
	[self setClipsToBounds:YES];
	
	self.backgroundColor = [UIColor yellowColor];
	[self setTextContainerInset:UIEdgeInsetsMake(10, 20, 10, 20)];
	[self addLabel];
}

- (void)addLabel
{
	self.placeholderLabel = [[UILabel alloc] initWithFrame:[self calculateLabelFrame]];
//	self.placeholderLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
	self.placeholderLabel.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
	self.placeholderLabel.numberOfLines = 0;
	[self.placeholderLabel setClipsToBounds:YES];
	self.placeholderLabel.font = self.font;
	self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
	[self addSubview:self.placeholderLabel];
	[self.placeholderLabel setHidden:[self isPlaceholderVisible]];
	self.placeholderLabel.text = self.placeholder;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	DLog(@"w %.1f, h %.1f",CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//	DLog(@"left %f, right %f", self.textContainerInset.left ,self.textContainerInset.right);
	self.placeholderLabel.frame = [self calculateLabelFrame];
}

- (CGRect)calculateLabelFrame
{
//	DLog(@"w %.1f, h%.1f",CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//	DLog(@"left %f, right %f", self.textContainerInset.left ,self.textContainerInset.right);
	CGFloat labelWidth = CGRectGetWidth(self.frame) - self.textContainerInset.left - self.textContainerInset.right -5;
	CGFloat labelHeight = CGRectGetHeight(self.frame) - self.textContainerInset.top - self.textContainerInset.bottom;
	CGRect labelFrame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top, labelWidth, labelHeight);
	return labelFrame;
}

#pragma mark - Accessors

- (void)setText:(NSString *)text
{
	[super setText:text];
	[self.placeholderLabel setHidden:[self isPlaceholderVisible]];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
	[super setTextContainerInset:textContainerInset];
	self.placeholderLabel.frame = [self calculateLabelFrame];
}

- (BOOL)isPlaceholderVisible
{
	return self.text.length ? YES : NO;
}

- (void)setPlaceholder:(NSString *)placeholder
{
	_placeholder = placeholder;
	self.placeholderLabel.frame = [self calculateLabelFrame];
	self.placeholderLabel.text = placeholder;
}

- (CGSize)sizeThatFits:(CGSize)size
{
//	if (self.placeholder.length) {
//		CGFloat height = CGRectGetHeight(self.frame);
////		UITextView *testTextView = [[UITextView alloc] init];
//		self.text = self.placeholder;
//		CGFloat height2 = ceil([super sizeThatFits:size].height + 0.5);
//		if (height < height2) {
//			return CGSizeMake(size.width, height2);
//		}
//	}
	return [super sizeThatFits:size];
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)textChangedNotificationRecieved:(NSNotification *)notification
{
	if ([notification.object isMemberOfClass:[self class]]) {
		PHTextView *sender = notification.object;
		if (!sender.text.length) {
			[sender.placeholderLabel setHidden:NO];
		} else {
			[sender.placeholderLabel setHidden:YES];
		}
	}
}

- (void)didBeginEditingNotificationRecieved:(NSNotification *)notification
{
	if ([[notification.object class] isMemberOfClass:[self class]]) {
		
	}
}

- (void)didEndEditingNotificationRecieved:(NSNotification *)notification
{
	if ([[notification.object class] isMemberOfClass:[self class]]) {
		
	}
}

@end
