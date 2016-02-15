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

	
//	CGFloat labelWidth = CGRectGetWidth(self.frame) - self.textContainerInset.left - self.textContainerInset.right;
//	CGFloat labelHeight = CGRectGetHeight(self.frame) - self.textContainerInset.top - self.textContainerInset.bottom;
//	CGRect labelFrame = CGRectMake(self.textContainerInset.left+5, self.textContainerInset.top, labelWidth, labelHeight);
	self.placeholderLabel = [[UILabel alloc] initWithFrame:[self calculateLabelFrame]];

//	self.placeholderLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
	self.placeholderLabel.textColor = [UIColor colorWithRed:204 / 255.0 green:206 / 255.0 blue:209 / 255.0 alpha:1.0];
	self.placeholderLabel.numberOfLines = 0;
	[self.placeholderLabel setClipsToBounds:YES];
	self.placeholderLabel.font = self.font;
	self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
	self.placeholderLabel.lineBreakMode = NSLineBreakByClipping;
	[self addSubview:self.placeholderLabel];
	[self.placeholderLabel setHidden:[self isPlaceholderVisible]];
}

- (CGRect)calculateLabelFrame
{
	CGFloat labelWidth = CGRectGetWidth(self.frame) - self.textContainerInset.left - self.textContainerInset.right;
	CGFloat labelHeight = CGRectGetHeight(self.frame) - self.textContainerInset.top - self.textContainerInset.bottom;
	CGRect labelFrame = CGRectMake(self.textContainerInset.left+5, self.textContainerInset.top, labelWidth, labelHeight);
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
	self.placeholderLabel.text = placeholder;
	[self.placeholderLabel sizeToFit];
	NSString *initialText = self.text;
	self.text = placeholder;
//	CGFloat height = ceil([self sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)].height + 0.5);
	[self sizeToFit];
	self.text = initialText;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)textChangedNotificationRecieved:(NSNotification *)notification
{
	if ([notification.object isMemberOfClass:[self class]]) {
//		((PHTextView *)notification.object).text;
		if (!self.text.length) {
//			self.text = self.placeholderText;
			[self.placeholderLabel setHidden:NO];
		} else {
			[self.placeholderLabel setHidden:YES];
		}
//		if ([self.text isEqualToString:self.placeholderText]) {
//			self.text = @"";
//		}
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
