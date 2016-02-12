//
//  PHTextView.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/11/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

#import "PHTextView.h"

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
	
	CGFloat labelWidth = CGRectGetWidth(self.frame) - self.contentInset.left - self.contentInset.right;
	CGFloat labelHeight = CGRectGetHeight(self.frame) - self.contentInset.top - self.contentInset.bottom;
	CGRect labelFrame = CGRectMake(self.contentInset.left, self.contentInset.top, labelWidth, labelHeight);
	self.placeholderLabel = [[UILabel alloc] initWithFrame:self.frame];
//	[self.textCell.textView setTextContainerInset:UIEdgeInsetsMake(10, 20, 5, 20)];

//	self.placeholderLabel.backgroundColor = [UIColor redColor];
	
	self.placeholderLabel.numberOfLines = 0;
	[self.placeholderLabel setClipsToBounds:YES];
	self.placeholderLabel.font = self.font;
	self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
	self.placeholderLabel.lineBreakMode = NSLineBreakByClipping;
	[self addSubview:self.placeholderLabel];
}

#pragma mark - Accessors

- (void)setText:(NSString *)text
{
	[super setText:text];
}

- (void)setPlaceholder:(NSString *)placeholder
{
	self.placeholderLabel.text = placeholder;
	[self.placeholderLabel sizeToFit];
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
//		if (!self.text.length) {
//			self.text = self.placeholderText;
//		}
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
