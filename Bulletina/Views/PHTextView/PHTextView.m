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
		_placeholderText = @"Placeholder";
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedNotificationRecieved:) name:UITextViewTextDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditingNotificationRecieved:) name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditingNotificationRecieved:) name:UITextViewTextDidEndEditingNotification object:nil];	
}

#pragma mark - Accessors

- (void)setText:(NSString *)text
{
	[super setText:text];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
	_placeholderText = placeholderText;
	if (!self.text.length) {
		self.text = placeholderText;
	}
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)textChangedNotificationRecieved:(NSNotification *)notification
{
	if ([notification.object isMemberOfClass:[self class]]) {
		((PHTextView *)notification.object).text;
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
