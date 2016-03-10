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

- (void)awakeFromNib
{
	[super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedNotificationRecieved:) name:UITextViewTextDidChangeNotification object:nil];
	[self setClipsToBounds:YES];
	[self setTextContainerInset:UIEdgeInsetsMake(10, 20, 10, 20)];
	[self addLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.placeholderLabel.frame = [self calculateLabelFrame];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Utils

- (void)addLabel
{
	self.placeholderLabel = [[UILabel alloc] initWithFrame:[self calculateLabelFrame]];
	self.placeholderLabel.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
	self.placeholderLabel.numberOfLines = 0;
	[self.placeholderLabel setClipsToBounds:YES];
	self.placeholderLabel.font = self.font;
	self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
	[self addSubview:self.placeholderLabel];
	[self.placeholderLabel setHidden:[self isPlaceholderVisible]];
	self.placeholderLabel.text = self.placeholder;
}

- (CGRect)calculateLabelFrame
{
	CGFloat labelWidth = CGRectGetWidth(self.frame) - self.textContainerInset.left - self.textContainerInset.right - 5;
	CGFloat labelHeight = CGRectGetHeight(self.frame) - self.textContainerInset.top - self.textContainerInset.bottom;
	CGRect labelFrame = CGRectMake(self.textContainerInset.left, self.textContainerInset.top, labelWidth, labelHeight);
	return labelFrame;
}

- (BOOL)isPlaceholderVisible
{
	return self.text.length ? YES : NO;
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

- (void)setPlaceholder:(NSString *)placeholder
{
	_placeholder = placeholder;
	self.placeholderLabel.frame = [self calculateLabelFrame];
	self.placeholderLabel.text = placeholder;
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

@end
